Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYJ3B12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYJ3B12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYJ3B1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:27:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:4551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYJ3B1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:27:19 -0400
Subject: sound: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:27:20 +0100
Message-Id: <1225330040.5970.83.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sound: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Takashi Iwai <tiwai@suse.de>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 6704acb..bd510ec 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1927,9 +1927,9 @@ static int snd_ac97_dev_register(struct snd_device *device)
 	ac97->dev.bus = &ac97_bus_type;
 	ac97->dev.parent = ac97->bus->card->dev;
 	ac97->dev.release = ac97_device_release;
-	snprintf(ac97->dev.bus_id, BUS_ID_SIZE, "%d-%d:%s",
-		 ac97->bus->card->number, ac97->num,
-		 snd_ac97_get_short_name(ac97));
+	dev_set_name(&ac97->dev, "%d-%d:%s",
+		     ac97->bus->card->number, ac97->num,
+		     snd_ac97_get_short_name(ac97));
 	if ((err = device_register(&ac97->dev)) < 0) {
 		snd_printk(KERN_ERR "Can't register ac97 bus\n");
 		ac97->dev.bus = NULL;


