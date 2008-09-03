Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYICLLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYICLLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYICLLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:11:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.112.152]:5847 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYICLLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:11:06 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 07:11:06 EDT
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 03 Sep 2008 04:05:55 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [alsa-devel][PATCH] add the nvidia HDMI codec driver for MCP77/79
Date: Wed, 3 Sep 2008 19:05:47 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com>
In-Reply-To: <s5hhc8xpq6z.wl%tiwai@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel][PATCH] add the nvidia HDMI codec driver for MCP77/79
Thread-Index: AckNrQERcb419n//Sxu5crgGwm4nSAAAf+rg
References: <200809031558156739794@gmail.com> <s5hhc8xpq6z.wl%tiwai@suse.de>
From: "Wei Ni" <wni@nvidia.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "alsa-devel" <alsa-devel@alsa-project.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Peer Chen" <pchen@nvidia.com>
X-OriginalArrivalTime: 03 Sep 2008 11:05:51.0350 (UTC) FILETIME=[06F17960:01C90DB5]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Thanks for your comments. Some reply below:

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Wednesday, September 03, 2008 4:52 PM
To: peerchen
Cc: alsa-devel; linux-kernel; akpm; Peer Chen; Wei Ni
Subject: Re: [alsa-devel][PATCH] add the nvidia HDMI codec driver for
MCP77/79

At Wed, 3 Sep 2008 15:58:17 +0800,
peerchen wrote:
> 
> Add the nvidia HDMI codec driver for MCP77/79. 
> The patch based on kernel 2.6.27-rc5.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> Signed-off-by: Peer Chen <peerchen@gmail.com>

Thanks for the patch.  Some comments below.


> diff -uprN -X linux-2.6.26-Orig/Documentation/dontdiff
linux-2.6.26-Orig/sound/pci/hda/hda_intel.c
linux-2.6.26-New/sound/pci/hda/hda_intel.c
> --- linux-2.6.26-Orig/sound/pci/hda/hda_intel.c	2008-08-28
13:47:20.000000000 +0800
> +++ linux-2.6.26-New/sound/pci/hda/hda_intel.c	2008-08-28
15:33:51.000000000 +0800
> @@ -223,8 +223,8 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
>  #define RIRB_INT_MASK		0x05
>  
>  /* STATESTS int mask: SD2,SD1,SD0 */
> -#define AZX_MAX_CODECS		3
> -#define STATESTS_INT_MASK	0x07
> +#define AZX_MAX_CODECS		4
> +#define STATESTS_INT_MASK	0x0f

This may break other platforms.  Expanding STATESTS_INT_MASK is OK and
would be harmless, but AZX_MAX_CODECS is not.
AZX_MAX_CODECS is the default number of max codecs.  The chipset
specific max number of codecs is defined in azx_max_codecs[].
If Nvidia chipsets supports properly more than 3, change
azx_max_codecs[AZX_DRIVER_NVIDIA] to 4.

==========Wei Ni's Answer: ==============
There are 2 codec connect to the nvidia AZA controller, one is realtek,
and the other is nvidia HDMI codec.
In azx_codec_create(), the chip->codec_mask indicate codec connection.
This chip->codec_mask=0x9, bit0 indicate realtek codec, and bit3
indicate hdmi codec.
In this routine, it use:
......
for (c = 0; c < AZX_MAX_CODECS; c++) {
		if ((chip->codec_mask & (1 << c)) & codec_probe_mask) {
			struct hda_codec *codec;
			err = snd_hda_codec_new(chip->bus, c, &codec);
			if (err < 0)
				continue;
			codecs++;
			if (codec->afg)
				audio_codecs++;
		}
	}
if (!audio_codecs) {
		/* probe additional slots if no codec is found */
		for (; c < azx_max_codecs[chip->driver_type]; c++) {
			if ((chip->codec_mask & (1 << c)) &
codec_probe_mask) {
				err = snd_hda_codec_new(chip->bus, c,
NULL);
				if (err < 0)
					continue;
				codecs++;
			}
		}
	}
......
According to these codes, It only can get the realtek codec and can not
get hdmi codec, if just change azx_max_codecs[AZX_DRIVER_NVIDIA] to 4
I think if remove "if (!audio_codecs)", it will be better, and I only
need to chang azx_max_codecs[AZX_DRIVER_NVIDIA] to 4
=====================================

> +static unsigned short convert_from_spdif_status_nv(unsigned int
sbits)
> +{
> +        unsigned short val = 0;
> +
> +        if (sbits & IEC958_AES0_PROFESSIONAL)
> +                val |= AC_DIG1_PROFESSIONAL;
> +        if (sbits & IEC958_AES0_NONAUDIO)
> +                val |= AC_DIG1_NONAUDIO;
> +        if (sbits & IEC958_AES0_PROFESSIONAL) {
> +                if ((sbits & IEC958_AES0_PRO_EMPHASIS) ==
> +                    IEC958_AES0_PRO_EMPHASIS_5015)
> +                        val |= AC_DIG1_EMPHASIS;
> +        } else {
> +                if ((sbits & IEC958_AES0_CON_EMPHASIS) ==
> +                    IEC958_AES0_CON_EMPHASIS_5015)
> +                        val |= AC_DIG1_EMPHASIS;
> +                if (!(sbits & IEC958_AES0_CON_NOT_COPYRIGHT))
> +                        val |= AC_DIG1_COPYRIGHT;
> +                if (sbits & (IEC958_AES1_CON_ORIGINAL << 8))
> +                        val |= AC_DIG1_LEVEL;
> +                val |= sbits & (IEC958_AES1_CON_CATEGORY << 8);
> +        }
> +        return val;
> +}
> +
> +static unsigned int convert_to_spdif_status_nv(unsigned short val)
> +{
> +        unsigned int sbits = 0;
> +
> +        if (val & AC_DIG1_NONAUDIO)
> +                sbits |= IEC958_AES0_NONAUDIO;
> +        if (val & AC_DIG1_PROFESSIONAL)
> +                sbits |= IEC958_AES0_PROFESSIONAL;
> +        if (sbits & IEC958_AES0_PROFESSIONAL) {
> +                if (sbits & AC_DIG1_EMPHASIS)
> +                        sbits |= IEC958_AES0_PRO_EMPHASIS_5015;
> +        } else {
> +                if (val & AC_DIG1_EMPHASIS)
> +                        sbits |= IEC958_AES0_CON_EMPHASIS_5015;
> +                if (!(val & AC_DIG1_COPYRIGHT))
> +                        sbits |= IEC958_AES0_CON_NOT_COPYRIGHT;
> +                if (val & AC_DIG1_LEVEL)
> +                        sbits |= (IEC958_AES1_CON_ORIGINAL << 8);
> +                sbits |= val & (0x7f << 8);
> +        }
> +        return sbits;
> +}
> +
> +static int snd_hda_hdmi_cmask_get(struct snd_kcontrol *kcontrol,
> +                                   struct snd_ctl_elem_value
*ucontrol)
> +{
> +        ucontrol->value.iec958.status[0] = IEC958_AES0_PROFESSIONAL |
> +                                           IEC958_AES0_NONAUDIO |
> +
IEC958_AES0_CON_EMPHASIS_5015 |
> +
IEC958_AES0_CON_NOT_COPYRIGHT;
> +        ucontrol->value.iec958.status[1] = IEC958_AES1_CON_CATEGORY |
> +                                           IEC958_AES1_CON_ORIGINAL;
> +        return 0;
> +}
> +
> +static int snd_hda_hdmi_pmask_get(struct snd_kcontrol *kcontrol,
> +                                   struct snd_ctl_elem_value
*ucontrol)
> +{
> +        ucontrol->value.iec958.status[0] = IEC958_AES0_PROFESSIONAL |
> +                                           IEC958_AES0_NONAUDIO |
> +
IEC958_AES0_PRO_EMPHASIS_5015;
> +        return 0;
> +}
> +
> +static int snd_hda_hdmi_mask_info(struct snd_kcontrol *kcontrol,
> +                                   struct snd_ctl_elem_info *uinfo)
> +{
> +        uinfo->type = SNDRV_CTL_ELEM_TYPE_IEC958;
> +        uinfo->count = 1;
> +        return 0;
> +}
> +
> +static int snd_hda_hdmi_default_get(struct snd_kcontrol *kcontrol,
> +                                     struct snd_ctl_elem_value
*ucontrol)
> +{
> +        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
> +
> +        ucontrol->value.iec958.status[0] = codec->spdif_status &
0xff;
> +        ucontrol->value.iec958.status[1] = (codec->spdif_status >> 8)
& 0xff;
> +        ucontrol->value.iec958.status[2] = (codec->spdif_status >>
16) & 0xff;
> +        ucontrol->value.iec958.status[3] = (codec->spdif_status >>
24) & 0xff;
> +
> +        return 0;
> +}
> +
> +static int snd_hda_hdmi_default_put(struct snd_kcontrol *kcontrol,
> +                                     struct snd_ctl_elem_value
*ucontrol)
> +{
> +        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
> +        hda_nid_t nid = kcontrol->private_value;
> +        unsigned short val;
> +        int change;
> +
> +        mutex_lock(&codec->spdif_mutex);
> +        codec->spdif_status = ucontrol->value.iec958.status[0] |
> +                ((unsigned int)ucontrol->value.iec958.status[1] << 8)
|
> +                ((unsigned int)ucontrol->value.iec958.status[2] <<
16) |
> +                ((unsigned int)ucontrol->value.iec958.status[3] <<
24);
> +        val = convert_from_spdif_status_nv(codec->spdif_status);
> +        val |= codec->spdif_ctls & 1;
> +        change = codec->spdif_ctls != val;
> +        codec->spdif_ctls = val;
> +
> +        if (change) {
> +                snd_hda_codec_write_cache(codec, nid, 0,
> +                                          AC_VERB_SET_DIGI_CONVERT_1,
> +                                          val & 0xff);
> +                snd_hda_codec_write_cache(codec, nid, 0,
> +                                          AC_VERB_SET_DIGI_CONVERT_2,
> +                                          val >> 8);
> +        }
> +
> +        mutex_unlock(&codec->spdif_mutex);
> +        return change;
> +}
> +
> +#define snd_hda_hdmi_out_switch_info   snd_ctl_boolean_mono_info
> +
> +static int snd_hda_hdmi_out_switch_get(struct snd_kcontrol *kcontrol,
> +                                        struct snd_ctl_elem_value
*ucontrol)
> +{
> +        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
> +
> +        ucontrol->value.integer.value[0] = codec->spdif_ctls &
AC_DIG1_ENABLE;
> +        return 0;
> +}
> +
> +static int snd_hda_hdmi_out_switch_put(struct snd_kcontrol *kcontrol,
> +                                        struct snd_ctl_elem_value
*ucontrol)
> +{
> +        struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
> +        hda_nid_t nid = kcontrol->private_value;
> +        unsigned short val;
> +        int change;
> +
> +        mutex_lock(&codec->spdif_mutex);
> +        val = codec->spdif_ctls & ~AC_DIG1_ENABLE;
> +        if (ucontrol->value.integer.value[0])
> +                val |= AC_DIG1_ENABLE;
> +        change = codec->spdif_ctls != val;
> +        if (change) {
> +                codec->spdif_ctls = val;
> +                snd_hda_codec_write_cache(codec, nid, 0,
> +                                          AC_VERB_SET_DIGI_CONVERT_1,
> +                                          val & 0xff);
> +                /* unmute amp switch (if any) */
> +                if ((get_wcaps(codec, nid) & AC_WCAP_OUT_AMP) &&
> +                    (val & AC_DIG1_ENABLE))
> +                        snd_hda_codec_amp_stereo(codec, nid,
HDA_OUTPUT, 0,
> +                                                 HDA_AMP_MUTE, 0);
> +        }
> +        mutex_unlock(&codec->spdif_mutex);
> +        return change;
> +}

