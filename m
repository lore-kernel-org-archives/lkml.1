Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZBILxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZBILxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZBILxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:53:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:44987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753388AbZBILxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:53:14 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/rj4Q2vdfrw/9D0mqTmGmoK6GDCbIaq8fR3tdE/R
	co9lJ/NU3L4gs3
Date: Mon, 9 Feb 2009 12:53:08 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: namespaces?: bug at mm/slub.c:2750
Message-ID: <20090209115308.GA3180@alice>
References: <20090206113556.GA3161@alice> <20090206161518.81e7d42c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090206161518.81e7d42c.akpm@linux-foundation.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.29-rc3 (x86_64)
X-Uptime: 15:16:07 up  4:37,  8 users,  load average: 0.66, 0.88, 0.66
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 6 Feb 2009 12:35:56 +0100
> Eric Sesterhenn <snakebyte@gmx.de> wrote:
> 
> > Hi,
> > 
> > with todays -git i get the following bug when i reboot the machine
> > 
> > [   94.369135] ------------[ cut here ]------------
> > [   94.369344] kernel BUG at mm/slub.c:2750!
> > [   94.369463] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> > [   94.369828] last sysfs file: /sys/devices/pnp0/00:0c/id
> > [   94.369952] Modules linked in:
> > [   94.370035] 
> > [   94.370035] Pid: 0, comm: swapper Not tainted
> > (2.6.29-rc3-00653-g8285bbf #240) System Name
> > [   94.370035] EIP: 0060:[<c018340b>] EFLAGS: 00010246 CPU: 0
> > [   94.370035] EIP is at kfree+0x3c/0xe4
> > [   94.370035] EAX: 00000400 EBX: c1139000 ECX: 00000000 EDX: c09fb204
> > [   94.370035] ESI: c114cf60 EDI: c09fb204 EBP: c0ab0f94 ESP: c0ab0f80
> > [   94.370035]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > [   94.370035] Process swapper (pid: 0, ti=c0ab0000 task=c09f23ac
> > task.ti=c0a50000)
> > [   94.370035] Stack:
> > [   94.370035]  c0ab0f94 00000286 c09fb204 c014e784 00000020 c0ab0fa0
> > c014e79c c09fb204
> > [   94.370035]  c0ab0fb0 c04dca32 cede1240 00000282 c0ab0fc4 c01297d1
> > c012c8aa cf9e4dc0
> > [   94.370035]  cf9e4e20 c0ab0fd0 c0135b0d 00000000 c0ab0fe0 c015a783
> > 00000100 00000001
> > [   94.370035] Call Trace:
> > [   94.370035]  [<c014e784>] ? free_user_ns+0x0/0x1b
> > [   94.370035]  [<c014e79c>] ? free_user_ns+0x18/0x1b
> > [   94.370035]  [<c04dca32>] ? kref_put+0x3b/0x49
> > [   94.370035]  [<c01297d1>] ? free_uid+0x49/0xa4
> > [   94.370035]  [<c012c8aa>] ? groups_free+0x31/0x35
> > [   94.370035]  [<c0135b0d>] ? put_cred_rcu+0x52/0x63
> > [   94.370035]  [<c015a783>] ? rcu_process_callbacks+0x60/0x74
> > [   94.370035]  [<c0125af2>] ? __do_softirq+0x6a/0xf1
> > [   94.370035]  [<c0125a88>] ? __do_softirq+0x0/0xf1
> > [   94.370035]  <IRQ> <0> [<c01598a8>] ? handle_level_irq+0x0/0xbc
> > [   94.370035]  [<c0125a0a>] ? irq_exit+0x3b/0x77
> > [   94.370035]  [<c010411d>] ? do_IRQ+0xdc/0xf3
> > [   94.370035]  [<c010340c>] ? common_interrupt+0x2c/0x34
> > [   94.370035]  [<c013007b>] ? param_array_set+0x18/0xc6
> > [   94.370035]  [<c051f5d2>] ? acpi_idle_enter_simple+0x167/0x1d1
> > [   94.370035]  [<c062c69d>] ? cpuidle_idle_call+0x57/0x8e
> > [   94.370035]  [<c01019eb>] ? cpu_idle+0x59/0x86
> > [   94.370035]  [<c077a585>] ? rest_init+0x61/0x63
> > [   94.370035] Code: 00 00 00 8b 1d e4 0f 03 c1 e8 fb f3 f8 ff c1 e8 0c
> > c1 e0 05 8d 34 03 f6 46 01 40 74 03 8b 76 0c 8b 06 84 c0 78 15 f6 c4 60
> > 75 04 <0f> 0b eb fe 89 f0 e8 90 7a fe ff e9 90 00 00 00 8b 45 04 89 45 
> > [   94.370035] EIP: [<c018340b>] kfree+0x3c/0xe4 SS:ESP 0068:c0ab0f80
> > [   94.383497] ---[ end trace 4779637014de8de6 ]---
> > [   94.383620] Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > The bug triggered is BUG_ON(!PageCompound(page)) in kfree();
> > 
> > (gdb) l *(free_user_ns+0x0)
> > 0xc014e784 is in free_user_ns (kernel/user_namespace.c:64).
> > 59	
> > 60		return 0;
> > 61	}
> > 62	
> > 63	void free_user_ns(struct kref *kref)
> > 64	{
> > 65		struct user_namespace *ns;
> > 66	
> > 67		ns = container_of(kref, struct user_namespace, kref);
> > 68		free_uid(ns->creator);
> > (gdb) l *(groups_free)
> > 0xc012c879 is in groups_free (kernel/sys.c:1160).
> > 1155	}
> > 1156	
> > 1157	EXPORT_SYMBOL(groups_alloc);
> > 1158	
> > 1159	void groups_free(struct group_info *group_info)
> > 1160	{
> > 1161		if (group_info->blocks[0] != group_info->small_block) {
> > 1162			int i;
> > 1163			for (i = 0; i < group_info->nblocks; i++)
> > 1164				free_page((unsigned
> > long)group_info->blocks[i]);
> > 
> 
> Well that's ugly.  We seem to have passed a non-slab address into
> kfree().
> 
> void kfree(const void *x)
> {
> 	struct page *page;
> 	void *object = (void *)x;
> 
> 	if (unlikely(ZERO_OR_NULL_PTR(x)))
> 		return;
> 
> 	page = virt_to_head_page(x);
> 	if (unlikely(!PageSlab(page))) {
> 		BUG_ON(!PageCompound(page));
> 
> 
> doing BUG_ON(!PageCompound) is a rather odd way of reporting that.
> 
> I'm unsure what could have caused this.  Could you have a play around
> please?  Set all the memory debug options, try using slab instead of
> slub, etc

Short story, I cant reproduce this anymore.

Long story:

I tried bisecting this. I tested each kernel with at least two
reboots, the ones marked bad paniced on both, all the good
ones rebooted cleanly.

root@whiterabbit:/usr/src/linux# git-bisect log
git-bisect start
# good: [97499aafffd20f018d719acc5ed73cf65705784d] Merge branch 'master' of
# git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
git-bisect good 97499aafffd20f018d719acc5ed73cf65705784d
# bad: [695874d11965eee158e9bf45807a7a2db3f652c9] Merge branch 'master' of
# git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
git-bisect bad 695874d11965eee158e9bf45807a7a2db3f652c9
# good: [67e70baf043cfdcdaf5972bc94be82632071536b] V4L/DVB (10411): s5h1409:
# Perform s5h1409 soft reset after tuning
git-bisect good 67e70baf043cfdcdaf5972bc94be82632071536b
# good: [5c350d93ff4736086a1b08fef1d0b5e22138d2e0] Merge branch 'for-linus' of
# git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc
git-bisect good 5c350d93ff4736086a1b08fef1d0b5e22138d2e0
# bad: [93bfbd71db4d2e01c05e219f285249a74808b1d4] Merge branch 'merge' of
# git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git-bisect bad 93bfbd71db4d2e01c05e219f285249a74808b1d4
# bad: [31c952dcf83d5b0fd57b514cbe8a1664647c26e7] Merge branch
# 'sched-fixes-for-linus' of
# git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad 31c952dcf83d5b0fd57b514cbe8a1664647c26e7
# good: [a9f3e2b549f83a9cdab873abf4140be27c05a3f2] sched: clear buddies more
# aggressively
git-bisect good a9f3e2b549f83a9cdab873abf4140be27c05a3f2
# good: [3d398703ef06fd97b4c28c86b580546d5b57e7b7] sched_rt: don't use
# first_cpu on cpumask created with cpumask_and
git-bisect good 3d398703ef06fd97b4c28c86b580546d5b57e7b7
# good: [9e6235e997bf091326b2f3ac92217c2ac2e27eb5] Merge branch 'for_linus' of
# git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
git-bisect good 9e6235e997bf091326b2f3ac92217c2ac2e27eb5

root@whiterabbit:/usr/src/linux# git-bisect good
31c952dcf83d5b0fd57b514cbe8a1664647c26e7 is first bad commit

root@whiterabbit:/usr/src/linux# git-show 31c952dcf83d5b0fd57b514cbe8a1664647c26e7
commit 31c952dcf83d5b0fd57b514cbe8a1664647c26e7
Merge: 9e6235e... 3d39870...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 2 19:26:29 2009 -0800

    Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
    
    * 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip:
      sched_rt: don't use first_cpu on cpumask created with cpumask_and
      sched: fix buddie group latency
      sched: clear buddies more aggressively
      sched: symmetric sync vs avg_overlap
      sched: fix sync wakeups
      cpuset: fix possible deadlock in async_rebuild_sched_domains


This seemed bogus to me, as far as i understand git, the merge commits
do not actually change the code, they only server as a reference
that other commits where pulled in.

Tried a git-reset --hard 31c952dcf83d5b0fd57b514cbe8a1664647c26e7
to get to the always failing version again. Which turned out to
fail in the last of three reboots... :| With dmesg -n 8 I didnt get more
information out of this.

I enabled slab on this 2.6.29-rc3-00410-g31c952d and tested 10 
reboots. None showed anything strange :(

After this I tried with SLOB, but it often hang
during boot after

[    0.762297] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
253)
[    0.762556] io scheduler noop registered
[    0.762662] io scheduler cfq registered (default)
[    0.767357] PCI: VIA PCI bridge detected. Disabling DAC.

So I checked out a fresh tree (2.6.29-rc3-00742-ge83102c) and build it
with the same config and SLUB enabled again. Just to see
if this was still reproducible. 16 reboots later
I didnt see this again. I then tested 2.6.29-rc4-00001-gd5b5623
but saw nothing in 13 reboots. Noticed CONFIG_SLUB_DEBUG_ON=n
and set it to y, tried another 12 boots and nothing happened.

Based on this I assume this was just a somehow miscompiled
kernel since being really really hard to reproduce on some kernels,
while always reproducible on others sounds somewhat strange.

Greetings, Eric
