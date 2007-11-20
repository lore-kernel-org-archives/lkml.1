Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXKTB3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXKTB3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbXKTBS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:18:29 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56623 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757909AbXKTBS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:18:28 -0500
Date: Mon, 19 Nov 2007 17:18:27 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ak@suse.de
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data handling
 on x86_64
In-Reply-To: <20071120011132.143632442@sgi.com>
Message-ID: <Pine.LNX.4.64.0711191716550.19324@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Duh a  patch did not make it due to XXX in the header.

I will put this also on git.kernel.org slab tree branch cpudata


x86_64: Strip down PDA operations through the use of CPU_XXX operations.

The *_pda operations behave in the same way as the CPU_XX ops. They both access data
that is relative to a segment register. So strip out as much as we can.

What is left after this patchset are some special pda ops for x86_64

	or_pda()
	test_and_clear_bit_pda()

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/current_64.h     |    2 +-
 include/asm-x86/pda.h            |   34 ++++------------------------------
 include/asm-x86/thread_info_64.h |    2 ++
 3 files changed, 7 insertions(+), 31 deletions(-)

Index: linux-2.6/include/asm-x86/pda.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pda.h	2007-11-19 16:17:22.325639807 -0800
+++ linux-2.6/include/asm-x86/pda.h	2007-11-19 16:24:13.569640223 -0800
@@ -81,36 +81,10 @@ extern struct x8664_pda _proxy_pda;
        }					\
        } while (0)
 
-#define pda_from_op(op,field) ({		\
-	typeof(_proxy_pda.field) ret__;		\
-	switch (sizeof(_proxy_pda.field)) {	\
-       	case 2:					\
-		asm(op "w %%gs:%c1,%0" : 	\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)), 	\
-		    "m" (_proxy_pda.field)); 	\
-		 break;				\
-	case 4:					\
-		asm(op "l %%gs:%c1,%0":		\
-		    "=r" (ret__):		\
-		    "i" (pda_offset(field)), 	\
-		    "m" (_proxy_pda.field)); 	\
-		 break;				\
-       case 8:					\
-		asm(op "q %%gs:%c1,%0":		\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)), 	\
-		    "m" (_proxy_pda.field)); 	\
-		 break;				\
-       default: 				\
-		__bad_pda_field();		\
-       }					\
-       ret__; })
-
-#define read_pda(field) pda_from_op("mov",field)
-#define write_pda(field,val) pda_to_op("mov",field,val)
-#define add_pda(field,val) pda_to_op("add",field,val)
-#define sub_pda(field,val) pda_to_op("sub",field,val)
+#define read_pda(field) CPU_READ(per_cpu_var(pda).field)
+#define write_pda(field,val) CPU_WRITE(per_cpu_var(pda).field, val)
+#define add_pda(field,val) CPU_ADD(per_cpu_var(pda).field, val)
+#define sub_pda(field,val) CPU_ADD(per_cpu_var(pda).field, val)
 #define or_pda(field,val) pda_to_op("or",field,val)
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
Index: linux-2.6/include/asm-x86/current_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/current_64.h	2007-11-19 15:45:03.470390243 -0800
+++ linux-2.6/include/asm-x86/current_64.h	2007-11-19 16:24:13.569640223 -0800
@@ -4,7 +4,7 @@
 #if !defined(__ASSEMBLY__) 
 struct task_struct;
 
-#include <asm/pda.h>
+#include <asm/percpu.h>
 
 static inline struct task_struct *get_current(void) 
 { 
Index: linux-2.6/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_64.h	2007-11-19 15:45:03.482390495 -0800
+++ linux-2.6/include/asm-x86/thread_info_64.h	2007-11-19 16:24:13.569640223 -0800
@@ -41,6 +41,8 @@ struct thread_info {
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
+#include <asm/percpu_64.h>
+
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task	       = &tsk,			\

