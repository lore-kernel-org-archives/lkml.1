Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXEFX4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXEFX4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXEFX4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:56:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:44680 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXEFX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nVg+tpMoLqDUWaXh7jzoF8pPW/RI9aJortgcqshcXDwy+ndZF6ulZFB5g5e7rqqr5UqTpTXIbPO4wrZ7KnMjOdd9oSpOaJeTsygOeiR5hwg5gAIV524hv4tGMhTPkQiyJC0r11UJEKGOGqzhmtXBkxAyMHIfBoWGQCIj/EdfGNI=
Message-ID: <a781481a0705061656u37b90022jfded9b1edbea3fa5@mail.gmail.com>
Date: Mon, 7 May 2007 05:26:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH] make hci_notifier a blocking notifier (was Re: BUG: sleeping function called from invalid context at net/core/sock.c:1523)
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Max Krasnyansky" <maxk@qualcomm.com>, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <2c0942db0705061615i1c6147a1h6aca54012c3509aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705060816v59c1ae70m1d5067fcaba5a25d@mail.gmail.com>
	 <Pine.LNX.4.44L0.0705061801330.21407-100000@netrider.rowland.org>
	 <2c0942db0705061615i1c6147a1h6aca54012c3509aa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropped Pavel, Rafael and linux-pm from CC list, this isn't a PM
error so don't want to spam them; and added bluez-devel)

On 5/7/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> On 5/6/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sun, 6 May 2007, Satyam Sharma wrote:
> >
> > > Anyway, the hci_notifier is called from the following six call sites:
> > >
> > > hci_dev_open() and hci_dev_close() -> both called from
> > > hci_sock_ioctl() => both can sleep
> > > hci_register_dev() and hci_unregister_dev() => again both are capable
> > > of sleeping
> > > hci_suspend_dev() and hci_resume_dev() -> called from the .suspend()
> > > and .resume() of the hci_usb_driver, and again both of these can sleep
> > >
> > > Is there any other reason why hci_notifier must be an atomic notifier?
> > >
> > > (CC'ing Alan Stern just in case, apparently hci_notifier became atomic
> > > when notifier chains were classified into atomic / blocking)
> >
> > I don't remember exactly why this particular choice was made.  Perhaps we
> > found that the notifier callout routines didn't use any blocking
> > primitives (we may have been mistaken about this -- there was a lot of
> > code to check) and so therefore the choice didn't matter.  In that case we
> > probably just decided to make it an atomic notifier to keep things simple.
> >
> > As you found, changing it to a blocking notifier is very easy.  Provided
> > all the callers are non-atomic it should work just fine.
>
> Okay, I'll go ahead and try the patch, then, and report back.

You'd still get the BUG message. To fully resolve the problem, we need
to make the hci_sock_dev_event() notifier callout blocking (which
happened with this patch) but also convert hci_sk_list.lock to a
rwsem, but some users of that rwlock (other than hci_sock_dev_event)
are atomic.

However, please do try and get back, as your testing would still be
helpful to see whether converting hci_notifier to blocking had other
side-effects -- if you only see the same message again and otherwise
things seem fine, then we're good as far as at least this change was
concerned.

Thanks,
Satyam