These are almost identical with the functions in hda_codec.c.
Is your intention to allow a different set of IEC958 status bits
controls for HDMI *in addition* to SPDIF?  If so, we should change
the codes in hda_codec.c to allow other control names.

==========Wei Ni's Answer: ==============
There are 2 codec connect to the nvidia AZA controller, one is realtek,
the other is nvidia HDMI codec.
If I use the default SPDIF routine: snd_hda_create_spdif_out_ctls(), the
driver can not be insmod success.
I traced this issue, the realtek's SPDIF used this IEC958 first, and
then HDMI codec can't use IEC958 again.
( I traced it based on linux-2.6.25 )
So I write some routines for HDMI which are same as SPDIF routine, and
the driver can work.
=====================================


> +struct snd_kcontrol_new hdmi_mixes[] = {
> +    {
> +        .access = SNDRV_CTL_ELEM_ACCESS_READ,
> +        .iface = SNDRV_CTL_ELEM_IFACE_MIXER,
> +        .name = "IEC958 Playback Con Mask HDMI",
> +        .info = snd_hda_hdmi_mask_info,
> +        .get = snd_hda_hdmi_cmask_get,
> +    },

These have also different names from the standard ones.
Any reason?

==========Wei Ni's Answer: ==============
Ditto
=====================================

> +static struct hda_pcm_stream nvhdmi_pcm_digital_playback = {
> +	.substreams = 1,
> +	.channels_min = 2,
> +	.channels_max = 2,
> +	.nid = 0x4, /* NID to query formats and rates and setup streams
*/
> +        .rates = SNDRV_PCM_RATE_48000,
> +        .maxbps = 16,
> +        .formats = SNDRV_PCM_FMTBIT_S16_LE,

Use tabs please.

==========Wei Ni's Answer: ==============
Thanks, I will modify it.
=====================================

> +static int nvhdmi_build_pcms(struct hda_codec *codec)
> +{
> +	struct nvhdmi_spec *spec = codec->spec;
> +	struct hda_pcm *info = &spec->pcm_rec;
> +
> +	codec->num_pcms = 1;
> +	codec->pcm_info = info;
> +
> +	info->name = "NVIDIA HDMI";
> +        info->pcm_type = HDA_PCM_TYPE_HDMI

Ditto.

==========Wei Ni's Answer: ==============
Thanks, I will modify it.
=====================================


thanks,

Takashi
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
