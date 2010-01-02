Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121Ab0ABVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0ABVt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447Ab0ABVt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:49:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51401 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab0ABVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:49:26 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 02 Jan 2010 13:49:20 -0800
In-Reply-To: <4B3EB687.7000005@kernel.org> (Tejun Heo's message of "Sat\, 02 Jan 2010 11\:59\:19 +0900")
Message-ID: <m17hs0xjmn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Eric.
>
> On 01/02/2010 12:16 AM, Eric W. Biederman wrote:
>>>> kobject_del with a lock held scares me.
>>>
>>> I would not object at _all_ if sysfs fixed the locking here instead of in 
>>> filldir.
>> 
>> I just sent you my sysfs filldir scalability patch, so we can take that
>> red-herring off the plate.
>> 
>> The problem as I see it is that kobject_del is convenient.
>> kobject_del waits until all of the sysfs show and store methods for
>> that kobject have stopped executing.  Which imposes the rule that
>> kobject_del can not be called with any locks held that are taken in a
>> sysfs show or store method.  This is all invisible to lockdep as the
>> wait is done with a completion and not a lock.
>
> The synchronization against read/write ops is in sysfs_deactivate on
> purpose so that drivers (most common users) don't have to worry about
> sysfs ops accessing different parts of data structures once
> device_del() is complete.  Implementing the exlusion at the driver
> level is possible but not easy because some hardware devices are
> represented with complex data structures, some of them are reused when
> devices are exchanged and some sysfs ops end up accessing the
> hardware.  So, it's often not possible to simply disassociate the data
> structure and float it till the last reference goes away.  There needs
> to be a synchronization point where the driver can tell that nothing
> is accessing released data structure or hardware resource after it and
> it's far easier to define it at the sysfs level.
>
>> sysfs_deactivate happens in the device_del(), but if we were to move
>> sysfs_deactivate into the final kobject_put then in theory we can
>> continue to block and be friendly but not need to be called with
>> locations where locks are held.
>
> Nobody would know when that final put will actually happen.  In
> progress sysfs ops might access the hardware after the hardware is
> gone or replaced with another unit.

Alright than that is a bad possible split of the functionality.  Which
is all I was suggesting splitting the functionality not doing away
with the wait or moving it to a point where the wait would not work.
It was simply my bad assumption that the final kobject_put would
happen before the module that controlled that kobject could be
removed.

I still think it might make sense to separate kobject_del into two
parts.  One that we call with the locks held and one without, but that
does seem to be applicable to only a very small set of cases and our
problems appear to be much larger than that.

For the moment I have generated a patch that does the lockdep
annotations, and I have found that a simple:

   find /sys -type f | xargs cat {} > /dev/null

trivially generates lockdep warnings.  In particular:

[  165.049042] 
[  165.049044] =======================================================
[  165.052761] [ INFO: possible circular locking dependency detected ]
[  165.052761] 2.6.33-rc2x86_64 #3
[  165.052761] -------------------------------------------------------
[  165.052761] cat/5026 is trying to acquire lock:
[  165.052761]  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
[  165.052761] 
[  165.052761] but task is already holding lock:
[  165.089443]  (s_active){++++.+}, at: [<ffffffff810e84dd>] sysfs_get_active_two+0x2c/0x43
[  165.089443] 
[  165.089443] which lock already depends on the new lock.
[  165.089443] 
[  165.089443] 
[  165.089443] the existing dependency chain (in reverse order) is:
[  165.089443] 
[  165.089443] -> #1 (s_active){++++.+}:
[  165.089443]        [<ffffffff81054956>] validate_chain+0xa25/0xd1d
[  165.089443]        [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
[  165.089443]        [<ffffffff81056112>] lock_acquire+0x5a/0x74
[  165.089443]        [<ffffffff810e8202>] sysfs_addrm_finish+0xba/0x125
[  165.089443]        [<ffffffff810e68b0>] sysfs_hash_and_remove+0x4f/0x6b
[  165.089443]        [<ffffffff810e94cf>] remove_files+0x1f/0x2c
[  165.089443]        [<ffffffff810e9561>] sysfs_remove_group+0x85/0xb4
[  165.089443]        [<ffffffff81331f0f>] psmouse_disconnect+0x33/0x147
[  165.089443]        [<ffffffff8132687b>] serio_disconnect_driver+0x2d/0x3a
[  165.089443]        [<ffffffff81326898>] serio_driver_remove+0x10/0x14
[  165.089443]        [<ffffffff812077f0>] __device_release_driver+0x67/0xb0
[  165.089443]        [<ffffffff81207857>] device_release_driver+0x1e/0x2b
[  165.089443]        [<ffffffff81326e68>] serio_disconnect_port+0x60/0x69
[  165.089443]        [<ffffffff8132757a>] serio_thread+0x170/0x34a
[  165.089443]        [<ffffffff810470e7>] kthread+0x7d/0x85
[  165.089443]        [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
[  165.089443] 
[  165.089443] -> #0 (&serio->drv_mutex){+.+.+.}:
[  165.089443]        [<ffffffff81054642>] validate_chain+0x711/0xd1d
[  165.089443]        [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
[  165.089443]        [<ffffffff81056112>] lock_acquire+0x5a/0x74
[  165.089443]        [<ffffffff814378ed>] mutex_lock_interruptible_nested+0x4a/0x307
[  165.089443]        [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
[  165.089443]        [<ffffffff8132ed81>] atkbd_do_show_extra+0x13/0x15
[  165.089443]        [<ffffffff812049b6>] dev_attr_show+0x20/0x43
[  165.089443]        [<ffffffff810e71db>] sysfs_read_file+0xba/0x145
[  165.089443]        [<ffffffff8109f507>] vfs_read+0xab/0x147
[  165.089443]        [<ffffffff8109f85c>] sys_read+0x47/0x70
[  165.089443]        [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
[  165.089443] 
[  165.089443] other info that might help us debug this:
[  165.089443] 
[  165.089443] 3 locks held by cat/5026:
[  165.089443]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff810e715a>] sysfs_read_file+0x39/0x145
[  165.089443]  #1:  (s_active){++++.+}, at: [<ffffffff810e84d0>] sysfs_get_active_two+0x1f/0x43
[  165.089443]  #2:  (s_active){++++.+}, at: [<ffffffff810e84dd>] sysfs_get_active_two+0x2c/0x43
[  165.089443] 
[  165.089443] stack backtrace:
[  165.089443] Pid: 5026, comm: cat Not tainted 2.6.33-rc2x86_64 #3
[  165.089443] Call Trace:
[  165.089443]  [<ffffffff810538f3>] print_circular_bug+0xb3/0xc1
[  165.089443]  [<ffffffff81054642>] validate_chain+0x711/0xd1d
[  165.089443]  [<ffffffff81052fb6>] ? trace_hardirqs_on_caller+0x10b/0x12f
[  165.089443]  [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
[  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
[  165.089443]  [<ffffffff81056112>] lock_acquire+0x5a/0x74
[  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
[  165.089443]  [<ffffffff814378ed>] mutex_lock_interruptible_nested+0x4a/0x307
[  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
[  165.089443]  [<ffffffff8132ee41>] ? atkbd_show_extra+0x0/0x28
[  165.089443]  [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
[  165.089443]  [<ffffffff8132ed81>] atkbd_do_show_extra+0x13/0x15
[  165.089443]  [<ffffffff812049b6>] dev_attr_show+0x20/0x43
[  165.089443]  [<ffffffff810e71db>] sysfs_read_file+0xba/0x145
[  165.089443]  [<ffffffff8109f507>] vfs_read+0xab/0x147
[  165.089443]  [<ffffffff8109f85c>] sys_read+0x47/0x70
[  165.089443]  [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b

Suggestions on how to sort out this other set of issues are welcome.

Eric
