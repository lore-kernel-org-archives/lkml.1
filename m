Return-Path: <linux-kernel-owner+w=401wt.eu-S937347AbZDIXPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937347AbZDIXPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937250AbZDIXOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:14:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:54304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937249AbZDIXOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:14:00 -0400
Date: Thu, 9 Apr 2009 23:13:35 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       hpa@linux.intel.com
In-Reply-To: <49DE7F79.4030106@zytor.com>
References: <49DE7F79.4030106@zytor.com>
Subject: [tip:x86/setup] x86, setup: "glove box" BIOS interrupts in the MCA code
Message-ID: <tip-0a706db320768f8f6e43bbf73b58d2aabdc93354@git.kernel.org>
Git-Commit-ID: 0a706db320768f8f6e43bbf73b58d2aabdc93354
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 23:13:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a706db320768f8f6e43bbf73b58d2aabdc93354
Gitweb:     http://git.kernel.org/tip/0a706db320768f8f6e43bbf73b58d2aabdc93354
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 18:19:00 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 9 Apr 2009 16:08:11 -0700

x86, setup: "glove box" BIOS interrupts in the MCA code

Impact: BIOS proofing

"Glove box" off BIOS interrupts in the MCA code.

LKML-Reference: <49DE7F79.4030106@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>


---
 arch/x86/boot/mca.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/mca.c b/arch/x86/boot/mca.c
index 911eaae..a95a531 100644
--- a/arch/x86/boot/mca.c
+++ b/arch/x86/boot/mca.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -16,26 +17,22 @@
 
 int query_mca(void)
 {
-	u8 err;
-	u16 es, bx, len;
-
-	asm("pushw %%es ; "
-	    "int $0x15 ; "
-	    "setc %0 ; "
-	    "movw %%es, %1 ; "
-	    "popw %%es"
-	    : "=acd" (err), "=acdSD" (es), "=b" (bx)
-	    : "a" (0xc000));
-
-	if (err)
+	struct biosregs ireg, oreg;
+	u16 len;
+
+	initregs(&ireg);
+	ireg.ah = 0xc0;
+	intcall(0x15, &ireg, &oreg);
+
+	if (oreg.eflags & X86_EFLAGS_CF)
 		return -1;	/* No MCA present */
 
-	set_fs(es);
-	len = rdfs16(bx);
+	set_fs(oreg.es);
+	len = rdfs16(oreg.bx);
 
 	if (len > sizeof(boot_params.sys_desc_table))
 		len = sizeof(boot_params.sys_desc_table);
 
-	copy_from_fs(&boot_params.sys_desc_table, bx, len);
+	copy_from_fs(&boot_params.sys_desc_table, oreg.bx, len);
 	return 0;
 }
