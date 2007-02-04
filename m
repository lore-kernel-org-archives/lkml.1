Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXBDBcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXBDBcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXBDBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:32:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35702 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbXBDBcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:32:14 -0500
X-Sasl-enc: XOPLGFs4BKHwcuAKlt8c9vPSa3gjvwMZV9pW6g23RXpb 1170552732
Message-ID: <45C537B9.7080704@imap.cc>
Date: Sun, 04 Feb 2007 02:32:41 +0100
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
References: <200702012112.l11LCOO4016557@lx1.pxnet.com> <20070201171345.bd98ce30.akpm@osdl.org>
In-Reply-To: <20070201171345.bd98ce30.akpm@osdl.org>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD1BB0E0E990685E4A47B9D73"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD1BB0E0E990685E4A47B9D73
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks, Andrew, for your review. Some replies:

Am 02.02.2007 02:13 schrieb Andrew Morton:
> On Thu, 1 Feb 2007 22:12:24 +0100
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> +/* Kbuild sometimes doesn't set this */
>> +#ifndef KBUILD_MODNAME
>> +#define KBUILD_MODNAME "asy_gigaset"
>> +#endif
>=20
> That's a subtle way of reporting a kbuild bug ;)
>=20
> What's the story here?

If an object file is linked into more than one module (like
asyncdata.o which is linked into both ser_gigaset and usb_gigaset)
then Kbuild compiles it only once but cannot decide which of the
module names to put into KBUILD_MODNAME, so it takes the easy way
out and doesn't define KBUILD_MODNAME at all. I'm not sure if
that qualifies as a kbuild bug. I'd rather call it a limitation.

>> +static int write_modem(struct cardstate *cs)
>> +{
>> +	struct tty_struct *tty =3D cs->hw.ser->tty;
>> +	struct bc_state *bcs =3D &cs->bcs[0];	/* only one channel */
>> +	struct sk_buff *skb =3D bcs->tx_skb;
>> +	int sent;
>> +
>> +	if (!tty || !tty->driver || !skb)
>> +		return -EFAULT;
>=20
> Is EFAULT appropriate?

It hardly matters, as it isn't propagated anywhere. -1 would
work just as well.

> Can all these things happen?

Theoretically no, but this is called from a tasklet and I have
already traced a bug which made one of these disappear. Not
having the kernel crash completely in such an event considerably
helps debugging.

>> +	set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>=20
> Is a client of the tty interface supposed to be diddling tty flags like=
 this?

Documentation/tty.txt says so. (Yes, I wrote that part myself,
but nobody protested. ;-) Also, the PPP line discipline does
the same.

>> +	spin_lock_irqsave(&cs->cmdlock, flags);
>> +	cb =3D cs->cmdbuf;
>> +	spin_unlock_irqrestore(&cs->cmdlock, flags);
>=20
> It is doubtful if the locking here does anything useful.

It assures atomicity when reading the cs->cmdbuf pointer.

>> +	spin_lock_irqsave(&cs->cmdlock, flags);
>> +	cb->prev =3D cs->lastcmdbuf;
>> +	if (cs->lastcmdbuf)
>> +		cs->lastcmdbuf->next =3D cb;
>> +	else {
>> +		cs->cmdbuf =3D cb;
>> +		cs->curlen =3D len;
>> +	}
>> +	cs->cmdbytes +=3D len;
>> +	cs->lastcmdbuf =3D cb;
>> +	spin_unlock_irqrestore(&cs->cmdlock, flags);
>=20
> Would the use of list_heads simplify things here?

I don't think so. The operations in list.h do not keep track of
the total byte count, and adding that in a race-free way appears
non-trivial.

>> +/*
>> + * Free hardware specific device data
>> + * This will be called by "gigaset_freecs" in common.c
>> + */
>> +static void gigaset_freecshw(struct cardstate *cs)
>> +{
>> +	tasklet_kill(&cs->write_tasklet);
>=20
> Does tasklet kill() wait for the tasklet to stop running on a different=

> CPU?  I thing so, but it was written in the days before we commented co=
de.

Its description in LDD3 ch. 7 seems to imply that it does.

>> +			down(&cs->hw.ser->dead_sem);
>=20
> Does this actually use the semaphore's counting feature?  If not, can w=
e
> switch it to a mutex?

I stole that code from the PPP line discipline. It is to assure all
other ldisc methods have completed before the close method proceeds.
This doesn't look like a case for a mutex to me, but I'm open to
suggestions if it's important to avoid a semaphore here.

>> +	tail =3D atomic_read(&inbuf->tail);
>> +	head =3D atomic_read(&inbuf->head);
>> +	gig_dbg(DEBUG_INTR, "buffer state: %u -> %u, receive %u bytes",
>> +		head, tail, count);
>> +
>> +	if (head <=3D tail) {
>> +		n =3D RBUFSIZE - tail;
>> +		if (count >=3D n) {
>> +			/* buffer wraparound */
>> +			memcpy(inbuf->data + tail, buf, n);
>> +			tail =3D 0;
>> +			buf +=3D n;
>> +			count -=3D n;
>> +		} else {
>> +			memcpy(inbuf->data + tail, buf, count);
>> +			tail +=3D count;
>> +			buf +=3D count;
>> +			count =3D 0;
>> +		}
>> +	}
>=20
> Perhaps the (fairly revolting) circ_buf.h can be used for this stuff.

It probably could, but IMHO readability would suffer rather than improve.=


Thanks,
Tilman

PS: My patch hasn't appeared on LKML so far. Any idea why?

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD1BB0E0E990685E4A47B9D73
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFxTfCMdB4Whm86/kRAjnyAJ9y/eQM3AQZI2oz73dhvoUMZTA+/gCdH5bV
PIxeoXKOYClf/K9JwHppQFk=
=0g/o
-----END PGP SIGNATURE-----

--------------enigD1BB0E0E990685E4A47B9D73--
