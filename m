Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYLNIVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYLNIVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYLNIId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59952 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYLNIHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:23 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 29/36] KVM: x86 emulator: add the assembler code for three operands
Date: Sun, 14 Dec 2008 10:07:02 +0200
Message-Id: <1229242029-13410-30-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add the assembler code for instruction with three operands and one
operand is stored in ECX register

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 0c75306..9ae6d5b 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -431,6 +431,45 @@ static u32 group2_table[] = {
 	__emulate_2op_nobyte(_op, _src, _dst, _eflags,			\
 			     "w", "r", _LO32, "r", "", "r")
 
+/* Instruction has three operands and one operand is stored in ECX register */
+#define __emulate_2op_cl(_op, _cl, _src, _dst, _eflags, _suffix, _type) 	\
+	do {									\
+		unsigned long _tmp;						\
+		_type _clv  = (_cl).val;  					\
+		_type _srcv = (_src).val;    					\
+		_type _dstv = (_dst).val;					\
+										\
+		__asm__ __volatile__ (						\
+			_PRE_EFLAGS("0", "5", "2")				\
+			_op _suffix " %4,%1 \n"					\
+			_POST_EFLAGS("0", "5", "2")				\
+			: "=m" (_eflags), "+r" (_dstv), "=&r" (_tmp)		\
+			: "c" (_clv) , "r" (_srcv), "i" (EFLAGS_MASK)		\
+			); 							\
+										\
+		(_cl).val  = (unsigned long) _clv;				\
+		(_src).val = (unsigned long) _srcv;				\
+		(_dst).val = (unsigned long) _dstv;				\
+	} while (0)
+
+#define emulate_2op_cl(_op, _cl, _src, _dst, _eflags)				\
+	do {									\
+		switch ((_dst).bytes) {						\
+		case 2:								\
+			__emulate_2op_cl(_op, _cl, _src, _dst, _eflags,  	\
+						"w", unsigned short);         	\
+			break;							\
+		case 4: 							\
+			__emulate_2op_cl(_op, _cl, _src, _dst, _eflags,  	\
+						"l", unsigned int);           	\
+			break;							\
+		case 8:								\
+			ON64(__emulate_2op_cl(_op, _cl, _src, _dst, _eflags,	\
+						"q", unsigned long));  		\
+			break;							\
+		}								\
+	} while (0)
+
 #define __emulate_1op(_op, _dst, _eflags, _suffix)			\
 	do {								\
 		unsigned long _tmp;					\
-- 
1.6.0.3

