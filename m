Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbZEFLfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbZEFLfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbZEFLfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:35:20 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58883 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZEFLfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:35:19 -0400
Message-ID: <4A0175F0.1090705@novell.com>
Date: Wed, 06 May 2009 07:35:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: viro@ZenIV.linux.org.uk, davidel@xmailserver.org
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net>
In-Reply-To: <20090504175750.26758.7023.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6D65FF0EC681F0CE221A4209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6D65FF0EC681F0CE221A4209
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Al, Davide,

Gregory Haskins wrote:
> +
> +int
> +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
> +{
> +	struct _irqfd *irqfd;
> +	struct file *file =3D NULL;
> +	int fd =3D -1;
> +	int ret;
> +
> +	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
> +	if (!irqfd)
> +		return -ENOMEM;
> +
> +	irqfd->kvm =3D kvm;
> +	irqfd->gsi =3D gsi;
> +	INIT_LIST_HEAD(&irqfd->list);
> +	INIT_WORK(&irqfd->work, irqfd_inject);
> +
> +	/*
> +	 * We re-use eventfd for irqfd, and therefore will embed the eventfd
> +	 * lifetime in the irqfd.
> +	 */
> +	file =3D eventfd_file_create(0, 0);
> +	if (IS_ERR(file)) {
> +		ret =3D PTR_ERR(file);
> +		goto fail;
> +	}
> +
> +	irqfd->file =3D file;
> +
> +	/*
> +	 * Install our own custom wake-up handling so we are notified via
> +	 * a callback whenever someone signals the underlying eventfd
> +	 */
> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
> +
> +	ret =3D file->f_op->poll(file, &irqfd->pt);
> +	if (ret < 0)
> +		goto fail;
> +
> +	mutex_lock(&kvm->lock);
> +	list_add_tail(&irqfd->list, &kvm->irqfds);
> +	mutex_unlock(&kvm->lock);
> +
> +	ret =3D get_unused_fd();
> +	if (ret < 0)
> +		goto fail;
> +
> +	fd =3D ret;
> +
> +	fd_install(fd, file);
>  =20

Can you comment on whether this function needs to take an additional
reference on file here?  (one for the one held by userspace/fd, and the
other for irqfd->file)  My instinct is telling me this may be currently
broken, but I am not sure.

-Greg




--------------enig6D65FF0EC681F0CE221A4209
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoBdfAACgkQlOSOBdgZUxnsOgCeMqqoaOz7pV0mNOTdCUUw0Afq
IQIAoI2NjqPIkDhy1KJl470ZdcsWP3S8
=51jv
-----END PGP SIGNATURE-----

--------------enig6D65FF0EC681F0CE221A4209--
