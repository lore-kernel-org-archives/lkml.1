Return-Path: <linux-kernel-owner+w=401wt.eu-S937309AbZDIXOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937309AbZDIXOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937203AbZDIXNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:13:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:54268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937032AbZDIXNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:13:46 -0400
Date: Thu, 9 Apr 2009 23:13:24 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <49DE7F79.4030106@zytor.com>
References: <49DE7F79.4030106@zytor.com>
Subject: [tip:x86/setup] x86, setup: "glove box" BIOS interrupts in the EDD code
Message-ID: <tip-3435d3476c5ed955d56a6216ed2d156847b3a575@git.kernel.org>
Git-Commit-ID: 3435d3476c5ed955d56a6216ed2d156847b3a575
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 23:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3435d3476c5ed955d56a6216ed2d156847b3a575
Gitweb:     http://git.kernel.org/tip/3435d3476c5ed955d56a6216ed2d156847b3a575
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 18:17:17 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 9 Apr 2009 16:08:11 -0700

x86, setup: "glove box" BIOS interrupts in the EDD code

Impact: BIOS proofing

"Glove box" off BIOS interrupts in the EDD code.

LKML-Reference: <49DE7F79.4030106@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


---
 arch/x86/boot/edd.c |   71 ++++++++++++++++++++++----------------------------
 1 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index 1aae8f3..c501a5b 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -22,17 +23,17 @@
  */
 static int read_mbr(u8 devno, void *buf)
 {
-	u16 ax, bx, cx, dx;
+	struct biosregs ireg, oreg;
 
-	ax = 0x0201;		/* Legacy Read, one sector */
-	cx = 0x0001;		/* Sector 0-0-1 */
-	dx = devno;
-	bx = (size_t)buf;
-	asm volatile("pushfl; stc; int $0x13; setc %%al; popfl"
-		     : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
-		     : : "esi", "edi", "memory");
+	initregs(&ireg);
+	ireg.ax = 0x0201;		/* Legacy Read, one sector */
+	ireg.cx = 0x0001;		/* Sector 0-0-1 */
+	ireg.dl = devno;
+	ireg.bx = (size_t)buf;
 
-	return -(u8)ax;		/* 0 or -1 */
+	intcall(0x13, &ireg, &oreg);
+
+	return -(oreg.eflags & X86_EFLAGS_CF); /* 0 or -1 */
 }
 
 static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
@@ -72,56 +73,46 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
 
 static int get_edd_info(u8 devno, struct edd_info *ei)
 {
-	u16 ax, bx, cx, dx, di;
+	struct biosregs ireg, oreg;
 
 	memset(ei, 0, sizeof *ei);
 
 	/* Check Extensions Present */
 
-	ax = 0x4100;
-	bx = EDDMAGIC1;
-	dx = devno;
-	asm("pushfl; stc; int $0x13; setc %%al; popfl"
-	    : "+a" (ax), "+b" (bx), "=c" (cx), "+d" (dx)
-	    : : "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x41;
+	ireg.bx = EDDMAGIC1;
+	ireg.dl = devno;
+	intcall(0x13, &ireg, &oreg);
 
-	if ((u8)ax)
+	if (oreg.eflags & X86_EFLAGS_CF)
 		return -1;	/* No extended information */
 
-	if (bx != EDDMAGIC2)
+	if (oreg.bx != EDDMAGIC2)
 		return -1;
 
 	ei->device  = devno;
-	ei->version = ax >> 8;	/* EDD version number */
-	ei->interface_support = cx; /* EDD functionality subsets */
+	ei->version = oreg.ah;		 /* EDD version number */
+	ei->interface_support = oreg.cx; /* EDD functionality subsets */
 
 	/* Extended Get Device Parameters */
 
 	ei->params.length = sizeof(ei->params);
-	ax = 0x4800;
-	dx = devno;
-	asm("pushfl; int $0x13; popfl"
-	    : "+a" (ax), "+d" (dx), "=m" (ei->params)
-	    : "S" (&ei->params)
-	    : "ebx", "ecx", "edi");
+	ireg.ah = 0x48;
+	ireg.si = (size_t)&ei->params;
+	intcall(0x13, &ireg, &oreg);
 
 	/* Get legacy CHS parameters */
 
 	/* Ralf Brown recommends setting ES:DI to 0:0 */
-	ax = 0x0800;
-	dx = devno;
-	di = 0;
-	asm("pushw %%es; "
-	    "movw %%di,%%es; "
-	    "pushfl; stc; int $0x13; setc %%al; popfl; "
-	    "popw %%es"
-	    : "+a" (ax), "=b" (bx), "=c" (cx), "+d" (dx), "+D" (di)
-	    : : "esi");
-
-	if ((u8)ax == 0) {
-		ei->legacy_max_cylinder = (cx >> 8) + ((cx & 0xc0) << 2);
-		ei->legacy_max_head = dx >> 8;
-		ei->legacy_sectors_per_track = cx & 0x3f;
+	ireg.ah = 0x08;
+	ireg.es = 0;
+	intcall(0x13, &ireg, &oreg);
+
+	if (!(oreg.eflags & X86_EFLAGS_CF)) {
+		ei->legacy_max_cylinder = oreg.ch + ((oreg.cl & 0xc0) << 2);
+		ei->legacy_max_head = oreg.dh;
+		ei->legacy_sectors_per_track = oreg.cl & 0x3f;
 	}
 
 	return 0;
