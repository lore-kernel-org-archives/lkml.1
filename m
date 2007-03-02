Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXCBUio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXCBUio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXCBUio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:38:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:62624 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbXCBUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=MMchM9rA56b6cXDxT20ZIPEAuSWiEIHRno5TuKiS4kogQhMl0FM37yCycyui+SSBm1VU4GJ6MijAqWwcax280yndxLIVfoDEyItl+UzktwCESNeeu1AKH51x64ad87Wzq/cqqmqYNyJuVC4PNB7vkiNmJIhNTaIW4t3WNlTSzV4=
Date: Fri, 2 Mar 2007 23:38:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel-list <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Dan Aloni <da-x@monatomic.org>
Subject: [PATCH] MTD: ESB2 check for closed ROM window
Message-ID: <20070302203836.GA10525@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for closed ROM window
on Intel ESB2 Southbridge.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

I made this patch looking into ichxrom.c from which
ESB2 driver has been derived. So review for the patch
is needed :) Actually a such checking takes a place in
original ichxrom.c so ESB2 should has it too I think.

 drivers/mtd/maps/esb2rom.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/esb2rom.c b/drivers/mtd/maps/esb2rom.c
index 0bc013f..aa64a47 100644
--- a/drivers/mtd/maps/esb2rom.c
+++ b/drivers/mtd/maps/esb2rom.c
@@ -30,7 +30,7 @@
 
 #define ROM_PROBE_STEP_SIZE (64*1024) /* 64KiB */
 
-#define BIOS_CNTL	0xDC
+#define BIOS_CNTL		0xDC
 #define BIOS_LOCK_ENABLE	0x02
 #define BIOS_WRITE_ENABLE	0x01
 
@@ -145,7 +145,7 @@ static void esb2rom_cleanup(struct esb2rom_window *window)
 }
 
 static int __devinit esb2rom_init_one(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+				      const struct pci_device_id *ent)
 {
 	static char *rom_probe_types[] = { "cfi_probe", "jedec_probe", NULL };
 	struct esb2rom_window *window = &esb2rom_window;
@@ -185,7 +185,7 @@ static int __devinit esb2rom_init_one(struct pci_dev *pdev,
 	/* Find a region continuous to the end of the ROM window  */
 	window->phys = 0;
 	pci_read_config_word(pdev, FWH_DEC_EN1, &word);
-	printk(KERN_DEBUG "pci_read_config_byte : %x\n", word);
+	printk(KERN_DEBUG "pci_read_config_word : %x\n", word);
 
 	if ((word & FWH_8MiB) == FWH_8MiB)
 		window->phys = 0xff400000;
@@ -212,6 +212,11 @@ static int __devinit esb2rom_init_one(struct pci_dev *pdev,
 	else if ((word & FWH_0_5MiB) == FWH_0_5MiB)
 		window->phys = 0xfff80000;
 
+	if (window->phys == 0) {
+		printk(KERN_ERR MOD_NAME ": Rom window is closed\n");
+		goto out;
+	}
+
 	/* reserved  0x0020 and 0x0010 */
 	window->phys -= 0x400000UL;
 	window->size = (0xffffffffUL - window->phys) + 1UL;
