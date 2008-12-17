Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753011AbYLQWlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYLQWlu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLQWlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:41:39 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:43466 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYLQWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:41:38 -0500
X-Greylist: delayed 2024 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2008 17:41:38 EST
Date: Wed, 17 Dec 2008 20:08:30 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wait for all codecs to be ready if doing a cold reset
Message-ID: <20081217220829.GF3672@vespa.holoscopio.com>
References: <s5hfxqlvec2.wl%tiwai@suse.de> <20080707173654.GA28388@vespa.holoscopio.com> <s5h1w24vfy4.wl%tiwai@suse.de> <20080708165931.GA2882@vespa.holoscopio.com> <s5hskujayfu.wl%tiwai@suse.de> <20080708173121.GA2860@vespa.holoscopio.com> <s5h63rezzlb.wl%tiwai@suse.de> <20080709172637.GA5355@vespa.holoscopio.com> <s5h8ww2r9qg.wl%tiwai@suse.de> <20080715001039.GA13399@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47eKBCiAZYFK5l32"
Content-Disposition: inline
In-Reply-To: <20080715001039.GA13399@vespa.holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2008 at 09:10:39PM -0300, Thadeu Lima de Souza Cascardo wro=
te:
> On Wed, Jul 16, 2008 at 01:47:03AM +0200, Takashi Iwai wrote:
> > Thanks.
> >=20
> > Meanwhile, I reconsidered about this problem.  I think the check of
> > the whole "active" codec slots can be done better in a way like the
> > following.  Could you give it a try?
> >=20
> > If this still doesn't work, I suspect it's really the matter of
> > additional delay.
> >=20

I've put some more effort on this issue last weekend. Here is the
result:

The codec I have is AD1881A. The additional delay makes a pretty
difference, right. Only the delay is enough to solve it.

However, I agree this is not the right solution. The codec_init_bits
solution does not work.

I have diff'ed the value of the codec registers and they are different
=66rom all the other situations I tested, that are:

* booted my notebook: OK
* suspended, resumed, reloaded the driver: OK
* loaded the driver with no cold reset
  (no AC97_POWER_SAVE on intel8x0): OK
* same as above, after resuming: OK
* AC97_POWER_SAVE enabled (cold reset), after resume: NOT ok

As previously reported, even when probing, after loading the driver, we
get a different behaviour if we cold reset. When probing, we wait for
those HZ/4, which may explain why everything works.

I tested if ac97_resume was writing the same values to the same
registers if I had the delay or if I didn't. It was. However, the values
I read from /proc were still different, very similar to what the codec
specification refered to as the default values.

The best solution would be to do whatever is needed to do after cold
resetting that we are not doing, unless it is a hardware issue and the
driver can't really do anything about it but wait. Reading the Intel
ICH3 doc and AD1881A doc, I couldn't figure out anything that the driver
is doing wrong.

So, right now, the alternatives amount to:

* Wait for the HZ/4 additional delay. Probing is doing it and my
previously submitted patch does not add any delay for the probe case
and, it the resume case, it only adds a delay if we are cold resetting,
that is, AC97_POWER_SAVE is enabled.

* Do not do the cold reset at all. It works pretty well for me if ac97
power save is enabled and we only do a warm reset.

* Do only one of the above as a quirk for my controller or codec or
their combination.


Any help trying to figure out what's really happening, I'd appreciate.
If any more details of my tests are needed, I can collect and publish
them.

Regards,
Thadeu Cascardo.

--47eKBCiAZYFK5l32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklJeF0ACgkQyTpryRcqtS3k2QCfUTP/QxKIaKcet4Z9WKOhIMiJ
um8An0Aq+SDD4hnX8iJSRn0mAuDiZylf
=tw5z
-----END PGP SIGNATURE-----

--47eKBCiAZYFK5l32--
