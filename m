Return-Path: <linux-kernel-owner+w=401wt.eu-S1764880AbYHDUc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764880AbYHDUc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbYHDUcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:32:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:49501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764618AbYHDUbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:31:21 -0400
Date: Mon, 4 Aug 2008 13:16:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 29/33] ALSA: emu10k1 - Fix inverted Analog/Digital mixer
	switch on Audigy2
Message-ID: <20080804201621.GD1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-emu10k1-fix-inverted-analog-digital-mixer-switch-on-audigy2.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d2cd74b158d7214a556226e3312f9fb1de64d7ae upstream

On Audigy2 Platinum, the Analog/Digital mixer switch is inverted.
	https://bugzilla.novell.com/show_bug.cgi?id=396204

The patch adds a simple workaround.

There might be another device requiring a similar fix, too (or fix for
audigy2 generically), but right now I fix only the known broken one.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/sound/emu10k1.h          |    1 +
 sound/pci/emu10k1/emu10k1_main.c |    1 +
 sound/pci/emu10k1/emumixer.c     |   13 ++++++++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -1670,6 +1670,7 @@ struct snd_emu_chip_details {
 	unsigned char spi_dac;      /* SPI interface for DAC */
 	unsigned char i2c_adc;      /* I2C interface for ADC */
 	unsigned char adc_1361t;    /* Use Philips 1361T ADC */
+	unsigned char invert_shared_spdif; /* analog/digital switch inverted */
 	const char *driver;
 	const char *name;
 	const char *id;		/* for backward compatibility - can be NULL if not needed */
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1527,6 +1527,7 @@ static struct snd_emu_chip_details emu_c
 	 .ca0151_chip = 1,
 	 .spk71 = 1,
 	 .spdif_bug = 1,
+	 .invert_shared_spdif = 1,	/* digital/analog switch swapped */
 	 .adc_1361t = 1,  /* 24 bit capture instead of 16bit. Fixes ALSA bug#324 */
 	 .ac97_chip = 1} ,
 	{.vendor = 0x1102, .device = 0x0004, .revision = 0x04,
--- a/sound/pci/emu10k1/emumixer.c
+++ b/sound/pci/emu10k1/emumixer.c
@@ -1578,6 +1578,10 @@ static int snd_emu10k1_shared_spdif_get(
 		ucontrol->value.integer.value[0] = inl(emu->port + A_IOCFG) & A_IOCFG_GPOUT0 ? 1 : 0;
 	else
 		ucontrol->value.integer.value[0] = inl(emu->port + HCFG) & HCFG_GPOUT0 ? 1 : 0;
+	if (emu->card_capabilities->invert_shared_spdif)
+		ucontrol->value.integer.value[0] =
+			!ucontrol->value.integer.value[0];
+
 	return 0;
 }
 
@@ -1586,15 +1590,18 @@ static int snd_emu10k1_shared_spdif_put(
 {
 	unsigned long flags;
 	struct snd_emu10k1 *emu = snd_kcontrol_chip(kcontrol);
-	unsigned int reg, val;
+	unsigned int reg, val, sw;
 	int change = 0;
 
+	sw = ucontrol->value.integer.value[0];
+	if (emu->card_capabilities->invert_shared_spdif)
+		sw = !sw;
 	spin_lock_irqsave(&emu->reg_lock, flags);
 	if ( emu->card_capabilities->i2c_adc) {
 		/* Do nothing for Audigy 2 ZS Notebook */
 	} else if (emu->audigy) {
 		reg = inl(emu->port + A_IOCFG);
-		val = ucontrol->value.integer.value[0] ? A_IOCFG_GPOUT0 : 0;
+		val = sw ? A_IOCFG_GPOUT0 : 0;
 		change = (reg & A_IOCFG_GPOUT0) != val;
 		if (change) {
 			reg &= ~A_IOCFG_GPOUT0;
@@ -1603,7 +1610,7 @@ static int snd_emu10k1_shared_spdif_put(
 		}
 	}
 	reg = inl(emu->port + HCFG);
-	val = ucontrol->value.integer.value[0] ? HCFG_GPOUT0 : 0;
+	val = sw ? HCFG_GPOUT0 : 0;
 	change |= (reg & HCFG_GPOUT0) != val;
 	if (change) {
 		reg &= ~HCFG_GPOUT0;

-- 
