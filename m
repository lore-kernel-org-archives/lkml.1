Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbZEHPZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbZEHPZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761900AbZEHPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:24:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37192 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbZEHPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:24:32 -0400
X-IronPort-AV: E=Sophos;i="4.40,318,1238990400"; 
   d="scan'208";a="4154157"
Subject: Re: [PATCH 6/8] x86: use flush_tlb_others to implement
	flush_tlb_all
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <1241727902-3176-7-git-send-email-jeremy@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
	 <1241727902-3176-7-git-send-email-jeremy@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 8 May 2009 16:24:29 +0100
Message-ID: <1241796269.15972.41.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 13:25 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Use the flush_tlb_others() call to implement flush_tlb_all().

This causes:
        BUG: spinlock bad magic on CPU#0, swapper/0
         lock: c05b7588, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
        Pid: 0, comm: swapper Not tainted 2.6.30-rc3-x86_32p-xen0-tip-01797-g3db7847 #1054
        Call Trace:
         [<c023e656>] spin_bug+0x96/0xf0
         [<c023e90f>] _raw_spin_lock+0x6f/0x150
         [<c0158baf>] ? lock_acquire+0x7f/0x90
         [<c03e89a9>] _spin_lock+0x39/0x40
         [<c0127bdf>] ? flush_tlb_others_ipi+0x3f/0xc0
         [<c0127bdf>] flush_tlb_others_ipi+0x3f/0xc0
         [<c0127c68>] native_flush_tlb_others+0x8/0x10
         [<c0127b4f>] flush_tlb_all+0x1f/0x70
         [<c0121b1c>] zap_low_mappings+0x7c/0x90
         [<c055caa5>] mem_init+0x2f5/0x330
         [<c054a000>] ? __init_begin+0x0/0x20
         [<c03e9bc2>] ? _etext+0x0/0x2
         [<c03e9bc2>] ? _etext+0x0/0x2
         [<c054a928>] start_kernel+0x1e8/0x300
         [<c054a2c0>] ? unknown_bootoption+0x0/0x210
         [<c054a076>] i386_start_kernel+0x56/0xa0
Because zap_low_mappings happens before the init_smp_flush
core_initcall. Also I don't think init_smp_flush has needed to be
__cpuinit since 09b3ec73, or even before then since it doesn't seem to
be called in any hotplug paths.

--- 
Subject: initialise tlbflush locks before any callers

Now that flush_tlb_all() is implemented via flush_tlb_others() the later
can be called before the core_initcalls are run. Make it an
early_initcall so it happens earlier.

Also there is no need for init_smp_flush to be __cpuinit.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

[ Impact: initialise spinlock before use ]

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index e69bdad..c6af8aa 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -229,7 +229,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
-static int __cpuinit init_smp_flush(void)
+static int __init init_smp_flush(void)
 {
 	int i;
 
@@ -238,7 +238,7 @@ static int __cpuinit init_smp_flush(void)
 
 	return 0;
 }
-core_initcall(init_smp_flush);
+early_initcall(init_smp_flush);
 
 void flush_tlb_current_task(void)
 {


