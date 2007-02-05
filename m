Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbXBEBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbXBEBlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 20:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXBEBlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 20:41:35 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37599 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbXBEBle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 20:41:34 -0500
X-Sasl-enc: 33THcgL9LW8f4M9S6IHl4y09Eds40CKUVaZO2id/z91I 1170639691
Message-ID: <45C68B71.6050904@imap.cc>
Date: Mon, 05 Feb 2007 02:42:09 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de, linux-serial@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drivers/isdn/gigaset: new M101 driver
References: <200702012112.l11LCOO4016557@lx1.pxnet.com>	<20070201171345.bd98ce30.akpm@osdl.org>	<45C537B9.7080704@imap.cc> <20070203175623.72a171a1.akpm@linux-foundation.org>
In-Reply-To: <20070203175623.72a171a1.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig26453FBDB0852D2EED5A4656"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig26453FBDB0852D2EED5A4656
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 04.02.2007 02:56 schrieb Andrew Morton:
> On Sun, 04 Feb 2007 02:32:41 +0100 Tilman Schmidt <tilman@imap.cc> wrot=
e:
>=20
>>>> +	spin_lock_irqsave(&cs->cmdlock, flags);
>>>> +	cb =3D cs->cmdbuf;
>>>> +	spin_unlock_irqrestore(&cs->cmdlock, flags);
>>> It is doubtful if the locking here does anything useful.
>> It assures atomicity when reading the cs->cmdbuf pointer.
>=20
> I think it's bogus.  If the quantity being copied here is more than 32-=
bits
> then yes, a lock is appropriate.  But if it's a single word then it's
> unlikely that the locking does anything useful.  Or there might be a bu=
g
> here.

It's a pointer. Are reads and writes of pointer sized objects
guaranteed to be atomic on every platform? If so, I'll happily
omit the locking.

>>>> +	spin_lock_irqsave(&cs->cmdlock, flags);
>>>> +	cb->prev =3D cs->lastcmdbuf;
>>>> +	if (cs->lastcmdbuf)
>>>> +		cs->lastcmdbuf->next =3D cb;
>>>> +	else {
>>>> +		cs->cmdbuf =3D cb;
>>>> +		cs->curlen =3D len;
>>>> +	}
>>>> +	cs->cmdbytes +=3D len;
>>>> +	cs->lastcmdbuf =3D cb;
>>>> +	spin_unlock_irqrestore(&cs->cmdlock, flags);
>>> Would the use of list_heads simplify things here?
>> I don't think so. The operations in list.h do not keep track of
>> the total byte count, and adding that in a race-free way appears
>> non-trivial.
>=20
> Maintaining a byte count isn't related to maintaining a list.

Sure. But your question was whether the list.h operations would
simplify this code. AFAICS it wouldn't, because the necessity
of maintaining the byte count would complicate a list.h based
solution beyond the current one. Also, this is part of the
interface with the components of the Gigaset driver which are
already part of the kernel. Changing this to a list_head now
would require significant changes in those other parts, too.

>>>> +	tail =3D atomic_read(&inbuf->tail);
>>>> +	head =3D atomic_read(&inbuf->head);
>>>> +	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u, receive %u bytes",
>>>> +		head, tail, count);
>>>> +
>>>> +	if (head <=3D tail) {
>>>> +		n =3D RBUFSIZE - tail;
>>>> +		if (count >=3D n) {
>>>> +			/* buffer wraparound */
>>>> +			memcpy(inbuf->data + tail, buf, n);
>>>> +			tail =3D 0;
>>>> +			buf +=3D n;
>>>> +			count -=3D n;
>>>> +		} else {
>>>> +			memcpy(inbuf->data + tail, buf, count);
>>>> +			tail +=3D count;
>>>> +			buf +=3D count;
>>>> +			count =3D 0;
>>>> +		}
>>>> +	}
>>> Perhaps the (fairly revolting) circ_buf.h can be used for this stuff.=

>> It probably could, but IMHO readability would suffer rather than impro=
ve.
>=20
> How about kernel/kfifo.c?

That would indeed fit the bill. But again, this code matches
parts of drivers/isdn/gigaset which are already in the kernel,
and changing it here would require significant corresponding
changes in those other parts.

I'll gladly consider your last two propositions (list_head for
cs->lastcmdbuf and kfifo for cs->inbuf) for a future revision of
the entire set of drivers in drivers/isdn/gigaset, but it goes
way beyond the scope of the present patch, which merely aims at
adding the missing M101 hardware driver.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig26453FBDB0852D2EED5A4656
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFxot4MdB4Whm86/kRAnvPAJ0ZlCJiwpISxsKQtImIZAPl06J5hgCcCCm3
mhGV1nwdmsFV+pZ/MwmvhRE=
=Yy78
-----END PGP SIGNATURE-----

--------------enig26453FBDB0852D2EED5A4656--
