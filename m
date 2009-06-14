Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbZFNMxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbZFNMxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZFNMx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:53:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59758 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZFNMx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:53:26 -0400
Message-ID: <4A34F2B7.1030606@novell.com>
Date: Sun, 14 Jun 2009 08:53:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davdel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090604124812.10544.5811.stgit@dev.haskins.net> <20090614114854.GA10269@redhat.com>
In-Reply-To: <20090614114854.GA10269@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8FB539ABBA8D8BE3B2CBF49E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8FB539ABBA8D8BE3B2CBF49E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 04, 2009 at 08:48:12AM -0400, Gregory Haskins wrote:
>  =20
>> +static void
>> +irqfd_disconnect(struct _irqfd *irqfd)
>> +{
>> +	struct kvm *kvm;
>> +
>> +	mutex_lock(&irqfd->lock);
>> +
>> +	kvm =3D rcu_dereference(irqfd->kvm);
>> +	rcu_assign_pointer(irqfd->kvm, NULL);
>> +
>> +	mutex_unlock(&irqfd->lock);
>> +
>> +	if (!kvm)
>> +		return;
>> =20
>>  	mutex_lock(&kvm->lock);
>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> +	list_del(&irqfd->list);
>>  	mutex_unlock(&kvm->lock);
>> +
>> +	/*
>> +	 * It is important to not drop the kvm reference until the next grac=
e
>> +	 * period because there might be lockless references in flight up
>> +	 * until then
>> +	 */
>> +	synchronize_srcu(&irqfd->srcu);
>> +	kvm_put_kvm(kvm);
>>  }
>>    =20
>
> So irqfd object will persist after kvm goes away, until eventfd is clos=
ed?
>  =20

Yep, by design.  It becomes part of the eventfd and is thus associated
with its lifetime.  Consider it as if we made our own anon-fd
implementation for irqfd and the lifetime looks similar.  The difference
is that we are reusing eventfd and its interface semantics.
>  =20
>> =20
>>  static int
>>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>  {
>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>> +	unsigned long flags =3D (unsigned long)key;
>> =20
>> -	/*
>> -	 * The wake_up is called with interrupts disabled.  Therefore we nee=
d
>> -	 * to defer the IRQ injection until later since we need to acquire t=
he
>> -	 * kvm->lock to do so.
>> -	 */
>> -	schedule_work(&irqfd->work);
>> +	if (flags & POLLIN)
>> +		/*
>> +		 * The POLLIN wake_up is called with interrupts disabled.
>> +		 * Therefore we need to defer the IRQ injection until later
>> +		 * since we need to acquire the kvm->lock to do so.
>> +		 */
>> +		schedule_work(&irqfd->inject);
>> +
>> +	if (flags & POLLHUP) {
>> +		/*
>> +		 * The POLLHUP is called unlocked, so it theoretically should
>> +		 * be safe to remove ourselves from the wqh using the locked
>> +		 * variant of remove_wait_queue()
>> +		 */
>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +		flush_work(&irqfd->inject);
>> +		irqfd_disconnect(irqfd);
>> +
>> +		cleanup_srcu_struct(&irqfd->srcu);
>> +		kfree(irqfd);
>> +	}
>> =20
>>  	return 0;
>>  }
>>    =20
>
> And it is removed by this function when eventfd is closed.
> But what prevents the kvm module from going away, meanwhile?
>  =20

Well, we hold a reference to struct kvm until we call
irqfd_disconnect().  If kvm closes first, we disconnect and disassociate
all references to kvm leaving irqfd->kvm =3D NULL.  Likewise, if irqfd
closes first, we disassociate with kvm with the above quoted logic.  In
either case, we are holding a kvm reference up until that "disconnect"
point.  Therefore kvm should not be able to disappear before that
disconnect, and after that point we do not care.  If that is not
sufficient to prevent kvm.ko from going away in the middle, then IMO
kvm_get_kvm() has a bug, not irqfd. ;)  However, I believe everything is
actually ok here.

-Greg


--------------enig8FB539ABBA8D8BE3B2CBF49E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko08rcACgkQlOSOBdgZUxltzgCdEyEp/5yD4hEJ6M9FONotgpXI
mD0An2ifUPKx2Ight1sDMpVxHBLKXojp
=O0PC
-----END PGP SIGNATURE-----

--------------enig8FB539ABBA8D8BE3B2CBF49E--
