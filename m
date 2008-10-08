Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYJHVvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYJHVvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYJHVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:50:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbYJHVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:50:56 -0400
Date: Wed, 8 Oct 2008 14:50:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Klaas De Craemer <klaasdc@gmail.com>
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] Sigmatel stac92hd71b7 low HP volume
Message-Id: <20081008145008.5c6d0cfd.akpm@linux-foundation.org>
In-Reply-To: <200810022145.03535.klaasdc@gmail.com>
References: <200810022145.03535.klaasdc@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 21:45:03 +0200
Klaas De Craemer <klaasdc@gmail.com> wrote:

> Hello,
> 
> Below is my patch for an issue on Dell E6500 notebooks with the Sigmatel stac92hd71b7 codec. In the default snd-hda-intel configuration, the sound going to the headphone jack goes comes directly from the DAC, resulting in very low volume output. The patch changes the codec's widget connections so that the internal mixer is put in between and sets its input amplifiers to the maximum value. The output to the internal speaker port has been left untouched.
> I have tested this and it gives a much better output.
> 
> Klaas De Craemer
> 
> 
> diff -uNr linux-2.6.26.5/sound/pci/hda/patch_sigmatel.c linux-2.6.26.5.new/sound/pci/hda/patch_sigmatel.c
> --- linux-2.6.26.5/sound/pci/hda/patch_sigmatel.c	2008-09-08 19:40:20.000000000 +0200
> +++ linux-2.6.26.5.new/sound/pci/hda/patch_sigmatel.c	2008-10-02 20:08:51.000000000 +0200
> @@ -624,6 +624,22 @@
>  	{}
>  };
>  
> +static struct hda_verb stac92hd71b7_core_init[] = {
> +	/* set master volume and direct control */
> +	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
> +	/* connect headphone jack to mixer */
> +	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x02},
> +	/* unmute right and left channels for nodes 0x0a, 0xd, 0x0f */
> +	{ 0x0a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
> +	{ 0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
> +	{ 0x0f, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
> +
> +	/* Increase mixer volume for the two dac's */
> +	{ 0x17, 0x370, 0x7f },
> +	{ 0x17, 0x371, 0x7f },
> +	{}
> +};
> +
>  static struct hda_verb stac92hd71bxx_core_init[] = {
>  	/* set master volume and direct control */
>  	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
> @@ -3642,6 +3658,10 @@
>  		spec->mixer = stac92hd71bxx_mixer;
>  		spec->init = stac92hd71bxx_core_init;
>  		break;
> +	case 0x111d76b2: /* Dell E6500 stac92hd71b7 configuration */
> +		spec->mixer = stac92hd71bxx_mixer;
> +		spec->init = stac92hd71b7_core_init;
> +		break;
>  	default:
>  		spec->mixer = stac92hd71bxx_analog_mixer;
>  		spec->init = stac92hd71bxx_analog_core_init;

This needed updating to apply on the current alsa development tree. 
Please see below.

Note that this may now be wrong - various cases in
patch_stac92hd71bxx() have recently been updated to modify
codec->slave_dig_outs, but we're not doing that in the case of
0x111d76b2.

Please send us a Signed-off-by: for your patch, as per
Documentation/Submittingpatches, thanks.



From: Klaas De Craemer <klaasdc@gmail.com>

Fix an issue on Dell E6500 notebooks with the Sigmatel stac92hd71b7 codec.

In the default snd-hda-intel configuration, the sound going to the
headphone jack goes comes directly from the DAC, resulting in very low
volume output.  The patch changes the codec's widget connections so that
the internal mixer is put in between and sets its input amplifiers to the
maximum value.  The output to the internal speaker port has been left
untouched.  I have tested this and it gives a much better output.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_sigmatel.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN sound/pci/hda/patch_sigmatel.c~alsa-sigmatel-stac92hd71b7-low-hp-volume sound/pci/hda/patch_sigmatel.c
--- a/sound/pci/hda/patch_sigmatel.c~alsa-sigmatel-stac92hd71b7-low-hp-volume
+++ a/sound/pci/hda/patch_sigmatel.c
@@ -855,6 +855,22 @@ static struct hda_verb stac92hd83xxx_cor
 	{ 0x01, AC_VERB_SET_EAPD, 1 << 2},
 };
 
+static struct hda_verb stac92hd71b7_core_init[] = {
+	/* set master volume and direct control */
+	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
+	/* connect headphone jack to mixer */
+	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x02},
+	/* unmute right and left channels for nodes 0x0a, 0xd, 0x0f */
+	{ 0x0a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{ 0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{ 0x0f, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+
+	/* Increase mixer volume for the two dac's */
+	{ 0x17, 0x370, 0x7f },
+	{ 0x17, 0x371, 0x7f },
+	{}
+};
+
 static struct hda_verb stac92hd71bxx_core_init[] = {
 	/* set master volume and direct control */
 	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
@@ -4354,6 +4370,10 @@ again:
 		spec->init = stac92hd71bxx_core_init;
 		codec->slave_dig_outs = stac92hd71bxx_slave_dig_outs;
 		break;
+	case 0x111d76b2: /* Dell E6500 stac92hd71b7 configuration */
+		spec->mixer = stac92hd71bxx_mixer;
+		spec->init = stac92hd71b7_core_init;
+		break;
 	case 0x111d7608: /* 5 Port with Analog Mixer */
 		if ((codec->revision_id & 0xf) == 0 ||
 				(codec->revision_id & 0xf) == 1) {
_

