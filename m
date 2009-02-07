Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZBGASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZBGASb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZBGASX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:18:23 -0500
Received: from gw.goop.org ([64.81.55.164]:57418 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZBGASW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:18:22 -0500
Message-ID: <498CD34A.1040608@goop.org>
Date: Fri, 06 Feb 2009 16:18:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
Subject: [GIT PULL] Fix xen_flush_tlb_others
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this patch from git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git jsgf/tip/fixups

>From e63d051d12d52a7ce59caac3d1f55837b86d19a3 Mon Sep 17 00:00:00 2001
From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Fri, 6 Feb 2009 17:36:36 +0000
Subject: [PATCH] Fix xen_flush_tlb_others

The commit
    commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
    Author: Rusty Russell <rusty@rustcorp.com.au>
    Date:   Sat Jan 10 21:58:09 2009 -0800

        x86: change flush_tlb_others to take a const struct cpumask

causes xen_flush_tlb_others to allocate a multicall and then issue it
without initializing it in the case where the cpumask is empty,
leading to:

        [    8.354898] 1 multicall(s) failed: cpu 1
        [    8.354921] Pid: 2213, comm: bootclean Not tainted 2.6.29-rc3-x86_32p-xenU-tip #135
        [    8.354937] Call Trace:
        [    8.354955]  [<c01036e3>] xen_mc_flush+0x133/0x1b0
        [    8.354971]  [<c0105d2a>] ? xen_force_evtchn_callback+0x1a/0x30
        [    8.354988]  [<c0105a60>] xen_flush_tlb_others+0xb0/0xd0
        [    8.355003]  [<c0126643>] flush_tlb_page+0x53/0xa0
        [    8.355018]  [<c0176a80>] do_wp_page+0x2a0/0x7c0
        [    8.355034]  [<c0238f0a>] ? notify_remote_via_irq+0x3a/0x70
        [    8.355049]  [<c0178950>] handle_mm_fault+0x7b0/0xa50
        [    8.355065]  [<c0131a3e>] ? wake_up_new_task+0x8e/0xb0
        [    8.355079]  [<c01337b5>] ? do_fork+0xe5/0x320
        [    8.355095]  [<c0121919>] do_page_fault+0xe9/0x240
        [    8.355109]  [<c0121830>] ? do_page_fault+0x0/0x240
        [    8.355125]  [<c032457a>] error_code+0x72/0x78
        [    8.355139]   call  1/1: op=2863311530 arg=[aaaaaaaa] result=-38     xen_flush_tlb_others+0x41/0xd0

Since empty cpumasks are rare and undoing an xen_mc_entry() is tricky
just issue such requests normally.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Cc: x86@kernel.org
---
 arch/x86/xen/mmu.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d2e8ed1..319bd40 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1273,8 +1273,6 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	/* Remove us, and any offline CPUS. */
 	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
-	if (unlikely(cpumask_empty(to_cpumask(args->mask))))
-		goto issue;
 
 	if (va == TLB_FLUSH_ALL) {
 		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
@@ -1285,7 +1283,6 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 
 	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
 
-issue:
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
-- 
1.6.0.6


