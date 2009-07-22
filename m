Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZGVDYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZGVDYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbZGVDYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:24:30 -0400
Received: from d1.icnet.pl ([212.160.220.21]:39242 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927AbZGVDY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:24:27 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC] [PATCH 3/3] ASoC: add support for Amstrad E3 (Delta) machine
Date: Wed, 22 Jul 2009 05:22:59 +0200
User-Agent: KMail/1.9.10
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jarkko Nikula <jhnikula@gmail.com>,
       Jonathan McDowell <noodles@earth.li>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, alsa-devel@alsa-project.org,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907220523.01107.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds machine support for Amstrad E3 (Delta) videophone to ASoC.

Created and tested against linux-2.6.31-rc3.
Applies and works with linux-omap-2.6 commit
7c5cb7862d32cb344be7831d466535d5255e35ac as well.

Depends on patch 2 form this series: TTY: Add definition of a new line
discipline required by Amstrad E3 (Delta) ASoC driver.

Credits to Mark Underwood for his initial, omap-alsa based sound driver for
this machine.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
CPU DAI parameters best matching the codec DAI has been selected out
empirically for best user experience.

Board specific audio function control (with related DAPM widgets) has been
modeled after empirically discovered codec capabilities.

Unlike other ASoC machine drivers, this one contains a line discipline. This
is required for providig the codec driver with support for talking to the
modem chip that can control the codec behavoiur. As the line discipline code
contains board specific bits, I decided to make it a part of the ASoC machine
driver, not the codec, and not a separate source file. Otherwise, some kind of
a glue, like a bus over a tty, could help in linking the board specific part
(bus device) to a more generic line discipline (bus adapter)[1].

In order to work at all, this driver requires a working McBSP1. On OMAP1510
based machines (not sure if other OMAP1 variants as well), where McBSP1 is a
DSP public peripheral, that means the kernel must provide basic DSP support,
ie. omap_dsp_init(), in order to power up the DSP. This used to be included in
linux-omap-2.6 tree up to commit 2512fd29db4eb09e82d182596304c7aaf76d2c5c.
Without that, the driver would not work, ie. not shift in/out any bits over
the CPU DAI[2]. This limitation is not board, but CPU specific, and may apply
to other code that makes use of McBSP1/McBSP3 on affected machines. I provide
an extra patch [4/3] as a temporary solution.

To work correctly in playback mode, this driver requires my prevoiusly
submitted patch that corrects pcm pointer calculation for OMAP1510 based
machines[3] (already included in linux-2.6.31-rc3).

To support codec controls, this driver requires my previously submitted patch
that adds support for modem found on Amstrad Delta[4].

[1] http://www.spinics.net/lists/linux-serial/msg01856.html
[2] http://www.spinics.net/lists/linux-omap/msg15114.html
[3] http://mailman.alsa-project.org/pipermail/alsa-devel/2009-June/018950.html
[4] http://www.spinics.net/lists/linux-omap/msg15432.html

--- linux-2.6.31-rc1/sound/soc/omap/Kconfig.orig	2009-07-04 16:40:00.000000000 +0200
+++ linux-2.6.31-rc1/sound/soc/omap/Kconfig	2009-07-22 01:06:51.000000000 +0200
@@ -15,6 +15,14 @@ config SND_OMAP_SOC_N810
 	help
 	  Say Y if you want to add support for SoC audio on Nokia N810.
 
+config SND_OMAP_SOC_AMS_DELTA
+	tristate "SoC Audio support for Amstrad E3 (Delta) videophone"
+	depends on SND_OMAP_SOC && MACH_AMS_DELTA
+	select SND_OMAP_SOC_MCBSP
+	select SND_SOC_CX20442
+	help
+	  Say Y if you want to add support for SoC audio on Amstrad Delta.
+
 config SND_OMAP_SOC_OSK5912
 	tristate "SoC Audio support for omap osk5912"
 	depends on SND_OMAP_SOC && MACH_OMAP_OSK && I2C
