Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0CCDaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:30:14 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:14705 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab0CCDaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:30:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 02 Mar 2010 19:30:10 -0800
From: Wei Ni <wni@nvidia.com>
To: "'Takashi Iwai'" <tiwai@suse.de>
CC: "'Pavel Hofman'" <pavel.hofman@insite.cz>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'akpm'" <akpm@linux-foundation.org>
Date: Wed, 3 Mar 2010 11:28:26 +0800
Subject: RE: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Topic: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Index: Acq57pob8XJ0mHi/TSqof+yehfJzDQAkmZXg
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C16A89A118@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
	<s5hmxyrp311.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C068B2BA8C@HKMAIL01.nvidia.com>
 <s5heik3ujy0.wl%tiwai@suse.de>
In-Reply-To: <s5heik3ujy0.wl%tiwai@suse.de>
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
I still have a question about AZX_MAX_CODECS.
In azx_command_addr() and azx_response_addr(), they use AZX_MAX_CODECS like
If (addr >= AZX_MAX_CODECS) {
    snd_BUG();
    addr = 0;
}
The azx_max_codes[] could not be used in these functions.
How could we do in these functions?

Thanks
Wei.

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Tuesday, March 02, 2010 5:55 PM
To: Wei Ni
Cc: 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio

At Tue, 2 Mar 2010 17:43:28 +0800,
Wei Ni wrote:
> 
> Hi, Takashi
> 1. About AZX_MAX_CODECS, on our new chipset, the codec_mask=0x31, it means
> the codec connect on the slot0, slot4, slot5, and on some GT2xx, the codec
> will connect to slot6 or slot7, although these chip at most have 4 codecs.
> So I change the AZX_MAX_CODECS to 8 directly.
> In hda_intel.c, the azx_command_addr(), azx_response_addr(), and
> azx_codec_create() use the AZX_MAX_CODECS, if it set as 4, the driver will
> not detect the codecs which connect to slot4~7.

Yeah, I understand it.  But, as mentioned, changing this to *all*
controller chips is dangerous.
We have already a quirk for controller chips to set max codecs depending
on the chip model.  Right now, only teradici chip sets to 1.

So, add "#define AZX_DEFAULT_CODECS 4", and use this value unless
azx_max_codecs[] is defined.  And, for the new controller chip
supporting more than 4, it can has 8 in azx_max_codecs[].

Is it feasible?

> 2. yes, it's better to merge the hdmi common codes.
> 3. About ELD, yes, we need to change the Makefile and Kconfig as well.
> Could you help me to change it.

In sound/pci/hda/Makefile, hda_eld.c is built into snd-hda-codec-intelhdmi
by the following rule:

snd-hda-codec-intelhdmi-objs :=	patch_intelhdmi.o hda_eld.o

Since now hda_eld.c is used in two modules, this has to be in the common
place, such as snd-hda-codec.  For this, uncomment the line:

# snd-hda-codec-$(CONFIG_SND_HDA_ELD) += hda_eld.o

and remove hda_eld.o from snd-hda-codec-intelhdmi-objs line.

For Kconfig, right now we have the definition

config SND_HDA_ELD
	def_bool y
	depends on SND_HDA_CODEC_INTELHDMI

Change depends on like

	depends on SND_HDA_CODEC_INTELHDMI || SND_HDA_CODEC_NVHDMI

This can be done via "select" instead.  But, we'd merge all hdmi codes
later, so which way to choose is no big matter.


thanks,

Takashi
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
