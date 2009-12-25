Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZLYR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZLYR6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 12:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbZLYR6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 12:58:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:55046 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbZLYR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 12:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=Ib+DhAgbL8XbZ6R0WJ2d1a1YfD61aYFuVbYKKq4A0HBoMpfhmFCZxyYuiUyOHRwVvP
         /LdPlQX/s4QlouDNdSckvJmy/f+GZgzOhyd7z2NcyzDNZrFXMZceRjmiV11SszmpSuZo
         4VTGEFv/oezHQyEB+R3EIut+JIkfp62EDuZ1k=
Date: Fri, 25 Dec 2009 20:00:00 +0200
From: Sergei Trofimovich <slyich@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?B?w4lyaWM=?= Piel <eric.piel@tremplin-utc.net>
Subject: Re: intel hda regression: 2.6.33-rc{1,2}: hd-audio0 eats 25% CPU 
 (according to top)
Message-ID: <20091225200000.5730fb45@mosly>
In-Reply-To: <s5hvdfvyoef.wl%tiwai@suse.de>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
	<20091225122107.357d7102@mosly>
	<s5h637vmhcu.wl%tiwai@suse.de>
	<20091225162528.5dbbbea0@mosly>
	<8db1092f0912250731u46637a55lccb77e6cdb376a57@mail.gmail.com>
	<s5hy6kr6nur.wl%tiwai@suse.de>
	<20091225183205.744be270@mosly>
	<s5hvdfvyoef.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8.=Z6BQ5bo/Kz/I.c9G.KO9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8.=Z6BQ5bo/Kz/I.c9G.KO9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Dec 2009 18:06:00 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Fri, 25 Dec 2009 18:32:05 +0200,
> Sergei Trofimovich wrote:
> >=20
> > On Fri, 25 Dec 2009 17:05:16 +0100
> > Takashi Iwai <tiwai@suse.de> wrote:
> >=20
> > > It's a bit surprising that this resulted in the high CPU usage
> > > instead of erroneous behavior.  This should be rather a bug of
> > > codec chip...
> > >=20
> > > Anyway, Segei, which codec is on your machine?  Is it Analog Device
> > > one?=20
> > > IIRC, the one's on Maciej and Eric machines are AD codecs.
> > > If so, we can just revert the changes to patch_analog.c in that
> > > commit.
> >=20
> > How can I check? alsamixer shows=20
> >     Chip: Analog Devices AD1981
> > Not sure it's valid though.
> >=20
> > It's a HP Compaq 2510p laptop.
> >=20
> > 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio C=
ontroller (rev 03)
> >         Subsystem: Hewlett-Packard Company Device 30c9
> > (posted whole lspci output slightly earlier if needed)
>=20
> OK, they all seem to have AD codecs indeed.
> Instead of reverting, how about the patch below?

Fixed both CPU load and crackling sounds for me!
Thank You!

> ---
> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 950ee5c..f98b47c 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -1327,11 +1327,13 @@ EXPORT_SYMBOL_HDA(snd_hda_query_pin_caps);
>   */
>  u32 snd_hda_pin_sense(struct hda_codec *codec, hda_nid_t nid)
>  {
> -	u32 pincap =3D snd_hda_query_pin_caps(codec, nid);
> -
> -	if (pincap & AC_PINCAP_TRIG_REQ) /* need trigger? */
> -		snd_hda_codec_read(codec, nid, 0, AC_VERB_SET_PIN_SENSE, 0);
> +	u32 pincap;
> =20
> +	if (!codec->no_trigger_sense) {
> +		pincap =3D snd_hda_query_pin_caps(codec, nid);
> +		if (pincap & AC_PINCAP_TRIG_REQ) /* need trigger? */
> +			snd_hda_codec_read(codec, nid, 0, AC_VERB_SET_PIN_SENSE, 0);
> +	}
>  	return snd_hda_codec_read(codec, nid, 0,
>  				  AC_VERB_GET_PIN_SENSE, 0);
>  }
> diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
> index 1d541b7..0a770a2 100644
> --- a/sound/pci/hda/hda_codec.h
> +++ b/sound/pci/hda/hda_codec.h
> @@ -817,6 +817,7 @@ struct hda_codec {
>  	unsigned int pin_amp_workaround:1; /* pin out-amp takes index
>  					    * (e.g. Conexant codecs)
>  					    */
> +	unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
>  #ifdef CONFIG_SND_HDA_POWER_SAVE
>  	unsigned int power_on :1;	/* current (global) power-state */
>  	unsigned int power_transition :1; /* power-state in transition */
> diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
> index 1a36137..69a941c 100644
> --- a/sound/pci/hda/patch_analog.c
> +++ b/sound/pci/hda/patch_analog.c
> @@ -1186,6 +1186,8 @@ static int patch_ad1986a(struct hda_codec *codec)
>  	 */
>  	spec->multiout.no_share_stream =3D 1;
> =20
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20
> @@ -1371,6 +1373,8 @@ static int patch_ad1983(struct hda_codec *codec)
> =20
>  	codec->patch_ops =3D ad198x_patch_ops;
> =20
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20
> @@ -1813,6 +1817,9 @@ static int patch_ad1981(struct hda_codec *codec)
>  		codec->patch_ops.unsol_event =3D ad1981_hp_unsol_event;
>  		break;
>  	}
> +
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20
> @@ -3118,6 +3125,8 @@ static int patch_ad1988(struct hda_codec *codec)
>  #endif
>  	spec->vmaster_nid =3D 0x04;
> =20
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20
> @@ -3330,6 +3339,8 @@ static int patch_ad1884(struct hda_codec *codec)
> =20
>  	codec->patch_ops =3D ad198x_patch_ops;
> =20
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20
> @@ -4287,6 +4298,8 @@ static int patch_ad1884a(struct hda_codec *codec)
>  		break;
>  	}
> =20
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20
> @@ -4623,6 +4636,9 @@ static int patch_ad1882(struct hda_codec *codec)
>  		spec->mixers[2] =3D ad1882_6stack_mixers;
>  		break;
>  	}
> +
> +	codec->no_trigger_sense =3D 1;
> +
>  	return 0;
>  }
> =20


--=20

  Sergei

--Sig_/8.=Z6BQ5bo/Kz/I.c9G.KO9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAks0/aMACgkQcaHudmEf86oqXACeP6awtbrZIhhJqttp1uscCfEC
e54AmgKH7jEqKahjjCBZXmkX7sPm1dJI
=ImOI
-----END PGP SIGNATURE-----

--Sig_/8.=Z6BQ5bo/Kz/I.c9G.KO9--
