Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYGIQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYGIQyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYGIQvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53207 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbYGIQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:31 -0400
Message-Id: <20080709165131.219641000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:43 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 14/15] x86_64: Remove xxx_pda() operations
Content-Disposition: inline; filename=zero_based_remove_pda_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * As there are no more references to xxx_pda() ops then remove them.

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/pda.h |   77 ++++----------------------------------------------
 1 file changed, 7 insertions(+), 70 deletions(-)

--- linux-2.6.tip.orig/include/asm-x86/pda.h
+++ linux-2.6.tip/include/asm-x86/pda.h
@@ -21,7 +21,7 @@ struct x8664_pda {
 					   offset 40!!! */
 	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
-	short in_bootmem;		/* pda lives in bootmem */
+	short unused1;			/* unused */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
@@ -42,12 +42,6 @@ extern void pda_init(int);
 #define cpu_pda(cpu) (&per_cpu(pda, cpu))
 
 /*
- * There is no fast way to get the base address of the PDA, all the accesses
- * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */
-extern void __bad_pda_field(void) __attribute__((noreturn));
-
-/*
  * proxy_pda doesn't actually exist, but tell gcc it is accessed for
  * all PDA accesses so it gets read/write dependencies right.
  */
@@ -55,69 +49,11 @@ extern struct x8664_pda _proxy_pda;
 
 #define pda_offset(field) offsetof(struct x8664_pda, field)
 
-#define pda_to_op(op, field, val)					\
-do {									\
-	typedef typeof(_proxy_pda.field) T__;				\
-	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */	\
-	switch (sizeof(_proxy_pda.field)) {				\
-	case 2:								\
-		asm(op "w %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	case 4:								\
-		asm(op "l %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i" (pda_offset(field)));				\
-		break;							\
-	case 8:								\
-		asm(op "q %1,%%gs:%c2":					\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	default:							\
-		__bad_pda_field();					\
-	}								\
-} while (0)
-
-#define pda_from_op(op, field)			\
-({						\
-	typeof(_proxy_pda.field) ret__;		\
-	switch (sizeof(_proxy_pda.field)) {	\
-	case 2:					\
-		asm(op "w %%gs:%c1,%0" :	\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 4:					\
-		asm(op "l %%gs:%c1,%0":		\
-		    "=r" (ret__):		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 8:					\
-		asm(op "q %%gs:%c1,%0":		\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	default:				\
-		__bad_pda_field();		\
-	}					\
-	ret__;					\
-})
-
-#define read_pda(field)		pda_from_op("mov", field)
-#define write_pda(field, val)	pda_to_op("mov", field, val)
-#define add_pda(field, val)	pda_to_op("add", field, val)
-#define sub_pda(field, val)	pda_to_op("sub", field, val)
-#define or_pda(field, val)	pda_to_op("or", field, val)
-
-/* This is not atomic against other CPUs -- CPU preemption needs to be off */
+/*
+ * This is not atomic against other CPUs -- CPU preemption needs to be off
+ * NOTE: This relies on the fact that the cpu_pda is the *first* field in
+ *       the per cpu area.  Move it and you'll need to change this.
+ */
 #define test_and_clear_bit_pda(bit, field)				\
 ({									\
 	int old__;							\
@@ -127,6 +63,7 @@ do {									\
 	old__;								\
 })
 
+
 #endif
 
 #define PDA_STACKOFFSET (5*8)

-- 
