Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbZJBUpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbZJBUpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbZJBUpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:45:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37988 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbZJBUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:45:07 -0400
Date: Fri, 2 Oct 2009 15:44:51 -0500 (CDT)
From: manoj.iyer@canonical.com
To: Takashi Iwai <tiwai@suse.de>
cc: manoj.iyer@canonical.com, perex@perex.cz, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Joey Stanford <joey@canonical.com>
Subject: Re: [PATCH REALTEK] Added quirk to enable sound on Toshiba NB200
In-Reply-To: <s5htyyivrpv.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.00.0910021544280.4531@little>
References: <alpine.DEB.2.00.0909230036570.29432@little> <s5h3a6eb46r.wl%tiwai@suse.de> <alpine.DEB.2.00.0909281022500.2112@little> <s5hd45agqoi.wl%tiwai@suse.de> <alpine.DEB.2.00.0909291812030.2426@little> <s5hhbulov3f.wl%tiwai@suse.de>
 <alpine.DEB.2.00.0910010208220.7813@little> <s5h1vlnjzaa.wl%tiwai@suse.de> <s5htyyivrpv.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sure, I will try this over the weekend and report the results back here.

On Thu, 1 Oct 2009, Takashi Iwai wrote:

> At Thu, 01 Oct 2009 10:26:05 +0200,
> I wrote:
>>
>> At Thu, 1 Oct 2009 02:11:35 -0500 (CDT),
>> manoj.iyer@canonical.com wrote:
>>>
>>>> 2.6.31.x is way too old for testing the new stuff :)
>>>> Any chance to test 2.6.32-rc1?
>>>
>>> http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.32-rc1/
>>>
>>> I tried the 2.6.32-rc1 today, and sound does not work for me on the NB200.
>>
>> OK, thanks for checking.
>> After looking at the code a bit more deeply, it turned out that the
>> BIOS auto-parser doesn't work with this particular configuration (the
>> speaker with mono pin 0x17).
>>
>> I'm going to fix it later, but I applied your patch as the quick fix
>> for the time being.
>
> Could you try the patch below with model=auto?
> This will make the auto-parser working, hopefully.
>
>
> thanks,
>
> Takashi
>
> ---
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index 87da5e8..7810d3d 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -17146,70 +17146,145 @@ static struct alc_config_preset alc662_presets[] = {
>  * BIOS auto configuration
>  */
>
> +/* convert from MIX nid to DAC */
> +static inline hda_nid_t alc662_mix_to_dac(hda_nid_t nid)
> +{
> +	if (nid == 0x0f)
> +		return 0x02;
> +	else if (nid >= 0x0c && nid <= 0x0e)
> +		return nid - 0x0c + 0x02;
> +	else
> +		return 0;
> +}
> +
> +/* get MIX nid connected to the given pin targeted to DAC */
> +static hda_nid_t alc662_dac_to_mix(struct hda_codec *codec, hda_nid_t pin,
> +				   hda_nid_t dac)
> +{
> +	hda_nid_t mix[4];
> +	int i, num;
> +
> +	num = snd_hda_get_connections(codec, pin, mix, ARRAY_SIZE(mix));
> +	for (i = 0; i < num; i++) {
> +		if (alc662_mix_to_dac(mix[i]) == dac)
> +			return mix[i];
> +	}
> +	return 0;
> +}
> +
> +/* look for an empty DAC slot */
> +static hda_nid_t alc662_look_for_dac(struct hda_codec *codec, hda_nid_t pin)
> +{
> +	struct alc_spec *spec = codec->spec;
> +	hda_nid_t srcs[5];
> +	int i, j, num;
> +
> +	num = snd_hda_get_connections(codec, pin, srcs, ARRAY_SIZE(srcs));
> +	if (num < 0)
> +		return 0;
> +	for (i = 0; i < num; i++) {
> +		hda_nid_t nid = alc662_mix_to_dac(srcs[i]);
> +		if (!nid)
> +			continue;
> +		for (j = 0; j < spec->multiout.num_dacs; j++)
> +			if (spec->multiout.dac_nids[j] == nid)
> +				break;
> +		if (j >= spec->multiout.num_dacs)
> +			return nid;
> +	}
> +	return 0;
> +}
> +
> +/* fill in the dac_nids table from the parsed pin configuration */
> +static int alc662_auto_fill_dac_nids(struct hda_codec *codec,
> +				     const struct auto_pin_cfg *cfg)
> +{
> +	struct alc_spec *spec = codec->spec;
> +	int i;
> +	hda_nid_t dac;
> +
> +	spec->multiout.dac_nids = spec->private_dac_nids;
> +	for (i = 0; i < cfg->line_outs; i++) {
> +		dac = alc662_look_for_dac(codec, cfg->line_out_pins[i]);
> +		if (!dac)
> +			continue;
> +		spec->multiout.dac_nids[spec->multiout.num_dacs++] = dac;
> +	}
> +	return 0;
> +}
> +
> +static int alc662_add_vol_ctl(struct alc_spec *spec, const char *pfx,
> +			      hda_nid_t nid, unsigned int chs)
> +{
> +	char name[32];
> +	sprintf(name, "%s Playback Volume", pfx);
> +	return add_control(spec, ALC_CTL_WIDGET_VOL, name,
> +			   HDA_COMPOSE_AMP_VAL(nid, chs, 0, HDA_OUTPUT));
> +}
> +
> +static int alc662_add_sw_ctl(struct alc_spec *spec, const char *pfx,
> +			     hda_nid_t nid, unsigned int chs)
> +{
> +	char name[32];
> +	sprintf(name, "%s Playback Switch", pfx);
> +	return add_control(spec, ALC_CTL_WIDGET_MUTE, name,
> +			   HDA_COMPOSE_AMP_VAL(nid, chs, 0, HDA_INPUT));
> +}
> +
> +#define alc662_add_stereo_vol(spec, pfx, nid) \
> +	alc662_add_vol_ctl(spec, pfx, nid, 3)
> +#define alc662_add_stereo_sw(spec, pfx, nid) \
> +	alc662_add_sw_ctl(spec, pfx, nid, 3)
> +
> /* add playback controls from the parsed DAC table */
> -static int alc662_auto_create_multi_out_ctls(struct alc_spec *spec,
> +static int alc662_auto_create_multi_out_ctls(struct hda_codec *codec,
> 					     const struct auto_pin_cfg *cfg)
> {
> -	char name[32];
> +	struct alc_spec *spec = codec->spec;
> 	static const char *chname[4] = {
> 		"Front", "Surround", NULL /*CLFE*/, "Side"
> 	};
> -	hda_nid_t nid;
> +	hda_nid_t nid, mix;
> 	int i, err;
>
> 	for (i = 0; i < cfg->line_outs; i++) {
> -		if (!spec->multiout.dac_nids[i])
> +		nid = spec->multiout.dac_nids[i];
> +		if (!nid)
> +			continue;
> +		mix = alc662_dac_to_mix(codec, cfg->line_out_pins[i], nid);
> +		if (!mix)
> 			continue;
> -		nid = alc880_idx_to_dac(i);
> 		if (i == 2) {
> 			/* Center/LFE */
> -			err = add_control(spec, ALC_CTL_WIDGET_VOL,
> -					  "Center Playback Volume",
> -					  HDA_COMPOSE_AMP_VAL(nid, 1, 0,
> -							      HDA_OUTPUT));
> +			err = alc662_add_vol_ctl(spec, "Center", nid, 1);
> 			if (err < 0)
> 				return err;
> -			err = add_control(spec, ALC_CTL_WIDGET_VOL,
> -					  "LFE Playback Volume",
> -					  HDA_COMPOSE_AMP_VAL(nid, 2, 0,
> -							      HDA_OUTPUT));
> +			err = alc662_add_vol_ctl(spec, "LFE", nid, 2);
> 			if (err < 0)
> 				return err;
> -			err = add_control(spec, ALC_CTL_WIDGET_MUTE,
> -					  "Center Playback Switch",
> -					  HDA_COMPOSE_AMP_VAL(0x0e, 1, 0,
> -							      HDA_INPUT));
> +			err = alc662_add_sw_ctl(spec, "Center", mix, 1);
> 			if (err < 0)
> 				return err;
> -			err = add_control(spec, ALC_CTL_WIDGET_MUTE,
> -					  "LFE Playback Switch",
> -					  HDA_COMPOSE_AMP_VAL(0x0e, 2, 0,
> -							      HDA_INPUT));
> +			err = alc662_add_sw_ctl(spec, "LFE", mix, 2);
> 			if (err < 0)
> 				return err;
> 		} else {
> 			const char *pfx;
> 			if (cfg->line_outs == 1 &&
> 			    cfg->line_out_type == AUTO_PIN_SPEAKER_OUT) {
> -				if (!cfg->hp_pins)
> +				if (cfg->hp_outs)
> 					pfx = "Speaker";
> 				else
> 					pfx = "PCM";
> 			} else
> 				pfx = chname[i];
> -			sprintf(name, "%s Playback Volume", pfx);
> -			err = add_control(spec, ALC_CTL_WIDGET_VOL, name,
> -					  HDA_COMPOSE_AMP_VAL(nid, 3, 0,
> -							      HDA_OUTPUT));
> +			err = alc662_add_vol_ctl(spec, pfx, nid, 3);
> 			if (err < 0)
> 				return err;
> 			if (cfg->line_outs == 1 &&
> 			    cfg->line_out_type == AUTO_PIN_SPEAKER_OUT)
> 				pfx = "Speaker";
> -			sprintf(name, "%s Playback Switch", pfx);
> -			err = add_control(spec, ALC_CTL_WIDGET_MUTE, name,
> -				HDA_COMPOSE_AMP_VAL(alc880_idx_to_mixer(i),
> -						    3, 0, HDA_INPUT));
> +			err = alc662_add_sw_ctl(spec, pfx, mix, 3);
> 			if (err < 0)
> 				return err;
> 		}
> @@ -17218,54 +17293,38 @@ static int alc662_auto_create_multi_out_ctls(struct alc_spec *spec,
> }
>
> /* add playback controls for speaker and HP outputs */
> -static int alc662_auto_create_extra_out(struct alc_spec *spec, hda_nid_t pin,
> +/* return DAC nid if any new DAC is assigned */
> +static int alc662_auto_create_extra_out(struct hda_codec *codec, hda_nid_t pin,
> 					const char *pfx)
> {
> -	hda_nid_t nid;
> +	struct alc_spec *spec = codec->spec;
> +	hda_nid_t nid, mix;
> 	int err;
> -	char name[32];
>
> 	if (!pin)
> 		return 0;
> -
> -	if (pin == 0x17) {
> -		/* ALC663 has a mono output pin on 0x17 */
> +	nid = alc662_look_for_dac(codec, pin);
> +	if (!nid) {
> +		char name[32];
> +		/* the corresponding DAC is already occupied */
> +		if (!(get_wcaps(codec, pin) & AC_WCAP_OUT_AMP))
> +			return 0; /* no way */
> +		/* create a switch only */
> 		sprintf(name, "%s Playback Switch", pfx);
> -		err = add_control(spec, ALC_CTL_WIDGET_MUTE, name,
> -				  HDA_COMPOSE_AMP_VAL(pin, 2, 0, HDA_OUTPUT));
> -		return err;
> +		return add_control(spec, ALC_CTL_WIDGET_MUTE, name,
> +				   HDA_COMPOSE_AMP_VAL(pin, 3, 0, HDA_OUTPUT));
> 	}
>
> -	if (alc880_is_fixed_pin(pin)) {
> -		nid = alc880_idx_to_dac(alc880_fixed_pin_idx(pin));
> -		/* printk(KERN_DEBUG "DAC nid=%x\n",nid); */
> -		/* specify the DAC as the extra output */
> -		if (!spec->multiout.hp_nid)
> -			spec->multiout.hp_nid = nid;
> -		else
> -			spec->multiout.extra_out_nid[0] = nid;
> -		/* control HP volume/switch on the output mixer amp */
> -		nid = alc880_idx_to_dac(alc880_fixed_pin_idx(pin));
> -		sprintf(name, "%s Playback Volume", pfx);
> -		err = add_control(spec, ALC_CTL_WIDGET_VOL, name,
> -				  HDA_COMPOSE_AMP_VAL(nid, 3, 0, HDA_OUTPUT));
> -		if (err < 0)
> -			return err;
> -		sprintf(name, "%s Playback Switch", pfx);
> -		err = add_control(spec, ALC_CTL_BIND_MUTE, name,
> -				  HDA_COMPOSE_AMP_VAL(nid, 3, 2, HDA_INPUT));
> -		if (err < 0)
> -			return err;
> -	} else if (alc880_is_multi_pin(pin)) {
> -		/* set manual connection */
> -		/* we have only a switch on HP-out PIN */
> -		sprintf(name, "%s Playback Switch", pfx);
> -		err = add_control(spec, ALC_CTL_WIDGET_MUTE, name,
> -				  HDA_COMPOSE_AMP_VAL(pin, 3, 0, HDA_OUTPUT));
> -		if (err < 0)
> -			return err;
> -	}
> -	return 0;
> +	mix = alc662_dac_to_mix(codec, pin, nid);
> +	if (!mix)
> +		return 0;
> +	err = alc662_add_vol_ctl(spec, pfx, nid, 3);
> +	if (err < 0)
> +		return err;
> +	err = alc662_add_sw_ctl(spec, pfx, mix, 3);
> +	if (err < 0)
> +		return err;
> +	return nid;
> }
>
> /* create playback/capture controls for input pins */
> @@ -17274,30 +17333,35 @@ static int alc662_auto_create_extra_out(struct alc_spec *spec, hda_nid_t pin,
>
> static void alc662_auto_set_output_and_unmute(struct hda_codec *codec,
> 					      hda_nid_t nid, int pin_type,
> -					      int dac_idx)
> +					      hda_nid_t dac)
> {
> +	int i, num;
> +	hda_nid_t srcs[4];
> +
> 	alc_set_pin_output(codec, nid, pin_type);
> 	/* need the manual connection? */
> -	if (alc880_is_multi_pin(nid)) {
> -		struct alc_spec *spec = codec->spec;
> -		int idx = alc880_multi_pin_idx(nid);
> -		snd_hda_codec_write(codec, alc880_idx_to_selector(idx), 0,
> -				    AC_VERB_SET_CONNECT_SEL,
> -				    alc880_dac_to_idx(spec->multiout.dac_nids[dac_idx]));
> +	num = snd_hda_get_connections(codec, nid, srcs, ARRAY_SIZE(srcs));
> +	if (num <= 1)
> +		return;
> +	for (i = 0; i < num; i++) {
> +		if (alc662_mix_to_dac(srcs[i]) != dac)
> +			continue;
> +		snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CONNECT_SEL, i);
> +		return;
> 	}
> }
>
> static void alc662_auto_init_multi_out(struct hda_codec *codec)
> {
> 	struct alc_spec *spec = codec->spec;
> +	int pin_type = get_pin_type(spec->autocfg.line_out_type);
> 	int i;
>
> 	for (i = 0; i <= HDA_SIDE; i++) {
> 		hda_nid_t nid = spec->autocfg.line_out_pins[i];
> -		int pin_type = get_pin_type(spec->autocfg.line_out_type);
> 		if (nid)
> 			alc662_auto_set_output_and_unmute(codec, nid, pin_type,
> -							  i);
> +					spec->multiout.dac_nids[i]);
> 	}
> }
>
> @@ -17307,12 +17371,13 @@ static void alc662_auto_init_hp_out(struct hda_codec *codec)
> 	hda_nid_t pin;
>
> 	pin = spec->autocfg.hp_pins[0];
> -	if (pin) /* connect to front */
> -		/* use dac 0 */
> -		alc662_auto_set_output_and_unmute(codec, pin, PIN_HP, 0);
> +	if (pin)
> +		alc662_auto_set_output_and_unmute(codec, pin, PIN_HP,
> +						  spec->multiout.hp_nid);
> 	pin = spec->autocfg.speaker_pins[0];
> 	if (pin)
> -		alc662_auto_set_output_and_unmute(codec, pin, PIN_OUT, 0);
> +		alc662_auto_set_output_and_unmute(codec, pin, PIN_OUT,
> +					spec->multiout.extra_out_nid[0]);
> }
>
> #define ALC662_PIN_CD_NID		ALC880_PIN_CD_NID
> @@ -17350,21 +17415,25 @@ static int alc662_parse_auto_config(struct hda_codec *codec)
> 	if (!spec->autocfg.line_outs)
> 		return 0; /* can't find valid BIOS pin config */
>
> -	err = alc880_auto_fill_dac_nids(spec, &spec->autocfg);
> +	err = alc662_auto_fill_dac_nids(codec, &spec->autocfg);
> 	if (err < 0)
> 		return err;
> -	err = alc662_auto_create_multi_out_ctls(spec, &spec->autocfg);
> +	err = alc662_auto_create_multi_out_ctls(codec, &spec->autocfg);
> 	if (err < 0)
> 		return err;
> -	err = alc662_auto_create_extra_out(spec,
> +	err = alc662_auto_create_extra_out(codec,
> 					   spec->autocfg.speaker_pins[0],
> 					   "Speaker");
> 	if (err < 0)
> 		return err;
> -	err = alc662_auto_create_extra_out(spec, spec->autocfg.hp_pins[0],
> +	if (err)
> +		spec->multiout.extra_out_nid[0] = err;
> +	err = alc662_auto_create_extra_out(codec, spec->autocfg.hp_pins[0],
> 					   "Headphone");
> 	if (err < 0)
> 		return err;
> +	if (err)
> +		spec->multiout.hp_nid = err;
> 	err = alc662_auto_create_input_ctls(codec, &spec->autocfg);
> 	if (err < 0)
> 		return err;
>
