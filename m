Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYIEOu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYIEOu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYIEOuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:50:16 -0400
Received: from server.drzeus.cx ([85.8.24.28]:54335 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753357AbYIEOuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:50:15 -0400
Date: Fri, 5 Sep 2008 16:50:05 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Christer Weinigel <christer@weinigel.se>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: Proposed SDIO layer rework
Message-ID: <20080905165005.2a4ac355@mjolnir.drzeus.cx>
In-Reply-To: <48C11BF3.2060609@weinigel.se>
References: <48C11BF3.2060609@weinigel.se>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-19144-1220626214-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-19144-1220626214-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Sep 2008 13:45:55 +0200
Christer Weinigel <christer@weinigel.se> wrote:

> First some measurements.  I've connected the SDIO bus to an Agilent=20
> scope to get some pretty plots.

Why doesn't santa bring me any of the nice toys everyone else seems to
be getting :(

> Since more and more high speed chips are being connected to embedded=20
> devices using SDIO, I belive that to get good SDIO performance, the SDIO=
=20
> layer has to be changed not to use a worker thread.  This is=20
> unfortunately rather painful since it means that we have to add=20
> asynchronous variants of all the I/O operations, and the sdio_irq thread=
=20
> has to be totally redone, and the sdio IRQ enabling and disablin turned=20
> out to be a bit tricky.
>=20
> So, do you think that it is worth it to make such a major change to the=20
> SDIO subsystem?  I belive so, but I guess I'm a bit biased.  I can clean=
=20
> up the work I've done and make sure that everything is backwards=20
> compatible so that existing SDIO function drivers keep working (my=20
> current hack to the sdio_irq thread breaks existing drivers, and it is=20
> too ugly to live anyway so I don't even want to show it to you yet), and=
=20
> add a demo driver which shows how to use the asynchronous functions.

The latency improvement is indeed impressive, but I am not convinced it
is worth it. An asynchronous API is much more complex and difficult to
work with (not to mention reading and trying to make sense of existing
code), and SDIO is not even an asynchronous bus to begin with.

Also, as the latency is caused by CPU cycles, the problem will be
reduced as hardware improved.

But...

> But if you don't like this idea at all, I'll probably just keep it as a=20
> patch and not bother as much with backwards compatibility.  This is a=20
> lot more work for me though, and I'd much prefer to get it into the=20
> official kernel.

I do like the idea of reducing latencies (and generally improving the
performance of the MMC stack). The primary reason I haven't done
anything myself is lack of stuff to test and proper instrumentation.

There are really two issues here, which aren't necessarily related;
actual interrupt latency and command completion latency.

The main culprit in your case is the command completion one. Perhaps
there is some other way of solving that inside the MMC core? E.g. we
could spin instead of sleeping while we wait for the request to
complete. Most drivers never use process context to handle a request
anyway. We would need to determine when the request is small enough
(all non-busy, non-data commands?) and that the CPU is slow enough. I
also saw something about a new trigger interface that could make this
efficient.

Does this sound like something worth exploring?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-19144-1220626214-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjBRyAACgkQ7b8eESbyJLiKdACglUcNqDYgKkrzhCY1iRhMGtVB
oo8AoKDv6HQ1ZIVdv6yWuTAtbO0FxXdz
=VBAl
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-19144-1220626214-0001-2--
