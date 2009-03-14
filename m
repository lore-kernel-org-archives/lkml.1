Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbZCNAk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbZCNAk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZCNATh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:37 -0400
Received: from kroah.org ([198.145.64.141]:34852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753038AbZCNATZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:48 2009
Message-Id: <20090314000748.716629690@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 64/96] sound: virtuoso: revert "do not overwrite EEPROM on Xonar D2/D2X"
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=sound-virtuoso-revert-do-not-overwrite-eeprom-on-xonar-d2-d2x.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 6ce6c473a7fd742fdb0db95841e2c4c6b37337c5 upstream.

This reverts commit 7e86c0e6850504ec9516b953f316a47277825e33 ("do not
overwrite EEPROM on Xonar D2/D2X") because it did not actually help with
the problem.

More user reports show that the overwriting of the EEPROM is not
triggered by using this driver but by installing Linux, and that the
installation of any other operating system (even one without any CMI8788
driver) has the same effect.  In other words, the presence of this
driver does not have any effect on the occurrence of the error.  (So
far, the available evidence seems to point to a BIOS bug.)

Furthermore, it turns out that the EEPROM chip is protected against
stray write commands by the command format and by requiring a separate
write-enable command, so the error scenario in the previous commit (that
SPI writes can be misinterpreted as an EEPROM write command) is not even
theoretically possible.

The mixer control that was removed as a consequence of the previous
commit can only be partially emulated in userspace, which also means it
cannot be seen be the in-kernel OSS API emulation, so it is better to
revert that change.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/virtuoso.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -26,7 +26,7 @@
  * SPI 0 -> 1st PCM1796 (front)
  * SPI 1 -> 2nd PCM1796 (surround)
  * SPI 2 -> 3rd PCM1796 (center/LFE)
- * SPI 4 -> 4th PCM1796 (back) and EEPROM self-destruct (do not use!)
+ * SPI 4 -> 4th PCM1796 (back)
  *
  * GPIO 2 -> M0 of CS5381
  * GPIO 3 -> M1 of CS5381
@@ -142,12 +142,6 @@ struct xonar_data {
 static void pcm1796_write(struct oxygen *chip, unsigned int codec,
 			  u8 reg, u8 value)
 {
-	/*
-	 * We don't want to do writes on SPI 4 because the EEPROM, which shares
-	 * the same pin, might get confused and broken.  We'd better take care
-	 * that the driver works with the default register values ...
-	 */
-#if 0
 	/* maps ALSA channel pair number to SPI output */
 	static const u8 codec_map[4] = {
 		0, 1, 2, 4
@@ -158,7 +152,6 @@ static void pcm1796_write(struct oxygen 
 			 (codec_map[codec] << OXYGEN_SPI_CODEC_SHIFT) |
 			 OXYGEN_SPI_CEN_LATCH_CLOCK_HI,
 			 (reg << 8) | value);
-#endif
 }
 
 static void cs4398_write(struct oxygen *chip, u8 reg, u8 value)
@@ -546,9 +539,6 @@ static const DECLARE_TLV_DB_SCALE(cs4362
 
 static int xonar_d2_control_filter(struct snd_kcontrol_new *template)
 {
-	if (!strncmp(template->name, "Master Playback ", 16))
-		/* disable volume/mute because they would require SPI writes */
-		return 1;
 	if (!strncmp(template->name, "CD Capture ", 11))
 		/* CD in is actually connected to the video in pin */
 		template->private_value ^= AC97_CD ^ AC97_VIDEO;
@@ -598,8 +588,9 @@ static const struct oxygen_model xonar_m
 		.dac_volume_min = 0x0f,
 		.dac_volume_max = 0xff,
 		.misc_flags = OXYGEN_MISC_MIDI,
-		.function_flags = OXYGEN_FUNCTION_SPI,
-		.dac_i2s_format = OXYGEN_I2S_FORMAT_I2S,
+		.function_flags = OXYGEN_FUNCTION_SPI |
+				  OXYGEN_FUNCTION_ENABLE_SPI_4_5,
+		.dac_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
 		.adc_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
 	},
 	[MODEL_D2X] = {
@@ -628,8 +619,9 @@ static const struct oxygen_model xonar_m
 		.dac_volume_min = 0x0f,
 		.dac_volume_max = 0xff,
 		.misc_flags = OXYGEN_MISC_MIDI,
-		.function_flags = OXYGEN_FUNCTION_SPI,
-		.dac_i2s_format = OXYGEN_I2S_FORMAT_I2S,
+		.function_flags = OXYGEN_FUNCTION_SPI |
+				  OXYGEN_FUNCTION_ENABLE_SPI_4_5,
+		.dac_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
 		.adc_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
 	},
 	[MODEL_D1] = {


