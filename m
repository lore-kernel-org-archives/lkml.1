Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXEPTKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXEPTKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbXEPTJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:09:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:57575 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907AbXEPTJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UUFKR8j5Qfke33UdQWu0MMEaFGbcyYALasKSL3jtx8zEOc9W6kGSgE3o0T2bWCuq6jEJF1UVsEMk6D/nPXNu9X2FJbjOW/0rzsaqSg2BgIjYHs/1rfUP0gy9hExq90LEEa1LE9IfnXGcjorbDfYQITVtk2kDa4MOpaN88GAwwZk=
Message-ID: <2c0942db0705161209u5a0f1b8ay6864f9b9c4f7aac1@mail.gmail.com>
Date: Wed, 16 May 2007 12:09:56 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [PATCH] make hci_notifier a blocking notifier (was Re: BUG: sleeping function called from invalid context at net/core/sock.c:1523)
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Max Krasnyansky" <maxk@qualcomm.com>, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <a781481a0705061656u37b90022jfded9b1edbea3fa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705060816v59c1ae70m1d5067fcaba5a25d@mail.gmail.com>
	 <Pine.LNX.4.44L0.0705061801330.21407-100000@netrider.rowland.org>
	 <2c0942db0705061615i1c6147a1h6aca54012c3509aa@mail.gmail.com>
	 <a781481a0705061656u37b90022jfded9b1edbea3fa5@mail.gmail.com>
X-Google-Sender-Auth: e5d48160ea6b48be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for taking so long to get back to you -- I've been on the
road for the last week and have finally got to a point where I could
test the patch.

On 5/6/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> (Dropped Pavel, Rafael and linux-pm from CC list, this isn't a PM
> error so don't want to spam them; and added bluez-devel)
>
> On 5/7/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > On 5/6/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Sun, 6 May 2007, Satyam Sharma wrote:
> > >
> > > > Anyway, the hci_notifier is called from the following six call sites:
> > > >
> > > > hci_dev_open() and hci_dev_close() -> both called from
> > > > hci_sock_ioctl() => both can sleep
> > > > hci_register_dev() and hci_unregister_dev() => again both are capable
> > > > of sleeping
> > > > hci_suspend_dev() and hci_resume_dev() -> called from the .suspend()
> > > > and .resume() of the hci_usb_driver, and again both of these can sleep
> > > >
> > > > Is there any other reason why hci_notifier must be an atomic notifier?
> > > >
> > > > (CC'ing Alan Stern just in case, apparently hci_notifier became atomic
> > > > when notifier chains were classified into atomic / blocking)
> > >
> > > I don't remember exactly why this particular choice was made.  Perhaps we
> > > found that the notifier callout routines didn't use any blocking
> > > primitives (we may have been mistaken about this -- there was a lot of
> > > code to check) and so therefore the choice didn't matter.  In that case we
> > > probably just decided to make it an atomic notifier to keep things simple.
> > >
> > > As you found, changing it to a blocking notifier is very easy.  Provided
> > > all the callers are non-atomic it should work just fine.
> >
> > Okay, I'll go ahead and try the patch, then, and report back.
>
> You'd still get the BUG message. To fully resolve the problem, we need
> to make the hci_sock_dev_event() notifier callout blocking (which
> happened with this patch) but also convert hci_sk_list.lock to a
> rwsem, but some users of that rwlock (other than hci_sock_dev_event)
> are atomic.
>
> However, please do try and get back, as your testing would still be
> helpful to see whether converting hci_notifier to blocking had other
> side-effects -- if you only see the same message again and otherwise
> things seem fine, then we're good as far as at least this change was
> concerned.

Yes, it's roughly the same trace. There are some differences, though
those are likely due to me finding a new way to trigger the issue. (My
laptop has a button to turn the WiFi/Bluetooth on and off. Hitting
that and causing a disconnect of the internal Bluetooth connector
triggers the same issue without going through a suspend/resume cycle.)

[  272.539154] BUG: sleeping function called from invalid context at
net/core/sock.c:1547
[  272.539161] in_atomic():1, irqs_disabled():0
[  272.539163] 2 locks held by khubd/1350:
[  272.539165]  #0:  ((hci_notifier).rwsem){----}, at:
[<ffffffff8023741b>] __blocking_notifier_call_chain+0x3b/0x80
[  272.539175]  #1:  (old_style_rw_init#2){-.-?}, at:
[<ffffffff88203c53>] hci_sock_dev_event+0x53/0x100 [bluetooth]
[  272.539196]
[  272.539197] Call Trace:
[  272.539203]  [<ffffffff80245833>] debug_show_held_locks+0x13/0x30
[  272.539216]  [<ffffffff80224963>] __might_sleep+0xc3/0xf0
[  272.539221]  [<ffffffff803c29dc>] lock_sock_nested+0x2c/0x120
[  272.539231]  [<ffffffff88203c53>] :bluetooth:hci_sock_dev_event+0x53/0x100
[  272.539241]  [<ffffffff88203c76>] :bluetooth:hci_sock_dev_event+0x76/0x100
[  272.539250]  [<ffffffff8045d073>] notifier_call_chain+0x53/0x80
[  272.539256]  [<ffffffff80237431>] __blocking_notifier_call_chain+0x51/0x80
[  272.539262]  [<ffffffff80237471>] blocking_notifier_call_chain+0x11/0x20
[  272.539270]  [<ffffffff881fed16>] :bluetooth:hci_notify+0x16/0x20
[  272.539278]  [<ffffffff881ffdbb>] :bluetooth:hci_unregister_dev+0x5b/0x80
[  272.539286]  [<ffffffff88224136>] :hci_usb:hci_usb_disconnect+0x56/0x90
[  272.539309]  [<ffffffff8801e66e>] :usbcore:usb_unbind_interface+0x4e/0xa0
[  272.539315]  [<ffffffff80380d86>] __device_release_driver+0x86/0xc0
[  272.539320]  [<ffffffff803812e6>] device_release_driver+0x46/0x70
[  272.539325]  [<ffffffff803804e3>] bus_remove_device+0x63/0x90
[  272.539329]  [<ffffffff8037e474>] device_del+0x1a4/0x2e0
[  272.539344]  [<ffffffff8801b8c6>] :usbcore:usb_disable_device+0x96/0x120
[  272.539358]  [<ffffffff880173ba>] :usbcore:usb_disconnect+0xba/0x140
[  272.539372]  [<ffffffff88017ac3>] :usbcore:hub_thread+0x263/0xdb0
[  272.539382]  [<ffffffff80456b66>] __sched_text_start+0x296/0x2ce
[  272.539389]  [<ffffffff8023eb30>] autoremove_wake_function+0x0/0x40
[  272.539403]  [<ffffffff88017860>] :usbcore:hub_thread+0x0/0xdb0
[  272.539408]  [<ffffffff8023e73d>] kthread+0x4d/0x80
[  272.539414]  [<ffffffff8020a298>] child_rip+0xa/0x12
[  272.539420]  [<ffffffff80209e50>] restore_args+0x0/0x30
[  272.539424]  [<ffffffff8023e844>] kthreadd+0xd4/0x160
[  272.539429]  [<ffffffff8023e6f0>] kthread+0x0/0x80
[  272.539433]  [<ffffffff8020a28e>] child_rip+0x0/0x12

Ray
