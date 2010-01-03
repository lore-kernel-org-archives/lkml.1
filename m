Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121Ab0ACA1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0ACA1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 19:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951Ab0ACA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 19:27:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:37117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0ACA1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 19:27:08 -0500
Message-ID: <4B3FE586.7020109@kernel.org>
Date: Sun, 03 Jan 2010 09:32:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>	<20091226094504.GA6214@liondog.tnic>	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>	<m11victac1.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>	<m1fx6rtu31.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org> <m17hs0xjmn.fsf@fess.ebiederm.org>
In-Reply-To: <m17hs0xjmn.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/03/2010 06:49 AM, Eric W. Biederman wrote:
>>> sysfs_deactivate happens in the device_del(), but if we were to move
>>> sysfs_deactivate into the final kobject_put then in theory we can
>>> continue to block and be friendly but not need to be called with
>>> locations where locks are held.
>>
>> Nobody would know when that final put will actually happen.  In
>> progress sysfs ops might access the hardware after the hardware is
>> gone or replaced with another unit.
> 
> Alright than that is a bad possible split of the functionality.  Which
> is all I was suggesting splitting the functionality not doing away
> with the wait or moving it to a point where the wait would not work.
> It was simply my bad assumption that the final kobject_put would
> happen before the module that controlled that kobject could be
> removed.

The module should stay around.  The severing is necessary to protect
driver internal data structures and possibly removed or reattached (to
a different driver) hardware.

> I still think it might make sense to separate kobject_del into two
> parts.  One that we call with the locks held and one without, but that
> does seem to be applicable to only a very small set of cases and our
> problems appear to be much larger than that.

If such separation is necessary, we can implement the split interface
while leaving kobject_del() as is feature-wise and convert the
offending ones to use the split interface but I think it would be
better to simply fix the offending ones if there aren't too many and
they're easily fixable.  Let's see how many lockdep warnings turn up.

> For the moment I have generated a patch that does the lockdep
> annotations, and I have found that a simple:
> 
>    find /sys -type f | xargs cat {} > /dev/null
> 
> trivially generates lockdep warnings.  In particular:

