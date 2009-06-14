Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbZFNMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbZFNMlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZFNMlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:41:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53941 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZFNMlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:41:05 -0400
Message-ID: <4A34EFD9.7010303@novell.com>
Date: Sun, 14 Jun 2009 08:40:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090614092542.GA4833@redhat.com>
In-Reply-To: <20090614092542.GA4833@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0AD5E1A146184A02E3BB6322"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0AD5E1A146184A02E3BB6322
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
>
> ...
>
>  =20
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> +static int
>> +kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
>> +{
>> +	struct _irqfd *irqfd;
>> +	struct file *file =3D NULL;
>> +	int ret;
>> +
>> +	irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>> +	if (!irqfd)
>> +		return -ENOMEM;
>> +
>> +	irqfd->kvm =3D kvm;
>> +	irqfd->gsi =3D gsi;
>> +	INIT_LIST_HEAD(&irqfd->list);
>> +	INIT_WORK(&irqfd->work, irqfd_inject);
>> +
>> +	/*
>> +	 * Embed the file* lifetime in the irqfd.
>> +	 */
>> +	file =3D fget(fd);
>> +	if (IS_ERR(file)) {
>> +		ret =3D PTR_ERR(file);
>> +		goto fail;
>> +	}
>> +
>> +	/*
>> +	 * Install our own custom wake-up handling so we are notified via
>> +	 * a callback whenever someone signals the underlying eventfd
>> +	 */
>> +	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
>> +	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
>> +
>> +	ret =3D file->f_op->poll(file, &irqfd->pt);
>> +	if (ret < 0)
>> +		goto fail;
>> +
>> +	irqfd->file =3D file;
>> +
>> +	mutex_lock(&kvm->lock);
>> +	list_add_tail(&irqfd->list, &kvm->irqfds);
>> +	mutex_unlock(&kvm->lock);
>> +
>> +	return 0;
>> +
>> +fail:
>> +	if (irqfd->wqh)
>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +
>> +	if (file && !IS_ERR(file))
>> +		fput(file);
>> +
>> +	kfree(irqfd);
>> +	return ret;
>> +}
>>    =20
>
> It seems that this lets the guest assign an unlimited number of fds
> to the same gsi, potentially using up all of kernel memory.
>
> Since we don't need multiple fds assigned to the same gsi (instead,
> multiple processes can write to the same eventfd to trigger an
> interrupt) let's simply check that no fd is yet assigned to this gsi.
>  =20

I think Avi asked for this specific feature during review which is the
reason why its there today.  However, I agree that it would probably be
a good idea to put an upper limit on the number of supported aliases
that can be registered.  Will fix.

Thanks Michael,

-Greg



--------------enig0AD5E1A146184A02E3BB6322
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko079kACgkQlOSOBdgZUxmzbgCgh+bx2v+qs7EXsKYPpM5VlTQl
Pd0AnAngo+Fcv0+vxA05TAH9cdIy8yHb
=cNEs
-----END PGP SIGNATURE-----

--------------enig0AD5E1A146184A02E3BB6322--
