Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbZDBPdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbZDBPdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbZDBPcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:32:42 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44597 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760790AbZDBPck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:32:40 -0400
X-Sasl-enc: c4Y8YiiZLgkORe8TUryMxw1MjtH6az5+cG1S/QGaFM7i 1238686358
Message-ID: <49D4DA86.5020307@imap.cc>
Date: Thu, 02 Apr 2009 17:32:22 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@tglx.de>,
       linux-usb@vger.kernel.org
Subject: Re: Help: tasklet blocked for >8msec - USB mouse related
References: <49CCFEBA.6060009@imap.cc>  <49D24A32.9070103@imap.cc> <1238665439.8530.5740.camel@twins>
In-Reply-To: <1238665439.8530.5740.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3CDB2C308BF5B19DBBEDC9AF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3CDB2C308BF5B19DBBEDC9AF
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

[CCing linux-usb as I had started another thread there already]

On Thu, 02 Apr 2009 11:43:59 +0200, Peter Zijlstra wrote:
> On Tue, 2009-03-31 at 18:52 +0200, Tilman Schmidt wrote:

>>> A user of the Gigaset base driver (drivers/isdn/gigaset/bas-gigaset.c=
)
>>> reports his connection being dropped exactly every 30 seconds.
>>> Analysis of his dmesg indicates that when the error occurs, both the
>>> tasklets read_iso_tasklet and write_iso_tasklet handling the B channe=
l
>>> data stream (125 USB isochronous packets per second in each direction=
)
>>> are at the same time not executed for an entire inter-packet interval=
,
>>> ie. 8 msecs.
>> The user did a bit of ellimination work, and it turned out that if
>> he disconnected his Logitech Laser Mouse from its USB port and
>> connected it to the PS2 port instead, the regular blockages ceased.
>=20
> Looks like the USB driver holds off interrupts for a long-long time.

Well, not quite. The sequence of events is this:
- two isochronous read URBs are queued
- completion handler is called for the first one
- schedules tasklet for bottom half processing of received data
- submits another URB so that there are again two URBs queued
- 8 ms later, completion handler is called again for the next URB
- notices previous URB hasn't been processed (ie. tasklet hasn't run)
- bitches
And the same, mutatis mutandis, for the sending direction.

So interrupts seem to be delivered fine, it's just the tasklets that are
held off.

> Another possible source might be SMIs -- and there's nothing much you
> can do about those except bitch to Gigabyte.
>=20
> But really, relying on <10ms execution latency on mainline is almost
> asking for it -- in general we do better, but there are a few sore
> spots.

Interestingly, I never encountered that sort of problem while developing
the driver, on a lowly 700 MHz P3 with kernels around 2.6.11, and the onl=
y
problem report I ever received in that area until now was from a user who=

ran an IDE disk in PIO mode, and whose problems vanished once he switched=

that to DMA mode.

So what do you propose? Queue more URBs, so that I can tolerate waiting
longer for bottom half processing to kick in? How much time will I have
to be able to tolerate?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig3CDB2C308BF5B19DBBEDC9AF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFJ1NqTQ3+did9BuFsRAvBhAJ0RePSh38NsPkgIp8Au/wdeMYb2PACfW3EP
jMDcCa455XkOgG64wI//TA8=
=3ITJ
-----END PGP SIGNATURE-----

--------------enig3CDB2C308BF5B19DBBEDC9AF--
