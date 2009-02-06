Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZBFRoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZBFRoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZBFRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:44:46 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:32698 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbZBFRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:44:45 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
In-Reply-To: <1233935101.20597.28.camel@zakaz.uk.xensource.com>
References: <patchbomb.1233862242@abulafia.goop.org>
	 <ab45a6865df539a36a75.1233862277@abulafia.goop.org>
	 <1233934150.20597.26.camel@zakaz.uk.xensource.com>
	 <1233935101.20597.28.camel@zakaz.uk.xensource.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 17:43:52 +0000
Message-Id: <1233942232.20597.33.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 35 of 36] x86: make pgd/pud/pmd/pte_none consistent
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=NkRAZMAOj8gA:10 a=x2RMdOTEVusA:10 a=JxU_R2U-SVHvJynmarQA:9 a=snQ9TkyEyc8BAGN2VyQA:7 a=QU_9AvxSQ2IDq8hi8jtOq9GKeYYA:4 a=LY0hPdMaydYA:10 a=6O0IECtVFhoA:10 a=KciULlu47koA:10 a=W39ifWXXhksA:10 a=LI9Vle30uBYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 15:45 +0000, Ian Campbell wrote:
> On Fri, 2009-02-06 at 15:29 +0000, Ian Campbell wrote:
> > On Thu, 2009-02-05 at 11:31 -0800, Jeremy Fitzhardinge wrote:
> > > The _none test is done differently for every level of the pagetable.
> > > Standardize them by:
> > > 
> > >  1: Use the native_X_val to extract the raw entry, with no need to go
> > >     via paravirt_ops, diff -r 1d0646d0d319 arch/x86/include/asm/pgtable.h, and
> > >  2: Compare with 0 rather than using a boolean !, since they are actually values
> > >     and not booleans.
> > 
> > In a 32 bit Xen guest this one causes
> > 
> >         [    8.354898] 1 multicall(s) failed: cpu 1
> 
> Spoke too soon, it's not as 100% reliably reproducing as I thought which
> confused my bisection attempt. Will try and locate the real culprit...

Real culprit was somewhere else entirely:

Subject: Fix xen_flush_tlb_others after const cpumask changes 

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
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
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
1.5.6.5


-- 
Ian Campbell

We are now enjoying total mutual interaction in an imaginary hot tub ...

