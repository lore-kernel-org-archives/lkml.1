Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZHAWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZHAWJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZHAWJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:09:18 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:41204 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbZHAWJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:09:17 -0400
X-Trace: 235797335/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.85.231/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.85.231
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4EABZadEpQKVXn/2dsb2JhbACBUtAEgjIIgV4FiiE
X-IronPort-AV: E=Sophos;i="4.43,307,1246834800"; 
   d="scan'208";a="235797335"
Date: Sat, 1 Aug 2009 23:09:09 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: memory-controller patch fails to boot in qemu [mmotm]
In-Reply-To: <20090801200200.GB8514@balbir.in.ibm.com>
Message-ID: <Pine.LNX.4.64.0908012305260.4581@sister.anvils>
References: <4A744C2A.6040009@gmail.com> <20090801200200.GB8514@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009, Balbir Singh wrote:
> * Jiri Slaby <jirislaby@gmail.com> [2009-08-01 16:07:38]:
> > 
> > in mmotm-2009-07-30-05-01, the patch named
> > memory-controller-soft-limit-organize-cgroups-v9.patch
> > causes qemu fail to boot with tons of:
> > BUG: scheduling while atomic: async/2/480/0x10000002
> > Modules linked in:
> > Pid: 480, comm: async/2 Tainted: G       AW  2.6.31-rc4-mm1-bh #13
> > Call Trace:
> >  [<ffffffff81036b6c>] __schedule_bug+0x5c/0x70
> >  [<ffffffff8140491b>] thread_return+0x5c1/0x786
> >  [<ffffffff8103dd30>] __cond_resched+0x20/0x50
> >  [<ffffffff81404b9d>] _cond_resched+0x2d/0x40
> >  [<ffffffff81096694>] truncate_inode_pages_range+0x224/0x450
> >  [<ffffffff8106dfa1>] ? smp_call_function_many+0x1e1/0x210
> >  [<ffffffff810e50d0>] ? invalidate_bh_lru+0x0/0x90
> >  [<ffffffff810e514b>] ? invalidate_bh_lru+0x7b/0x90
> >  [<ffffffff810e50d0>] ? invalidate_bh_lru+0x0/0x90
> >  [<ffffffff810968d0>] truncate_inode_pages+0x10/0x20
> >  [<ffffffff810ea875>] kill_bdev+0x35/0x40
> >  [<ffffffff810eba18>] __blkdev_put+0xa8/0x190
> >  [<ffffffff810ebb0b>] blkdev_put+0xb/0x10
> >  [<ffffffff81116f62>] register_disk+0x172/0x180
> >  [<ffffffff8115bca5>] add_disk+0x85/0x150
> >  [<ffffffff812398cf>] sd_probe_async+0x12f/0x200
> >  [<ffffffff810616ca>] async_thread+0x10a/0x270
> >  [<ffffffff8103f7a0>] ? default_wake_function+0x0/0x10
> >  [<ffffffff810615c0>] ? async_thread+0x0/0x270
> >  [<ffffffff8105ac66>] kthread+0x96/0xa0
> >  [<ffffffff8100ceaa>] child_rip+0xa/0x20
> >  [<ffffffff8105abd0>] ? kthread+0x0/0xa0
> >  [<ffffffff8100cea0>] ? child_rip+0x0/0x20
> > 
> > Looks like an omitted unlock. I don't see anything suspicious in the
> > patch though.
> 
> 
> Thanks for the report, did you bisect the mmotm series to identify the
> root cause? What does your .config look like? I tried kvm with the
> patches (mmotm 30th July) and qemu-kvm (30th-july) with a Fedora 11
> guest image and the system booted just fine for me.
> 
> Could you share your command line as well?

I've just finished chasing something similar (without qemu),
and was about to post this:

[PATCH mmotm] memory controller: soft limit organize cgroups v9 fix

CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_PREEMPT=y mmotm fails to boot:
Kernel panic - not syncing: No init found; after lots of scheduling
while atomics, starting from when async_thread does sd_probe_async.

mem_cgroup_soft_limit_check() was doing an unbalanced get_cpu():
don't get_cpu if we won't need it, and put_cpu if we did get_cpu.

Hmm, this a weird function, passed an argument just to tell it to do
nothing.  Perhaps a placeholder for something more sensible to come?

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
Fix to memory-controller-soft-limit-organize-cgroups-v9.patch

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- mmotm/mm/memcontrol.c	2009-08-01 05:48:08.000000000 +0100
+++ linux/mm/memcontrol.c	2009-08-01 21:45:37.000000000 +0100
@@ -375,19 +375,21 @@ static bool mem_cgroup_soft_limit_check(
 					bool over_soft_limit)
 {
 	bool ret = false;
-	int cpu = get_cpu();
+	int cpu;
 	s64 val;
 	struct mem_cgroup_stat_cpu *cpustat;
 
 	if (!over_soft_limit)
 		return ret;
 
+	cpu = get_cpu();
 	cpustat = &mem->stat.cpustat[cpu];
 	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
 	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
 		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
 		ret = true;
 	}
+	put_cpu();
 	return ret;
 }
 
