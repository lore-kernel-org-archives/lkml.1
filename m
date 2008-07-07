Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbYGGWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbYGGWB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYGGWA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:00:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9235 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298AbYGGWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=pSFJxkJl2TC6Ad+7fwwraZic25cJTY+Dpn/todHnNvqH2V5X9A7VhFMPOffy5d6Vdd
         LdFyUKVtSLLd2axK1i99NQI3V4GJgJb09uaTHAp9Q6dOZh1l3z3jvtrZr/nZA/JNof1X
         7bF5QXDCbs0z11uby1Gx98a2WaL+AnAKfXU9E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/10] ide-generic: minor fix for mips
Date: Mon, 7 Jul 2008 23:53:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807072353.02859.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ide_probe_legacy() call to ide_generic_init() so it fails
early if necessary and returns the proper error value (nowadays
ide_default_io_base() is used only by ide-generic).

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c           |    4 ++++
 include/asm-mips/mach-generic/ide.h |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -87,6 +87,10 @@ static int __init ide_generic_init(void)
 	unsigned long io_addr;
 	int i, rc;
 
+#ifdef CONFIG_MIPS
+	if (!ide_probe_legacy())
+		return -ENODEV;
+#endif
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -72,8 +72,6 @@ static __inline__ int ide_default_irq(un
 
 static __inline__ unsigned long ide_default_io_base(int index)
 {
-	if (!ide_probe_legacy())
-		return 0;
 	/*
 	 *      If PCI is present then it is not safe to poke around
 	 *      the other legacy IDE ports. Only 0x1f0 and 0x170 are
