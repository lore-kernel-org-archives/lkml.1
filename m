Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYHPRdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYHPRdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYHPRdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:33:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:7814 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHPRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CfyvFrMal76uckfBrn5I5YBwMGpvWw88OZp5uBFhV37Mbmh3bB/KdRpxdnLOZziOMn
         tZdsnFmtM+EO4mxrl/iFMvSzex7CTVDP94ivy/NE/SZ9tBcE/4wAEndfjbBSKY0ePxM7
         OnXVw9rcmZRGmE7JIT6XYVo2/CXmpGPHDXqBo=
Message-ID: <6278d2220808161033g7e42947dn54d9dc951d1f61b0@mail.gmail.com>
Date: Sat, 16 Aug 2008 18:33:33 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hod3s99og.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
	 <6278d2220808141210p3c612feen6fe779bc84a4ae78@mail.gmail.com>
	 <s5hfxp65ohr.wl%tiwai@suse.de>
	 <6278d2220808151501i207e5cccg733e20b8fa1d227d@mail.gmail.com>
	 <s5hwsihnym4.wl%tiwai@suse.de>
	 <6278d2220808160637h1c096c1akdf929820f2cbd23d@mail.gmail.com>
	 <s5hod3s99og.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Sat, Aug 16, 2008 at 6:00 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sat, 16 Aug 2008 14:37:37 +0100,
> Daniel J Blueman wrote:
>>
>> This patch is first one you sent, except differing line numbers
>> (rediffed against 2.6.27-rc3?).
>
> Oops, I forgot to refresh it.  Below is the right one.
>
>> You could try attaching the patch to the mail too, to avoid the line
>> wrapping, silent whitespace conversion and any gmail/mailer 'hide
>> quoted text' mangling...
>
> On LKML, the patches should be inlined.
> And, you can save a raw file even via gmail, too...
>
> Takashi
>
>
> [PATCH] ALSA: hda - Fix capture source widgets on ALC codecs
>
> On some Realtek codecs like ALC882 or ALC883, the capture source is
> no mux but sum widget.  We have to initialize all channels properly
> for this type, otherwise noises may come in from the unused route.
>
> The patch assures to mute unused routes, and unmute the currently
> selected route.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index add4e87..b80e725 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -6437,6 +6437,39 @@ static void alc882_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +static void alc882_auto_init_input_src(struct hda_codec *codec)
> +{
> +       struct alc_spec *spec = codec->spec;
> +       const struct hda_input_mux *imux = spec->input_mux;
> +       int c;
> +
> +       for (c = 0; c < spec->num_adc_nids; c++) {
> +               hda_nid_t conn_list[HDA_MAX_NUM_INPUTS];
> +               hda_nid_t nid = spec->capsrc_nids[c];
> +               int conns, mute, idx, item;
> +
> +               conns = snd_hda_get_connections(codec, nid, conn_list,
> +                                               ARRAY_SIZE(conn_list));
> +               if (conns < 0)
> +                       continue;
> +               for (idx = 0; idx < conns; idx++) {
> +                       /* if the current connection is the selected one,
> +                        * unmute it as default - otherwise mute it
> +                        */
> +                       mute = AMP_IN_MUTE(idx);
> +                       for (item = 0; item < imux->num_items; item++) {
> +                               if (imux->items[item].index == idx) {
> +                                       if (spec->cur_mux[c] == item)
> +                                               mute = AMP_IN_UNMUTE(idx);
> +                                       break;
> +                               }
> +                       }
> +                       snd_hda_codec_write(codec, nid, 0,
> +                                           AC_VERB_SET_AMP_GAIN_MUTE, mute);
> +               }
> +       }
> +}
> +
>  /* add mic boosts if needed */
>  static int alc_auto_add_mic_boost(struct hda_codec *codec)
>  {
> @@ -6491,6 +6524,7 @@ static void alc882_auto_init(struct hda_codec *codec)
>        alc882_auto_init_multi_out(codec);
>        alc882_auto_init_hp_out(codec);
>        alc882_auto_init_analog_input(codec);
> +       alc882_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -8285,6 +8319,8 @@ static void alc883_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +#define alc883_auto_init_input_src     alc882_auto_init_input_src
> +
>  /* almost identical with ALC880 parser... */
>  static int alc883_parse_auto_config(struct hda_codec *codec)
>  {
> @@ -8315,6 +8351,7 @@ static void alc883_auto_init(struct hda_codec *codec)
>        alc883_auto_init_multi_out(codec);
>        alc883_auto_init_hp_out(codec);
>        alc883_auto_init_analog_input(codec);
> +       alc883_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -9663,6 +9700,7 @@ static int alc262_parse_auto_config(struct hda_codec *codec)
>  #define alc262_auto_init_multi_out     alc882_auto_init_multi_out
>  #define alc262_auto_init_hp_out                alc882_auto_init_hp_out
>  #define alc262_auto_init_analog_input  alc882_auto_init_analog_input
> +#define alc262_auto_init_input_src     alc882_auto_init_input_src
>
>
>  /* init callback for auto-configuration model -- overriding the default init */
> @@ -9672,6 +9710,7 @@ static void alc262_auto_init(struct hda_codec *codec)
>        alc262_auto_init_multi_out(codec);
>        alc262_auto_init_hp_out(codec);
>        alc262_auto_init_analog_input(codec);
> +       alc262_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -13330,6 +13369,8 @@ static void alc861vd_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +#define alc861vd_auto_init_input_src   alc882_auto_init_input_src
> +
>  #define alc861vd_idx_to_mixer_vol(nid)         ((nid) + 0x02)
>  #define alc861vd_idx_to_mixer_switch(nid)      ((nid) + 0x0c)
>
> @@ -13512,6 +13553,7 @@ static void alc861vd_auto_init(struct hda_codec *codec)
>        alc861vd_auto_init_multi_out(codec);
>        alc861vd_auto_init_hp_out(codec);
>        alc861vd_auto_init_analog_input(codec);
> +       alc861vd_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }
> @@ -14677,6 +14719,8 @@ static void alc662_auto_init_analog_input(struct hda_codec *codec)
>        }
>  }
>
> +#define alc662_auto_init_input_src     alc882_auto_init_input_src
> +
>  static int alc662_parse_auto_config(struct hda_codec *codec)
>  {
>        struct alc_spec *spec = codec->spec;
> @@ -14733,6 +14777,7 @@ static void alc662_auto_init(struct hda_codec *codec)
>        alc662_auto_init_multi_out(codec);
>        alc662_auto_init_hp_out(codec);
>        alc662_auto_init_analog_input(codec);
> +       alc662_auto_init_input_src(codec);
>        if (spec->unsol_event)
>                alc_sku_automute(codec);
>  }

The updated patch validates fully also. Checking everything with
codecgraph and varying both capture inputs looks as expected, so
thanks again!

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>

Daniel
-- 
Daniel J Blueman
