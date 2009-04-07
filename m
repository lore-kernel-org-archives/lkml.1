Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZDGPRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZDGPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZDGPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48885 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725AbZDGPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:10 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [24/28] x86: MCE: Support more than 256 CPUs in struct mce
Message-Id: <20090407150807.7BF3E1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The old struct mce had a limitation to 256 CPUs. But x86 Linux supports more than
that now with x2apic. Add a new field extcpu to report the extended number.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:09.000000000 +0200
@@ -40,9 +40,9 @@
 	__u64 res2;	/* dito. */
 	__u8  cs;		/* code segment */
 	__u8  bank;	/* machine check bank */
-	__u8  cpu;	/* cpu that raised the error */
+	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
 	__u8  finished;   /* entry is valid */
-	__u32 pad;
+	__u32 extcpu;	/* linux cpu number that detected the error */
 };
 
 /*
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:09.000000000 +0200
@@ -82,7 +82,7 @@
 void mce_setup(struct mce *m)
 {
 	memset(m, 0, sizeof(struct mce));
-	m->cpu = smp_processor_id();
+	m->cpu = m->extcpu = smp_processor_id();
 	rdtscll(m->tsc);
 }
 
@@ -140,7 +140,7 @@
 	       KERN_EMERG "HARDWARE ERROR\n"
 	       KERN_EMERG
 	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
-	       m->cpu, m->mcgstatus, m->bank, m->status);
+	       m->extcpu, m->mcgstatus, m->bank, m->status);
 	if (m->ip) {
 		printk(KERN_EMERG "RIP%s %02x:<%016Lx> ",
 		       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
