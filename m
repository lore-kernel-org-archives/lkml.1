Return-Path: <linux-kernel-owner+w=401wt.eu-S1762417AbXJRPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417AbXJRPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbXJRPZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:25:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:32342 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXJRPZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YZWtFuFcfqSrL+PXhQ0D1mkxmZk41MwriP9pAhkfD23lCYL+kAlXZda48HX/SQFiZi7QCAEeis4nW+vxR/aMv7W054m68HyQcfK/jIO3+3daARzQinSqsFJQX7si+81X2lVCU9nlBjX2Z9sZSzIHBZciqOcSPOYJCs4R8jMB11M=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 17:24:46 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <471538C2.80806@m3y3r.de> <200710181621.59795.maximlevitsky@gmail.com> <s5h4pgo1qjh.wl%tiwai@suse.de>
In-Reply-To: <s5h4pgo1qjh.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181724.47256.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 15:49:22 Takashi Iwai wrote:
> At Thu, 18 Oct 2007 16:21:59 +0200,
> Maxim Levitsky wrote:
> > 
> > On Thursday 18 October 2007 07:57:27 Takashi Iwai wrote:
> > > At Thu, 18 Oct 2007 03:53:08 +0200,
> > > Maxim Levitsky wrote:
> > > > 
> > > > From 0824b077b75c19253b45c5a455775c331acd54ee Mon Sep 17 00:00:00 2001
> > > > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > > > Date: Thu, 18 Oct 2007 03:35:37 +0200
> > > > Subject: [PATCH] [HDA] [STAC] Since there is now a master volume control,
> > > > don't call the headphone output "Master", it isn't strictly correct anyway
> > > 
> > > I thought stac925x has no volume knob, so "Master" should be still
> > > applied for this codec?
> > 
> > Yes, you are right, but stac925x has only one DAC, and thus if it is
> > connected to any line-out, it will be 
> > 'Front', but if it is connected to 'headphones' only, then why not
> > to call it 'Headphone' 
> 
> The point is that apps usually require a "Master" volume.  If it's the
> single volume control, it's better to call it master for convenience.
And most STACs didn't have one till I added this volumeknob...


> 
> 
> > STAC  9200 has no volumeknob too, but it is handled seperartly
> 
> Yes, 9200 doesn't call stac92xx_auto_create_hp_ctls(), so it's not
> affected.
> 
> > STAC  9202 and 9250 has no volumeknob too, but as I said they have
> > just one DAC again 
> 
> Both are handled as patch_stac925x.  That's what I meant.  With your
> patch, there will be no master any more.
> 
> So, how about the patch below?
> 
> 
> Takashi
> 
> diff -r fb9512ce24e0 pci/hda/patch_sigmatel.c
> --- a/pci/hda/patch_sigmatel.c	Thu Oct 18 10:48:43 2007 +0200
> +++ b/pci/hda/patch_sigmatel.c	Thu Oct 18 16:36:35 2007 +0200
> @@ -111,6 +111,7 @@ struct sigmatel_spec {
>  	unsigned int alt_switch: 1;
>  	unsigned int hp_detect: 1;
>  	unsigned int gpio_mute: 1;
> +	unsigned int no_vol_knob :1;
>  
>  	unsigned int gpio_mask, gpio_data;
>  
> @@ -1930,7 +1931,8 @@ static int stac92xx_auto_create_hp_ctls(
>  	}
>  	if (spec->multiout.hp_nid) {
>  		const char *pfx;
> -		if (old_num_dacs == spec->multiout.num_dacs)
> +		if (old_num_dacs == spec->multiout.num_dacs &&
> +		    spec->no_vol_knob)
>  			pfx = "Master";
>  		else
>  			pfx = "Headphone";
> @@ -2487,6 +2489,7 @@ static int patch_stac9200(struct hda_cod
>  	codec->spec = spec;
>  	spec->num_pins = ARRAY_SIZE(stac9200_pin_nids);
>  	spec->pin_nids = stac9200_pin_nids;
> +	spec->no_vol_knob = 1;
>  	spec->board_config = snd_hda_check_board_config(codec, STAC_9200_MODELS,
>  							stac9200_models,
>  							stac9200_cfg_tbl);
> @@ -2541,6 +2544,7 @@ static int patch_stac925x(struct hda_cod
>  	codec->spec = spec;
>  	spec->num_pins = ARRAY_SIZE(stac925x_pin_nids);
>  	spec->pin_nids = stac925x_pin_nids;
> +	spec->no_vol_knob = 1;
>  	spec->board_config = snd_hda_check_board_config(codec, STAC_925x_MODELS,
>  							stac925x_models,


Perfect.
This will ensure the same behavior, as was without the volumeknob.

Best regards,
	Maxim Levitsky	

