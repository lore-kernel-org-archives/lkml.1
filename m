Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZD1XKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZD1XKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZD1XKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:10:39 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50019 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbZD1XKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:10:39 -0400
Date: Wed, 29 Apr 2009 01:10:28 +0200
From: Florian Mickler <florian@mickler.org>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
Message-ID: <20090429011028.22c69b40@schatten>
In-Reply-To: <alpine.DEB.1.10.0904281447240.17268@asgard.lang.hm>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	<20090427083935.GA20941@elte.hu>
	<21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
	<49F65FA2.4010603@kernel.org>
	<alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
	<alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm>
	<alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>
	<alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm>
	<alpine.LFD.2.00.0904281043420.22156@localhost.localdomain>
	<20090428234300.4a49d22f@schatten>
	<alpine.DEB.1.10.0904281447240.17268@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sA9C8TmEzSVctIS=8rjVHAE";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sA9C8TmEzSVctIS=8rjVHAE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Apr 2009 14:50:08 -0700 (PDT)
david@lang.hm wrote:

> On Tue, 28 Apr 2009, Florian Mickler wrote:
>=20
> > perhaps there needs to be an infrastructure where each
> > kconfig-entry-causer can also provide userlevel code to help with
> > that entry?
> >
> > i could imagine a kconfig knob to specify an optional
> > per-kconfig-userspace-helperscript which calculates a new "suggested
> > value" at configure time.
> > this "suggested value" is displayed next to the default value
> > or is then already incorporated in the default value.
>=20
> what is the difference between the default value and this suggested
> value?

well... for example:

----snip----
config MY_NEW_DRIVER
bool "mynewDriver"
default n
helper obey
help
  this is my new shiny driver which speeds up the system by factor of
  ten if the hardware is available. it the hardware is not available
  this reduces performance by the factor of 5.=20
  if unshure say 42.=20
 ----snap----

and the helper line causes the Kconfig script to execute
"some_path/userspacehelper.sh MY_NEW_DRIVER"

with "obey", the return value would override the default value

with "definitive_no", it would overide the default value with "no" if
the script returned "no",=20

with "definitive_yes", it would override the default value with "yes"
if the script returned "yes"

there could also be an msg displayed:=20
"userspace config helper says: the machine seems to have the hardware
but it has to be enabled in the bios!"=20

maybe. maybe not.

perhaps the "obey" "definitive_yes" "definitive_no" has to come from
the helperscript too... dunno....


>
> > each maintainer of each kconfig entry
> > a) decides if it is possible to supply such a script
> > b) if it would be useful
> > c) suplies and maintains his (focused on only one kconfig entry)
> > script
>=20
> please no!!! we don't want to have to run 2000 different scripts to
> get the settings.
>=20
> one script.
>=20
> David Lang

hmm... alright, but that's not my main point here. the point is to
have some infrastructure in the kconfig script for
configure-time-hardware-detection.

the rest is more an question of how to organize the work. however a
modularized approach has more appeal in my eyes. but this was only
me thinking out loud...

there could be one script which facilitates the results of steve's
allmod-cut-down script.=20

i could also imagine having only one helperscript which knows it all. =20
or there could be one which knows which script to call for what
config-symbol.=20

there could be the default-one, bundled with the kernel and
third-party-scripts which may or may not fall back to the default one,
but can override it.=20

this would also enable some script to first generate some "hardware-id"
and query the internet for known bad and known good config-facts for
this platform and filter the in tree detection logic. (like when that
machine has support for two equivalent services, but one is to be
preferred on that platform because of a dumb biosbug or because of
some social contract one has with the tasmanian devil)

there are many options. it just needs to be done(tm)

i'm gonna try to experiment a bit with smth like this, but maybe it
turns out that the idea is not so good after all.  who knows...

>=20
> > c) if the script is 100% fool-proof he can say so in the
> > description of the kconfig-entry or just skip the user or notify
> > the user of the result.
> > d) maybe dosn't provide an userspace helper
> >
> > this spreads the burden of the complex detection-code and hopefully
> > eases configuration for everyone where possible.
> >
> > what do others think?
> >
> >
> > sincerely,
> > Florian
> >

--Sig_/sA9C8TmEzSVctIS=8rjVHAE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkn3jOkACgkQPjqCkyL3Kv2wHwCbBYcJvvuBwVBk6Kbc+tyEf2/1
6bMAniKogkSV7mvlhFyS1gQufHyhf/G+
=riBS
-----END PGP SIGNATURE-----

--Sig_/sA9C8TmEzSVctIS=8rjVHAE--
