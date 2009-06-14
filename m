Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZFNMZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZFNMZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZFNMZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:25:46 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51641 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZFNMZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:25:45 -0400
Message-ID: <4A34EC47.5090103@novell.com>
Date: Sun, 14 Jun 2009 08:25:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090611131647.GA15743@redhat.com> <20090611133643.GA16335@redhat.com>
In-Reply-To: <20090611133643.GA16335@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90CB5A2BA596489E0A095753"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90CB5A2BA596489E0A095753
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 11, 2009 at 04:16:47PM +0300, Michael S. Tsirkin wrote:
>  =20
>>> +
>>> +	ret =3D file->f_op->poll(file, &irqfd->pt);
>>> +	if (ret < 0)
>>> +		goto fail;
>>>      =20
>
> Looking at it some more, we have:
> struct file_operations {
> ....
> 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
>
> So the comparison above does not seem to make sense:
> it seems that the return value from poll can not be negative.
>  =20

Indeed.  Will fix.
> Will the callback be executed if someone did a write to eventfd
> before we attached it? If no, maybe we should call it here
> if ret !=3D 0.
>  =20

I do the cleanup in case the callback has been called, but poll() fails
somewhere internally afterwards.  Perhaps this is not a realistic
scenario, but it was my motivation for adding the wqh cleanup.
>
>  =20
>>> +
>>> +	irqfd->file =3D file;
>>> +
>>> +	mutex_lock(&kvm->lock);
>>> +	list_add_tail(&irqfd->list, &kvm->irqfds);
>>> +	mutex_unlock(&kvm->lock);
>>> +
>>> +	return 0;
>>> +
>>> +fail:
>>> +	if (irqfd->wqh)
>>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>>      =20
>> Why are these 2 lines here? Either we might get a callback even though=

>> poll failed - and then this test without lock is probably racy -
>> or we can't, and then we can replace the above with BUG_ON(irqfd->wqh)=
=2E
>>
>> Which is it? I think the later ...
>>
>>
>>    =20
>>> +
>>> +	if (file && !IS_ERR(file))
>>> +		fput(file);
>>> +
>>> +	kfree(irqfd);
>>> +	return ret;
>>> +}
>>> +
>>>      =20



--------------enig90CB5A2BA596489E0A095753
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko07EcACgkQlOSOBdgZUxlMxACdEB0F/gOAowuXq3PVOwBGn2uR
W6UAnjeRSpF6+Ntw34C6TSuuzciJ+Ls3
=E4nm
-----END PGP SIGNATURE-----

--------------enig90CB5A2BA596489E0A095753--
