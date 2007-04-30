Return-Path: <linux-kernel-owner+w=401wt.eu-S1423497AbXD3Pxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423497AbXD3Pxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423473AbXD3PxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:53:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:34380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423472AbXD3Pt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:57 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: joachim.deguara@amd.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [23/34] i386: check capability
Message-Id: <20070430154956.30E3C151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Joachim Deguara" <joachim.deguara@amd.com>

Currently the i386 architecture checks the family for mce capability and this
removes that and uses the CPUID information.  Tested on a K8 revE and a
family10h processor.

This eliminates checking of a set AMD procesor family if mce is 
allowed and relies on the information being in CPUID.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/k7.c  |    3 +++
 arch/i386/kernel/cpu/mcheck/mce.c |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/cpu/mcheck/k7.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/k7.c
+++ linux/arch/i386/kernel/cpu/mcheck/k7.c
@@ -75,6 +75,9 @@ void amd_mcheck_init(struct cpuinfo_x86 
 	machine_check_vector = k7_machine_check;
 	wmb();
 
+	if (!cpu_has(c, X86_FEATURE_MCE))
+		return;
+
 	printk (KERN_INFO "Intel machine check architecture supported.\n");
 	rdmsr (MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<8))	/* Control register present ? */
Index: linux/arch/i386/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/mce.c
+++ linux/arch/i386/kernel/cpu/mcheck/mce.c
@@ -38,8 +38,7 @@ void mcheck_init(struct cpuinfo_x86 *c)
 
 	switch (c->x86_vendor) {
 		case X86_VENDOR_AMD:
-			if (c->x86==6 || c->x86==15)
-				amd_mcheck_init(c);
+			amd_mcheck_init(c);
 			break;
 
 		case X86_VENDOR_INTEL:
