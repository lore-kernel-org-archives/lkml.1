Return-Path: <linux-kernel-owner+w=401wt.eu-S1763682AbZE0OHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763682AbZE0OHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbZE0OHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:07:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46719 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZE0OHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:07:36 -0400
Message-ID: <4A1D48FA.9080403@novell.com>
Date: Wed, 27 May 2009 10:06:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090527130447.GA11643@redhat.com>
In-Reply-To: <20090527130447.GA11643@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2FA59AF1A306024F019E5680"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2FA59AF1A306024F019E5680
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
>  =20
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
>>    =20
>
> So we get a reference to a file, and unless the user is nice to us, it
> will only be dropped when kvm char device file is closed?
> I think this will deadlock if the fd in question is the open kvm char d=
evice.
>
>
>  =20
Hmm...I hadn't considered this possibility, though I am not sure if it
would cause a deadlock in the pattern you suggest.  It seems more like
it would result in, at worst, an extra reference to itself (and thus a
leak) rather than a deadlock...

I digress.  In either case, perhaps I should s/fget/eventfd_fget to at
least limit the type of fd to eventfd.  I was trying to be "slick" by
not needing the eventfd_fget() exported, but I am going to need to
export it later anyway for iosignalfd, so its probably a moot point.

Thanks Michael,
-Greg


--------------enig2FA59AF1A306024F019E5680
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodSP8ACgkQlOSOBdgZUxnNkQCfSHmNrXvFlRYectK6Gi18bfcW
wfsAn0PHIjbc+TCx/5ifcmyYBn945fiB
=++LK
-----END PGP SIGNATURE-----

--------------enig2FA59AF1A306024F019E5680--
