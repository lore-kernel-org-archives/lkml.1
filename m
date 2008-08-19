Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYHSSiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYHSSiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYHSShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:37:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:47611 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYHSShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=kwaFBBeDurgwJKgBslBQ/BobJJcrGqBNA2iWaSdHKu4GP6p7w+xDMZ+7fSQM43JXaJ
         nZ3EE4v4hXXu+1udg/bFLa75EQ4/ry5xxJT5enlvpPHB+2xV7eYyv3+7jZodtoQsMqPn
         V19oXsVptR8Hf38Br/Nr7jG/OpKEEJsu+xRFM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] ide-generic: remove no longer needed ide_probe_legacy()
Date: Tue, 19 Aug 2008 20:33:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192033.30305.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is now a generic solution [ide_generic_check_pci_legacy_iobases()]
so MIPS-specific ide_probe_legacy() is no longer necessary.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c           |    4 ----
 include/asm-mips/mach-generic/ide.h |   29 -----------------------------
 2 files changed, 33 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -141,10 +141,6 @@ static int __init ide_generic_init(void)
 	unsigned long io_addr;
 	int i, rc = 0, primary = 0, secondary = 0;
 
-#ifdef CONFIG_MIPS
-	if (!ide_probe_legacy())
-		return -ENODEV;
-#endif
 	ide_generic_check_pci_legacy_iobases(&primary, &secondary);
 
 	if (!probe_mask) {
Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -19,35 +19,6 @@
 #include <linux/stddef.h>
 #include <asm/processor.h>
 
-static __inline__ int ide_probe_legacy(void)
-{
-#ifdef CONFIG_PCI
-	struct pci_dev *dev;
-	/*
-	 * This can be called on the ide_setup() path, super-early in
-	 * boot.  But the down_read() will enable local interrupts,
-	 * which can cause some machines to crash.  So here we detect
-	 * and flag that situation and bail out early.
-	 */
-	if (no_pci_devices())
-		return 0;
-	dev = pci_get_class(PCI_CLASS_BRIDGE_EISA << 8, NULL);
-	if (dev)
-		goto found;
-	dev = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, NULL);
-	if (dev)
-		goto found;
-	return 0;
-found:
-	pci_dev_put(dev);
-	return 1;
-#elif defined(CONFIG_EISA) || defined(CONFIG_ISA)
-	return 1;
-#else
-	return 0;
-#endif
-}
-
 /* MIPS port and memory-mapped I/O string operations.  */
 static inline void __ide_flush_prologue(void)
 {
