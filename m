Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbZAWBUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbZAWBUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760209AbZAWBO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:58 -0500
Received: from kroah.org ([198.145.64.141]:50420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759567AbZAWBOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:46 -0500
Date: Thu, 22 Jan 2009 17:11:44 -0800
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
Subject: [patch 09/46] sound: virtuoso: do not overwrite EEPROM on Xonar
	D2/D2X
Message-ID: <20090123011144.GJ19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sound-virtuoso-do-not-overwrite-eeprom-on-xonar-d2-d2x.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 7e86c0e6850504ec9516b953f316a47277825e33 upstream.

On the Asus Xonar D2 and D2X models, the SPI chip select signal for the
fourth DAC shares its pin with the serial clock for the EEPROM that
contains the PCI subdevice ID values.  It appears that when DAC
registers are written and some other unknown conditions occur (probably
noise on the EEPROM's chip select line), the EEPROM gets overwritten
with garbage, which makes it impossible to properly detect the card
later.

Therefore, we better avoid DAC register writes and make sure that the
driver works with the DAC's registers' default values.  Consequently,
the sample format is now I2S instead of left-justified (no user-visible
change), and the DAC's volume/mute registers cannot be used anymore
(volume changes are now done by the software volume plugin).

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/virtuoso.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -26,7 +26,7 @@
  * SPI 0 -> 1st PCM1796 (front)
  * SPI 1 -> 2nd PCM1796 (surround)
  * SPI 2 -> 3rd PCM1796 (center/LFE)
- * SPI 4 -> 4th PCM1796 (back)
+ * SPI 4 -> 4th PCM1796 (back) and EEPROM self-destruct (do not use!)
  *
  * GPIO 2 -> M0 of CS5381
  * GPIO 3 -> M1 of CS5381
@@ -207,6 +207,12 @@ static void xonar_gpio_changed(struct ox
 static inline void pcm1796_write_spi(struct oxygen *chip, unsigned int codec,
 				     u8 reg, u8 value)
 {
+	/*
+	 * We don't want to do writes on SPI 4 because the EEPROM, which shares
+	 * the same pin, might get confused and broken.  We'd better take care
+	 * that the driver works with the default register values ...
+	 */
+#if 0
 	/* maps ALSA channel pair number to SPI output */
 	static const u8 codec_map[4] = {
 		0, 1, 2, 4
@@ -217,6 +223,7 @@ static inline void pcm1796_write_spi(str
 			 (codec_map[codec] << OXYGEN_SPI_CODEC_SHIFT) |
 			 OXYGEN_SPI_CEN_LATCH_CLOCK_HI,
 			 (reg << 8) | value);
+#endif
 }
 
 static inline void pcm1796_write_i2c(struct oxygen *chip, unsigned int codec,
@@ -750,6 +757,9 @@ static const DECLARE_TLV_DB_SCALE(cs4362
 
 static int xonar_d2_control_filter(struct snd_kcontrol_new *template)
 {
+	if (!strncmp(template->name, "Master Playback ", 16))
+		/* disable volume/mute because they would require SPI writes */
+		return 1;
 	if (!strncmp(template->name, "CD Capture ", 11))
 		/* CD in is actually connected to the video in pin */
 		template->private_value ^= AC97_CD ^ AC97_VIDEO;
@@ -840,9 +850,8 @@ static const struct oxygen_model model_x
 	.dac_volume_min = 0x0f,
 	.dac_volume_max = 0xff,
 	.misc_flags = OXYGEN_MISC_MIDI,
-	.function_flags = OXYGEN_FUNCTION_SPI |
-			  OXYGEN_FUNCTION_ENABLE_SPI_4_5,
-	.dac_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
+	.function_flags = OXYGEN_FUNCTION_SPI,
+	.dac_i2s_format = OXYGEN_I2S_FORMAT_I2S,
 	.adc_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
 };
 

