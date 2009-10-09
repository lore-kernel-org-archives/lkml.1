Return-Path: <linux-kernel-owner+w=401wt.eu-S1761878AbZJIXUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878AbZJIXUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761810AbZJIXUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:20:16 -0400
Received: from kroah.org ([198.145.64.141]:36853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761641AbZJIXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.901946466@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 14/26] sound: via82xx: move DXS volume controls to PCM interface
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=sound-via82xx-move-dxs-volume-controls-to-pcm-interface.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 2fb930b53f513cbc4c102d415d2923a8a7091337 upstream.

The "VIA DXS" controls are actually volume controls that apply to the
four PCM substreams, so we better indicate this connection by moving the
controls to the PCM interface.

Commit b452e08e73c0e3dbb0be82130217be4b7084299e in 2.6.30 broke the
restoring of these volumes by "alsactl restore" that most distributions
use; the renaming in this patch cures that regression by preventing
alsactl from applying the old, wrong volume levels to the new controls.
http://bugzilla.kernel.org/show_bug.cgi?id=14151
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=532613

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/via82xx.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -1626,7 +1626,7 @@ static int snd_via8233_dxs_volume_get(st
 				      struct snd_ctl_elem_value *ucontrol)
 {
 	struct via82xx *chip = snd_kcontrol_chip(kcontrol);
-	unsigned int idx = snd_ctl_get_ioff(kcontrol, &ucontrol->id);
+	unsigned int idx = kcontrol->id.subdevice;
 
 	ucontrol->value.integer.value[0] = VIA_DXS_MAX_VOLUME - chip->playback_volume[idx][0];
 	ucontrol->value.integer.value[1] = VIA_DXS_MAX_VOLUME - chip->playback_volume[idx][1];
@@ -1646,7 +1646,7 @@ static int snd_via8233_dxs_volume_put(st
 				      struct snd_ctl_elem_value *ucontrol)
 {
 	struct via82xx *chip = snd_kcontrol_chip(kcontrol);
-	unsigned int idx = snd_ctl_get_ioff(kcontrol, &ucontrol->id);
+	unsigned int idx = kcontrol->id.subdevice;
 	unsigned long port = chip->port + 0x10 * idx;
 	unsigned char val;
 	int i, change = 0;
@@ -1705,11 +1705,12 @@ static struct snd_kcontrol_new snd_via82
 };
 
 static struct snd_kcontrol_new snd_via8233_dxs_volume_control __devinitdata = {
-	.name = "VIA DXS Playback Volume",
-	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+	.iface = SNDRV_CTL_ELEM_IFACE_PCM,
+	.device = 0,
+	/* .subdevice set later */
+	.name = "PCM Playback Volume",
 	.access = (SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		   SNDRV_CTL_ELEM_ACCESS_TLV_READ),
-	.count = 4,
 	.info = snd_via8233_dxs_volume_info,
 	.get = snd_via8233_dxs_volume_get,
 	.put = snd_via8233_dxs_volume_put,
@@ -1936,10 +1937,18 @@ static int __devinit snd_via8233_init_mi
 		}
 		else /* Using DXS when PCM emulation is enabled is really weird */
 		{
-			/* Standalone DXS controls */
-			err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_via8233_dxs_volume_control, chip));
-			if (err < 0)
-				return err;
+			for (i = 0; i < 4; ++i) {
+				struct snd_kcontrol *kctl;
+
+				kctl = snd_ctl_new1(
+					&snd_via8233_dxs_volume_control, chip);
+				if (!kctl)
+					return -ENOMEM;
+				kctl->id.subdevice = i;
+				err = snd_ctl_add(chip->card, kctl);
+				if (err < 0)
+					return err;
+			}
 		}
 	}
 	/* select spdif data slot 10/11 */


