Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbXBZIyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbXBZIyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 03:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXBZIyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 03:54:41 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:65248 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbXBZIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 03:54:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hPSAof8LZz/WHf8XNAsJy9SIob2gJhoalHuv/LIuyFDCJdCZgD7DP9fGgG45/XQxjXyoqDPvqrrvvxm+M4TazhAR302d4x1d25Fyvs0LRzt8IjU4K6WGgzl1mmeebkrijvf/HiQq8KK9mbRKSUP9xeDsDTuUHcJyp3Hx5kz4ULY=
Date: Mon, 26 Feb 2007 00:54:31 -0800
From: Sarah Bailey <saharabeara@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>,
       usb-hacking@svcs.cs.pdx.edu,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usbfs2: Why asynchronous I/O?
Message-ID: <20070226085431.GA16499@localdomain>
Mail-Followup-To: Sarah Bailey <saharabeara@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	usb-hacking@svcs.cs.pdx.edu,
	USB development list <linux-usb-devel@lists.sourceforge.net>
References: <20070225085755.GA4886@localdomain> <200702250853.03851.david-b@pacbell.net> <20070225173302.GA12190@comsec.com> <20070225085755.GA4886@localdomain> <200702250853.03851.david-b@pacbell.net> <Pine.LNX.4.44L0.0702251147500.25265-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20070225173302.GA12190@comsec.com> <200702250853.03851.david-b@pacbell.net> <Pine.LNX.4.44L0.0702251147500.25265-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 25, 2007 at 08:53:03AM -0800, David Brownell wrote:
> On Sunday 25 February 2007 12:57 am, Sarah Bailey wrote:
> > I haven't seen any evidence that the kernel-side aio is substantially
> > more efficient than the GNU libc implementation,
>=20
> Face it:  spawning a new thread is fundamentally not as lightweight
> as just submitting an aiocb plus an URB.  And spawning ten threads
> costs a *LOT* more than submitting ten aiocbs and URBs.  (Count just
> the 4KB stacks associated with each thread, vs memory consumed by
> using AIO ... and remember to count the scheduling overheads.)

Yes, spawning a new thread is costly.  However, if someone writes their
own thread-based program and allocates the threads from a pool, that
argument is irrelevant.  Even with fibrils, you have a stack and
scheduling overhead.  With kernel AIO, you have also have some memory
overhead, and you also have context switch overhead when you call
kick_iocb or aio_complete.

Can someone point me at hard evidence one way or another?

> > so it seems like it would be better to leave the complexity in
> > userspace.=20
>=20
> Thing is, the kernel *already* has URBs.  And the concept behind them
> maps one-to-one onto AIOCBs.  All the kernel needs to expose is:
> mechanisms to submit (and probably cancel) async requests, then collect
> the responses when they're done.

It seems to me that you're arguing that URBs and AIOCBs go together on
the basis that they are both asynchronous and both have some sort of
completion function.  Just because two things are alike doesn't mean
that it's better to use them together.

> You're right that associating a thread with an URB is complexity.

That's not what I said.  I don't think that the libc implementation is
more complex than the kernel AIO implementation.  The libc code is
smaller than the kernel AIO (the core code in aio_misc.c is 721 lines,
while the kernel AIO core code is 1769 lines).  The libc code is simpler
and easier to understand, and therefore may be less error prone.

> > I also doubt that=20
> > most userspace application writers know they aren't getting kernel-side
> > aio when they use aio_read(3) and aio_write(3).  Why implement something
> > that isn't going to be used?
>=20
> I can't much help application writers that don't bother to read the
> relevant documentation (after it's been pointed out to them).

Where is this documentation?  There's a man page on io_submit, etc., but
how would an application writer know to look for it?  I've grepped
through the Documentation directory, and I didn't find anything that
looked relevant.=20

> The gap between POSIX AIO and kernel AIO has been an ongoing problem.  Th=
is
> syslet/fibril/yadda-yadda stuff is just the latest spin.

Do you think that fibrils will replace the kernel AIO?  It seems like a
logicial conclusion, but does the kernel AIO give you anything more?
For example, I think it currently allows drivers to guarantee that the
requests will be queued in the order they are submitted.  GNU libc and
fibrils can't make that guarantee because the operations may block
before the request enters the hardware queue. =20

On Sun, Feb 25, 2007 at 09:33:02AM -0800, Eric Blossom wrote:
> On Sun, Feb 25, 2007 at 08:53:03AM -0800, David Brownell wrote:
> > Without it, how would you achieve I/O overlap, and thus maximize the
> > I/O throughput accessible when streaming data to/from userspace?  The
> > description you gave of glibc aio support sure sounded to me like it
> > was incapable of achieving much in the way of I/O overlap.
>=20
> I heartily agree with this sentiment.  The only way we've been able to
> sustain 32MB/s read and write bulk transfers across the USB from user
> space is by using the usbfs USBDEVFS_SUBMITURB ioctl.  We typically
> run with 8 to 16 outstanding requests, each around 4kB.

GNU libc can overlap I/O.  It implements the userland equivalent of
fibrils.  No one is arguing that we don't need I/O overlap. :)

> FWIW, the peripheral we're using is the Universal Software Radio
> Peripheral (USRP).  It's basically an FX2, FPGA, ADC's and DAC's.
>
> The code we use for this is in the GNU Radio code base,
> http://gnuradio.org/trac/wiki
>=20
> The relevant part is usrp/host/lib/fusb*.{h,cc}

Yes, a sane interface to the USRP was one of the main motivations for
the new USB filesystem.  It remains to be seen whether we need a
non-standard interface like io_submit, or whether threads with blocking
I/O is fast enough and has the right semantics.

Sarah Bailey

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF4qBHRqNbFWK10kwRAnvsAJwK0Sg68+FuARV0gonsgRanjhwxcQCgi3LF
/7HmvydQMrUIFBkUBu46UBs=
=ZIZd
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
