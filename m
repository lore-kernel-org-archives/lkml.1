Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbYB1TMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbYB1TMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759714AbYB1TLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:21 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:4302 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664AbYB1TLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xDz5VXSRH+OJtt+17tPDnDbMybb4O9WJ/mFzsoWmea348QJ/uD5VurBKLiwFIeRhHT4/Z0m3tKnOtBsMRqPlBJhPd9I1Qyk1UpjV4VKf6Htrp2Zq+S9qbhVLhFS5SF+XBHq84BTTrEIl3txYT69OTISAM3ksTW3NvpHNW2L/arU=
Subject: [PATCH 3/8] sound: ice1712.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:12 -0800
Message-Id: <1204225873.20280.81.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all four case, adding a private value to the iooff index,
call it priv_idx.
sound/pci/ice1712/ice1712.c:1300:6: warning: symbol 'index' shadows an earlier one
sound/pci/ice1712/ice1712.c:85:12: originally declared here
sound/pci/ice1712/ice1712.c:1312:6: warning: symbol 'index' shadows an earlier one
sound/pci/ice1712/ice1712.c:85:12: originally declared here
sound/pci/ice1712/ice1712.c:1338:6: warning: symbol 'index' shadows an earlier one
sound/pci/ice1712/ice1712.c:85:12: originally declared here
sound/pci/ice1712/ice1712.c:1350:6: warning: symbol 'index' shadows an earlier one
sound/pci/ice1712/ice1712.c:85:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ice1712/ice1712.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index df292af..379ba5a 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1297,11 +1297,11 @@ static void snd_ice1712_update_volume(struct snd_ice1712 *ice, int index)
 static int snd_ice1712_pro_mixer_switch_get(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
-	int index = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
+	int priv_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
 	
 	spin_lock_irq(&ice->reg_lock);
-	ucontrol->value.integer.value[0] = !((ice->pro_volumes[index] >> 15) & 1);
-	ucontrol->value.integer.value[1] = !((ice->pro_volumes[index] >> 31) & 1);
+	ucontrol->value.integer.value[0] = !((ice->pro_volumes[priv_idx] >> 15) & 1);
+	ucontrol->value.integer.value[1] = !((ice->pro_volumes[priv_idx] >> 31) & 1);
 	spin_unlock_irq(&ice->reg_lock);
 	return 0;
 }
@@ -1309,16 +1309,16 @@ static int snd_ice1712_pro_mixer_switch_get(struct snd_kcontrol *kcontrol, struc
 static int snd_ice1712_pro_mixer_switch_put(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
-	int index = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
+	int priv_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
 	unsigned int nval, change;
 
 	nval = (ucontrol->value.integer.value[0] ? 0 : 0x00008000) |
 	       (ucontrol->value.integer.value[1] ? 0 : 0x80000000);
 	spin_lock_irq(&ice->reg_lock);
-	nval |= ice->pro_volumes[index] & ~0x80008000;
-	change = nval != ice->pro_volumes[index];
-	ice->pro_volumes[index] = nval;
-	snd_ice1712_update_volume(ice, index);
+	nval |= ice->pro_volumes[priv_idx] & ~0x80008000;
+	change = nval != ice->pro_volumes[priv_idx];
+	ice->pro_volumes[priv_idx] = nval;
+	snd_ice1712_update_volume(ice, priv_idx);
 	spin_unlock_irq(&ice->reg_lock);
 	return change;
 }
@@ -1335,11 +1335,11 @@ static int snd_ice1712_pro_mixer_volume_info(struct snd_kcontrol *kcontrol, stru
 static int snd_ice1712_pro_mixer_volume_get(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
-	int index = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
+	int priv_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
 	
 	spin_lock_irq(&ice->reg_lock);
-	ucontrol->value.integer.value[0] = (ice->pro_volumes[index] >> 0) & 127;
-	ucontrol->value.integer.value[1] = (ice->pro_volumes[index] >> 16) & 127;
+	ucontrol->value.integer.value[0] = (ice->pro_volumes[priv_idx] >> 0) & 127;
+	ucontrol->value.integer.value[1] = (ice->pro_volumes[priv_idx] >> 16) & 127;
 	spin_unlock_irq(&ice->reg_lock);
 	return 0;
 }
@@ -1347,16 +1347,16 @@ static int snd_ice1712_pro_mixer_volume_get(struct snd_kcontrol *kcontrol, struc
 static int snd_ice1712_pro_mixer_volume_put(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
-	int index = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
+	int priv_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id) + kcontrol->private_value;
 	unsigned int nval, change;
 
 	nval = (ucontrol->value.integer.value[0] & 127) |
 	       ((ucontrol->value.integer.value[1] & 127) << 16);
 	spin_lock_irq(&ice->reg_lock);
-	nval |= ice->pro_volumes[index] & ~0x007f007f;
-	change = nval != ice->pro_volumes[index];
-	ice->pro_volumes[index] = nval;
-	snd_ice1712_update_volume(ice, index);
+	nval |= ice->pro_volumes[priv_idx] & ~0x007f007f;
+	change = nval != ice->pro_volumes[priv_idx];
+	ice->pro_volumes[priv_idx] = nval;
+	snd_ice1712_update_volume(ice, priv_idx);
 	spin_unlock_irq(&ice->reg_lock);
 	return change;
 }
-- 
1.5.4.3.342.g99e8


