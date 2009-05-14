Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZENPxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZENPxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZENPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:52:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53643 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZENPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:52:56 -0400
Message-ID: <4A0C3E54.1090109@novell.com>
Date: Thu, 14 May 2009 11:52:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net> <4A0BFF13.9090802@redhat.com>
In-Reply-To: <4A0BFF13.9090802@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigABD6D377238A2E5039B3DC33"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigABD6D377238A2E5039B3DC33
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> KVM provides a complete virtual system environment for guests, includi=
ng
>> support for injecting interrupts modeled after the real
>> exception/interrupt
>> facilities present on the native platform (such as the IDT on x86).
>> Virtual interrupts can come from a variety of sources (emulated device=
s,
>> pass-through devices, etc) but all must be injected to the guest via
>> the KVM infrastructure.  This patch adds a new mechanism to inject a
>> specific
>> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal
>> signal
>> on the irqfd (using eventfd semantics from either userspace or
>> kernel) will
>> translate into an injected interrupt in the guest at the next availabl=
e
>> interrupt window.
>>
>> +
>> +static void
>> +irqfd_inject(struct work_struct *work)
>> +{
>> +    struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);=

>> +    struct kvm *kvm =3D irqfd->kvm;
>> +
>>  =20
>
>
> I think you need to ->read() from the irqfd, otherwise the count will
> never clear.

Yeah, and this is a disavantage to using eventfd vs a custom anon-fd
implementation.

However, the count is really only there for deciding whether to sleep a
traditional eventfd recipient which doesn't really apply in this
application.  I suppose we could try to invoke the read method (or add a
new method to eventfd to allow it to be cleared independent of the
f_ops->read() (ala eventfd_signal() vs f_ops->write()).  I'm not
convinced we really need to worry about it, though.  IMO we can just let
the count accumulate.

But if you insist this loose end should be addressed, perhaps Davide has
some thoughts on how to best do this?

-Greg

>
>> +    mutex_lock(&kvm->lock);
>> +    kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> +    kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> +    mutex_unlock(&kvm->lock);
>> +}
>>  =20
>



--------------enigABD6D377238A2E5039B3DC33
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoMPlQACgkQlOSOBdgZUxlesQCeIUXVz6XpRlfqKbP8zlzNoHjt
gOQAn0nRRf+JOWbK9TBCvVLez2Gkggx0
=hKEt
-----END PGP SIGNATURE-----

--------------enigABD6D377238A2E5039B3DC33--
