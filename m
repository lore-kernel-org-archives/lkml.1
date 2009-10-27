Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZJ0Ner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZJ0Ner (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZJ0Neq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:34:46 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:48307 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZJ0Neo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=FvMIO4cd8THBEEfmJcUuotKbSlbnNfT9rST8417knUVVFpey5uod0VqAr+pV5qy1tL
         zbtbyEM3EdukrogIrFxY+C38vZP+odGmqVr3c0lMd4gg8WGA95f+dlbKrw06/JyJOUhL
         j8kNDgYggriwL8ulosXnvMi6k5zLVf0MNIhbo=
Message-ID: <4AE6F6F1.4090308@gmail.com>
Date: Tue, 27 Oct 2009 09:34:41 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027033601.GA6645@linux.vnet.ibm.com>
In-Reply-To: <20091027033601.GA6645@linux.vnet.ibm.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig62C7CD78E4F29AB2CA2D8F07"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig62C7CD78E4F29AB2CA2D8F07
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Paul E. McKenney wrote:
> On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
>> The current code suffers from the following race condition:
>>
>> thread-1                                    thread-2
>> -----------------------------------------------------------
>>
>> kvm_set_irq() {
>>    rcu_read_lock()
>>    irq_rt =3D rcu_dereference(table);
>>    rcu_read_unlock();
>>
>>                                        kvm_set_irq_routing() {
>>                                           mutex_lock();
>>                                           irq_rt =3D table;
>>                                           rcu_assign_pointer();
>>                                           mutex_unlock();
>>                                           synchronize_rcu();
>>
>>                                           kfree(irq_rt);
>>
>>    irq_rt->entry->set(); /* bad */
>>
>> -------------------------------------------------------------
>>
>> Because the pointer is accessed outside of the read-side critical
>> section.  There are two basic patterns we can use to fix this bug:
>>
>> 1) Switch to sleeping-rcu and encompass the ->set() access within the
>>    read-side critical section,
>>
>>    OR
>>
>> 2) Add reference counting to the irq_rt structure, and simply acquire
>>    the reference from within the RSCS.
>>
>> This patch implements solution (1).
>=20
> Looks like a good transformation!  A few questions interspersed below.

Thanks for the review.  I would have CC'd you but I figured I pestered
you enough with my RCU reviews in the past, and didn't want to annoy you =
;)

I will be sure to CC you in the future, unless you ask otherwise.

>=20
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  include/linux/kvm_host.h |    6 +++++-
>>  virt/kvm/irq_comm.c      |   50 +++++++++++++++++++++++++++----------=
---------
>>  virt/kvm/kvm_main.c      |    1 +
>>  3 files changed, 35 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index bd5a616..1fe135d 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -185,7 +185,10 @@ struct kvm {
>>
>>  	struct mutex irq_lock;
>>  #ifdef CONFIG_HAVE_KVM_IRQCHIP
>> -	struct kvm_irq_routing_table *irq_routing;
>> +	struct {
>> +		struct srcu_struct            srcu;
>=20
> Each structure has its own SRCU domain.  This is OK, but just asking
> if that is the intent.  It does look like the SRCU primitives are
> passed a pointer to the correct structure, and that the return value
> from srcu_read_lock() gets passed into the matching srcu_read_unlock()
> like it needs to be, so that is good.

Yeah, it was intentional.  Technically the table is per-guest, and thus
the locking is too, which is the desired/intentional granularity.

On that note, I tried to denote that kvm->irq_routing.srcu and
kvm->irq_routing.table were related to one another, but then went ahead
and modified the hunks that touched kvm->irq_ack_notifier_list, too.  In
retrospect, this was probably a mistake.  I should leave the rcu usage
outside of ->irq_routing.table alone.

>=20
>> +		struct kvm_irq_routing_table *table;
>> +	} irq_routing;
>>  	struct hlist_head mask_notifier_list;
>>  	struct hlist_head irq_ack_notifier_list;
>>  #endif
>=20
> [ . . . ]
>=20
>> @@ -155,21 +156,19 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_=
id, u32 irq, int level)
>>  	 * IOAPIC.  So set the bit in both. The guest will ignore
>>  	 * writes to the unused one.
>>  	 */
>> -	rcu_read_lock();
>> -	irq_rt =3D rcu_dereference(kvm->irq_routing);
>> +	idx =3D srcu_read_lock(&kvm->irq_routing.srcu);
>> +	irq_rt =3D rcu_dereference(kvm->irq_routing.table);
>>  	if (irq < irq_rt->nr_rt_entries)
>> -		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
>> -			irq_set[i++] =3D *e;
>> -	rcu_read_unlock();
>> +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
>=20
> What prevents the above list from changing while we are traversing it?
> (Yes, presumably whatever was preventing it from changing before this
> patch, but what?)
>=20
> Mostly kvm->lock is held, but not always.  And if kvm->lock were held
> all the time, there would be no point in using SRCU.  ;-)

This is protected by kvm->irq_lock within kvm_set_irq_routing().
Entries are added to a copy of the list, and the top-level table pointer
is swapped (via rcu_assign_pointer(), as it should be) while holding the
lock.  Finally, we synchronize with the RSCS before deleting the old
copy.  It looks to me like the original author got this part right, so I
didn't modify it outside of converting to SRCU.

>=20
>> +			int r;
>>
>> -	while(i--) {
>> -		int r;
>> -		r =3D irq_set[i].set(&irq_set[i], kvm, irq_source_id, level);
>> -		if (r < 0)
>> -			continue;
>> +			r =3D e->set(e, kvm, irq_source_id, level);
>> +			if (r < 0)
>> +				continue;
>>
>> -		ret =3D r + ((ret < 0) ? 0 : ret);
>> -	}
>> +			ret =3D r + ((ret < 0) ? 0 : ret);
>> +		}
>> +	srcu_read_unlock(&kvm->irq_routing.srcu, idx);
>>
>>  	return ret;
>>  }
>> @@ -179,17 +178,18 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsig=
ned irqchip, unsigned pin)
>>  	struct kvm_irq_ack_notifier *kian;
>>  	struct hlist_node *n;
>>  	int gsi;
>> +	int idx;
>>
>>  	trace_kvm_ack_irq(irqchip, pin);
>>
>> -	rcu_read_lock();
>> -	gsi =3D rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
>> +	idx =3D srcu_read_lock(&kvm->irq_routing.srcu);
>> +	gsi =3D rcu_dereference(kvm->irq_routing.table)->chip[irqchip][pin];=

>>  	if (gsi !=3D -1)
>>  		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
>>  					 link)
>=20
> And same question here -- what keeps the above list from changing while=

> we are traversing it?

This is also protected via the kvm->irq_lock in
kvm_register_irq_ack_notifier().  Though as mentioned above, I should
probably drop the non irq_routing.table hunks, so this will go away.
But I think its correct either way.

Thanks Paul,
-Greg


--------------enig62C7CD78E4F29AB2CA2D8F07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrm9vEACgkQP5K2CMvXmqEL2gCeOIbNZpU7g9HfPW5p9prIhVfs
EbkAoIWOIO5JhwxBbvQQwq3geUZBz1qp
=EbaC
-----END PGP SIGNATURE-----

--------------enig62C7CD78E4F29AB2CA2D8F07--
