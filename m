Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZAAROw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZAAROw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZAAROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:14:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46736 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZAAROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:14:41 -0500
Date: Thu, 1 Jan 2009 18:14:35 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] sound: Use usb_set/get_intfdata
Message-ID: <Pine.LNX.4.64.0901011814080.20447@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the USB functions usb_get_intfdata and usb_set_intfdata instead of
dev_get_drvdata and dev_set_drvdata, respectively.

The semantic patch that makes this change for the usb_get_intfdata case is
as follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@header@
@@

#include <linux/usb.h>

@same depends on header@
position p;
@@

usb_get_intfdata@p(...) { ... }

@depends on header@
position _p!=same.p;
identifier _f;
struct usb_interface*intf;
@@

_f@_p(...) { <+...
- dev_get_drvdata(&intf->dev)
+ usb_get_intfdata(intf)
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/usb/caiaq/caiaq-device.c |    4 ++--
 sound/usb/usbaudio.c           |    8 ++++----
 sound/usb/usx2y/us122l.c       |    4 ++--
 sound/usb/usx2y/usbusx2y.c     |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/usb/caiaq/caiaq-device.c b/sound/usb/caiaq/caiaq-device.c
index b143ef7..a62500e 100644
--- a/sound/usb/caiaq/caiaq-device.c
+++ b/sound/usb/caiaq/caiaq-device.c
@@ -446,7 +446,7 @@ static int __devinit snd_probe(struct usb_interface *intf,
 	if (!card)
 		return -ENOMEM;
 			
-	dev_set_drvdata(&intf->dev, card);
+	usb_set_intfdata(intf, card);
 	ret = init_card(caiaqdev(card));
 	if (ret < 0) {
 		log("unable to init card! (ret=%d)\n", ret);
@@ -460,7 +460,7 @@ static int __devinit snd_probe(struct usb_interface *intf,
 static void snd_disconnect(struct usb_interface *intf)
 {
 	struct snd_usb_caiaqdev *dev;
-	struct snd_card *card = dev_get_drvdata(&intf->dev);
+	struct snd_card *card = usb_get_intfdata(intf);
 
 	debug("%s(%p)\n", __func__, intf);
 
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index bbd70d5..c709b95 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -3709,7 +3709,7 @@ static int usb_audio_probe(struct usb_interface *intf,
 	void *chip;
 	chip = snd_usb_audio_probe(interface_to_usbdev(intf), intf, id);
 	if (chip) {
-		dev_set_drvdata(&intf->dev, chip);
+		usb_set_intfdata(intf, chip);
 		return 0;
 	} else
 		return -EIO;
@@ -3718,13 +3718,13 @@ static int usb_audio_probe(struct usb_interface *intf,
 static void usb_audio_disconnect(struct usb_interface *intf)
 {
 	snd_usb_audio_disconnect(interface_to_usbdev(intf),
-				 dev_get_drvdata(&intf->dev));
+				 usb_get_intfdata(intf));
 }
 
 #ifdef CONFIG_PM
 static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
 {
-	struct snd_usb_audio *chip = dev_get_drvdata(&intf->dev);
+	struct snd_usb_audio *chip = usb_get_intfdata(intf);
 	struct list_head *p;
 	struct snd_usb_stream *as;
 
@@ -3744,7 +3744,7 @@ static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
 
 static int usb_audio_resume(struct usb_interface *intf)
 {
-	struct snd_usb_audio *chip = dev_get_drvdata(&intf->dev);
+	struct snd_usb_audio *chip = usb_get_intfdata(intf);
 
 	if (chip == (void *)-1L)
 		return 0;
diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index c2515b6..73e59f4 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -589,7 +589,7 @@ static int snd_us122l_suspend(struct usb_interface *intf, pm_message_t message)
 	struct us122l *us122l;
 	struct list_head *p;
 
-	card = dev_get_drvdata(&intf->dev);
+	card = usb_get_intfdata(intf);
 	if (!card)
 		return 0;
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -615,7 +615,7 @@ static int snd_us122l_resume(struct usb_interface *intf)
 	struct list_head *p;
 	int err;
 
-	card = dev_get_drvdata(&intf->dev);
+	card = usb_get_intfdata(intf);
 	if (!card)
 		return 0;
 
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index e5981a6..ca26c53 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -392,7 +392,7 @@ static int snd_usX2Y_probe(struct usb_interface *intf, const struct usb_device_i
 	void *chip;
 	chip = usX2Y_usb_probe(interface_to_usbdev(intf), intf, id);
 	if (chip) {
-		dev_set_drvdata(&intf->dev, chip);
+		usb_set_intfdata(intf, chip);
 		return 0;
 	} else
 		return -EIO;
@@ -401,7 +401,7 @@ static int snd_usX2Y_probe(struct usb_interface *intf, const struct usb_device_i
 static void snd_usX2Y_disconnect(struct usb_interface *intf)
 {
 	usX2Y_usb_disconnect(interface_to_usbdev(intf),
-				 dev_get_drvdata(&intf->dev));
+				 usb_get_intfdata(intf));
 }
 
 MODULE_DEVICE_TABLE(usb, snd_usX2Y_usb_id_table);
