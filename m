Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZFCTUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZFCTUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZFCTUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:20:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43042 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZFCTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:20:31 -0400
Message-ID: <4A26CCFA.7050105@novell.com>
Date: Wed, 03 Jun 2009 15:20:26 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll - send POLLHUP on ->release
References: <alpine.DEB.1.10.0906031153471.18001@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906031153471.18001@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7B5B940617C5C89775F2433"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7B5B940617C5C89775F2433
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> The following patch allows waiters to be notified about the eventfd fil=
e*=20
> going away, and give them a change to unregister from the wait queue.
> This is turn allows eventfd users to use the eventfd file* w/out=20
> holding a live reference to it.
> After the eventfd user callbacks returns, any usage of the eventfd file=
*=20
> should be dropped. The eventfd user callback can acquire sleepy locks=20
> since it is invoked lockless.
>
>
>
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>  =20

Tested-by: Gregory Haskins <ghaskins@novell.com>
>
> - Davide
>
>
> ---
>  fs/eventfd.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.mod/fs/eventfd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.mod.orig/fs/eventfd.c	2009-05-27 12:10:03.000000000 -0700=

> +++ linux-2.6.mod/fs/eventfd.c	2009-05-27 12:16:57.000000000 -0700
> @@ -59,7 +59,15 @@ int eventfd_signal(struct file *file, in
> =20
>  static int eventfd_release(struct inode *inode, struct file *file)
>  {
> -	kfree(file->private_data);
> +	struct eventfd_ctx *ctx =3D file->private_data;
> +
> +	/*
> +	 * No need to hold the lock here, since we are on the file cleanup
> +	 * path and the ones still attached to the wait queue will be
> +	 * serialized by wake_up_locked_poll().
> +	 */
> +	wake_up_locked_poll(&ctx->wqh, POLLHUP);
> +	kfree(ctx);
>  	return 0;
>  }
> =20
>  =20



--------------enigC7B5B940617C5C89775F2433
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkomzP4ACgkQlOSOBdgZUxm/RwCeLRYXmh6PO/R/4IbMz8MXUJcT
RRsAn3FUQh65hbQs5SQW99F/oLfGBVqf
=sGlu
-----END PGP SIGNATURE-----

--------------enigC7B5B940617C5C89775F2433--
