Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZFSVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZFSVRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZFSVRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:17:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51547 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZFSVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:17:07 -0400
Message-ID: <4A3C004B.8010706@novell.com>
Date: Fri, 19 Jun 2009 17:16:59 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBC7551858083A6F179260048"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBC7551858083A6F179260048
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Fri, 19 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> eventfd currently emits a POLLHUP wakeup on f_ops->release() to genera=
te a
>> notifier->release() callback.  This lets notification clients know if
>> the eventfd is about to go away and is very useful particularly for
>> in-kernel clients.  However, as it stands today it is not possible to
>> use the notification API in a race-free way.  This patch adds some
>> additional logic to the notification subsystem to rectify this problem=
=2E
>>
>> Background:
>> -----------------------
>> Eventfd currently only has one reference count mechanism: fget/fput.  =
This
>> in of itself is normally fine.  However, if a client expects to be
>> notified if the eventfd is closed, it cannot hold a fget() reference
>> itself or the underlying f_ops->release() callback will never be invok=
ed
>> by VFS.  Therefore we have this somewhat unusual situation where we ma=
y
>> hold a pointer to an eventfd object (by virtue of having a waiter regi=
stered
>> in its wait-queue), but no reference.  This makes it nearly impossible=
 to
>> design a mutual decoupling algorithm: you cannot unhook one side from =
the
>> other (or vice versa) without racing.
>>    =20
>
> And why is that?
>
> struct xxx {
> 	struct mutex mtx;
> 	struct file *file;
> 	...
> };
>
> struct file *xxx_get_file(struct xxx *x) {
> 	struct file *file;
>
> 	mutex_lock(&x->mtx);
> 	file =3D x->file;
> 	if (!file)
> 		mutex_unlock(&x->mtx);
> 	return file;
> }
>
> void xxx_release_file(struct xxx *x) {
> 	mutex_unlock(&x->mtx);
> }
>
> void handle_POLLHUP(struct xxx *x) {
> 	struct file *file;
>
> 	file =3D xxx_get_file(x);
> 	if (file) {
> 		unhook_waitqueue(file, ...);
> 		x->file =3D NULL;
> 		xxx_release_file(x);
> 	}
> }
>
>
> Every time you need to "use" file, you call xxx_get_file(), and if you =
get=20
> NULL, it means it's gone and you handle it accordigly to your IRQ fd=20
> policies. As soon as you done with the file, you call xxx_release_file(=
).
> Replace "mtx" with the lock that fits your needs.
>  =20

Consider what would happen if the f_ops->release() was preempted inside
the wake_up_locked_polled() after it dereferenced the xxx from the list,
but before it calls the callback(POLLHUP).  The xxx object, and/or the
=2Etext for the xxx object may be long gone by the time it comes back
around.  Afaict, there is no way to guard against that scenario unless
you do something like 2/3+3/3.  Or am I missing something?

-Greg



--------------enigBC7551858083A6F179260048
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko8AEsACgkQlOSOBdgZUxmnoQCfa9HnTcvOMi+nW5MA6FE4NMuD
Gl4AoIjH4f7m8z06hM0QRSDaORmL+OV3
=q3Fh
-----END PGP SIGNATURE-----

--------------enigBC7551858083A6F179260048--
