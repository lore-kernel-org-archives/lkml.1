Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYFPTYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYFPTYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYFPTXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:23:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:10726 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYFPTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=gD+3C83Yr4fyC8fNVRVQJR4Z3/nVJyXQti0DQA29yfssAkq84Nl+3TLkFWUbycnMLf
         97u5y/PLJOqzVBi7D7PqMy7LPFqtgdGimo+GJfcVwKpTJZCihAyK6olNPFGxUTwMIp20
         5hs2mNNvlcXXMfHfFlguLj9PvxrwR3O/9poJo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Mon, 16 Jun 2008 21:24:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806162124.43005.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* If MB_CD device has already been detected and bay is in mb_up state just
  change bay's state to mb_ide_resetting and let probing thread do the rest
  instead of having open-coded waiting for IDE device to become ready in
  media_bay_set_ide_infos() and doing the probe by ide_device_add().

* Move media_bay_set_ide_infos() call after ide_device_add().

* Use check_media_bay() instead of check_media_bay_by_base(),
  then remove the latter function.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
unchanged patch

 drivers/ide/ppc/pmac.c         |   18 ++++++++----------
 drivers/macintosh/mediabay.c   |   33 +++++----------------------------
 include/asm-powerpc/mediabay.h |    1 -
 3 files changed, 13 insertions(+), 39 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1030,10 +1030,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	/* XXX FIXME: Media bay stuff need re-organizing */
 	if (np->parent && np->parent->name
 	    && strcasecmp(np->parent->name, "media-bay") == 0) {
-#ifdef CONFIG_PMAC_MEDIABAY
-		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq,
-					hwif);
-#endif /* CONFIG_PMAC_MEDIABAY */
 		pmif->mediabay = 1;
 		if (!bidp)
 			pmif->aapl_bus_id = 1;
@@ -1067,19 +1063,21 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 
 	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
-		if (check_media_bay_by_base(pmif->regbase, MB_CD)) {
-#else
-		if (1) {
+		if (check_media_bay(np->parent, MB_CD) == -ENODEV)
+			break;
 #endif
-			hwif->drives[0].noprobe = 1;
-			hwif->drives[1].noprobe = 1;
-		}
+		hwif->drives[0].noprobe = 1;
+		hwif->drives[1].noprobe = 1;
 	}
 
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d);
 
+#ifdef CONFIG_PMAC_MEDIABAY
+	media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq, hwif);
+#endif
+
 	return 0;
 }
 
Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -433,21 +433,6 @@ int check_media_bay(struct device_node *
 EXPORT_SYMBOL(check_media_bay);
 
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
-int check_media_bay_by_base(unsigned long base, int what)
-{
-	int	i;
-
-	for (i=0; i<media_bay_count; i++)
-		if (media_bays[i].mdev && base == (unsigned long) media_bays[i].cd_base) {
-			if ((what == media_bays[i].content_id) && media_bays[i].state == mb_up)
-				return 0;
-			media_bays[i].cd_index = -1;
-			return -EINVAL;
-		} 
-
-	return -ENODEV;
-}
-
 int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
 			    int irq, ide_hwif_t *hwif)
 {
@@ -457,8 +442,6 @@ int media_bay_set_ide_infos(struct devic
 		struct media_bay_info* bay = &media_bays[i];
 
 		if (bay->mdev && which_bay == bay->mdev->ofdev.node) {
-			int timeout = 5000, index = hwif->index;
-			
 			down(&bay->lock);
 
 			bay->cd_port	= hwif;
@@ -469,18 +452,12 @@ int media_bay_set_ide_infos(struct devic
 				up(&bay->lock);
 				return 0;
 			}
-			printk(KERN_DEBUG "Registered ide%d for media bay %d\n", index, i);
-			do {
-				if (MB_IDE_READY(i)) {
-					bay->cd_index	= index;
-					up(&bay->lock);
-					return 0;
-				}
-				mdelay(1);
-			} while(--timeout);
-			printk(KERN_DEBUG "Timeount waiting IDE in bay %d\n", i);
+
+			/* let probing thread do the rest */
+			bay->state = mb_ide_resetting;
+
 			up(&bay->lock);
-			return -ENODEV;
+			return 0;
 		}
 	}
 
Index: b/include/asm-powerpc/mediabay.h
===================================================================
--- a/include/asm-powerpc/mediabay.h
+++ b/include/asm-powerpc/mediabay.h
@@ -25,7 +25,6 @@ extern int media_bay_count;
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 #include <linux/ide.h>
 
-int check_media_bay_by_base(unsigned long base, int what);
 /* called by IDE PMAC host driver to register IDE controller for media bay */
 int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
 			    int irq, ide_hwif_t *hwif);
