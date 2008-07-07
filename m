Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYGGRhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYGGRhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYGGRhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:37:04 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:48566 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYGGRhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:37:03 -0400
Date: Mon, 7 Jul 2008 14:36:55 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wait for all codecs to be ready if doing a cold reset
Message-ID: <20080707173654.GA28388@vespa.holoscopio.com>
References: <20080706171548.GA9962@vespa.holoscopio.com> <s5hfxqlvec2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <s5hfxqlvec2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2008 at 06:39:09PM +0200, Takashi Iwai wrote:
> At Sun, 6 Jul 2008 14:15:56 -0300,
> Thadeu Lima de Souza Cascardo wrote:
> >=20
> > If AC97_POWER_SAVE is enabled, intel8x0 does a cold reset when
> > initializing the codecs. While resuming, it does not wait for all codecs
> > to be active. Sound card does not work after a resume without it,
> > however. This patch fixes it.
>=20
> Thanks for the patch.
>=20
> But, I still don't figure out why this is needed.
> In the else block (with the comment "resume phase"), you can find the
> loop to wait for the all *probed* codecs.  The difference with the
> code you moved is that it checks only the bits corresponding to the
> already probed codecs.  In other words, the other bits should be
> irrelevant with the hardware.
>=20
> I guess it's not about the loop but the additional 1/4 sec delay that
> did fix the resume on your device.  Please check how is the status
> bits and whether it passed the loop in the middle.
>=20
>=20
> Takashi
>=20
>=20

The 1/4 sec delay came in my mind as one of the possible reasons, and
that's why I've made some tests. status and nstatus are 0x200, while
codec_isr_bits is 0x300. The loop waits for the status register give us
0x300 as the active codecs, instead of the only one probed. Since the
cold reset in the case of a power saving cleans up all codec registers,
it is needed that we wait for all codecs again (like in the probe case).

If you need more information or that I ran any more tests, I'd be glad
to do it. By the way, I've tested the patch against your audio and modem
merged version and it works OK.

Best Regards,
Thadeu Cascardo.

> > ---
> >  sound/pci/intel8x0.c |   24 ++++++++++++++----------
> >  1 files changed, 14 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
> > index 048d99e..7228a0a 100644
> > --- a/sound/pci/intel8x0.c
> > +++ b/sound/pci/intel8x0.c
> > @@ -2335,16 +2335,6 @@ static int snd_intel8x0_ich_chip_init(struct int=
el8x0 *chip, int probing)
> >  				   igetdword(chip, ICHREG(GLOB_STA)));
> >  			return -EIO;
> >  		}
> > -
> > -		/* wait for other codecs ready status. */
> > -		end_time =3D jiffies + HZ / 4;
> > -		while (status !=3D chip->codec_isr_bits &&
> > -		       time_after_eq(end_time, jiffies)) {
> > -			schedule_timeout_uninterruptible(1);
> > -			status |=3D igetdword(chip, ICHREG(GLOB_STA)) &
> > -				chip->codec_isr_bits;
> > -		}
> > -
> >  	} else {
> >  		/* resume phase */
> >  		int i;
> > @@ -2363,6 +2353,20 @@ static int snd_intel8x0_ich_chip_init(struct int=
el8x0 *chip, int probing)
> >  		} while (time_after_eq(end_time, jiffies));
> >  	}
> > =20
> > +#ifndef CONFIG_SND_AC97_POWER_SAVE
> > +	if (probing)
> > +#endif
> > +	{
> > +		/* wait for other codecs ready status. */
> > +		end_time =3D jiffies + HZ / 4;
> > +		while (status !=3D chip->codec_isr_bits &&
> > +		       time_after_eq(end_time, jiffies)) {
> > +			schedule_timeout_uninterruptible(1);
> > +			status |=3D igetdword(chip, ICHREG(GLOB_STA)) &
> > +				chip->codec_isr_bits;
> > +		}
> > +	}
> > +
> >  	if (chip->device_type =3D=3D DEVICE_SIS) {
> >  		/* unmute the output on SIS7012 */
> >  		iputword(chip, 0x4c, igetword(chip, 0x4c) | 1);
> > --=20
> > 1.5.6
> >=20

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhyVDYACgkQyTpryRcqtS0XNQCaAzw6LwiMPAu58mXrB0wRnOcp
Ew4AnjVhkLEPr/H5Lp7mCEY9W1eH8gJt
=DYn/
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
