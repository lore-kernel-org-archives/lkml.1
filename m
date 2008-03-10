Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYCJXfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYCJXfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYCJXeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:34:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:1266 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYCJXel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=G6ObYeFKfxsBo/Xk0ppbGXwRg2AcsCwgGR8k2IlESwppwH1OezPCCGGyPYkUDrLFutPK7HR3irSD0Zq9UcBzOKqK8JtQtsB8uQjB1jMDIBjo/ecBa8qmbxzHpjQMQdhZ1cS49BXUliQzSkupw5A4K+08McXqykl9um4bj79v+ig=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] ide: remove obsoleted "idex=reset" kernel parameter
Date: Tue, 11 Mar 2008 00:48:29 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110048.29285.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove obsoleted "idex=reset" kernel parameter
(it has been obsoleted since 1 Nov 2004).

Then remove corresponding code from ide_probe_port()
and no longer used ->reset field from ide_hwif_t.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |    2 --
 drivers/ide/ide-probe.c   |    9 ++-------
 drivers/ide/ide.c         |    6 ++----
 include/linux/ide.h       |    1 -
 4 files changed, 4 insertions(+), 14 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -235,8 +235,6 @@ Summary of ide driver parameters for ker
 			  As for VLB, it is safest to not specify it.
 			  Bigger values are safer than smaller ones.
 
- "idex=reset"		: reset interface after probe
-
  "ide=reverse"		: formerly called to pci sub-system, but now local.
 
 The following are valid ONLY on ide0, which usually corresponds
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -799,14 +799,9 @@ static int ide_probe_port(ide_hwif_t *hw
 		if (drive->present)
 			rc = 0;
 	}
-	if (hwif->io_ports[IDE_CONTROL_OFFSET] && hwif->reset) {
-		printk(KERN_WARNING "%s: reset\n", hwif->name);
-		hwif->OUTB(12, hwif->io_ports[IDE_CONTROL_OFFSET]);
-		udelay(10);
-		hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
-		(void)ide_busy_sleep(hwif);
-	}
+
 	local_irq_restore(flags);
+
 	/*
 	 * Use cached IRQ number. It might be (and is...) changed by probe
 	 * code above
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1006,7 +1006,7 @@ static int __init ide_setup(char *s)
 		 */
 		static const char *ide_words[] = {
 			"minus1", "minus2", "minus3", "minus4",
-			"reset", "minus6", "ata66", "minus8", "minus9",
+			"minus5", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
 
@@ -1088,9 +1088,7 @@ static int __init ide_setup(char *s)
 #else
 				goto bad_hwif;
 #endif
-			case -5: /* "reset" */
-				hwif->reset = 1;
-				goto obsolete_option;
+			case -5:
 			case -2:
 			case -1:
 			case 0:
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -521,7 +521,6 @@ typedef struct hwif_s {
 	unsigned	present    : 1;	/* this interface exists */
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
-	unsigned	reset      : 1;	/* reset after probe */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 	unsigned	mmio       : 1; /* host uses MMIO */
 
