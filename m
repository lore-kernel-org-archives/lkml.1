Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbZC0Uca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbZC0Uca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZC0UcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:32:03 -0400
Received: from gw.goop.org ([64.81.55.164]:33442 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346AbZC0UcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:32:01 -0400
Message-ID: <49CD37BD.1080102@goop.org>
Date: Fri, 27 Mar 2009 13:31:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH 2/2] xen: spin in xen_flush_tlb_others if a target cpu is
 in gup_fast()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_user_pages_fast() relies on cross-cpu tlb flushes being a barrier
between clearing and setting a pte, and before freeing a pagetable page.

It normally implements this by disabling interrupts to suspend tlb flush
IPIs.  This doesn't work for us because we don't use kernel-visible
IPIs for tlb flushes, so just spin manually until none of our target
cpus are in gup_fast().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aa16ef4..b0523f8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -50,6 +50,7 @@
 #include <asm/setup.h>
 #include <asm/paravirt.h>
 #include <asm/linkage.h>
+#include <asm/mmu.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -1334,6 +1335,14 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
 
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	/*
+	 * If we're racing with a get_user_pages_fast(), wait here
+	 * until it has finishes so that it can use cross-cpu tlb
+	 * flush as a barrier.
+	 */
+	while (cpus_intersects(*in_gup_cpumask, *cpus))
+		cpu_relax();
 }
 
 static unsigned long xen_read_cr3(void)


