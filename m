Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZJWCn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZJWCn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 22:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZJWCn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 22:43:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:37081 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZJWCn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 22:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=ZTIJzqzTg1nS2xC/3oCT7G79LYJT2SHQZjIivJqT1xX2UYNRsAN3MmwaDa265nCJIQ
         rgSHVL1FqxvBcT+yziLxIg9C50mwOBgpWrIFoU5clKeEZkI2ONY3m8MX0euZEqgEFmJP
         AW3BkPwCW84N/z2ku0TvDp4a1EH/SDm1ROKOw=
Message-ID: <4AE11849.9070807@gmail.com>
Date: Thu, 22 Oct 2009 22:43:21 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH v2 1/2] KVM: export lockless GSI attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net> <20091023023845.3891.36857.stgit@dev.haskins.net>
In-Reply-To: <20091023023845.3891.36857.stgit@dev.haskins.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F8B79625B54608D5F588267"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F8B79625B54608D5F588267
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Certain GSI's support lockless injecton, but we have no way to detect
> which ones at the GSI level.  Knowledge of this attribute will be
> useful later in the series so that we can optimize irqfd injection
> paths for cases where we know the code will not sleep.  Therefore,
> we provide an API to query a specific GSI.
>=20
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>=20
>  include/linux/kvm_host.h |    2 ++
>  virt/kvm/irq_comm.c      |   19 +++++++++++++++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index bd5a616..93393a4 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -119,6 +119,7 @@ struct kvm_memory_slot {
>  struct kvm_kernel_irq_routing_entry {
>  	u32 gsi;
>  	u32 type;
> +	bool lockless;
>  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
>  		   struct kvm *kvm, int irq_source_id, int level);
>  	union {
> @@ -417,6 +418,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapi=
c *ioapic,
>  				   unsigned long *deliver_bitmask);
>  #endif
>  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level=
);
> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq);
>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned =
pin);
>  void kvm_register_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index 00c68d2..04f0134 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -174,6 +174,23 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id=
, u32 irq, int level)
>  	return ret;
>  }
> =20
> +int kvm_irq_check_lockless(struct kvm *kvm, u32 irq)
> +{
> +	struct kvm_kernel_irq_routing_entry *e;
> +	struct kvm_irq_routing_table *irq_rt;
> +	struct hlist_node *n;
> +	int ret =3D -ENOENT;
> +
> +	rcu_read_lock();
> +	irq_rt =3D rcu_dereference(kvm->irq_routing);
> +	if (irq < irq_rt->nr_rt_entries)
> +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
> +			ret =3D e->lockless ? 1 : 0;

Sigh...  just noticed this as it hits the list.  I should probably break
out of the loop here.

> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned =
pin)
>  {
>  	struct kvm_irq_ack_notifier *kian;
> @@ -314,6 +331,7 @@ static int setup_routing_entry(struct kvm_irq_routi=
ng_table *rt,
> =20
>  	e->gsi =3D ue->gsi;
>  	e->type =3D ue->type;
> +	e->lockless =3D false;
>  	switch (ue->type) {
>  	case KVM_IRQ_ROUTING_IRQCHIP:
>  		delta =3D 0;
> @@ -342,6 +360,7 @@ static int setup_routing_entry(struct kvm_irq_routi=
ng_table *rt,
>  		e->msi.address_lo =3D ue->u.msi.address_lo;
>  		e->msi.address_hi =3D ue->u.msi.address_hi;
>  		e->msi.data =3D ue->u.msi.data;
> +		e->lockless =3D true;
>  		break;
>  	default:
>  		goto out;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--------------enig3F8B79625B54608D5F588267
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrhGEkACgkQP5K2CMvXmqFJSgCgiRJt6yeVhYedBtDrwfSaoYws
tWgAoINRj+BcXOc3jTLOhOWuaxML8L2A
=fJmY
-----END PGP SIGNATURE-----

--------------enig3F8B79625B54608D5F588267--
