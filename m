Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYIUWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYIUWbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYIUWb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:31:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYIUWb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:31:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] Commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b breaks resume on nx6325
Date: Mon, 22 Sep 2008 00:36:51 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200809210124.30547.rjw@sisk.pl> <200809210132.46504.rjw@sisk.pl> <200809212103.17578.rjw@sisk.pl>
In-Reply-To: <200809212103.17578.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809220036.52831.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of September 2008, Rafael J. Wysocki wrote:
> On Sunday, 21 of September 2008, Rafael J. Wysocki wrote:
> > On Sunday, 21 of September 2008, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > Unfortunately resume from suspend to RAM is completely broken on my hp nx6325
> > > because of
> > > 
> > > commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b
> > > Author: Thomas Gleixner <tglx@linutronix.de>
> > > Date:   Tue Sep 16 11:32:50 2008 -0700
> > > 
> > >     clockevents: make device shutdown robust
> > > 
> > >     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > 
> > > Reverting of this commit makes things work again.
> > 
> > One more thing, "broken" means that the box doesn't resume (the suspend part
> > seems to work correctly) and instead it seems to enter a neverending loop
> > that cannot be broken by any means except for the power button, so I think it
> > occurs with interrupts disabled.
> 
> Update:
> 
> After some more debugging I verified that in fact the $subject commit breaks
> CPU hotplugging (the 'online' part), so I should be able to get some more
> information about what really happens.
> 
> This still will be difficult, because the box hangs solid (magic sysrq doesn't
> work in this state) almost immediately after a (failing) attempt to 'online' the
> previously 'offlined' CPU.

Update:

It turns out that as long as X is not used (ie. I don't switch to it from the
console) the machine doesn't hang after the failing attempt to 'online' CPU1
(previously 'offlined').  This observation allowed me to get some more data.

Below is the trace of the process trying to 'online' CPU1 (obtained with
'echo t > /proc/sysrq-trigger'):

[  385.548018] bash          D 0000000000000000     0  3842   3796
[  385.548018]  ffff880074cdfb78 0000000000000082 ffff880074cdfac8 ffff88007500e3c0
[  385.548018]  ffffffff8073c900 ffffffff8073c900 ffffffff8073c900 ffffffff8073c900
[  385.548018]  ffffffff8073c900 ffffffff8073c900 ffffffff80738c80 ffffffff8073c900
[  385.548018] Call Trace:
[  385.548018]  [<ffffffff80457078>] schedule_timeout+0x22/0xbf
[  385.548018]  [<ffffffff8022c678>] ? need_resched+0x1e/0x28
[  385.548018]  [<ffffffff80235150>] ? __cond_resched+0x34/0x3a
[  385.548018]  [<ffffffff80456edd>] wait_for_common+0xd5/0x13c
[  385.548018]  [<ffffffff802309e7>] ? default_wake_function+0x0/0xf
[  385.548018]  [<ffffffff80456fce>] wait_for_completion+0x18/0x1a
[  385.548018]  [<ffffffff80248d5f>] synchronize_rcu+0x32/0x3b
[  385.548018]  [<ffffffff80248de0>] ? wakeme_after_rcu+0x0/0x10
[  385.548018]  [<ffffffff8023262a>] partition_sched_domains+0xc3/0x1ee
[  385.548018]  [<ffffffff8026850f>] cpuset_track_online_cpus+0x26d/0x281
[  385.548018]  [<ffffffff80230a13>] ? wake_up_process+0x10/0x12
[  385.548018]  [<ffffffff8024e7e1>] notifier_call_chain+0x33/0x5b
[  385.548018]  [<ffffffff8024e848>] __raw_notifier_call_chain+0x9/0xb
[  385.548018]  [<ffffffff8024e859>] raw_notifier_call_chain+0xf/0x11
[  385.548018]  [<ffffffff804555f4>] _cpu_up+0xd9/0x114
[  385.548018]  [<ffffffff80455686>] cpu_up+0x57/0x67
[  385.548018]  [<ffffffff8044b8d0>] store_online+0x4d/0x75
[  385.548018]  [<ffffffff80399e53>] sysdev_store+0x1b/0x1d
[  385.548018]  [<ffffffff802ea1c2>] sysfs_write_file+0xdf/0x114
[  385.548018]  [<ffffffff802a3ae1>] vfs_write+0xa7/0xe1
[  385.548018]  [<ffffffff802a3bd5>] sys_write+0x47/0x6c
[  385.548018]  [<ffffffff8020c1ab>] system_call_fastpath+0x16/0x1b

where the synchronize_rcu() appears to be called from
detach_destroy_domains().  It seems to stay in this schedule_timeout() forever.
(Kernel .config is at
http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc6-git6/nx6325-config)

I have repeated the following for a couple of times:
- boot the machine
- log in as root
- run 'echo 0 > /sys/devices/system/cpu/cpu1/online'
- run 'echo 1 > /sys/devices/system/cpu/cpu1/online' (this never returns)
and each time I have got an identical (except for the time stamps) trace for
the bash process running the last command.

So, it looks like RCU is broken and I have no idea how to debug it further.

Please advise.

Thanks,
Rafael
