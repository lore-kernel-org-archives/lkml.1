Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbXLTMIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbXLTMIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbXLTMBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761043AbXLTMAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 27/43] x86 i387 unify structs
Message-Id: <20071220115943.5854026F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i387_fxsave_struct formats really have the same layout
on 32 and 64, with only some slightly different use of a few
fields.  The i387_fsave_struct and i387_soft_struct formats
are never used by 64-bit kernels, but it doesn't hurt to
have the unused types in the union and cuts down on the
amount of #ifdef hair required throughout the i387 code.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/processor.h |   92 +++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 80c5002..ea222cf 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -226,64 +226,37 @@ struct orig_ist {
 	unsigned long ist[7];
 };
 
-#ifdef CONFIG_X86_32
-struct i387_fsave_struct {
-	long	cwd;
-	long	swd;
-	long	twd;
-	long	fip;
-	long	fcs;
-	long	foo;
-	long	fos;
-	long	st_space[20];	/* 8*10 bytes for each FP-reg = 80 bytes */
-	long	status;		/* software status information */
-};
-
-struct i387_fxsave_struct {
-	unsigned short	cwd;
-	unsigned short	swd;
-	unsigned short	twd;
-	unsigned short	fop;
-	long	fip;
-	long	fcs;
-	long	foo;
-	long	fos;
-	long	mxcsr;
-	long	mxcsr_mask;
-	long	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
-	long	xmm_space[32];	/* 8*16 bytes for each XMM-reg = 128 bytes */
-	long	padding[56];
-} __attribute__((aligned(16)));
+#define	MXCSR_DEFAULT		0x1f80
 
-struct i387_soft_struct {
-	long	cwd;
-	long	swd;
-	long	twd;
-	long	fip;
-	long	fcs;
-	long	foo;
-	long	fos;
-	long	st_space[20];	/* 8*10 bytes for each FP-reg = 80 bytes */
-	unsigned char	ftop, changed, lookahead, no_update, rm, alimit;
-	struct info	*info;
-	unsigned long	entry_eip;
-};
-
-union i387_union {
-	struct i387_fsave_struct	fsave;
-	struct i387_fxsave_struct	fxsave;
-	struct i387_soft_struct soft;
+struct i387_fsave_struct {
+	u32	cwd;
+	u32	swd;
+	u32	twd;
+	u32	fip;
+	u32	fcs;
+	u32	foo;
+	u32	fos;
+	u32	st_space[20];	/* 8*10 bytes for each FP-reg = 80 bytes */
+	u32	status;		/* software status information */
 };
 
-# include "processor_32.h"
-#else
 struct i387_fxsave_struct {
 	u16	cwd;
 	u16	swd;
 	u16	twd;
 	u16	fop;
-	u64	rip;
-	u64	rdp;
+	union {
+		struct {
+			u64	rip;
+			u64	rdp;
+		};
+		struct {
+			u32	fip;
+			u32	fcs;
+			u32	foo;
+			u32	fos;
+		};
+	};
 	u32	mxcsr;
 	u32	mxcsr_mask;
 	u32	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
@@ -291,10 +264,29 @@ struct i387_fxsave_struct {
 	u32	padding[24];
 } __attribute__((aligned(16)));
 
+struct i387_soft_struct {
+	u32	cwd;
+	u32	swd;
+	u32	twd;
+	u32	fip;
+	u32	fcs;
+	u32	foo;
+	u32	fos;
+	u32	st_space[20];	/* 8*10 bytes for each FP-reg = 80 bytes */
+	u8	ftop, changed, lookahead, no_update, rm, alimit;
+	struct info	*info;
+	u32	entry_eip;
+};
+
 union i387_union {
+	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
+	struct i387_soft_struct 	soft;
 };
 
+#ifdef CONFIG_X86_32
+# include "processor_32.h"
+#else
 # include "processor_64.h"
 #endif
 
-- 
1.5.3.6

