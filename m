Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZLYTBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZLYTBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 14:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbZLYTBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 14:01:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:15040 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbZLYTBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 14:01:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eQLaFCcQty81Puhf52rkupqcE9CuEsuosFX679fK+QVlcaejEHowMzR3MZHSp64j5G
         0RCTMjODw3CeGOoq/sU8KOoloCngiFBQwzSJMORZAeek9nYrv5vkId58+SpIWJRB+JtZ
         eyNV+0kzIuvCIyNzLphEOYOti+Fbo6sDouLho=
MIME-Version: 1.0
In-Reply-To: <s5hvdfvyoef.wl%tiwai@suse.de>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	 <20091225122107.357d7102@mosly> <s5h637vmhcu.wl%tiwai@suse.de>
	 <20091225162528.5dbbbea0@mosly>
	 <8db1092f0912250731u46637a55lccb77e6cdb376a57@mail.gmail.com>
	 <s5hy6kr6nur.wl%tiwai@suse.de> <20091225183205.744be270@mosly>
	 <s5hvdfvyoef.wl%tiwai@suse.de>
Date: Fri, 25 Dec 2009 20:01:46 +0100
Message-ID: <8db1092f0912251101q7ae69d1ai59c68d03a9155566@mail.gmail.com>
Subject: Re: intel hda regression: 2.6.33-rc{1,2}: hd-audio0 eats 25% CPU 
	(according to top)
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/25 Takashi Iwai <tiwai@suse.de>:

> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 950ee5c..f98b47c 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -1327,11 +1327,13 @@ EXPORT_SYMBOL_HDA(snd_hda_query_pin_caps);
>  */
>  u32 snd_hda_pin_sense(struct hda_codec *codec, hda_nid_t nid)
>  {
> -       u32 pincap = snd_hda_query_pin_caps(codec, nid);
> -
> -       if (pincap & AC_PINCAP_TRIG_REQ) /* need trigger? */
> -               snd_hda_codec_read(codec, nid, 0, AC_VERB_SET_PIN_SENSE, 0);
> +       u32 pincap;
>
> +       if (!codec->no_trigger_sense) {
> +               pincap = snd_hda_query_pin_caps(codec, nid);
> +               if (pincap & AC_PINCAP_TRIG_REQ) /* need trigger? */
> +                       snd_hda_codec_read(codec, nid, 0, AC_VERB_SET_PIN_SENSE, 0);
> +       }
>        return snd_hda_codec_read(codec, nid, 0,
>                                  AC_VERB_GET_PIN_SENSE, 0);
>  }
> diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
> index 1d541b7..0a770a2 100644
> --- a/sound/pci/hda/hda_codec.h
> +++ b/sound/pci/hda/hda_codec.h
> @@ -817,6 +817,7 @@ struct hda_codec {
>        unsigned int pin_amp_workaround:1; /* pin out-amp takes index
>                                            * (e.g. Conexant codecs)
>                                            */
> +       unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
>  #ifdef CONFIG_SND_HDA_POWER_SAVE
>        unsigned int power_on :1;       /* current (global) power-state */
>        unsigned int power_transition :1; /* power-state in transition */
> diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
> index 1a36137..69a941c 100644
> --- a/sound/pci/hda/patch_analog.c
> +++ b/sound/pci/hda/patch_analog.c
> @@ -1186,6 +1186,8 @@ static int patch_ad1986a(struct hda_codec *codec)
>         */
>        spec->multiout.no_share_stream = 1;
>
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
> @@ -1371,6 +1373,8 @@ static int patch_ad1983(struct hda_codec *codec)
>
>        codec->patch_ops = ad198x_patch_ops;
>
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
> @@ -1813,6 +1817,9 @@ static int patch_ad1981(struct hda_codec *codec)
>                codec->patch_ops.unsol_event = ad1981_hp_unsol_event;
>                break;
>        }
> +
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
> @@ -3118,6 +3125,8 @@ static int patch_ad1988(struct hda_codec *codec)
>  #endif
>        spec->vmaster_nid = 0x04;
>
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
> @@ -3330,6 +3339,8 @@ static int patch_ad1884(struct hda_codec *codec)
>
>        codec->patch_ops = ad198x_patch_ops;
>
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
> @@ -4287,6 +4298,8 @@ static int patch_ad1884a(struct hda_codec *codec)
>                break;
>        }
>
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
> @@ -4623,6 +4636,9 @@ static int patch_ad1882(struct hda_codec *codec)
>                spec->mixers[2] = ad1882_6stack_mixers;
>                break;
>        }
> +
> +       codec->no_trigger_sense = 1;
> +
>        return 0;
>  }
>
>
Patch solves the problem.

Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>

Thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