--- linux-2.6.31-rc1/sound/soc/omap/Makefile.orig	2009-07-04 16:40:00.000000000 +0200
+++ linux-2.6.31-rc1/sound/soc/omap/Makefile	2009-07-22 01:06:51.000000000 +0200
@@ -7,6 +7,7 @@ obj-$(CONFIG_SND_OMAP_SOC_MCBSP) += snd-
 
 # OMAP Machine Support
 snd-soc-n810-objs := n810.o
+snd-soc-ams-delta-objs := ams-delta.o
 snd-soc-osk5912-objs := osk5912.o
 snd-soc-overo-objs := overo.o
 snd-soc-omap2evm-objs := omap2evm.o
@@ -16,6 +17,7 @@ snd-soc-omap3pandora-objs := omap3pandor
 snd-soc-omap3beagle-objs := omap3beagle.o
 
 obj-$(CONFIG_SND_OMAP_SOC_N810) += snd-soc-n810.o
+obj-$(CONFIG_SND_OMAP_SOC_AMS_DELTA) += snd-soc-ams-delta.o
 obj-$(CONFIG_SND_OMAP_SOC_OSK5912) += snd-soc-osk5912.o
 obj-$(CONFIG_SND_OMAP_SOC_OVERO) += snd-soc-overo.o
 obj-$(CONFIG_MACH_OMAP2EVM) += snd-soc-omap2evm.o
