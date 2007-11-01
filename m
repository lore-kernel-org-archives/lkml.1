Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbXKAERR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbXKAERR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXKAERG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:17:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60428 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752390AbXKAERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:17:04 -0400
Date: Wed, 31 Oct 2007 21:16:59 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
In-Reply-To: <20071031.181335.207429553.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710312115520.26072@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0710311801110.25515@schroedinger.engr.sgi.com>
 <20071031.180906.155917087.davem@davemloft.net>
 <Pine.LNX.4.64.0710311810390.25643@schroedinger.engr.sgi.com>
 <20071031.181335.207429553.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmmm... Got this to run on an ia64 big iron. One problem is the sizing of 
the pool. Somehow this needs to be dynamic.

Apply this fix on top of the others.

---
 include/asm-ia64/page.h   |    2 +-
 include/asm-ia64/percpu.h |    9 ++++++---
 mm/allocpercpu.c          |   12 ++++++++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/allocpercpu.c
===================================================================
--- linux-2.6.orig/mm/allocpercpu.c	2007-10-31 20:53:16.565486654 -0700
+++ linux-2.6/mm/allocpercpu.c	2007-10-31 21:00:27.553486484 -0700
@@ -28,7 +28,12 @@
 /*
  * Maximum allowed per cpu data per cpu
  */
+#ifdef CONFIG_NUMA
+#define PER_CPU_ALLOC_SIZE (32768 + MAX_NUMNODES * 512)
+#else
 #define PER_CPU_ALLOC_SIZE 32768
+#endif
+
 
 #define UNIT_SIZE sizeof(unsigned long long)
 #define UNITS_PER_CPU (PER_CPU_ALLOC_SIZE / UNIT_SIZE)
@@ -37,7 +42,7 @@ enum unit_type { FREE, END, USED };
 
 static u8 cpu_alloc_map[UNITS_PER_CPU] = { 1, };
 static DEFINE_SPINLOCK(cpu_alloc_map_lock);
-static DEFINE_PER_CPU(int, cpu_area)[UNITS_PER_CPU];
+static DEFINE_PER_CPU(unsigned long long, cpu_area)[UNITS_PER_CPU];
 
 #define CPU_DATA_OFFSET ((unsigned long)&per_cpu__cpu_area)
 
@@ -97,8 +102,11 @@ static void *cpu_alloc(unsigned long siz
 		while (start < UNITS_PER_CPU &&
 				cpu_alloc_map[start] != FREE)
 			start++;
-		if (start == UNITS_PER_CPU)
+		if (start == UNITS_PER_CPU) {
+			spin_unlock(&cpu_alloc_map_lock);
+			printk(KERN_CRIT "Dynamic per cpu memory exhausted\n");
 			return NULL;
+		}
 
 		end = start + 1;
 		while (end < UNITS_PER_CPU && end - start < units &&
Index: linux-2.6/include/asm-ia64/page.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/page.h	2007-10-31 20:53:16.573486483 -0700
+++ linux-2.6/include/asm-ia64/page.h	2007-10-31 20:56:19.372870091 -0700
@@ -44,7 +44,7 @@
 #define PAGE_MASK		(~(PAGE_SIZE - 1))
 #define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
 
-#define PERCPU_PAGE_SHIFT	16	/* log2() of max. size of per-CPU area */
+#define PERCPU_PAGE_SHIFT	20	/* log2() of max. size of per-CPU area */
 #define PERCPU_PAGE_SIZE	(__IA64_UL_CONST(1) << PERCPU_PAGE_SHIFT)
 
 
Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2007-10-31 20:53:30.424553062 -0700
+++ linux-2.6/include/asm-ia64/percpu.h	2007-10-31 20:53:36.248486656 -0700
@@ -40,6 +40,12 @@
 #endif
 
 /*
+ * This will make per cpu access to the local area use the virtually mapped
+ * areas.
+ */
+#define this_cpu_offset()			0
+
+/*
  * Pretty much a literal copy of asm-generic/percpu.h, except that percpu_modcopy() is an
  * external routine, to avoid include-hell.
  */
@@ -51,8 +57,6 @@ extern unsigned long __per_cpu_offset[NR
 /* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
 DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
 
-#define this_cpu_offset() __ia64_per_cpu_var(local_per_cpu_offset)
-
 #define per_cpu(var, cpu)  (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]))
 #define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
 #define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __ia64_per_cpu_var(local_per_cpu_offset)))
@@ -67,7 +71,6 @@ extern void *per_cpu_init(void);
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
 #define per_cpu_init()				(__phys_per_cpu_start)
-#define this_cpu_offset()			0
 
 #endif	/* SMP */
 
