Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbZENLxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbZENLxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZENLxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:53:06 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:37042 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbZENLxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:53:05 -0400
Message-ID: <4A0C060D.2060107@novell.com>
Date: Thu, 14 May 2009 07:52:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net> <4A0BE8CA.7080801@redhat.com>
In-Reply-To: <4A0BE8CA.7080801@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCC5672938E37500B7BB07ACB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCC5672938E37500B7BB07ACB
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
>>  =20
>
>>          r =3D 1;
>>          break;
>>      case KVM_CAP_COALESCED_MMIO:
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 3db5d8d..dfc4bcc 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -415,6 +415,7 @@ struct kvm_trace_rec {
>>  #define KVM_CAP_ASSIGN_DEV_IRQ 29
>>  /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
>>  #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
>> +#define KVM_CAP_EVENTFD 31
>>  =20
>
> Let's keep a fine granularity and call it IRQFD.

Yeah, the iofd stuff is still immature and is not likely to be ready at
the same time anyway.  The CAP bits are cheap enough as it is, so not
sure what I was thinking.  Will fix.

>
>> +
>> +int
>> +kvm_deassign_irqfd(struct kvm *kvm, int fd)
>> +{
>> +    struct _irqfd *irqfd, *tmp;
>> +
>> +    mutex_lock(&kvm->lock);
>> +
>> +    /*
>> +     * linear search isn't brilliant, but this should be a infrequent=

>> +     * operation and the list should not grow very large
>> +     */
>> +    list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
>> +        if (irqfd->fd !=3D fd)
>> +            continue;
>>  =20
>
> Please fget() the new fd and compare the filps; fds aren't meaningful
> in the kernel.  You can also drop _irqfd::fd.

I like this as a second option...

>
> It may also be useful to compare the gsi, this allows a
> "make-before-break" switchover:

=2E..but I like this best.  Good idea.

>
> - guest reroutes irq to a different gsi
> - associate irqfd with new gsi
> - disassociate irqfd from old gsi
>
>> +
>> +        irqfd_release(irqfd);
>> +        mutex_unlock(&kvm->lock);
>> +        return 0;
>>  =20
>
> Don't return, userspace may have multiple associations?

Parse error.  Can you elaborate?

-Greg

>
>



--------------enigCC5672938E37500B7BB07ACB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoMBg0ACgkQlOSOBdgZUxnlewCeJGqRqf5HmZt0zpZ8jo6kDQHx
fI0An3ikxl1JmQMWgl7FFiMU0fBdbkmT
=Sr2C
-----END PGP SIGNATURE-----

--------------enigCC5672938E37500B7BB07ACB--
