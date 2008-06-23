Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYFWVok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYFWVok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbYFWVoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:44:24 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:35964 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbYFWVoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=X9hIaNe7XSO4sr8559My4/CMKtp6YWD2MBwOX5RHqVUltcqUm9cyeJpD6zufzT17L6
         sCxz+v0AdZ0fZcTHAPKHU4yGC1ZB48y8Uw0J22EgkB3vC4l4lM6d8j2bfxxJ0AhiUWe2
         uBOh9pjCZCrI6BdMS8yW0anApbLCuUvUH8rvU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Mon, 23 Jun 2008 23:00:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <1214200453.8011.232.camel@pasglop> <1214203312.8011.246.camel@pasglop>
In-Reply-To: <1214203312.8011.246.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806232300.57614.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Benjamin Herrenschmidt wrote:
> 
> > Don't panic. It looks like it's something else in linux-next that's
> > changing some ifdef's in the media-bay code which is causing that.
> > 
> > I managed to pull linux next at the merge point with your tree and
> > things apply. I'll use that to test.
> 
> Ok, it doesn't work properly. It gets error trying to register
> the IDE device. Booting with a CD drive in and no disk in the drive
> gives the log below.
> 
> I've verified that it works without your patches. If I apply only patch
> 1, it doesn't build due to some wrong construct in the probe code. I've
> hand fixed it, but then I hit a BUG_ON in ide_probe_port() (line 773).

Build error and/or your build fix would be useful here.

> mediabay boot time messages (before IDE probing) are:
> 
> mediabay0: Registered Heathrow media-bay
> mediabay0: powering down
> mediabay0: switching to 3
> mediabay0: powering up
> mediabay0: enabling (kind:3)
> mediabay0: waiting reset (kind:3)
> mediabay0: waiting IDE reset (kind:3)
> mediabay0: waiting IDE ready (kind:3)
> mediabay0: up before IDE init
> mediabay1: Registered Heathrow media-bay
> mediabay1: powering down
> mediabay1: switching to 0
> mediabay1: powering up
> mediabay1: enabling (kind:0)
> mediabay1: waiting reset (kind:0)
> mediabay1: bay is up (kind:0)
> 
> Later, IDE registers:
> 
> (ide0 is another controller, only ide1 and ide2 are media bay based, and
> ide2 has no device on it at all).
> 
> ide-pmac: Found Apple Heathrow ATA controller (macio), bus ID 1 (mediabay), irq  35
> ide1 at 0xc7020000-0xc7020070,0xc7020160 on irq 35
> ide-pmac: Found Apple Heathrow ATA controller (macio), bus ID 4 (mediabay), irq  67
> ide2 at 0xc7022000-0xc7022070,0xc7022160 on irq 67
> mediabay0: waiting IDE ready (kind:3)
> mediabay 0, registering IDE...
> IDE register error

Ok, I see the problem - we now need to clear dive->noprobe after
ide_device_add() call (pmac.c) or later ide_port_scan() call (mediabay.c)
will fail...  also there was a pmif->mediabay check missing...

Please try the new version of patch #1 (the other patches are unchanged):

[...]

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-pmac: media-bay support fixes (take 2)

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

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c         |   23 +++++++++++++----------
 drivers/macintosh/mediabay.c   |   33 +++++----------------------------
 include/asm-powerpc/mediabay.h |    1 -
 3 files changed, 18 insertions(+), 39 deletions(-)

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
@@ -1067,19 +1063,26 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 
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
