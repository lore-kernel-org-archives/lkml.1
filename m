Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYBEBQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYBEBQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbYBEBPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:15 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:16354 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYBEBPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TbCj+1W2Cs1D/j9X8c3cAzOrg/NcrJSuEp0zv2bPi4P1ZQFglP56JUcYb3f4nrx2aOP7nPxNpWzRt6XZZOdkh+xWODfW+UurU87mlN/0llUgltTI6K93OWO6rkGLSrfjI/Lne19z6jTYd5UllQsmKzUI08p281cwAYVPqqVg5y4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ppc: fix #ifdef-s in mediabay driver (take 2)
Date: Mon, 4 Feb 2008 20:47:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042047.52026.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Replace incorrect CONFIG_BLK_DEV_IDE #ifdef in
  check_media_bay() by CONFIG_MAC_FLOPPY one.

* Replace incorrect CONFIG_BLK_DEV_IDE #ifdef-s by
  CONFIG_BLK_DEV_IDE_PMAC ones.

* check_media_bay() is used only by drivers/block/swim3.c
  so make this function available only if CONFIG_MAC_FLOPPY
  is defined.

* check_media_bay_by_base() and media_bay_set_ide_infos()
  are used only by drivers/ide/ppc/pmac.c so so make these
  functions available only if CONFIG_MAC_FLOPPY is defined.

v2:
* Remove ifdefs from function prototypes. (Andrew Morton)

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/macintosh/mediabay.c   |   46 ++++++++++++++++++-----------------------
 include/asm-powerpc/mediabay.h |    8 +++----
 2 files changed, 25 insertions(+), 29 deletions(-)

Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -78,12 +78,14 @@ struct media_bay_info {
 	int				cached_gpio;
 	int				sleeping;
 	struct semaphore		lock;
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	void __iomem			*cd_base;
-	int 				cd_index;
 	int				cd_irq;
 	int				cd_retry;
 #endif
+#if defined(CONFIG_BLK_DEV_IDE_PMAC) || defined(CONFIG_MAC_FLOPPY)
+	int 				cd_index;
+#endif
 };
 
 #define MAX_BAYS	2
