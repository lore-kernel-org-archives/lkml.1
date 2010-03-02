Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0CBJse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:48:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:12916 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0CBJsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:48:32 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Mar 2010 04:48:32 EST
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 02 Mar 2010 01:43:30 -0800
From: Wei Ni <wni@nvidia.com>
To: "'Takashi Iwai'" <tiwai@suse.de>
CC: "'Pavel Hofman'" <pavel.hofman@insite.cz>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'akpm'" <akpm@linux-foundation.org>
Date: Tue, 2 Mar 2010 17:43:28 +0800
Subject: RE: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Topic: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Index: Acq53lv5+c9IkKuZTLefFr9k7Q8FNwACdvJg
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8C@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
 <s5hmxyrp311.wl%tiwai@suse.de>
In-Reply-To: <s5hmxyrp311.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takashi
1. About AZX_MAX_CODECS, on our new chipset, the codec_mask=0x31, it means
the codec connect on the slot0, slot4, slot5, and on some GT2xx, the codec
will connect to slot6 or slot7, although these chip at most have 4 codecs.
So I change the AZX_MAX_CODECS to 8 directly.
In hda_intel.c, the azx_command_addr(), azx_response_addr(), and
azx_codec_create() use the AZX_MAX_CODECS, if it set as 4, the driver will
not detect the codecs which connect to slot4~7.

2. yes, it's better to merge the hdmi common codes.

3. About ELD, yes, we need to change the Makefile and Kconfig as well.
Could you help me to change it.

Thanks
Wei.

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Tuesday, March 02, 2010 4:00 PM
To: Wei Ni
Cc: 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio

At Mon, 1 Mar 2010 19:27:53 +0800,
Wei Ni wrote:
> 
> Hi, Takashi
> I developed the hdmi audio driver for new chipset MCP89 and GT21x.
> The new HAD controller and codec support standard HDMI operation.
> 
> I attached the patch file, please check it.

Thanks.  A brief review comments below.


> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index d5c93ad..fbf2c29 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -267,7 +267,7 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO1, SDO2, SDO3 };
>  #define RIRB_INT_MASK		0x05
>  
>  /* STATESTS int mask: S3,SD2,SD1,SD0 */
> -#define AZX_MAX_CODECS		4
> +#define AZX_MAX_CODECS		8

Changing this blindly to all codecs seems a bit dangerous.
We have bad experiences regarding the codec probing, and probing more
codec slots may result in unexpected behavior with the older chip.

Do you know which controller chip supports more than 4 slots?
 

> +struct hdmi_audio_infoframe {
> +	u8 type; /* 0x84 */
> +	u8 ver;  /* 0x01 */
> +	u8 len;  /* 0x0a */
> +
> +	u8 checksum;	/* PB0 */
> +	u8 CC02_CT47;	/* CC in bits 0:2, CT in 4:7 */
> +	u8 SS01_SF24;
> +	u8 CXT04;
> +	u8 CA;
> +	u8 LFEPBL01_LSV36_DM_INH7;
...

Let's merge the stuff with patch_intelhdmi.c later...


> +static void hdmi_get_show_eld(struct hda_codec *codec, hda_nid_t pin_nid,
> +			      struct hdmi_eld *eld)
> +{
> +	if (!snd_hdmi_get_eld(eld, codec, pin_nid))
> +		snd_hdmi_show_eld(eld);

So, now this module depends on the ELD helper?
Then we need to change Makefile and Kconfig as well.
Right now, the eld helper is built into intel-hdmi module.  Now this
is needed to be individual or built-in snd-hda-codec.


thanks,

Takashi
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
