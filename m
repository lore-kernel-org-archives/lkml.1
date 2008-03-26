Return-Path: <linux-kernel-owner+w=401wt.eu-S1760763AbYCZVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbYCZVLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbYCZVLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:11:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41920 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755836AbYCZVLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:11:32 -0400
Date: Wed, 26 Mar 2008 16:11:31 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: torvalds@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86_64: resize NR_IRQS for large machines (re-submit)
Message-ID: <Pine.SGI.3.96.1080326161017.7873204a-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] x86_64: resize NR_IRQS for large machines

From: Alan Mayer <ajm@sgi.com>

On machines with very large numbers of cpus, tables that are dimensioned
by NR_IRQS get very large, especially the irq_desc table.  They are also
very sparsely used.  When the cpu count is > MAX_IO_APICS, use MAX_IO_APICS
to set NR_IRQS, otherwise use NR_CPUS.

Signed-off-by: Alan Mayer <ajm@sgi.com>

Reviewed-by: Christoph Lameter <clameter@sgi.com>

---

===================================================================
--- v2.6.25-rc6.orig/include/asm-x86/irq_64.h	2008-03-19 16:52:52.000000000 -0500
+++ v2.6.25-rc6/include/asm-x86/irq_64.h	2008-03-26 14:02:32.000000000 -0500
@@ -10,6 +10,8 @@
  *	<tomsoft@informatik.tu-chemnitz.de>
  */
 
+#include <asm/apicdef.h>
+
 #define TIMER_IRQ 0
 
 /*
@@ -31,7 +33,11 @@
 
 #define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in hw_irq.h */
 
-#define NR_IRQS (NR_VECTORS + (32 *NR_CPUS))
+#if NR_CPUS < MAX_IO_APICS
+#define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
+#else
+#define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
+#endif
 #define NR_IRQ_VECTORS NR_IRQS
 
 static __inline__ int irq_canonicalize(int irq)
Index: v2.6.25-rc6/include/linux/kernel_stat.h
===================================================================
--- v2.6.25-rc6.orig/include/linux/kernel_stat.h	2008-03-19 16:53:00.000000000 -0500
+++ v2.6.25-rc6/include/linux/kernel_stat.h	2008-03-20 11:12:27.000000000 -0500
@@ -1,11 +1,11 @@
 #ifndef _LINUX_KERNEL_STAT_H
 #define _LINUX_KERNEL_STAT_H
 
-#include <asm/irq.h>
 #include <linux/smp.h>
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
+#include <asm/irq.h>
 #include <asm/cputime.h>
 
 /*

