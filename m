Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYLNIId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYLNIId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYLNIHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYLNIHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/36] KVM: x86 emulator: consolidate emulation of two operand instructions
Date: Sun, 14 Dec 2008 10:06:35 +0200
Message-Id: <1229242029-13410-3-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to repeat the same assembly block over and over.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   79 +++++++++++++++----------------------------
 1 files changed, 28 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 5f87d3e..a11af6f 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -365,49 +365,42 @@ static u16 group2_table[] = {
 #define ON64(x)
 #endif
 
+#define ____emulate_2op(_op, _src, _dst, _eflags, _x, _y, _suffix)	\
+	do {								\
+		__asm__ __volatile__ (					\
+			_PRE_EFLAGS("0", "4", "2")			\
+			_op _suffix " %"_x"3,%1; "			\
+			_POST_EFLAGS("0", "4", "2")			\
+			: "=m" (_eflags), "=m" ((_dst).val),		\
+			  "=&r" (_tmp)					\
+			: _y ((_src).val), "i" (EFLAGS_MASK));		\
+	} while (0);
+
+
 /* Raw emulation: instruction has two explicit operands. */
 #define __emulate_2op_nobyte(_op,_src,_dst,_eflags,_wx,_wy,_lx,_ly,_qx,_qy) \
-	do { 								    \
-		unsigned long _tmp;					    \
-									    \
-		switch ((_dst).bytes) {					    \
-		case 2:							    \
-			__asm__ __volatile__ (				    \
-				_PRE_EFLAGS("0", "4", "2")		    \
-				_op"w %"_wx"3,%1; "			    \
-				_POST_EFLAGS("0", "4", "2")		    \
-				: "=m" (_eflags), "=m" ((_dst).val),        \
-				  "=&r" (_tmp)				    \
-				: _wy ((_src).val), "i" (EFLAGS_MASK));     \
-			break;						    \
-		case 4:							    \
-			__asm__ __volatile__ (				    \
-				_PRE_EFLAGS("0", "4", "2")		    \
-				_op"l %"_lx"3,%1; "			    \
-				_POST_EFLAGS("0", "4", "2")		    \
-				: "=m" (_eflags), "=m" ((_dst).val),	    \
-				  "=&r" (_tmp)				    \
-				: _ly ((_src).val), "i" (EFLAGS_MASK));     \
-			break;						    \
-		case 8:							    \
-			__emulate_2op_8byte(_op, _src, _dst,		    \
-					    _eflags, _qx, _qy);		    \
-			break;						    \
-		}							    \
+	do {								\
+		unsigned long _tmp;					\
+									\
+		switch ((_dst).bytes) {					\
+		case 2:							\
+			____emulate_2op(_op,_src,_dst,_eflags,_wx,_wy,"w"); \
+			break;						\
+		case 4:							\
+			____emulate_2op(_op,_src,_dst,_eflags,_lx,_ly,"l"); \
+			break;						\
+		case 8:							\
+			ON64(____emulate_2op(_op,_src,_dst,_eflags,_qx,_qy,"q")); \
+			break;						\
+		}							\
 	} while (0)
 
 #define __emulate_2op(_op,_src,_dst,_eflags,_bx,_by,_wx,_wy,_lx,_ly,_qx,_qy) \
 	do {								     \
-		unsigned long __tmp;					     \
+		unsigned long _tmp;					     \
 		switch ((_dst).bytes) {				             \
 		case 1:							     \
-			__asm__ __volatile__ (				     \
-				_PRE_EFLAGS("0", "4", "2")		     \
-				_op"b %"_bx"3,%1; "			     \
-				_POST_EFLAGS("0", "4", "2")		     \
-				: "=m" (_eflags), "=m" ((_dst).val),	     \
-				  "=&r" (__tmp)				     \
-				: _by ((_src).val), "i" (EFLAGS_MASK));      \
+			____emulate_2op(_op,_src,_dst,_eflags,_bx,_by,"b");  \
 			break;						     \
 		default:						     \
 			__emulate_2op_nobyte(_op, _src, _dst, _eflags,	     \
@@ -455,22 +448,6 @@ static u16 group2_table[] = {
 		}							\
 	} while (0)
 
-/* Emulate an instruction with quadword operands (x86/64 only). */
-#if defined(CONFIG_X86_64)
-#define __emulate_2op_8byte(_op, _src, _dst, _eflags, _qx, _qy)           \
-	do {								  \
-		__asm__ __volatile__ (					  \
-			_PRE_EFLAGS("0", "4", "2")			  \
-			_op"q %"_qx"3,%1; "				  \
-			_POST_EFLAGS("0", "4", "2")			  \
-			: "=m" (_eflags), "=m" ((_dst).val), "=&r" (_tmp) \
-			: _qy ((_src).val), "i" (EFLAGS_MASK));		\
-	} while (0)
-
-#elif defined(__i386__)
-#define __emulate_2op_8byte(_op, _src, _dst, _eflags, _qx, _qy)
-#endif				/* __i386__ */
-
 /* Fetch next part of the instruction being emulated. */
 #define insn_fetch(_type, _size, _eip)                                  \
 ({	unsigned long _x;						\
-- 
1.6.0.3

