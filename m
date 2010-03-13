Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936475Ab0CMB0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:26:10 -0500
Received: from kroah.org ([198.145.64.141]:60742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934906Ab0CMAUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:08 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001509.282258587@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [patch 047/123] thinkpad-acpi: fix ALSA callback return status
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 88cc83772a3c7756b9f2b4ba835545ad90a08409 upstream.

Clemens Ladisch reports that thinkpad-acpi improperly implements the
ALSA API, and always returns 0 for success for the "put" callbacks
while the API requires it to return "1" when the control value has
been changed in the hardware/firmware.

Rework the volume subdriver to be able to properly implement the ALSA
API.  Based on a patch by Clemens Ladisch <clemens@ladisch.de>.

This fix is also needed on 2.6.33.

Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   39 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6522,7 +6522,8 @@ static int volume_set_status(const u8 st
 	return volume_set_status_ec(status);
 }
 
-static int volume_set_mute_ec(const bool mute)
+/* returns < 0 on error, 0 on no change, 1 on change */
+static int __volume_set_mute_ec(const bool mute)
 {
 	int rc;
 	u8 s, n;
@@ -6537,22 +6538,37 @@ static int volume_set_mute_ec(const bool
 	n = (mute) ? s | TP_EC_AUDIO_MUTESW_MSK :
 		     s & ~TP_EC_AUDIO_MUTESW_MSK;
 
-	if (n != s)
+	if (n != s) {
 		rc = volume_set_status_ec(n);
+		if (!rc)
+			rc = 1;
+	}
 
 unlock:
 	mutex_unlock(&volume_mutex);
 	return rc;
 }
 
+static int volume_alsa_set_mute(const bool mute)
+{
+	dbg_printk(TPACPI_DBG_MIXER, "ALSA: trying to %smute\n",
+		   (mute) ? "" : "un");
+	return __volume_set_mute_ec(mute);
+}
+
 static int volume_set_mute(const bool mute)
 {
+	int rc;
+
 	dbg_printk(TPACPI_DBG_MIXER, "trying to %smute\n",
 		   (mute) ? "" : "un");
-	return volume_set_mute_ec(mute);
+
+	rc = __volume_set_mute_ec(mute);
+	return (rc < 0) ? rc : 0;
 }
 
-static int volume_set_volume_ec(const u8 vol)
+/* returns < 0 on error, 0 on no change, 1 on change */
+static int __volume_set_volume_ec(const u8 vol)
 {
 	int rc;
 	u8 s, n;
@@ -6569,19 +6585,22 @@ static int volume_set_volume_ec(const u8
 
 	n = (s & ~TP_EC_AUDIO_LVL_MSK) | vol;
 
-	if (n != s)
+	if (n != s) {
 		rc = volume_set_status_ec(n);
+		if (!rc)
+			rc = 1;
+	}
 
 unlock:
 	mutex_unlock(&volume_mutex);
 	return rc;
 }
 
-static int volume_set_volume(const u8 vol)
+static int volume_alsa_set_volume(const u8 vol)
 {
 	dbg_printk(TPACPI_DBG_MIXER,
-		   "trying to set volume level to %hu\n", vol);
-	return volume_set_volume_ec(vol);
+		   "ALSA: trying to set volume level to %hu\n", vol);
+	return __volume_set_volume_ec(vol);
 }
 
 static void volume_alsa_notify_change(void)
@@ -6628,7 +6647,7 @@ static int volume_alsa_vol_get(struct sn
 static int volume_alsa_vol_put(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	return volume_set_volume(ucontrol->value.integer.value[0]);
+	return volume_alsa_set_volume(ucontrol->value.integer.value[0]);
 }
 
 #define volume_alsa_mute_info snd_ctl_boolean_mono_info
@@ -6651,7 +6670,7 @@ static int volume_alsa_mute_get(struct s
 static int volume_alsa_mute_put(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
 {
-	return volume_set_mute(!ucontrol->value.integer.value[0]);
+	return volume_alsa_set_mute(!ucontrol->value.integer.value[0]);
 }
 
 static struct snd_kcontrol_new volume_alsa_control_vol __devinitdata = {


