Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbXDLTP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbXDLTP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXDLTP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:15:56 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:54606 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXDLTPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:15:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] EFI: warn only for pre-1.00 system tables
Date: Thu, 12 Apr 2007 13:15:40 -0600
User-Agent: KMail/1.9.5
Cc: Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121315.40754.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We used to warn unless the EFI system table major revision was exactly 1.
But EFI 2.00 firmware is starting to appear, and the 2.00 changes don't
affect anything in Linux.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/include/linux/efi.h
===================================================================
--- w.orig/include/linux/efi.h	2007-04-12 13:07:13.000000000 -0600
+++ w/include/linux/efi.h	2007-04-12 13:07:15.000000000 -0600
@@ -213,7 +213,6 @@
 } efi_config_table_t;
 
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
-#define EFI_SYSTEM_TABLE_REVISION  ((1 << 16) | 00)
 
 typedef struct {
 	efi_table_hdr_t hdr;
Index: w/arch/i386/kernel/efi.c
===================================================================
--- w.orig/arch/i386/kernel/efi.c	2007-04-12 13:07:13.000000000 -0600
+++ w/arch/i386/kernel/efi.c	2007-04-12 13:07:15.000000000 -0600
@@ -349,14 +349,12 @@
 		printk(KERN_ERR PFX "Woah! Couldn't map the EFI system table.\n");
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		printk(KERN_ERR PFX "Woah! EFI system table signature incorrect\n");
-	if ((efi.systab->hdr.revision ^ EFI_SYSTEM_TABLE_REVISION) >> 16 != 0)
-		printk(KERN_ERR PFX
-		       "Warning: EFI system table major version mismatch: "
-		       "got %d.%02d, expected %d.%02d\n",
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_ERR PFX "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
 		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff,
-		       EFI_SYSTEM_TABLE_REVISION >> 16,
-		       EFI_SYSTEM_TABLE_REVISION & 0xffff);
+		       efi.systab->hdr.revision & 0xffff);
+
 	/*
 	 * Grab some details from the system table
 	 */
Index: w/arch/ia64/kernel/efi.c
===================================================================
--- w.orig/arch/ia64/kernel/efi.c	2007-04-12 13:07:13.000000000 -0600
+++ w/arch/ia64/kernel/efi.c	2007-04-12 13:07:15.000000000 -0600
@@ -448,11 +448,11 @@
 		panic("Woah! Can't find EFI system table.\n");
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		panic("Woah! EFI system table signature incorrect\n");
-	if ((efi.systab->hdr.revision ^ EFI_SYSTEM_TABLE_REVISION) >> 16 != 0)
-		printk(KERN_WARNING "Warning: EFI system table major version mismatch: "
-		       "got %d.%02d, expected %d.%02d\n",
-		       efi.systab->hdr.revision >> 16, efi.systab->hdr.revision & 0xffff,
-		       EFI_SYSTEM_TABLE_REVISION >> 16, EFI_SYSTEM_TABLE_REVISION & 0xffff);
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_WARNING "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff);
 
 	config_tables = __va(efi.systab->tables);
 
Index: w/arch/ia64/hp/sim/boot/fw-emu.c
===================================================================
--- w.orig/arch/ia64/hp/sim/boot/fw-emu.c	2007-04-12 13:07:13.000000000 -0600
+++ w/arch/ia64/hp/sim/boot/fw-emu.c	2007-04-12 13:07:15.000000000 -0600
@@ -287,7 +287,7 @@
 
 	memset(efi_systab, 0, sizeof(efi_systab));
 	efi_systab->hdr.signature = EFI_SYSTEM_TABLE_SIGNATURE;
-	efi_systab->hdr.revision  = EFI_SYSTEM_TABLE_REVISION;
+	efi_systab->hdr.revision  = ((1 << 16) | 00);
 	efi_systab->hdr.headersize = sizeof(efi_systab->hdr);
 	efi_systab->fw_vendor = __pa("H\0e\0w\0l\0e\0t\0t\0-\0P\0a\0c\0k\0a\0r\0d\0\0");
 	efi_systab->fw_revision = 1;
