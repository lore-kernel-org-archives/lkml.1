Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXGMWJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXGMWJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbXGMWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:09:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbXGMWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:09:24 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [x86 setup] Fix assembly constraints
Date: Fri, 13 Jul 2007 15:09:14 -0700
Message-Id: <11843645541714-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect assembly constraints.  In particular, fix memory
constraints used inside push..pop, which can cause invalid operation
since gcc may generate %esp-relative references.

Additionally:

outl() should have "dN" not "dn".

query_mca() shouldn't listen 16/32-bit registers in an 8-bit only
context.

has_eflag(): the "mask" is only used well after both the stack pointer
and the output registers have been touched; this requires the output
registers to be earlyclobbers (=&) and the input to exclude memory (so
"ri", not "g").

Thanks to Chuck Ebbert for prompting this review.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/boot.h b/arch/i386/boot/boot.h
index 0329c4f..dec70c9 100644
--- a/arch/i386/boot/boot.h
+++ b/arch/i386/boot/boot.h
@@ -56,7 +56,7 @@ static inline u16 inw(u16 port)
 
 static inline void outl(u32 v, u16 port)
 {
-	asm volatile("outl %0,%1" : : "a" (v), "dn" (port));
+	asm volatile("outl %0,%1" : : "a" (v), "dN" (port));
 }
 static inline u32 inl(u32 port)
 {
diff --git a/arch/i386/boot/cpucheck.c b/arch/i386/boot/cpucheck.c
index 8b0f447..991e8ce 100644
--- a/arch/i386/boot/cpucheck.c
+++ b/arch/i386/boot/cpucheck.c
@@ -115,8 +115,8 @@ static int has_eflag(u32 mask)
 	    "pushfl ; "
 	    "popl %1 ; "
 	    "popfl"
-	    : "=r" (f0), "=r" (f1)
-	    : "g" (mask));
+	    : "=&r" (f0), "=&r" (f1)
+	    : "ri" (mask));
 
 	return !!((f0^f1) & mask);
 }
diff --git a/arch/i386/boot/mca.c b/arch/i386/boot/mca.c
index 9b68bd1..68222f2 100644
--- a/arch/i386/boot/mca.c
+++ b/arch/i386/boot/mca.c
@@ -26,7 +26,7 @@ int query_mca(void)
 	    "setc %0 ; "
 	    "movw %%es, %1 ; "
 	    "popw %%es"
-	    : "=acdSDm" (err), "=acdSDm" (es), "=b" (bx)
+	    : "=acd" (err), "=acdSD" (es), "=b" (bx)
 	    : "a" (0xc000));
 
 	if (err)
diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 3fa53e1..1df025c 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -65,7 +65,7 @@ static void move_kernel_around(void)
 			     "popw %%ds ; "
 			     "popw %%es"
 			     : "+c" (dwords)
-			     : "rm" (dst_seg), "rm" (src_seg)
+			     : "r" (dst_seg), "r" (src_seg)
 			     : "esi", "edi");
 
 		syssize -= paras;
diff --git a/arch/i386/boot/video.c b/arch/i386/boot/video.c
index 3bb3573..027a2c9 100644
--- a/arch/i386/boot/video.c
+++ b/arch/i386/boot/video.c
@@ -411,7 +411,7 @@ static void restore_screen(void)
 			     "1: rep;stosl ; "
 			     "popw %%es"
 			     : "+D" (dst), "+c" (npad)
-			     : "bdSm" (video_segment),
+			     : "bdS" (video_segment),
 			       "a" (0x07200720));
 	}
 
diff --git a/arch/i386/boot/voyager.c b/arch/i386/boot/voyager.c
index 9221614..61c8fe0 100644
--- a/arch/i386/boot/voyager.c
+++ b/arch/i386/boot/voyager.c
@@ -32,7 +32,7 @@ int query_voyager(void)
 	    "setc %0 ; "
 	    "movw %%es, %1 ; "
 	    "popw %%es"
-	    : "=qm" (err), "=rm" (es), "=D" (di)
+	    : "=q" (err), "=r" (es), "=D" (di)
 	    : "a" (0xffc0));
 
 	if (err)
