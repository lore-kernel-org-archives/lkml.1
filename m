Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYAHMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYAHMew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 07:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYAHMem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 07:34:42 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:65422 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750695AbYAHMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 07:34:41 -0500
Date: Tue, 8 Jan 2008 13:34:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Christoph Lameter <clameter@sgi.com>,
       kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       bunk@kernel.org, apw@shadowen.org, balbir@linux.vnet.ibm.com
Subject: Fix for __you_cannot_kmalloc_that_much failure with gcc 3.2
Message-ID: <20080108133438.7d0b41f4@hyperion.delvare>
In-Reply-To: <20080108105609.197a2874@hyperion.delvare>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<478200A4.4090707@linux.vnet.ibm.com>
	<20080107100733.3655f74f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com>
	<20080107113831.0865cf5e.akpm@linux-foundation.org>
	<20080108105609.197a2874@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 10:56:09 +0100, Jean Delvare wrote:
> I'll now check if I can do something similar for snd-mixer-oss.

And here you go, this is a unified patch fixing both bugs. The dmi-id
part is unchanged. Testers and reviewers are welcome.

* * * * *

gcc 3.2 has a hard time coping with the code in dmi_id_init():

drivers/built-in.o(.init.text+0x789e): In function `dmi_id_init':
: undefined reference to `__you_cannot_kmalloc_that_much'
make: *** [.tmp_vmlinux1] Error 1

Moving half of the code to a separate function seems to help. This is
a no-op for gcc 4.1 which will successfully inline the code anyway.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

A similar problem has been reported in snd_mixer_oss_build_input(),
fix it as well.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Dave Airlie <airlied@linux.ie>
---
 drivers/firmware/dmi-id.c  |   17 +++++--
 sound/core/oss/mixer_oss.c |  101 +++++++++++++++++++++++++++-----------------
 2 files changed, 75 insertions(+), 43 deletions(-)

--- linux-2.6.24-rc7.orig/drivers/firmware/dmi-id.c	2008-01-08 12:57:48.000000000 +0100
+++ linux-2.6.24-rc7/drivers/firmware/dmi-id.c	2008-01-08 13:06:15.000000000 +0100
@@ -175,12 +175,9 @@ static struct device *dmi_dev;
 
 extern int dmi_available;
 
-static int __init dmi_id_init(void)
+static void __init dmi_id_init_attr_table(void)
 {
-	int ret, i;
-
-	if (!dmi_available)
-		return -ENODEV;
+	int i;
 
 	/* Not necessarily all DMI fields are available on all
 	 * systems, hence let's built an attribute table of just
@@ -205,6 +202,16 @@ static int __init dmi_id_init(void)
 	ADD_DMI_ATTR(chassis_serial,    DMI_CHASSIS_SERIAL);
 	ADD_DMI_ATTR(chassis_asset_tag, DMI_CHASSIS_ASSET_TAG);
 	sys_dmi_attributes[i++] = &sys_dmi_modalias_attr.attr;
+}
+
+static int __init dmi_id_init(void)
+{
+	int ret;
+
+	if (!dmi_available)
+		return -ENODEV;
+
+	dmi_id_init_attr_table();
 
 	ret = class_register(&dmi_class);
 	if (ret)
--- linux-2.6.24-rc7.orig/sound/core/oss/mixer_oss.c	2008-01-08 12:57:48.000000000 +0100
+++ linux-2.6.24-rc7/sound/core/oss/mixer_oss.c	2008-01-08 13:21:12.000000000 +0100
@@ -925,6 +925,68 @@ static void mixer_slot_clear(struct snd_
 	rslot->number = idx;
 }
 
+/* In a separate function to keep gcc 3.2 happy - do NOT merge this in
+   snd_mixer_oss_build_input! */
+static int snd_mixer_oss_build_test_all(struct snd_mixer_oss *mixer,
+					struct snd_mixer_oss_assign_table *ptr,
+					struct slot *slot)
+{
+	char str[64];
+	int err;
+
+	err = snd_mixer_oss_build_test(mixer, slot, ptr->name, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GLOBAL);
+	if (err)
+		return err;
+	sprintf(str, "%s Switch", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GSWITCH);
+	if (err)
+		return err;
+	sprintf(str, "%s Route", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GROUTE);
+	if (err)
+		return err;
+	sprintf(str, "%s Volume", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_GVOLUME);
+	if (err)
+		return err;
+	sprintf(str, "%s Playback Switch", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_PSWITCH);
+	if (err)
+		return err;
+	sprintf(str, "%s Playback Route", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_PROUTE);
+	if (err)
+		return err;
+	sprintf(str, "%s Playback Volume", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_PVOLUME);
+	if (err)
+		return err;
+	sprintf(str, "%s Capture Switch", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_CSWITCH);
+	if (err)
+		return err;
+	sprintf(str, "%s Capture Route", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_CROUTE);
+	if (err)
+		return err;
+	sprintf(str, "%s Capture Volume", ptr->name);
+	err = snd_mixer_oss_build_test(mixer, slot, str, ptr->index,
+				       SNDRV_MIXER_OSS_ITEM_CVOLUME);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 /*
  * build an OSS mixer element.
  * ptr_allocated means the entry is dynamically allocated (change via proc file).
@@ -944,44 +1006,7 @@ static int snd_mixer_oss_build_input(str
 
 	memset(&slot, 0, sizeof(slot));
 	memset(slot.numid, 0xff, sizeof(slot.numid)); /* ID_UNKNOWN */
-	if (snd_mixer_oss_build_test(mixer, &slot, ptr->name, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GLOBAL))
-		return 0;
-	sprintf(str, "%s Switch", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GSWITCH))
-		return 0;
-	sprintf(str, "%s Route", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GROUTE))
-		return 0;
-	sprintf(str, "%s Volume", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_GVOLUME))
-		return 0;
-	sprintf(str, "%s Playback Switch", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_PSWITCH))
-		return 0;
-	sprintf(str, "%s Playback Route", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_PROUTE))
-		return 0;
-	sprintf(str, "%s Playback Volume", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_PVOLUME))
-		return 0;
-	sprintf(str, "%s Capture Switch", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_CSWITCH))
-		return 0;
-	sprintf(str, "%s Capture Route", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_CROUTE))
-		return 0;
-	sprintf(str, "%s Capture Volume", ptr->name);
-	if (snd_mixer_oss_build_test(mixer, &slot, str, ptr->index,
-				     SNDRV_MIXER_OSS_ITEM_CVOLUME))
+	if (snd_mixer_oss_build_test_all(mixer, ptr, &slot))
 		return 0;
 	down_read(&mixer->card->controls_rwsem);
 	if (ptr->index == 0 && (kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0)) != NULL) {


-- 
Jean Delvare
