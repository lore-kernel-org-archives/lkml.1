Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbYAVXAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbYAVXAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbYAVXAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:00:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:6284 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYAVW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:59:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=WuUmAuYq8O9cCpzHs1IBl1w+XL7uNBr5dZtcQKGOGKPxDxwvwPM0wRjTKmD+gUuiWWnT4KhiJbC6LHUKZbT3CYnDMPC0Yggi1wOidg/yXKBmlH1/VBormHNsaDw3lJ5g+dba9cwB1RxlVto3V8BUE/q+oX3rSB2165GsZ6b8ses=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ppc: fix #ifdef-s in mediabay driver
Date: Wed, 23 Jan 2008 00:12:38 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801230012.38516.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Ben, IMO this patch is safe for 2.6.24 (assuming that it builds fine :),
otherwise I would like to ask for permission to merge it through IDE
tree since I have other pending IDE patches depending on this one.

 drivers/macintosh/mediabay.c   |   46 ++++++++++++++++++-----------------------
 include/asm-powerpc/mediabay.h |   13 ++++++++---
 2 files changed, 30 insertions(+), 29 deletions(-)

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
@@ -745,7 +741,7 @@ static int media_bay_resume(struct macio
 	       	bay->last_value = bay->content_id;
 	       	bay->value_count = msecs_to_jiffies(MB_STABLE_DELAY);
 	       	bay->timer = msecs_to_jiffies(MB_POWER_DELAY);
-#ifdef CONFIG_BLK_DEV_IDE
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 	       	bay->cd_retry = 0;
 #endif
 	       	do {
@@ -835,7 +831,7 @@ static int __init media_bay_init(void)
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
@@ -17,15 +17,20 @@
 #define MB_POWER	6	/* media bay contains a Power device (???) */
 #define MB_NO		7	/* media bay contains nothing */
 
+#idef CONFIG_MAC_FLOPPY
 int check_media_bay(struct device_node *which_bay, int what);
-int check_media_bay_by_base(unsigned long base, int what);
+#endif
+
 
 /* Number of bays in the machine or 0 */
 extern int media_bay_count;
 
-/* called by pmac-ide.c to register IDE controller for media bay */
-extern int media_bay_set_ide_infos(struct device_node* which_bay,
-			unsigned long base, int irq, int index);
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
+int check_media_bay_by_base(unsigned long base, int what);
+/* called by IDE PMAC host driver to register IDE controller for media bay */
+int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
+			    int irq, int index);
+#endif
 
 #endif /* __KERNEL__ */
 #endif /* _PPC_MEDIABAY_H */
