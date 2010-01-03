Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612Ab0ACHry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0ACHry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 02:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269Ab0ACHrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 02:47:53 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:60869 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0ACHrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 02:47:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q1qZiirc27klbRhtiUXVp1QMZuTn1TAtdHoZ5vJR4xZa7lS6A7j2qDWQKMbR5pjIgG
         bQuBkPGCgBw6ccbUux1mB55MsPMoaWf++DNUStM/WgZKahFT+ABtaeTJkBfyeSwgvHKK
         u2LMvRbcpR6+H8bC1JyDEvUAsFwdjeonyElxY=
Date: Sat, 2 Jan 2010 23:47:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
Message-ID: <20100103074745.GA2314@core.coreip.homeip.net>
References: <20091228092712.AA8C.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
 <m11victac1.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
 <m1fx6rtu31.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
 <m11vi9c0td.fsf@fess.ebiederm.org>
 <4B3EB687.7000005@kernel.org>
 <m17hs0xjmn.fsf@fess.ebiederm.org>
 <4B3FE586.7020109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3FE586.7020109@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 03, 2010 at 09:32:06AM +0900, Tejun Heo wrote:
> On 01/03/2010 06:49 AM, Eric W. Biederman wrote:
> 
> > For the moment I have generated a patch that does the lockdep
> > annotations, and I have found that a simple:
> > 
> >    find /sys -type f | xargs cat {} > /dev/null
> > 
> > trivially generates lockdep warnings.  In particular:
> 
> (cc'ing Dmitry, Hi!)

Hi Tejun! ;)

