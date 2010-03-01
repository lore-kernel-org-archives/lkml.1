Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab0CAKnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:43:16 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:41490 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0CAKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:43:15 -0500
X-Spam-ASN: 
Date: Mon, 1 Mar 2010 13:43:08 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCHv2 1/6] ntp: add hardpps implementation
Message-ID: <20100301134308.4f39061a@desktopvm.lvknet>
In-Reply-To: <20100301081458.GG3671@enneenne.com>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
	<eb18684a471acd332c1d6be46f5bd89b1c935095.1267008049.git.lasaine@lvk.cs.msu.su>
	<20100301081458.GG3671@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CAMBauc4.pLdVo6RMWuxzVj";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CAMBauc4.pLdVo6RMWuxzVj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Mar 2010 09:14:59 +0100
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Wed, Feb 24, 2010 at 03:28:12PM +0300, Alexander Gordeev wrote:
> > This commit adds hardpps() implementation based upon the original one
> > from the NTPv4 reference kernel code from David Mills. However, it is
> > highly optimized towards very fast syncronization and maximum stickness
> > to PPS signal. The typical error is less then a microsecond.
> > To make it sync faster I had to throw away exponential phase filter so
> > that the full phase offset is corrected immediately. Then I also had to
> > throw away median phase filter because it gives a bigger error itself
> > if used without exponential filter.
> > Maybe we will find an appropriate filtering scheme in the future but
> > it's not necessary if the signal quality is ok.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/Kconfig   |    1 +
> >  include/linux/timex.h |    1 +
> >  kernel/time/Kconfig   |    7 +
> >  kernel/time/ntp.c     |  420 +++++++++++++++++++++++++++++++++++++++++=
++++++--
> >  4 files changed, 414 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> > index cc2eb8e..2bd4f65 100644
> > --- a/drivers/pps/Kconfig
> > +++ b/drivers/pps/Kconfig
> > @@ -7,6 +7,7 @@ menu "PPS support"
> >  config PPS
> >  	tristate "PPS support"
> >  	depends on EXPERIMENTAL
> > +	select NTP_PPS
> >  	---help---
> >  	  PPS (Pulse Per Second) is a special pulse provided by some GPS
> >  	  antennae. Userland can use it to get a high-precision time
> > diff --git a/include/linux/timex.h b/include/linux/timex.h
> > index e6967d1..5a93cd3 100644
> > --- a/include/linux/timex.h
> > +++ b/include/linux/timex.h
> > @@ -274,6 +274,7 @@ extern u64 tick_length;
> >  extern void second_overflow(void);
> >  extern void update_ntp_one_tick(void);
> >  extern int do_adjtimex(struct timex *);
> > +extern void hardpps(const struct timespec *, const struct timespec *);
> > =20
> >  /* Don't use! Compatibility define for existing users. */
> >  #define tickadj	(500/HZ ? : 1)
> > diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> > index 95ed429..2da4900 100644
> > --- a/kernel/time/Kconfig
> > +++ b/kernel/time/Kconfig
> > @@ -27,3 +27,10 @@ config GENERIC_CLOCKEVENTS_BUILD
> >  	default y
> >  	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
> > =20
> > +config NTP_PPS
> > +	bool "PPS kernel consumer support"
> > +	depends on PPS
> > +	help
> > +	  This option adds support for direct in-kernel time
> > +	  syncronization using an external PPS signal.
> > +
>=20
> This patch is both PPS and NTP related but I suppose is better moving
> this setting into drivers/pps directory since people whose want to use
> thise supports can go into same place and find whetever they want...

OK, I don't mind moving it. In fact I don't remember why I put it
here. :)
Thanks for the note!

--=20
  Alexander

--Sig_/CAMBauc4.pLdVo6RMWuxzVj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJLi5o8AAoJEElrwznyooJberMH+wce8GwjcpjTJPXYi/7xkq5R
BotSp8DBrIwlbdFvGOveL5r5qlo/zFVqWtGH4ce0g6Wj8HLpCLyDSf9733T14qJg
b+vlmteglZ4xOiRg90TBy0m+M16xYIwOu5/b1s5yO9G8guSavuODeSY1DqPpZK3Q
JIahh+o1LMR1P4ArI9KFci47aFeJW7dBCC11/xHRhL8QXCbyWyCsL32IY+PWG9aI
KAvBro0K8rXFKmTptfMhTXm1kSwlpN9bULqieS0OlF9eLJ+CzQEnlIgRBOk5vBYq
7b6UTxFe0GRWfvsg2iYqqlNUE70ukKcdd6BNyDf+mR1zQw77vlj0J3N17X1R9Xc=
=f8bD
-----END PGP SIGNATURE-----

--Sig_/CAMBauc4.pLdVo6RMWuxzVj--
