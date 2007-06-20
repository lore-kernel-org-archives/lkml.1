Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXFTPsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXFTPsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXFTPsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:48:16 -0400
Received: from dovecot.org ([82.118.211.50]:55963 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbXFTPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:48:15 -0400
Subject: Re: SMP read() stopping at memory page boundaries
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1182351171.3768.65.camel@hurina>
References: <1182351171.3768.65.camel@hurina>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1IppvHwtzOiuXG0COxtj"
Date: Wed, 20 Jun 2007 18:48:13 +0300
Message-Id: <1182354493.3768.80.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1IppvHwtzOiuXG0COxtj
Content-Type: multipart/mixed; boundary="=-32LprqJESYLghVLqsryc"


--=-32LprqJESYLghVLqsryc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-20 at 17:52 +0300, Timo Sirainen wrote:
> Sometimes read() returns only 4096 bytes. I'm locking the file, so I
> don't think this should ever happen, right?

Sorry, the problem was with file truncating so there's no bug with
locking. I didn't notice it first because it happened to work with
FreeBSD and Solaris.

Without locking there's a problem that I'd want to avoid, but I guess
it's not necessarily a bug (although it doesn't seem to happen with
FreeBSD or Solaris):

Process 1:

 - create "foo2"
 - rename() to "foo"
 - lock
 - write(4096 + 16 bytes)
 - [fsync() here doesn't change anything]
 - pwrite("1111" to offset=3D4096-4)
 - unlock

Process 2:

 - open("foo")
 - read(8192 bytes)

read() sometimes returns 4096 bytes but with the "1111" already included
in the data. Is there a way to avoid this without locking the file while
reading? The "1111" tries to act as a kind of a lock.

Again attached a test program, which should really do what I
intended. :)

--=-32LprqJESYLghVLqsryc
Content-Disposition: attachment; filename=concurrency.c
Content-Type: text/x-csrc; name=concurrency.c; charset=ISO-8859-15
Content-Transfer-Encoding: base64

