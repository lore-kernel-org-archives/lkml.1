Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYLNIJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYLNIJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYLNIHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59903 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbYLNIHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/36] KVM: x86 emulator: reduce duplication in one operand emulation thunks
Date: Sun, 14 Dec 2008 10:06:34 +0200
Message-Id: <1229242029-13410-2-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   66 +++++++++++++++----------------------------
 1 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 8f60ace..5f87d3e 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -359,6 +359,12 @@ static u16 group2_table[] = {
 	"andl %"_msk",%"_LO32 _tmp"; "		\
 	"orl  %"_LO32 _tmp",%"_sav"; "
 
+#ifdef CONFIG_X86_64
+#define ON64(x) x
+#else
+#define ON64(x)
+#endif
+
 /* Raw emulation: instruction has two explicit operands. */
 #define __emulate_2op_nobyte(_op,_src,_dst,_eflags,_wx,_wy,_lx,_ly,_qx,_qy) \
 	do { 								    \
@@ -425,42 +431,27 @@ static u16 group2_table[] = {
 	__emulate_2op_nobyte(_op, _src, _dst, _eflags,			\
 			     "w", "r", _LO32, "r", "", "r")
 
-/* Instruction has only one explicit operand (no source operand). */
-#define emulate_1op(_op, _dst, _eflags)                                    \
+#define __emulate_1op(_op, _dst, _eflags, _suffix)			\
 	do {								\
 		unsigned long _tmp;					\
 									\
+		__asm__ __volatile__ (					\
+			_PRE_EFLAGS("0", "3", "2")			\
+			_op _suffix " %1; "				\
+			_POST_EFLAGS("0", "3", "2")			\
+			: "=m" (_eflags), "+m" ((_dst).val),		\
+			  "=&r" (_tmp)					\
+			: "i" (EFLAGS_MASK));				\
+	} while (0)
+
+/* Instruction has only one explicit operand (no source operand). */
+#define emulate_1op(_op, _dst, _eflags)                                    \
+	do {								\
 		switch ((_dst).bytes) {				        \
-		case 1:							\
-			__asm__ __volatile__ (				\
-				_PRE_EFLAGS("0", "3", "2")		\
-				_op"b %1; "				\
-				_POST_EFLAGS("0", "3", "2")		\
-				: "=m" (_eflags), "=m" ((_dst).val),	\
-				  "=&r" (_tmp)				\
-				: "i" (EFLAGS_MASK));			\
-			break;						\
-		case 2:							\
-			__asm__ __volatile__ (				\
-				_PRE_EFLAGS("0", "3", "2")		\
-				_op"w %1; "				\
-				_POST_EFLAGS("0", "3", "2")		\
-				: "=m" (_eflags), "=m" ((_dst).val),	\
-				  "=&r" (_tmp)				\
-				: "i" (EFLAGS_MASK));			\
-			break;						\
-		case 4:							\
-			__asm__ __volatile__ (				\
-				_PRE_EFLAGS("0", "3", "2")		\
-				_op"l %1; "				\
-				_POST_EFLAGS("0", "3", "2")		\
-				: "=m" (_eflags), "=m" ((_dst).val),	\
-				  "=&r" (_tmp)				\
-				: "i" (EFLAGS_MASK));			\
-			break;						\
-		case 8:							\
-			__emulate_1op_8byte(_op, _dst, _eflags);	\
-			break;						\
+		case 1:	__emulate_1op(_op, _dst, _eflags, "b"); break;	\
+		case 2:	__emulate_1op(_op, _dst, _eflags, "w"); break;	\
+		case 4:	__emulate_1op(_op, _dst, _eflags, "l"); break;	\
+		case 8:	ON64(__emulate_1op(_op, _dst, _eflags, "q")); break; \
 		}							\
 	} while (0)
 
@@ -476,19 +467,8 @@ static u16 group2_table[] = {
 			: _qy ((_src).val), "i" (EFLAGS_MASK));		\
 	} while (0)
 
-#define __emulate_1op_8byte(_op, _dst, _eflags)                           \
-	do {								  \
-		__asm__ __volatile__ (					  \
-			_PRE_EFLAGS("0", "3", "2")			  \
-			_op"q %1; "					  \
-			_POST_EFLAGS("0", "3", "2")			  \
-			: "=m" (_eflags), "=m" ((_dst).val), "=&r" (_tmp) \
-			: "i" (EFLAGS_MASK));				  \
-	} while (0)
-
 #elif defined(__i386__)
 #define __emulate_2op_8byte(_op, _src, _dst, _eflags, _qx, _qy)
-#define __emulate_1op_8byte(_op, _dst, _eflags)
 #endif				/* __i386__ */
 
 /* Fetch next part of the instruction being emulated. */
-- 
1.6.0.3

