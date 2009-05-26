Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZEZSFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZEZSFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZEZSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:05:42 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55064 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbZEZSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:05:41 -0400
Message-ID: <4A1C2F67.70601@novell.com>
Date: Tue, 26 May 2009 14:05:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090526164201.GD9842@redhat.com>
In-Reply-To: <20090526164201.GD9842@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4A9F3E3F5F06A94CB0BDAC15"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4A9F3E3F5F06A94CB0BDAC15
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, May 20, 2009 at 10:30:49AM -0400, Gregory Haskins wrote:
>  =20
>> +static int
>> +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>> +{
>> +	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>> +
>> +	/*
>> +	 * The wake_up is called with interrupts disabled.  Therefore we nee=
d
>> +	 * to defer the IRQ injection until later since we need to acquire t=
he
>> +	 * kvm->lock to do so.
>> +	 */
>> +	schedule_work(&irqfd->work);
>> +
>> +	return 0;
>> +}
>>    =20
>
> This schedule_work is there just to work around the spinlock
> in eventfd_signal, which we don't really need. Isn't this right?
>  =20

Yep.

> And this is on each interrupt. Seems like a pity.
>  =20

I agree.  Moving towards a way to be able to inject without deferring to
a workqueue will be a good thing.  Note, however, that addressing it at
the eventfd/wqh-lock layer is only part of the picture since ideally we
can inject (i.e. eventfd_signal()) from any atomic context (e.g.
hard-irq), not just the artificial one created by the wqh based
implementation.  I think Marcelo's irq_lock split-up code is taking us
in that direction by (eventually) allowing the kvm_set_irq() path to be
atomic-context friendly.

> How about a flag in eventfd that would
> convert it from waking up someone to a plain function call?
>
> Davide, could we add something like
>
>
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index 2a701d5..8bfa308 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -29,6 +29,7 @@ struct eventfd_ctx {
>  	 */
>  	__u64 count;
>  	unsigned int flags;
> +	int nolock;
>  };
> =20
>  /*
> @@ -46,6 +47,12 @@ int eventfd_signal(struct file *file, int n)
> =20
>  	if (n < 0)
>  		return -EINVAL;
> +	if (ctx->nolock) {
> +               /* Whoever set nolock
> +                  better set wqh.func as well. */
> +		ctx->wqh.func(&ctx->wqh, 0, 0, NULL);
> +		return 0;
> +	}
>  	spin_lock_irqsave(&ctx->wqh.lock, flags);
>  	if (ULLONG_MAX - ctx->count < n)
>  		n =3D (int) (ULLONG_MAX - ctx->count);
>
>  =20

If we think we still need to address it at the eventfd layer (which I am
not 100% convinced we do), I think we should probably generalize it a
little more and make it so it doesn't completely re-route the
notification (there may be other end-points interrested in the event, I
suppose).

I am thinking something along the lines that the internal eventfd uses
an srcu_notifier, and we register a default notifier which points to a
wqh path very much like what we have today.  Then something like kvm
could register an additional srcu_notifier which should allow it to be
invoked lockless (*).  This would theoretically allow the eventfd to
remain free to support an arbitrary number of end-points which support
both locked and lockless operation.

-Greg

(*) disclaimer: I've never looked at the srcu_notifier implementation,
so perhaps this is not what they really offer.  I base this only on
basic RCU understanding.




--------------enig4A9F3E3F5F06A94CB0BDAC15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkocL2sACgkQlOSOBdgZUxnyRACgj575U2aSQmb47ioGEdUfXMnC
LMIAn3nRkhU1k0DF0xXKQSLRAFRx3qkk
=jpi4
-----END PGP SIGNATURE-----

--------------enig4A9F3E3F5F06A94CB0BDAC15--
