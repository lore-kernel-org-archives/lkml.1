Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZFBRmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZFBRmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZFBRmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:42:04 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55127 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbZFBRmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:42:03 -0400
Message-ID: <4A25646A.8030306@novell.com>
Date: Tue, 02 Jun 2009 13:42:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, mst@redhat.com, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net> <alpine.DEB.1.10.0906021011390.12866@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906021011390.12866@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9D1DE861ACDE5FDDBCD17FCF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9D1DE861ACDE5FDDBCD17FCF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Tue, 2 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> @@ -64,12 +101,28 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, i=
nt sync, void *key)
>>  {
>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>> =20
>> -	/*
>> -	 * The wake_up is called with interrupts disabled.  Therefore we nee=
d
>> -	 * to defer the IRQ injection until later since we need to acquire t=
he
>> -	 * kvm->lock to do so.
>> -	 */
>> -	schedule_work(&irqfd->work);
>> +	switch ((unsigned long)key) {
>> +	case POLLIN:
>> +		/*
>> +		 * The POLLIN wake_up is called with interrupts disabled.
>> +		 * Therefore we need to defer the IRQ injection until later
>> +		 * since we need to acquire the kvm->lock to do so.
>> +		 */
>> +		schedule_work(&irqfd->inject);
>> +		break;
>> +	case POLLHUP:
>> +		/*
>> +		 * The POLLHUP is called unlocked, so it theoretically should
>> +		 * be safe to remove ourselves from the wqh
>> +		 */
>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +		flush_work(&irqfd->inject);
>> +		irqfd_disconnect(irqfd);
>> +
>> +		cleanup_srcu_struct(&irqfd->srcu);
>> +		kfree(irqfd);
>> +		break;
>> +	}
>>    =20
>
> Since "key" is an event *bitmap*, you better be treating it as such. Do=
=20
> not assume what eventfd delivers today (event bitmaps with only one bit=
=20
> set). So this better be like:
>
> 	if (key & POLLIN) {
> 		...
> 	}
> 	if (key & POLLHUP) {
> 		...
> 	}
>
>
> - Davide
>
>
>  =20
Indeed.  Thanks for catching that!

-Greg


--------------enig9D1DE861ACDE5FDDBCD17FCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkolZGoACgkQlOSOBdgZUxm40wCcCC4XfV8fNcFhPeuRsMj3KyEm
sKwAmgJ97SAp4krbB4aKRgQdvpZtsT7K
=mSmg
-----END PGP SIGNATURE-----

--------------enig9D1DE861ACDE5FDDBCD17FCF--
