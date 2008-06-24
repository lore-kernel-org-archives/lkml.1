Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYFXSyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYFXSyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYFXSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:53:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:65516 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYFXSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jElBerP0jkrfxzOfSuNjfQq+TO9XXT9y0sOafiDc70Brz+MpUsKMQ08zprY2aUQC2B
         rJLtTnXbqcnHUDQOvQJsA6L663mII26teW+cga0VYg2M8AV5Rzw/CxRYtOhVEQkbs2PT
         K2yWF9c6fwGYEIMke796ngyXbr1JFwYof7op0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Tue, 24 Jun 2008 20:51:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <200806232300.57614.bzolnier@gmail.com> <1214303693.8011.345.camel@pasglop>
In-Reply-To: <1214303693.8011.345.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242051.22207.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008, Benjamin Herrenschmidt wrote:
> 
> > Build error and/or your build fix would be useful here.
> 
> Sorry. Fix was a quick hack. There is a check_media_bay() followed by a
> break; outside of a break-able construct in there (off memory, I'm not
> in front of the dev box right now).

Thanks, 'take 3' follows.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pmac: media-bay support fixes (take 3)

* If MB_CD device has already been detected and bay is in mb_up state just
  change bay's state to mb_ide_resetting and let probing thread do the rest
  instead of having open-coded waiting for IDE device to become ready in
  media_bay_set_ide_infos() and doing the probe by ide_device_add().

* Move media_bay_set_ide_infos() call after ide_device_add().

* Use check_media_bay() instead of check_media_bay_by_base(),
  then remove the latter function.

v2:
* Check pmif->mediabay and clear drive->noprobe before calling
  media_bay_set_ide_infos().

v3:
* Fix build problem noticed by Ben.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c         |   15 ++++++++++-----
 drivers/macintosh/mediabay.c   |   33 +++++----------------------------
 include/asm-powerpc/mediabay.h |    1 -
 3 files changed, 15 insertions(+), 34 deletions(-)

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
@@ -1067,7 +1063,7 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 
 	if (pmif->mediabay) {
 #ifdef CONFIG_PMAC_MEDIABAY
-		if (check_media_bay_by_base(pmif->regbase, MB_CD)) {
+		if (check_media_bay(np->parent, MB_CD) != -ENODEV) {
 #else
 		if (1) {
 #endif
@@ -1080,6 +1076,15 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 
 	ide_device_add(idx, &d);
 
+	if (pmif->mediabay) {
+		hwif->drives[0].noprobe = 0;
+		hwif->drives[1].noprobe = 0;
+#ifdef CONFIG_PMAC_MEDIABAY
+		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq,
+					hwif);
+#endif
+	}
+
 	return 0;
 }
 
Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -433,21 +433,6 @@ int check_media_bay(struct device_node *
 }
 EXPORT_SYMBOL(check_media_bay);
 
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
@@ -23,7 +23,6 @@ extern int media_bay_count;
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
 #include <linux/ide.h>
 
-int check_media_bay_by_base(unsigned long base, int what);
 /* called by IDE PMAC host driver to register IDE controller for media bay */
 int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
 			    int irq, ide_hwif_t *hwif);
