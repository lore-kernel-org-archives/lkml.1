Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbXJXXsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbXJXXsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbXJXXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:48:20 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33744 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbXJXXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:48:20 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH] sound/oss/pss: set_io_base() always returns success, mark it void
Message-Id: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
Date: Wed, 24 Oct 2007 19:48:19 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 sound/oss/pss.c |   25 ++++++-------------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index ece428b..e970f75 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -232,14 +232,12 @@ static int set_irq(pss_confdata * devc, int dev, int irq)
 	return 1;
 }
 
-static int set_io_base(pss_confdata * devc, int dev, int base)
+static void set_io_base(pss_confdata * devc, int dev, int base)
 {
 	unsigned short  tmp = inw(REG(dev)) & 0x003f;
 	unsigned short  bits = (base & 0x0ffc) << 4;
 
 	outw(bits | tmp, REG(dev));
-
-	return 1;
 }
 
 static int set_dma(pss_confdata * devc, int dev, int dma)
@@ -677,16 +675,11 @@ static void configure_nonsound_components(void)
 	{
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
 	}
-	else if(check_region(pss_cdrom_port, 2))
-	{
+	else if(check_region(pss_cdrom_port, 2)) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	}
-	else if(!set_io_base(devc, CONF_CDROM, pss_cdrom_port))
-	{
-		printk(KERN_ERR "PSS: CDROM I/O port could not be set.\n");
-	}
-	else					/* CDROM port successfully configured */
-	{
+	else {
+		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
 		printk(KERN_INFO "PSS: CDROM I/O port set to 0x%x.\n", pss_cdrom_port);
 	}
 }
@@ -758,10 +751,7 @@ static int __init probe_pss_mpu(struct address_info *hw_config)
 		printk(KERN_ERR "PSS: MPU I/O port conflict\n");
 		return 0;
 	}
-	if (!set_io_base(devc, CONF_MIDI, hw_config->io_base)) {
-		printk(KERN_ERR "PSS: MIDI base could not be set.\n");
-		goto fail;
-	}
+	set_io_base(devc, CONF_MIDI, hw_config->io_base);
 	if (!set_irq(devc, CONF_MIDI, hw_config->irq)) {
 		printk(KERN_ERR "PSS: MIDI IRQ allocation error.\n");
 		goto fail;
@@ -1057,10 +1047,7 @@ static int __init probe_pss_mss(struct address_info *hw_config)
 		release_region(hw_config->io_base, 4);
 		return 0;
 	}
-	if (!set_io_base(devc, CONF_WSS, hw_config->io_base)) {
-		printk("PSS: WSS base not settable.\n");
-		goto fail;
-	}
+	set_io_base(devc, CONF_WSS, hw_config->io_base);
 	if (!set_irq(devc, CONF_WSS, hw_config->irq)) {
 		printk("PSS: WSS IRQ allocation error.\n");
 		goto fail;
-- 
1.5.2.4