(cc'ing Dmitry, Hi!)

> [  165.049042] 
> [  165.049044] =======================================================
> [  165.052761] [ INFO: possible circular locking dependency detected ]
> [  165.052761] 2.6.33-rc2x86_64 #3
> [  165.052761] -------------------------------------------------------
> [  165.052761] cat/5026 is trying to acquire lock:
> [  165.052761]  (&serio->drv_mutex){+.+.+.}, at: [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
> [  165.052761] 
> [  165.052761] but task is already holding lock:
> [  165.089443]  (s_active){++++.+}, at: [<ffffffff810e84dd>] sysfs_get_active_two+0x2c/0x43
> [  165.089443] 
> [  165.089443] which lock already depends on the new lock.
> [  165.089443] 
> [  165.089443] 
> [  165.089443] the existing dependency chain (in reverse order) is:
> [  165.089443] 
> [  165.089443] -> #1 (s_active){++++.+}:
> [  165.089443]        [<ffffffff81054956>] validate_chain+0xa25/0xd1d
> [  165.089443]        [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
> [  165.089443]        [<ffffffff81056112>] lock_acquire+0x5a/0x74
> [  165.089443]        [<ffffffff810e8202>] sysfs_addrm_finish+0xba/0x125
> [  165.089443]        [<ffffffff810e68b0>] sysfs_hash_and_remove+0x4f/0x6b
> [  165.089443]        [<ffffffff810e94cf>] remove_files+0x1f/0x2c
> [  165.089443]        [<ffffffff810e9561>] sysfs_remove_group+0x85/0xb4
> [  165.089443]        [<ffffffff81331f0f>] psmouse_disconnect+0x33/0x147
> [  165.089443]        [<ffffffff8132687b>] serio_disconnect_driver+0x2d/0x3a
> [  165.089443]        [<ffffffff81326898>] serio_driver_remove+0x10/0x14
> [  165.089443]        [<ffffffff812077f0>] __device_release_driver+0x67/0xb0
> [  165.089443]        [<ffffffff81207857>] device_release_driver+0x1e/0x2b
> [  165.089443]        [<ffffffff81326e68>] serio_disconnect_port+0x60/0x69
> [  165.089443]        [<ffffffff8132757a>] serio_thread+0x170/0x34a
> [  165.089443]        [<ffffffff810470e7>] kthread+0x7d/0x85
> [  165.089443]        [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
> [  165.089443] 
> [  165.089443] -> #0 (&serio->drv_mutex){+.+.+.}:
> [  165.089443]        [<ffffffff81054642>] validate_chain+0x711/0xd1d
> [  165.089443]        [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
> [  165.089443]        [<ffffffff81056112>] lock_acquire+0x5a/0x74
> [  165.089443]        [<ffffffff814378ed>] mutex_lock_interruptible_nested+0x4a/0x307
> [  165.089443]        [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
> [  165.089443]        [<ffffffff8132ed81>] atkbd_do_show_extra+0x13/0x15
> [  165.089443]        [<ffffffff812049b6>] dev_attr_show+0x20/0x43
> [  165.089443]        [<ffffffff810e71db>] sysfs_read_file+0xba/0x145
> [  165.089443]        [<ffffffff8109f507>] vfs_read+0xab/0x147
> [  165.089443]        [<ffffffff8109f85c>] sys_read+0x47/0x70
> [  165.089443]        [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
> [  165.089443] 
> [  165.089443] other info that might help us debug this:
> [  165.089443] 
> [  165.089443] 3 locks held by cat/5026:
> [  165.089443]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff810e715a>] sysfs_read_file+0x39/0x145
> [  165.089443]  #1:  (s_active){++++.+}, at: [<ffffffff810e84d0>] sysfs_get_active_two+0x1f/0x43
> [  165.089443]  #2:  (s_active){++++.+}, at: [<ffffffff810e84dd>] sysfs_get_active_two+0x2c/0x43
> [  165.089443] 
> [  165.089443] stack backtrace:
> [  165.089443] Pid: 5026, comm: cat Not tainted 2.6.33-rc2x86_64 #3
> [  165.089443] Call Trace:
> [  165.089443]  [<ffffffff810538f3>] print_circular_bug+0xb3/0xc1
> [  165.089443]  [<ffffffff81054642>] validate_chain+0x711/0xd1d
> [  165.089443]  [<ffffffff81052fb6>] ? trace_hardirqs_on_caller+0x10b/0x12f
> [  165.089443]  [<ffffffff810553d3>] __lock_acquire+0x785/0x7dc
> [  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
> [  165.089443]  [<ffffffff81056112>] lock_acquire+0x5a/0x74
> [  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
> [  165.089443]  [<ffffffff814378ed>] mutex_lock_interruptible_nested+0x4a/0x307
> [  165.089443]  [<ffffffff8132ecaa>] ? atkbd_attr_show_helper+0x28/0x6e
> [  165.089443]  [<ffffffff8132ee41>] ? atkbd_show_extra+0x0/0x28
> [  165.089443]  [<ffffffff8132ecaa>] atkbd_attr_show_helper+0x28/0x6e
> [  165.089443]  [<ffffffff8132ed81>] atkbd_do_show_extra+0x13/0x15
> [  165.089443]  [<ffffffff812049b6>] dev_attr_show+0x20/0x43
> [  165.089443]  [<ffffffff810e71db>] sysfs_read_file+0xba/0x145
> [  165.089443]  [<ffffffff8109f507>] vfs_read+0xab/0x147
> [  165.089443]  [<ffffffff8109f85c>] sys_read+0x47/0x70
> [  165.089443]  [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
> 
> Suggestions on how to sort out this other set of issues are welcome.

Ummm... read of an input sysfs node can trigger
serio_disconnect_port() under serio->drv_mutex, which unfortunately
would need to wait for completion of in-progress sysfs ops thus
creating possibility for AB-BA deadlock.  Dmitry, is it possible to
make serio_disconnect_port() asynchronous from the sysfs ops (ie. put
it in a work or something)?

Thanks.

-- 
tejun