--- /dev/null	2009-06-24 10:33:03.437003511 +0200
+++ linux-2.6.31-rc1/sound/soc/omap/ams-delta.c	2009-07-22 01:06:51.000000000 +0200
@@ -0,0 +1,618 @@
+/*
+ * ams-delta.c  --  SoC audio for Amstrad E3 (Delta) videophone
+ *
+ * Copyright (C) 2009 Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/gpio.h>
+#include <linux/tty.h>
+
+#include <sound/soc-dapm.h>
+#include <sound/jack.h>
+
+#include <asm/mach-types.h>
+
+#include <mach/board-ams-delta.h>
+#include <mach/mcbsp.h>
+
+#include "omap-mcbsp.h"
+#include "omap-pcm.h"
+#include "../codecs/cx20442.h"
+
+
+/*
+ * Controls available after the modem line discipline has been activated.
+ */
+
+/* Virtual switch: audio input/output constellations */
+static const char *ams_delta_audio_mode[] =
+	{"Mixed", "Handset", "HandsFree", "SpeakerPhone"};
+
+/* Selection <-> pin translation */
+#define AMS_DELTA_MOUTHPIECE	0
+#define AMS_DELTA_EARPHONE	1
+#define AMS_DELTA_MICROPHONE	2
+#define AMS_DELTA_SPEAKER	3
+#define AMS_DELTA_AGC		4
+
+#define AMS_DELTA_MIXED		((1 << AMS_DELTA_EARPHONE) | \
+						(1 << AMS_DELTA_MICROPHONE))
+#define AMS_DELTA_HANDSET	((1 << AMS_DELTA_MOUTHPIECE) | \
+						(1 << AMS_DELTA_EARPHONE))
+#define AMS_DELTA_HANDSFREE	((1 << AMS_DELTA_MICROPHONE) | \
+						(1 << AMS_DELTA_SPEAKER))
+#define AMS_DELTA_SPEAKERPHONE	(AMS_DELTA_HANDSFREE | (1 << AMS_DELTA_AGC))
+
+unsigned short ams_delta_audio_mode_pins[] = {
+	AMS_DELTA_MIXED,
+	AMS_DELTA_HANDSET,
+	AMS_DELTA_HANDSFREE,
+	AMS_DELTA_SPEAKERPHONE,
+};
+
+static bool ams_delta_audio_agc = 0;
+
+static int ams_delta_set_audio_mode(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
+	struct soc_enum *control = (struct soc_enum *)kcontrol->private_value;
+	unsigned short function;
+	bool changed = 0;
+
+	if (ucontrol->value.enumerated.item[0] >= control->max)
+		return -EINVAL;
+
+	mutex_lock(&codec->mutex);
+
+	/* Translate selection to bitmap */
+	function = ams_delta_audio_mode_pins[ucontrol->value.enumerated.item[0]];
+
+	/* Setup pins after corresponding bits if changed */
+	if ((bool)snd_soc_dapm_get_pin_status(codec, "Speaker") !=
+			(bool)(function & (1 << AMS_DELTA_SPEAKER))) {
+		changed = 1;
+		if (function & (1 << AMS_DELTA_SPEAKER))
+			snd_soc_dapm_enable_pin(codec, "Speaker");
+		else
+			snd_soc_dapm_disable_pin(codec, "Speaker");
+	}
+	if ((bool)snd_soc_dapm_get_pin_status(codec, "Microphone") !=
+			(bool)(function & (1 << AMS_DELTA_MICROPHONE))) {
+		changed = 1;
+		if (function & (1 << AMS_DELTA_MICROPHONE))
+			snd_soc_dapm_enable_pin(codec, "Microphone");
+		else
+			snd_soc_dapm_disable_pin(codec, "Microphone");
+	}
+	if ((bool)snd_soc_dapm_get_pin_status(codec, "Earphone") !=
+			(bool)(function & (1 << AMS_DELTA_EARPHONE))) {
+		changed = 1;
+		if (function & (1 << AMS_DELTA_EARPHONE))
+			snd_soc_dapm_enable_pin(codec, "Earphone");
+		else
+			snd_soc_dapm_disable_pin(codec, "Earphone");
+	}
+	if ((bool)snd_soc_dapm_get_pin_status(codec, "Mouthpiece") !=
+			(bool)(function & (1 << AMS_DELTA_MOUTHPIECE))) {
+		changed = 1;
+		if (function & (1 << AMS_DELTA_MOUTHPIECE))
+			snd_soc_dapm_enable_pin(codec, "Mouthpiece");
+		else
+			snd_soc_dapm_disable_pin(codec, "Mouthpiece");
+	}
+	if (ams_delta_audio_agc != (bool)(function & (1 << AMS_DELTA_AGC))) {
+		ams_delta_audio_agc = (bool)(function & (1 << AMS_DELTA_AGC));
+		changed = 1;
+		if (ams_delta_audio_agc)
+			snd_soc_dapm_enable_pin(codec, "AGCIN");
+		else
+			snd_soc_dapm_disable_pin(codec, "AGCIN");
+	}
+	if (changed)
+		snd_soc_dapm_sync(codec);
+	
+	mutex_unlock(&codec->mutex);
+
+	return changed;
+}
+
+static int ams_delta_get_audio_mode(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
+	unsigned short value, mux;
+
+	value = ((snd_soc_dapm_get_pin_status(codec, "Mouthpiece") <<
+							AMS_DELTA_MOUTHPIECE) |
+			(snd_soc_dapm_get_pin_status(codec, "Earphone") <<
+							AMS_DELTA_EARPHONE));
+	if (value)
+		value |= (snd_soc_dapm_get_pin_status(codec, "Microphone") <<
+							AMS_DELTA_MICROPHONE);
+	else
+		value = ((snd_soc_dapm_get_pin_status(codec, "Microphone") <<
+							AMS_DELTA_MICROPHONE) |
+			(snd_soc_dapm_get_pin_status(codec, "Speaker") <<
+							AMS_DELTA_SPEAKER) |
+			((unsigned short)ams_delta_audio_agc << AMS_DELTA_AGC));
+
+	for (mux = 0; mux < ARRAY_SIZE(ams_delta_audio_mode); mux++)
+		if (value == ams_delta_audio_mode_pins[mux])
+			break;
+	
+	if (mux >= ARRAY_SIZE(ams_delta_audio_mode))
+		return -EINVAL;
+	
+	ucontrol->value.enumerated.item[0] = mux;
+
+	return 0;
+}
+
+static const struct soc_enum ams_delta_audio_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(ams_delta_audio_mode),
+						ams_delta_audio_mode),
+};
+
+static const struct snd_kcontrol_new ams_delta_audio_controls[] = {
+	SOC_ENUM_EXT("Audio Function", ams_delta_audio_enum[0],
+			ams_delta_get_audio_mode, ams_delta_set_audio_mode),
+};
+
+/* Now that we are able to control the codec over the modem,
+ * our hook switch can be used for dynamic DAPM reconfiguration */
+static struct snd_soc_jack ams_delta_hook_switch;
+static struct snd_soc_jack_gpio ams_delta_hook_switch_gpios[];
+static struct snd_soc_jack_pin ams_delta_hook_switch_pins[] = {
+	{
+		.pin = "Mouthpiece",
+		.mask = SND_JACK_MICROPHONE,
+	},
+	{
+		.pin = "Earphone",
+		.mask = SND_JACK_HEADPHONE,
+	},
+	{
+		.pin = "Speaker",
+		.mask = SND_JACK_HEADPHONE,
+		.invert = 1,
+	},
+	{
+		.pin = "Microphone",
+		.mask = SND_JACK_MICROPHONE,
+		.invert = 1,
+	},
+};
+
+/* To actually apply any modem controlled configuration changes to the codec,
+ * we must connect codec DAI pins to the modem for a moment.  Be carefull
+ * not to interfere with digital mute function that shares the same hardware. */
+static struct timer_list cx81801_timer;
+static bool cx81801_cmd_pending = 0;
+static bool ams_delta_muted;
+
+static void cx81801_timeout(unsigned long data)
+{
+	/* REVISIT - locking? */
+	if(!ams_delta_muted)
+		/* Reconnect the codec DAI back from the modem to the CPU DAI
+		 * only if digital mute still off */
+		ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC, 0);
+	cx81801_cmd_pending = 0;
+}
+
+/* Modem init: echo off, digital speaker off, quiet off, voice mode */
+static const char *cx81801_init = "ate0m0q0+fclass=8\r";
+
+
+/*
+ * Modem line discipline required for making above controls functional.
+ * Activated from userspace with ldattach, possibly invoked from udev rule.
+ */
+
+static struct snd_soc_card ams_delta_audio_card;
+
+/* Line discipline setup */
+static int cx81801_open(struct tty_struct *tty)
+{
+	struct snd_soc_codec *codec = ams_delta_audio_card.codec;
+	int ret, len = strlen(cx81801_init);
+
+	/* Doesn't make sense without write callback */
+	if (!tty->ops->write)
+		return -EINVAL;
+
+	/* Pass codec structure address to other ldisc callbacks */
+	tty->disc_data = codec;
+
+	if (tty->ops->write(tty, cx81801_init, len) != len) {
+		ret = -EIO;
+		goto err;
+	}
+	/* Actual setup will be performed after the modem responds. */
+	return 0;
+err:
+	tty->disc_data = NULL;
+	return ret;
+}
+
+/* Can this empty callback be omitted? */
+static void cx81801_wakeup(struct tty_struct *tty)
+{
+}
+
+/* Modem response callback */
+static void cx81801_receive(struct tty_struct *tty,
+				const unsigned char *cp, char *fp, int count)
+{
+	struct snd_soc_codec *codec = tty->disc_data;
+	const unsigned char *c;
+
+	if (!codec->control_data) {
+		/* First modem response, complete setup procedure */
+
+		/* Initialize timer used for config pulse generation */
+		setup_timer(&cx81801_timer, cx81801_timeout, 0);
+
+		/* Set up codec access to modem controls */
+		codec->control_data = tty;
+		codec->hw_write = (hw_write_t)tty->ops->write;
+		codec->pop_time = 1;
+
+		/* Link hook switch to DAPM pins */
+		snd_soc_jack_add_pins(&ams_delta_hook_switch,
+				ARRAY_SIZE(ams_delta_hook_switch_pins),
+				ams_delta_hook_switch_pins);
+
+		/* Add virtual switches */
+		snd_soc_add_controls(codec, ams_delta_audio_controls,
+					ARRAY_SIZE(ams_delta_audio_controls));
+
+		/* Set DAPM pins after hook switch present state */
+#if 0
+		/* Fails for switch state matching initial gpio->state = 0 */
+		snd_soc_jack_report(&ams_delta_ams_delta_hook_switch, 
+			gpio_get_value(ams_delta_hook_switch_gpios[0].gpio) ?
+					0 : SND_JACK_HEADSET, SND_JACK_HEADSET);
+#else
+		if (gpio_get_value(ams_delta_hook_switch_gpios[0].gpio)) {
+			snd_soc_dapm_enable_pin(codec, "Speaker");
+			snd_soc_dapm_enable_pin(codec, "Microphone");
+			snd_soc_dapm_disable_pin(codec, "Earphone");
+			snd_soc_dapm_disable_pin(codec, "Mouthpiece");
+		} else {
+			snd_soc_dapm_disable_pin(codec, "Speaker");
+			snd_soc_dapm_disable_pin(codec, "Microphone");
+			snd_soc_dapm_enable_pin(codec, "Earphone");
+			snd_soc_dapm_enable_pin(codec, "Mouthpiece");
+		}
+		snd_soc_dapm_sync(codec);
+#endif
+		return;
+	}
+	for (c = &cp[count - 1]; c >= cp; c--) {
+		if (*c != '\r')
+			continue;
+		/* Complete modem response received, apply config to codec */
+
+		/* REVISIT - locking? */
+		/* Reconnect the codec to the modem if not already done */
+		if (!ams_delta_muted && !cx81801_cmd_pending)
+			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
+						AMS_DELTA_LATCH2_MODEM_CODEC);
+
+		/* Keep config pulse long enough for proper config activation */
+		cx81801_cmd_pending = 1;
+		mod_timer(&cx81801_timer, jiffies + msecs_to_jiffies(200));
+		break;
+	}
+}
+
+static void cx81801_close(struct tty_struct *tty)
+{
+	struct snd_soc_codec *codec = tty->disc_data;
+
+	del_timer_sync(&cx81801_timer);
+
+	/* Revert back to default audio input/output constellation */
+	snd_soc_dapm_disable_pin(codec, "AGCIN");
+	snd_soc_dapm_disable_pin(codec, "AGCOUT");
+	snd_soc_jack_report(&ams_delta_hook_switch,
+				SND_JACK_HEADPHONE, SND_JACK_HEADSET);
+
+	/* REVISIT - Don't know how to do that */
+	/*
+	 * Remove controls that we expose when over the modem control available:
+	 * - virtual audio mode switch,
+	 * - hook switch to DAPM pins links
+	 */
+
+	/* Prevent the codec driver from further accessing the modem */
+	codec->hw_write = NULL;
+	codec->control_data = NULL;
+	codec->pop_time = 0;
+
+	tty->disc_data = NULL;
+}
+
+static struct tty_ldisc_ops cx81801_ops = {
+	.magic = TTY_LDISC_MAGIC,
+	.name = "cx81801",
+	.owner = THIS_MODULE,
+	.open = cx81801_open,
+	.close = cx81801_close,
+	.receive_buf = cx81801_receive,
+	.write_wakeup = cx81801_wakeup,
+};
+
+
+/*
+ * Even if not very usefull, the sound card can still work without any of the
+ * above functonality activated.  You can still control its audio input/output
+ * constellation and speakerphone gain from userspace by issueing AT commands
+ * over the modem port.
+ */
+
+static int ams_delta_hw_params(struct snd_pcm_substream *substream,
+			 struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+
+	/* Set cpu DAI configuration */
+	return snd_soc_dai_set_fmt(rtd->dai->cpu_dai,
+				   SND_SOC_DAIFMT_DSP_A |
+				   SND_SOC_DAIFMT_NB_NF |
+				   SND_SOC_DAIFMT_CBM_CFM);
+}
+
+static struct snd_soc_ops ams_delta_ops = {
+	.hw_params = ams_delta_hw_params,
+};
+
+
+/*
+ * Board specific DAPM widgets
+ */
+
+static const struct snd_soc_dapm_widget ams_delta_dapm_widgets[] = {
+	SND_SOC_DAPM_MIC("Microphone", NULL),
+	SND_SOC_DAPM_SPK("Speaker", NULL),
+	SND_SOC_DAPM_HP("Earphone", NULL),
+	SND_SOC_DAPM_MIC("Mouthpiece", NULL),
+};
+
+static const struct snd_soc_dapm_route ams_delta_audio_map[] = {
+	{"TELIN", NULL, "Mouthpiece"},
+	{"Earphone", NULL, "TELOUT"},
+
+	{"MIC", NULL, "Microphone"},
+	{"Speaker", NULL, "SPKOUT"},
+};
+
+/* Hook switch */
+static struct snd_soc_jack ams_delta_hook_switch;
+static struct snd_soc_jack_gpio ams_delta_hook_switch_gpios[] = {
+	{
+		.gpio = 4,
+		.name = "hook_switch",
+		.report = SND_JACK_HEADSET,
+		.invert = 1,
+		.debounce_time = 100,
+	}
+};
+
+/* Board specific codec bias level control */
+static int ams_delta_set_bias_level(struct snd_soc_card *card,
+					enum snd_soc_bias_level level)
+{
+	struct snd_soc_codec *codec = card->codec;
+
+	switch (level) {
+	case SND_SOC_BIAS_ON:
+	case SND_SOC_BIAS_PREPARE:
+	case SND_SOC_BIAS_STANDBY:
+		if (codec->bias_level == SND_SOC_BIAS_OFF)
+			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
+						AMS_DELTA_LATCH2_MODEM_NRESET);
+		break;
+	case SND_SOC_BIAS_OFF:
+		if (codec->bias_level != SND_SOC_BIAS_OFF)
+			ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_NRESET,
+						0);
+	}
+	codec->bias_level = level;
+	
+	return 0;
+}
+
+/* Digital mute implemented using modem/CPU multiplexer.
+ * Shares hardware with codec config pulse generation */
+static bool ams_delta_muted = 1;
+
+static int ams_delta_digital_mute(struct snd_soc_dai *dai, int mute)
+{
+	/* REVISIT - locking? */
+	if (ams_delta_muted == mute)
+		return 0;
+	ams_delta_muted = mute;
+	if (cx81801_cmd_pending)
+		return 0;
+
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_MODEM_CODEC,
+				mute ? AMS_DELTA_LATCH2_MODEM_CODEC : 0);
+
+	return 0;
+}
+
+/* Our codec DAI probably doesn't have its own .ops structure */
+static struct snd_soc_dai_ops ams_delta_dai_ops = {
+	.digital_mute = ams_delta_digital_mute,
+};
+
+/* Will be used if the codec ever has its own digital_mute function */
+static int ams_delta_startup(struct snd_pcm_substream *substream)
+{
+	return ams_delta_digital_mute(NULL, 0);
+}
+
+static void ams_delta_shutdown(struct snd_pcm_substream *substream)
+{
+	ams_delta_digital_mute(NULL, 1);
+}
+
+
+/*
+ * Card initialization
+ */
+
+static int ams_delta_cx20442_init(struct snd_soc_codec *codec)
+{
+	struct snd_soc_dai *codec_dai = codec->dai;
+	/* Codec is ready, now add/activate board specific controls */
+
+	/* Set up digital mute if not provided by codec */
+	if (!codec_dai->ops) {
+		codec_dai->ops = &ams_delta_dai_ops;
+	} else if (!codec_dai->ops->digital_mute) {
+		codec_dai->ops->digital_mute = ams_delta_digital_mute;
+	} else {
+		ams_delta_ops.startup = ams_delta_startup;
+		ams_delta_ops.shutdown = ams_delta_shutdown;
+	}	
+
+	/* Set codec bias level */
+	ams_delta_set_bias_level(&ams_delta_audio_card, SND_SOC_BIAS_STANDBY);
+
+	/* Add board specific DAPM controls */
+	if (!snd_soc_dapm_new_controls(codec, ams_delta_dapm_widgets,
+				ARRAY_SIZE(ams_delta_dapm_widgets))) {
+		if (!snd_soc_dapm_add_routes(codec, ams_delta_audio_map,
+					ARRAY_SIZE(ams_delta_audio_map))) {
+			/* Actual pin constellation if no modem control */
+			snd_soc_dapm_disable_pin(codec, "Mouthpiece");
+			snd_soc_dapm_enable_pin(codec, "Earphone");
+			snd_soc_dapm_enable_pin(codec, "Microphone");
+			snd_soc_dapm_disable_pin(codec, "Speaker");
+			snd_soc_dapm_disable_pin(codec, "AGCIN");
+			snd_soc_dapm_disable_pin(codec, "AGCOUT");
+
+			snd_soc_dapm_sync(codec);
+		}
+	}
+	/* Add hook switch */
+	if (!snd_soc_jack_new(&ams_delta_audio_card, "hook_switch",
+				SND_JACK_HEADSET, &ams_delta_hook_switch)) {
+		if (!snd_soc_jack_add_gpios(&ams_delta_hook_switch,
+					ARRAY_SIZE(ams_delta_hook_switch_gpios),
+					ams_delta_hook_switch_gpios)) {
+#ifdef CONFIG_GPIO_SYSFS
+			/* Expose hook switch over sysfs if configured */
+			gpio_export(ams_delta_hook_switch_gpios[0].gpio, false);
+#endif
+		}
+	}
+	/* Register optional line discipline for over the modem control */
+	tty_register_ldisc(N_AMSDELTA, &cx81801_ops);
+
+	return 0;
+}
+
+/* DAI glue - connects codec <--> CPU */
+static struct snd_soc_dai_link ams_delta_dai_link = {
+	.name = "CX20442",
+	.stream_name = "CX20442",
+	.cpu_dai = &omap_mcbsp_dai[0],
+	.codec_dai = &cx20442_dai,
+	.init = ams_delta_cx20442_init,
+	.ops = &ams_delta_ops,
+};
+
+/* Audio card driver */
+static struct snd_soc_card ams_delta_audio_card = {
+	.name = "AMS_DELTA",
+	.platform = &omap_soc_platform,
+	.dai_link = &ams_delta_dai_link,
+	.num_links = 1,
+	.set_bias_level = ams_delta_set_bias_level,
+};
+
+/* Audio subsystem */
+static struct snd_soc_device ams_delta_snd_soc_device = {
+	.card = &ams_delta_audio_card,
+	.codec_dev = &cx20442_codec_dev,
+};
+
+/* Module init/exit */
+static struct platform_device *ams_delta_audio_platform_device;
+static struct platform_device *cx20442_platform_device;
+
+static int __init ams_delta_module_init(void)
+{
+	int ret;
+
+	if (!(machine_is_ams_delta()))
+		return -ENODEV;
+
+	ams_delta_audio_platform_device = platform_device_alloc("soc-audio", -1);
+	if (!ams_delta_audio_platform_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(ams_delta_audio_platform_device,
+				&ams_delta_snd_soc_device);
+	ams_delta_snd_soc_device.dev = &ams_delta_audio_platform_device->dev;
+	*(unsigned int *)ams_delta_dai_link.cpu_dai->private_data = OMAP_MCBSP1;
+
+	ret = platform_device_add(ams_delta_audio_platform_device);
+	if (ret)
+		goto err;
+
+	/*
+	 * Codec platform device could be registered from elsewhere (board?),
+	 * but I do it here as it makes sense only if used with the card.
+	 */
+	cx20442_platform_device = platform_device_register_simple("cx20442",
+								-1, NULL, 0);
+	return 0;
+err:
+	platform_device_put(ams_delta_audio_platform_device);
+	return ret;
+}
+module_init(ams_delta_module_init);
+
+static void __exit ams_delta_module_exit(void)
+{
+	tty_unregister_ldisc(N_AMSDELTA);
+
+#ifdef CONFIG_GPIO_SYSFS
+	gpio_unexport(ams_delta_hook_switch_gpios[0].gpio);
+#endif
+	snd_soc_jack_free_gpios(&ams_delta_hook_switch,
+			ARRAY_SIZE(ams_delta_hook_switch_gpios),
+			ams_delta_hook_switch_gpios);
+
+	/* Keep modem power on */
+	ams_delta_set_bias_level(&ams_delta_audio_card, SND_SOC_BIAS_STANDBY);
+
+	platform_device_unregister(cx20442_platform_device);
+	platform_device_unregister(ams_delta_audio_platform_device);
+}
+module_exit(ams_delta_module_exit);
+
+MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
+MODULE_DESCRIPTION("ALSA SoC driver for Amstrad E3 (Delta) videophone");
+MODULE_LICENSE("GPL");
