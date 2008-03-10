Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYCJXfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYCJXfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYCJXek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:34:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:14345 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYCJXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tMBRLWyYiC9ggenTKhuXGfs4HyM2W05N9Hd25aegPOhBXQJc9sy5V+5W/XXKfy/1GDN3J79oQn6G3jTOujjdhltC9ujaVdt+kA770LhlcKellHNmCrsJ24iSuQnMzLt/8sc9VDlhthMPLxxJK/ebsJOOcpQ6OjYWC2qCHLvlqQQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] ide: add "ignore_cable" kernel parameter
Date: Tue, 11 Mar 2008 00:47:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110047.08125.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "ignore_cable" kernel parameter:

* "ide_core.ignore_cable=[interface_number]" boot option if IDE is built-in
  (i.e. "ide_core.ignore_cable=1" to force ignoring cable for "ide1")

* "ignore_cable=[interface_number]" module parameter (for ide_core module)
  if IDE is compiled as module

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/ide.txt |   15 ++++++++++-----
 drivers/ide/ide.c         |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 5 deletions(-)

Index: b/Documentation/ide/ide.txt
===================================================================
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -242,11 +242,6 @@ Summary of ide driver parameters for ker
 
  "idex=reset"		: reset interface after probe
 
- "idex=ata66"		: informs the interface that it has an 80c cable
-			  for chipsets that are ATA-66 capable, but the
-			  ability to bit test for detection is currently
-			  unknown.
-
  "ide=reverse"		: formerly called to pci sub-system, but now local.
 
 The following are valid ONLY on ide0, which usually corresponds
@@ -275,6 +270,16 @@ are detected automatically).
 You also need to use "probe" kernel parameter for ide-4drives driver
 (support for IDE generic chipset with four drives on one port).
 
+To force ignoring cable detection (this should be needed only if you're using
+short 40-wires cable which cannot be automatically detected - if this is not
+a case please report it as a bug instead) use "ignore_cable" kernel parameter:
+
+* "ide_core.ignore_cable=[interface_number]" boot option if IDE is built-in
+  (i.e. "ide_core.ignore_cable=1" to force ignoring cable for "ide1")
+
+* "ignore_cable=[interface_number]" module parameter (for ide_core module)
+  if IDE is compiled as module
+
 ================================================================================
 
 Some Terminology
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1257,6 +1257,38 @@ struct class ide_port_class = {
 	.release	= ide_port_class_release,
 };
 
+static unsigned int ide_ignore_cable;
+
+static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
+{
+	unsigned long i = simple_strtoul(s, NULL, 0);
+
+	if (i >= MAX_HWIFS)
+		return -EINVAL;
+
+	ide_ignore_cable |= (1 << i);
+
+	return 0;
+}
+
+module_param_call(ignore_cable, ide_set_ignore_cable, NULL, NULL, 0);
+MODULE_PARM_DESC(ignore_cable, "ignore cable detection");
+
+static void __init ide_apply_params(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		ide_hwif_t *hwif = &ide_hwifs[i];
+
+		if (ide_ignore_cable & (1 << i)) {
+			printk(KERN_INFO "ide: ignoring cable detection for "
+					 "ide%d\n", i);
+			hwif->cbl = ATA_CBL_PATA40_SHORT;
+		}
+	}
+}
+
 /*
  * This is gets invoked once during initialization, to set *everything* up
  */
@@ -1285,6 +1317,8 @@ static int __init ide_init(void)
 
 	proc_ide_create();
 
+	ide_apply_params();
+
 	return 0;
 
 out_port_class:
