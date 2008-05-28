Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYE1AVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYE1AVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbYE1AVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:21:01 -0400
Received: from ozlabs.org ([203.10.76.45]:36718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759763AbYE1AUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:20:32 -0400
To: Paul Mackerras <paulus@samba.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 28 May 2008 10:18:17 +1000
Subject: [PATCH] [POWERPC] Add "memory" clobber to MMIO accessors
Message-Id: <20080528002031.5D365DDF96@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc might re-order MMIO accessors vs. surrounding consistent
memory accesses, which is a "bad thing".

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 include/asm-powerpc/io.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux-work.orig/include/asm-powerpc/io.h	2008-05-28 09:39:11.000000000 +1000
+++ linux-work/include/asm-powerpc/io.h	2008-05-28 09:40:28.000000000 +1000
@@ -100,7 +100,7 @@ static inline type name(const volatile t
 {									\
 	type ret;							\
 	__asm__ __volatile__("sync;" insn ";twi 0,%0,0;isync"		\
- 		: "=r" (ret) : "r" (addr), "m" (*addr));		\
+ 		: "=r" (ret) : "r" (addr), "m" (*addr) : "memory");	\
 	return ret;							\
 }
 
@@ -108,8 +108,8 @@ static inline type name(const volatile t
 static inline void name(volatile type __iomem *addr, type val)		\
 {									\
 	__asm__ __volatile__("sync;" insn				\
- 		: "=m" (*addr) : "r" (val), "r" (addr));		\
-	IO_SET_SYNC_FLAG();					\
+ 		: "=m" (*addr) : "r" (val), "r" (addr) : "memory");	\
+	IO_SET_SYNC_FLAG();						\
 }
 
 
@@ -333,7 +333,8 @@ static inline unsigned int name(unsigned
 		"	.long	3b,5b\n"		\
 		".previous"				\
 		: "=&r" (x)				\
-		: "r" (port + _IO_BASE));		\
+		: "r" (port + _IO_BASE)			\
+		: "memory");
 	return x;					\
 }
 
@@ -350,7 +351,8 @@ static inline void name(unsigned int val
 		"	.long	0b,2b\n"		\
 		"	.long	1b,2b\n"		\
 		".previous"				\
-		: : "r" (val), "r" (port + _IO_BASE));	\
+		: : "r" (val), "r" (port + _IO_BASE)	\
+		: "memory");
 }
 
 __do_in_asm(_rec_inb, "lbzx")
