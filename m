Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYG2RnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYG2RnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYG2Rka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:6214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbYG2RkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="320702100"
Message-Id: <20080729173158.109096000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 6/9] x86, xsave: xsave/xrstor specific routines
Content-Disposition: inline; filename=xsave_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/include/asm-x86/xsave.h
===================================================================
--- tip-0728.orig/include/asm-x86/xsave.h	2008-07-28 18:19:58.000000000 -0700
+++ tip-0728/include/asm-x86/xsave.h	2008-07-28 18:20:05.000000000 -0700
@@ -48,6 +48,58 @@
 	return err;
 }
 
+static inline int xsave_check(struct xsave_struct __user *buf)
+{
+	int err;
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
+			     : "memory");
+	if (unlikely(err) && __clear_user(buf, xstate_size))
+		err = -EFAULT;
+	/* No need to clear here because the caller clears USED_MATH */
+	return err;
+}
+
+static inline int xrestore_user(struct xsave_struct __user *buf,
+				unsigned int lmask,
+				unsigned int hmask)
+{
+	int err;
+	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
+
+	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "2:\n"
+			     ".section .fixup,\"ax\"\n"
+			     "3:  movl $-1,%[err]\n"
+			     "    jmp  2b\n"
+			     ".previous\n"
+			     ".section __ex_table,\"a\"\n"
+			     _ASM_ALIGN "\n"
+			     _ASM_PTR "1b,3b\n"
+			     ".previous"
+			     : [err] "=r" (err)
+			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
+			     : "memory");	//memory required?
+	return err;
+}
+
+static inline void xrstor_state(struct xsave_struct *fx, int lmask, int hmask)
+{
+	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+		     :: "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		     : "memory");
+}
+
 static inline void xsave(struct task_struct *tsk)
 {
 	/* This, however, we can work around by forcing the compiler to select

-- 