@@ -91,7 +93,7 @@ struct media_bay_info {
 static struct media_bay_info media_bays[MAX_BAYS];
 int media_bay_count = 0;
 
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 /* check the busy bit in the media-bay ide interface
    (assumes the media-bay contains an ide device) */
 #define MB_IDE_READY(i)	((readb(media_bays[i].cd_base + 0x70) & 0x80) == 0)
@@ -401,7 +403,7 @@ static void poll_media_bay(struct media_
 				set_mb_power(bay, id != MB_NO);
 				bay->content_id = id;
 				if (id == MB_NO) {
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 					bay->cd_retry = 0;
 #endif
 					printk(KERN_INFO "media bay %d is empty\n", bay->index);
@@ -414,9 +416,9 @@ static void poll_media_bay(struct media_
 	}
 }
 
+#ifdef CONFIG_MAC_FLOPPY
 int check_media_bay(struct device_node *which_bay, int what)
 {
-#ifdef CONFIG_BLK_DEV_IDE
 	int	i;
 
 	for (i=0; i<media_bay_count; i++)
@@ -426,14 +428,14 @@ int check_media_bay(struct device_node *
 			media_bays[i].cd_index = -1;
 			return -EINVAL;
 		}
-#endif /* CONFIG_BLK_DEV_IDE */
 	return -ENODEV;
 }
 EXPORT_SYMBOL(check_media_bay);
+#endif /* CONFIG_MAC_FLOPPY */
 
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 int check_media_bay_by_base(unsigned long base, int what)
 {
-#ifdef CONFIG_BLK_DEV_IDE
 	int	i;
 
 	for (i=0; i<media_bay_count; i++)
@@ -443,15 +445,13 @@ int check_media_bay_by_base(unsigned lon
 			media_bays[i].cd_index = -1;
 			return -EINVAL;
 		} 
-#endif
-	
+
 	return -ENODEV;
 }
 
 int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
-	int irq, int index)
+			    int irq, int index)
 {
-#ifdef CONFIG_BLK_DEV_IDE
 	int	i;
 
 	for (i=0; i<media_bay_count; i++) {
@@ -483,10 +483,10 @@ int media_bay_set_ide_infos(struct devic
 			return -ENODEV;
 		}
 	}
-#endif /* CONFIG_BLK_DEV_IDE */
-	
+
 	return -ENODEV;
 }
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 
 static void media_bay_step(int i)
 {
@@ -521,14 +521,13 @@ static void media_bay_step(int i)
 	    	bay->state = mb_resetting;
 		MBDBG("mediabay%d: waiting reset (kind:%d)\n", i, bay->content_id);
 	    	break;
-	    
 	case mb_resetting:
 		if (bay->content_id != MB_CD) {
 			MBDBG("mediabay%d: bay is up (kind:%d)\n", i, bay->content_id);
 			bay->state = mb_up;
 			break;
 	    	}
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 		MBDBG("mediabay%d: waiting IDE reset (kind:%d)\n", i, bay->content_id);
 		bay->ops->un_reset_ide(bay);
 	    	bay->timer = msecs_to_jiffies(MB_IDE_WAIT);
@@ -536,16 +535,14 @@ static void media_bay_step(int i)
 #else
 		printk(KERN_DEBUG "media-bay %d is ide (not compiled in kernel)\n", i);
 		set_mb_power(bay, 0);
-#endif /* CONFIG_BLK_DEV_IDE */
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 	    	break;
-	    
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	case mb_ide_resetting:
 	    	bay->timer = msecs_to_jiffies(MB_IDE_TIMEOUT);
 	    	bay->state = mb_ide_waiting;
 		MBDBG("mediabay%d: waiting IDE ready (kind:%d)\n", i, bay->content_id);
 	    	break;
-	    
 	case mb_ide_waiting:
 		if (bay->cd_base == NULL) {
 			bay->timer = 0;
@@ -587,11 +584,10 @@ static void media_bay_step(int i)
 			bay->timer = 0;
 	    	}
 		break;
-#endif /* CONFIG_BLK_DEV_IDE */
-
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 	case mb_powering_down:
 	    	bay->state = mb_empty;
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
     	        if (bay->cd_index >= 0) {
 			printk(KERN_DEBUG "Unregistering mb %d ide, index:%d\n", i,
 			       bay->cd_index);
@@ -607,7 +603,7 @@ static void media_bay_step(int i)
 				bay->content_id = MB_NO;
 			}
 	    	}
-#endif /* CONFIG_BLK_DEV_IDE */    
+#endif /* CONFIG_BLK_DEV_IDE_PMAC */
 		MBDBG("mediabay%d: end of power down\n", i);
 	    	break;
 	}
@@ -739,7 +735,7 @@ static int media_bay_resume(struct macio
 	       	bay->last_value = bay->content_id;
 	       	bay->value_count = msecs_to_jiffies(MB_STABLE_DELAY);
 	       	bay->timer = msecs_to_jiffies(MB_POWER_DELAY);
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	       	bay->cd_retry = 0;
 #endif
 	       	do {
@@ -829,7 +825,7 @@ static int __init media_bay_init(void)
 	for (i=0; i<MAX_BAYS; i++) {
 		memset((char *)&media_bays[i], 0, sizeof(struct media_bay_info));
 		media_bays[i].content_id	= -1;
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 		media_bays[i].cd_index		= -1;
 #endif
 	}
Index: b/include/asm-powerpc/mediabay.h
===================================================================
--- a/include/asm-powerpc/mediabay.h
+++ b/include/asm-powerpc/mediabay.h
@@ -18,14 +18,14 @@
 #define MB_NO		7	/* media bay contains nothing */
 
 int check_media_bay(struct device_node *which_bay, int what);
-int check_media_bay_by_base(unsigned long base, int what);
 
 /* Number of bays in the machine or 0 */
 extern int media_bay_count;
 
-/* called by pmac-ide.c to register IDE controller for media bay */
-extern int media_bay_set_ide_infos(struct device_node* which_bay,
-			unsigned long base, int irq, int index);
+int check_media_bay_by_base(unsigned long base, int what);
+/* called by IDE PMAC host driver to register IDE controller for media bay */
+int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
+			    int irq, int index);
 
 #endif /* __KERNEL__ */
 #endif /* _PPC_MEDIABAY_H */
