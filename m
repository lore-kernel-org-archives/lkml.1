Return-Path: <linux-kernel-owner+w=401wt.eu-S937081AbZDIXNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937081AbZDIXNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936710AbZDIXNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:13:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:54258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937223AbZDIXNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:13:35 -0400
Date: Thu, 9 Apr 2009 23:13:12 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sfr@canb.auug.org.au, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, sfr@canb.auug.org.au, hpa@linux.intel.com
In-Reply-To: <49DE7F79.4030106@zytor.com>
References: <49DE7F79.4030106@zytor.com>
Subject: [tip:x86/setup] x86, setup: "glove box" BIOS interrupts in the APM code
Message-ID: <tip-d54ea252e4c92357226992cf65d94616a96e6fce@git.kernel.org>
Git-Commit-ID: d54ea252e4c92357226992cf65d94616a96e6fce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 23:13:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d54ea252e4c92357226992cf65d94616a96e6fce
Gitweb:     http://git.kernel.org/tip/d54ea252e4c92357226992cf65d94616a96e6fce
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 18:14:26 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 9 Apr 2009 16:08:11 -0700

x86, setup: "glove box" BIOS interrupts in the APM code

Impact: BIOS proofing

"Glove box" off BIOS interrupts in the APM code.

LKML-Reference: <49DE7F79.4030106@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>


---
 arch/x86/boot/apm.c |   76 +++++++++++++++++++-------------------------------
 1 files changed, 29 insertions(+), 47 deletions(-)

diff --git a/arch/x86/boot/apm.c b/arch/x86/boot/apm.c
index 7aa6033..ee27483 100644
--- a/arch/x86/boot/apm.c
+++ b/arch/x86/boot/apm.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   Original APM BIOS checking by Stephen Rothwell, May 1994
  *   (sfr@canb.auug.org.au)
@@ -19,75 +20,56 @@
 
 int query_apm_bios(void)
 {
-	u16 ax, bx, cx, dx, di;
-	u32 ebx, esi;
-	u8 err;
+	struct biosregs ireg, oreg;
 
 	/* APM BIOS installation check */
-	ax = 0x5300;
-	bx = cx = 0;
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %0"
-		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
-		     : : "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x53;
+	intcall(0x15, &ireg, &oreg);
 
-	if (err)
+	if (oreg.flags & X86_EFLAGS_CF)
 		return -1;		/* No APM BIOS */
 
-	if (bx != 0x504d)	/* "PM" signature */
+	if (oreg.bx != 0x504d)		/* "PM" signature */
 		return -1;
 
-	if (!(cx & 0x02))		/* 32 bits supported? */
+	if (!(oreg.cx & 0x02))		/* 32 bits supported? */
 		return -1;
 
 	/* Disconnect first, just in case */
-	ax = 0x5304;
-	bx = 0;
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
-		     : "+a" (ax), "+b" (bx)
-		     : : "ecx", "edx", "esi", "edi");
-
-	/* Paranoia */
-	ebx = esi = 0;
-	cx = dx = di = 0;
+	ireg.al = 0x04;
+	intcall(0x15, &ireg, NULL);
 
 	/* 32-bit connect */
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %6"
-		     : "=a" (ax), "+b" (ebx), "+c" (cx), "+d" (dx),
-		       "+S" (esi), "+D" (di), "=m" (err)
-		     : "a" (0x5303));
-
-	boot_params.apm_bios_info.cseg = ax;
-	boot_params.apm_bios_info.offset = ebx;
-	boot_params.apm_bios_info.cseg_16 = cx;
-	boot_params.apm_bios_info.dseg = dx;
-	boot_params.apm_bios_info.cseg_len = (u16)esi;
-	boot_params.apm_bios_info.cseg_16_len = esi >> 16;
-	boot_params.apm_bios_info.dseg_len = di;
-
-	if (err)
+	ireg.al = 0x03;
+	intcall(0x15, &ireg, &oreg);
+
+	boot_params.apm_bios_info.cseg        = oreg.ax;
+	boot_params.apm_bios_info.offset      = oreg.ebx;
+	boot_params.apm_bios_info.cseg_16     = oreg.cx;
+	boot_params.apm_bios_info.dseg        = oreg.dx;
+	boot_params.apm_bios_info.cseg_len    = oreg.si;
+	boot_params.apm_bios_info.cseg_16_len = oreg.hsi;
+	boot_params.apm_bios_info.dseg_len    = oreg.di;
+
+	if (oreg.flags & X86_EFLAGS_CF)
 		return -1;
 
 	/* Redo the installation check as the 32-bit connect;
 	   some BIOSes return different flags this way... */
 
-	ax = 0x5300;
-	bx = cx = 0;
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %0"
-		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
-		     : : "esi", "edi");
+	ireg.al = 0x00;
+	intcall(0x15, &ireg, &oreg);
 
-	if (err || bx != 0x504d) {
+	if ((oreg.eflags & X86_EFLAGS_CF) || oreg.bx != 0x504d) {
 		/* Failure with 32-bit connect, try to disconect and ignore */
-		ax = 0x5304;
-		bx = 0;
-		asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
-			     : "+a" (ax), "+b" (bx)
-			     : : "ecx", "edx", "esi", "edi");
+		ireg.al = 0x04;
+		intcall(0x15, &ireg, NULL);
 		return -1;
 	}
 
-	boot_params.apm_bios_info.version = ax;
-	boot_params.apm_bios_info.flags = cx;
+	boot_params.apm_bios_info.version = oreg.ax;
+	boot_params.apm_bios_info.flags   = oreg.cx;
 	return 0;
 }
 
