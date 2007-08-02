Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXHBKcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXHBKcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXHBKcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:32:05 -0400
Received: from norsk.toidinamai.de ([78.47.249.60]:37470 "EHLO
	norsk.toidinamai.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbXHBKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:32:04 -0400
Message-ID: <46B1B295.1010003@benkstein.net>
Date: Thu, 02 Aug 2007 12:31:49 +0200
From: Frank Benkstein <frank@benkstein.net>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: VT_PROCESS, VT_LOCKSWITCH capabilities
References: <46AFB62E.2080303@benkstein.net>	<46AFF390.10103@benkstein.net> <20070801151900.f80722b6.akpm@linux-foundation.org>
In-Reply-To: <20070801151900.f80722b6.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF17CD106BBE8F1F303D6DA8E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF17CD106BBE8F1F303D6DA8E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Wed, 01 Aug 2007 04:44:32 +0200
> Frank Benkstein <frank@benkstein.net> wrote:
>=20
>> Frank Benkstein wrote:
>>> I wonder why there are different permissions needed for VT_PROCESS
>>> (access to the current virtual console) and VT_LOCKSWITCH
>>> (CAP_SYS_TTY_CONFIG).
>> To be more direct:
>>
>> require CAP_SYS_TTY_CONFIG for VT_SETMODE as its essentially the same =
as
>> VT_LOCKSWITCH and said capability is already required there
>>
>> diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
>> index c6f6f42..7034a68 100644
>> --- a/drivers/char/vt_ioctl.c
>> +++ b/drivers/char/vt_ioctl.c
>> @@ -662,7 +662,7 @@ int vt_ioctl(struct tty_struct *tty, struct file *=
 file,
>>         {
>>                 struct vt_mode tmp;
>>
>> -               if (!perm)
>> +               if (!perm || !capable(CAP_SYS_TTY_CONFIG))
>>                         return -EPERM;
>>                 if (copy_from_user(&tmp, up, sizeof(struct vt_mode)))
>>                         return -EFAULT;
>>
>=20
> There's a good risk of breaking stuff with this change.  A quick peek
> through http://www.google.com/codesearch shows that.
>=20
> We need good reasons for making that change, and for handling the
> subsequent fallout, getting shouted at by aggrieved users, etc.
>=20
> It's tricky.

I had a quick look through codesearch, too.  Another solution may be to
allow VT_SETMODE but deny VT_RELDISP if CAP_SYS_TTY_CONFIG is not
present. This way graphics tools still get notified when the console is
switched but can't prevent it.

It probably isn't worth the hassle.  I was just looking though the
kernel source to find out which ioctl would be better for my own console
locking tool to use.  I'm happy that it doesn't have to be setuid-root
but at the same time it nags me a little that denying service (and
potentially making users lose data because they cannot save) is so easy.
 And there is no way to switch it off.  Other than carrying the patch
myself, that is.

Regarding your earlier remark of VT_LOCKSWITCH potentially affecting the
session of the next user:  this is also possible with VT_PROCESS by
starting the locking process in the background.

--=20
GPG (Mail): 7093 7A43 CC40 463A 5564  599B 88F6 D625 BE63 866F
GPG (XMPP): 2243 DBBA F234 7C5A 6D71  3983 9F28 4D03 7110 6D51




--------------enigF17CD106BBE8F1F303D6DA8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGsbKeiPbWJb5jhm8RAuBtAKCJF7RTnP6rZ2FVbTRWQZHd2YhgwgCeJdGB
o2a1Xl1bZDeXv5V/8XYSIRk=
=qoDb
-----END PGP SIGNATURE-----

--------------enigF17CD106BBE8F1F303D6DA8E--