> 
> > [  165.049042] 
> > [  165.049044] =======================================================
> > [  165.052761] [ INFO: possible circular locking dependency detected ]
> > [  165.052761] 2.6.33-rc2x86_64 #3
> > [  165.052761] -------------------------------------------------------
> > [  165.052761] cat/5026 is trying to acquire lock:
> > [  165.052761]  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
> > [  165.052761] 
> > [  165.052761] but task is already holding lock:
> > [  165.089443]  (s_active){++++.+}, at: [<ffffffff810e84dd>] sysfs_get_active_two+0x2c/0x43
> > [  165.089443] 
> > [  165.089443] which lock already depends on the new lock.
> > [  165.089443] 
> > [  165.089443] 
> > [  165.089443] the existing dependency chain (in reverse order) is:
> > [  165.089443] 
> > [  165.089443] -> #1 (s_active){++++.+}:
> > [  165.089443]        [<ffffffff81054956>] validate_chain+0xa25/0xd1d
> > [  165.089443]        [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
> > [  165.089443]        [<ffffffff81056112>] lock_acquire+0x5a/0x74
> > [  165.089443]        [<ffffffff810e8202>] sysfs_addrm_finish+0xba/0x125
> > [  165.089443]        [<ffffffff810e68b0>] sysfs_hash_and_remove+0x4f/0x6b
> > [  165.089443]        [<ffffffff810e94cf>] remove_files+0x1f/0x2c
> > [  165.089443]        [<ffffffff810e9561>] sysfs_remove_group+0x85/0xb4
> > [  165.089443]        [<ffffffff81331f0f>] psmouse_disconnect+0x33/0x147
> > [  165.089443]        [<ffffffff8132687b>] serio_disconnect_driver+0x2d/0x3a
> > [  165.089443]        [<ffffffff81326898>] serio_driver_remove+0x10/0x14
> > [  165.089443]        [<ffffffff812077f0>] __device_release_driver+0x67/0xb0
> > [  165.089443]        [<ffffffff81207857>] device_release_driver+0x1e/0x2b
> > [  165.089443]        [<ffffffff81326e68>] serio_disconnect_port+0x60/0x69
> > [  165.089443]        [<ffffffff8132757a>] serio_thread+0x170/0x34a
> > [  165.089443]        [<ffffffff810470e7>] kthread+0x7d/0x85
> > [  165.089443]        [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
> > [  165.089443] 
> > [  165.089443] -> #0 (&serio->drv_mutex){+.+.+.}:
> > [  165.089443]        [<ffffffff81054642>] validate_chain+0x711/0xd1d
> > [  165.089443]        [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
> > [  165.089443]        [<ffffffff81056112>] lock_acquire+0x5a/0x74
> > [  165.089443]        [<ffffffff814378ed>] mutex_lock_interruptible_nested+0x4a/0x307
> > [  165.089443]        [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
> > [  165.089443]        [<ffffffff8132ed81>] atkbd_do_show_extra+0x13/0x15
> > [  165.089443]        [<ffffffff812049b6>] dev_attr_show+0x20/0x43
> > [  165.089443]        [<ffffffff810e71db>] sysfs_read_file+0xba/0x145
> > [  165.089443]        [<ffffffff8109f507>] vfs_read+0xab/0x147
> > [  165.089443]        [<ffffffff8109f85c>] sys_read+0x47/0x70
> > [  165.089443]        [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
> > [  165.089443] 
> > [  165.089443] other info that might help us debug this:
> > [  165.089443] 
> > [  165.089443] 3 locks held by cat/5026:
> > [  165.089443]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff810e715a>] sysfs_read_file+0x39/0x145
> > [  165.089443]  #1:  (s_active){++++.+}, at: [<ffffffff810e84d0>] sysfs_get_active_two+0x1f/0x43
> > [  165.089443]  #2:  (s_active){++++.+}, at: [<ffffffff810e84dd>] sysfs_get_active_two+0x2c/0x43
> > [  165.089443] 
> > [  165.089443] stack backtrace:
> > [  165.089443] Pid: 5026, comm: cat Not tainted 2.6.33-rc2x86_64 #3
> > [  165.089443] Call Trace:
> > [  165.089443]  [<ffffffff810538f3>] print_circular_bug+0xb3/0xc1
> > [  165.089443]  [<ffffffff81054642>] validate_chain+0x711/0xd1d
> > [  165.089443]  [<ffffffff81052fb6>] ? trace_hardirqs_on_caller+0x10b/0x12f
> > [  165.089443]  [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
> > [  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
> > [  165.089443]  [<ffffffff81056112>] lock_acquire+0x5a/0x74
> > [  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
> > [  165.089443]  [<ffffffff814378ed>] mutex_lock_interruptible_nested+0x4a/0x307
> > [  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
> > [  165.089443]  [<ffffffff8132ee41>] ? atkbd_show_extra+0x0/0x28
> > [  165.089443]  [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
> > [  165.089443]  [<ffffffff8132ed81>] atkbd_do_show_extra+0x13/0x15
> > [  165.089443]  [<ffffffff812049b6>] dev_attr_show+0x20/0x43
> > [  165.089443]  [<ffffffff810e71db>] sysfs_read_file+0xba/0x145
> > [  165.089443]  [<ffffffff8109f507>] vfs_read+0xab/0x147
> > [  165.089443]  [<ffffffff8109f85c>] sys_read+0x47/0x70
> > [  165.089443]  [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
> > 
> > Suggestions on how to sort out this other set of issues are welcome.
> 
> Ummm... read of an input sysfs node can trigger

Read? I checked and I do not see where read would cause disconnect.
Also, disconnect only involves unbinding driver from the port, not the
destruction of the port itself (children may be destroyed but they have
different locks).

> serio_disconnect_port() under serio->drv_mutex, which unfortunately
> would need to wait for completion of in-progress sysfs ops thus
> creating possibility for AB-BA deadlock. 

I think that we are dealing with different drv->mutex instances here.

> Dmitry, is it possible to
> make serio_disconnect_port() asynchronous from the sysfs ops (ie. put
> it in a work or something)?

I am not sure it is needed. Also in the trace presented
serio_disconnect_port() is called from kseriod which certainly does not
access sysfs...

Overall I am not concerned about lockdep bitching about serio because it
still bitches if you simply reload psmouse on a box with Synaptics with a
pass-through port even though there are nested annotations and it is
silent first time around.

Out of curiosity, do yo uknow what caused psmouse disconnect and what
kind of mouse is in the box?

-- 
Dmitry