LyoNCiAgIGdjYyBjb25jdXJyZW5jeS5jIC1vIGNvbmN1cnJlbmN5IC1XYWxsDQoNCiAgIHN0YXJ0
IHR3byBib3RoIGEgcmVhZGVyIGFuZCBhIHdyaXRlcjoNCg0KICAgLi9jb25jdXJyZW5jeQ0KICAg
Li9jb25jdXJyZW5jeSAxDQoqLw0KI2RlZmluZSBfWE9QRU5fU09VUkNFIDUwMA0KI2luY2x1ZGUg
PHN0ZGlvLmg+DQojaW5jbHVkZSA8c3RkbGliLmg+DQojaW5jbHVkZSA8c3RyaW5nLmg+DQojaW5j
bHVkZSA8ZmNudGwuaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxhc3NlcnQuaD4N
CiNpbmNsdWRlIDxzeXMvZmlsZS5oPg0KDQojZGVmaW5lIE1BWF9QQUdFU0laRSA4MTkyDQoNCmlu
dCBtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pDQp7DQoJY2hhciBidWZbTUFYX1BBR0VTSVpF
KjJdLCBvbmVzWzRdID0geyAxLCAxLCAxLCAxIH07DQoJaW50IGZkLCByZXQsIHBhZ2VzaXplOw0K
DQoJbWVtc2V0KGJ1ZiwgMCwgc2l6ZW9mKGJ1ZikpOw0KDQoJcGFnZXNpemUgPSBnZXRwYWdlc2l6
ZSgpOw0KCWFzc2VydChwYWdlc2l6ZSA8PSBNQVhfUEFHRVNJWkUpOw0KDQoJYnVmW3BhZ2VzaXpl
XSA9ICdoJzsNCglpZiAoYXJnYyA9PSAxKSB7DQoJCXByaW50Zigid3JpdGluZywgcGFnZSBzaXpl
ID0gJWRcbiIsIHBhZ2VzaXplKTsNCgkJZm9yICg7Oykgew0KCQkJZmQgPSBvcGVuKCJmb28yIiwg
T19SRFdSIHwgT19DUkVBVCB8IE9fVFJVTkMsIDA2MDApOw0KCQkJaWYgKGZkID09IC0xKSB7DQoJ
CQkJcGVycm9yKCJvcGVuKCkiKTsNCgkJCQlyZXR1cm4gMTsNCgkJCX0NCgkJCWlmIChyZW5hbWUo
ImZvbzIiLCAiZm9vIikgPCAwKQ0KCQkJCXBlcnJvcigicmVuYW1lKCkiKTsNCgkJCXVzbGVlcChy
YW5kKCkgJSAxMDAwKTsNCg0KCQkJaWYgKGZsb2NrKGZkLCBMT0NLX0VYKSA8IDApDQoJCQkJcGVy
cm9yKCJmbG9jaygpIik7DQoJCQlwd3JpdGUoZmQsIGJ1ZiwgcGFnZXNpemUrMTYsIDApOw0KCQkJ
Ly91c2xlZXAocmFuZCgpICUgMTAwMCk7DQoJCQkvL2ZkYXRhc3luYyhmZCk7DQoJCQlwd3JpdGUo
ZmQsIG9uZXMsIDQsIHBhZ2VzaXplLTQpOw0KCQkJaWYgKGZsb2NrKGZkLCBMT0NLX1VOKSA8IDAp
DQoJCQkJcGVycm9yKCJmbG9jaygpIik7DQoJCQl1c2xlZXAocmFuZCgpICUgMTAwMCk7DQoJCQlj
bG9zZShmZCk7DQoJCX0NCgl9IGVsc2Ugew0KCQlwcmludGYoInJlYWRpbmcsIHBhZ2Ugc2l6ZSA9
ICVkXG4iLCBwYWdlc2l6ZSk7DQoJCWZvciAoOzsgY2xvc2UoZmQpKSB7DQoJCQlmZCA9IG9wZW4o
ImZvbyIsIE9fUkRXUiwgMDYwMCk7DQoJCQlpZiAoZmQgPT0gLTEpIHsNCgkJCQlwZXJyb3IoIm9w
ZW4oKSIpOw0KCQkJCXJldHVybiAxOw0KCQkJfQ0KDQoJCQlyZXQgPSBwcmVhZChmZCwgYnVmLCBz
aXplb2YoYnVmKSwgMCk7DQoJCQlpZiAocmV0IDwgcGFnZXNpemUpIHsNCgkJCQlpZiAocmV0ID4g
MCkNCgkJCQkJcHJpbnRmKCJsZXNzIHRoYW4gYSBwYWdlOiAlZFxuIiwgcmV0KTsNCgkJCQljb250
aW51ZTsNCgkJCX0NCg0KCQkJaWYgKG1lbWNtcChidWYgKyBwYWdlc2l6ZSAtIDQsIG9uZXMsIDQp
ID09IDApIHsNCgkJCQlpZiAocmV0ID09IHBhZ2VzaXplKSB7DQoJCQkJCXByaW50ZigicGFnZSBz
aXplIGN1dFxuIik7DQoJCQkJfSBlbHNlIGlmIChidWZbcGFnZXNpemVdICE9ICdoJykgew0KCQkJ
CQlwcmludGYoImJyb2tlbiBkYXRhXG4iKTsNCgkJCQl9DQoJCQl9DQoJCX0NCgl9DQoJcmV0dXJu
IDA7DQp9DQo=


--=-32LprqJESYLghVLqsryc--

--=-1IppvHwtzOiuXG0COxtj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGeUw9yUhSUUBViskRAkpKAJ4uDlvXTs8J4xnthJ3IjDcAFKhOvgCgpvVl
5a3g2/bgAyhqvUTzoTSgXwM=
=LDg9
-----END PGP SIGNATURE-----

--=-1IppvHwtzOiuXG0COxtj--

