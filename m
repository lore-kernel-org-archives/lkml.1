Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZJ1NYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZJ1NYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZJ1NYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:24:35 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:65429 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbZJ1NYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=LLoTo59Jvv1634pPrGfRv3Y/kJv9aV+w/H6HZJUUsneDfz4O4G3eMQDv4Q05kYG3H1
         4Vr0x9GnIDk0+gokFSpB8yGNGjy3rAgMH+YTVT0zqwCn6tq7QP4wNv3PWUSaBF1ETJ6k
         EAjReTQqovFegAF6e9yoyU/1kigFPA6LejsW4=
Message-ID: <4AE8460E.8070000@gmail.com>
Date: Wed, 28 Oct 2009 09:24:30 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 2/3] KVM: export lockless GSI attribute
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162202.23704.8727.stgit@dev.haskins.net> <20091028074623.GB22784@redhat.com>
In-Reply-To: <20091028074623.GB22784@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFCD756B749340DAC15E803DE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFCD756B749340DAC15E803DE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Oct 26, 2009 at 12:22:03PM -0400, Gregory Haskins wrote:
>> Certain GSI's support lockless injecton, but we have no way to detect
>> which ones at the GSI level.  Knowledge of this attribute will be
>> useful later in the series so that we can optimize irqfd injection
>> paths for cases where we know the code will not sleep.  Therefore,
>> we provide an API to query a specific GSI.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  include/linux/kvm_host.h |    2 ++
>>  virt/kvm/irq_comm.c      |   35 ++++++++++++++++++++++++++++++++++-
>>  2 files changed, 36 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 1fe135d..01151a6 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -119,6 +119,7 @@ struct kvm_memory_slot {
>>  struct kvm_kernel_irq_routing_entry {
>>  	u32 gsi;
>>  	u32 type;
>> +	bool lockless;
>=20
> So lockless is the same as type =3D=3D MSI from below?

Yep, today anyway.

> If the idea is to make it extensible for the future,
> let's just add an inline function, we don't need a field for this.
>=20

This makes sense.

>>  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
>>  		   struct kvm *kvm, int irq_source_id, int level);
>>  	union {
>> @@ -420,6 +421,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioap=
ic *ioapic,
>>  				   unsigned long *deliver_bitmask);
>>  #endif
>>  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int leve=
l);
>> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq);
>>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned=
 pin);
>>  void kvm_register_irq_ack_notifier(struct kvm *kvm,
>>  				   struct kvm_irq_ack_notifier *kian);
>> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
>> index db2553f..a7fd487 100644
>> --- a/virt/kvm/irq_comm.c
>> +++ b/virt/kvm/irq_comm.c
>> @@ -173,6 +173,35 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_i=
d, u32 irq, int level)
>>  	return ret;
>>  }
>> =20
>> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq)
>> +{
>> +	struct kvm_kernel_irq_routing_entry *e;
>> +	struct kvm_irq_routing_table *irq_rt;
>> +	struct hlist_node *n;
>> +	int ret =3D -ENOENT;
>> +	int idx;
>> +
>> +	idx =3D srcu_read_lock(&kvm->irq_routing.srcu);
>> +	irq_rt =3D rcu_dereference(kvm->irq_routing.table);
>> +	if (irq < irq_rt->nr_rt_entries)
>> +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
>> +			if (!e->lockless) {
>> +				/*
>> +				 * all destinations need to be lockless to
>> +				 * declare that the GSI as a whole is also
>> +				 * lockless
>> +				 */
>> +				ret =3D 0;
>> +				break;
>> +			}
>> +
>> +			ret =3D 1;
>> +		}
>> +	srcu_read_unlock(&kvm->irq_routing.srcu, idx);
>> +
>> +	return ret;
>> +}
>> +
>>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned=
 pin)
>>  {
>>  	struct kvm_irq_ack_notifier *kian;
>> @@ -310,18 +339,22 @@ static int setup_routing_entry(struct kvm_irq_ro=
uting_table *rt,
>>  	int delta;
>>  	struct kvm_kernel_irq_routing_entry *ei;
>>  	struct hlist_node *n;
>> +	bool lockless =3D ue->type =3D=3D KVM_IRQ_ROUTING_MSI;
>> =20
>>  	/*
>>  	 * Do not allow GSI to be mapped to the same irqchip more than once.=

>>  	 * Allow only one to one mapping between GSI and MSI.
>> +	 * Do not allow mixed lockless vs locked variants to coexist.
>=20
> Userspace has no idea which entries are lockless and which are not:
> this is an implementation detail - so it might not be able to avoid
> illegal combinations.
> Since this is called on an ioctl, can the rule be formulated in a way
> that makes sense for userspace?
>=20

I'm not sure.

>>  	 */
>>  	hlist_for_each_entry(ei, n, &rt->map[ue->gsi], link)
>>  		if (ei->type =3D=3D KVM_IRQ_ROUTING_MSI ||
>> -		    ue->u.irqchip.irqchip =3D=3D ei->irqchip.irqchip)
>> +		    ue->u.irqchip.irqchip =3D=3D ei->irqchip.irqchip ||
>> +		    ei->lockless !=3D lockless)
>=20
> So this check seems like it does nothing, because lockless is same as
> MSI, and MSI is always 1:1? Intentional?
>=20

Yeah, it was more to guard-against/document the dependency, in case the
1:1 with MSI ever changes in the future.

Kind Regards,
-Greg


--------------enigFCD756B749340DAC15E803DE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkroRg4ACgkQP5K2CMvXmqGzqACePvSLHlYfG7KoP8vqEK0UAihw
7PgAniPQOX41tA2nHLc/Fbxxwi/bKZny
=R0Qv
-----END PGP SIGNATURE-----

--------------enigFCD756B749340DAC15E803DE--
