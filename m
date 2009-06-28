Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZF1Mu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZF1Mu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZF1Muu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:50:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55703 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZF1Mut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:50:49 -0400
Message-ID: <4A476714.2000602@novell.com>
Date: Sun, 28 Jun 2009 08:50:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 3/4] KVM: Fix races in irqfd using new	eventfd_kref_get
 interface
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132826.26748.15607.stgit@dev.haskins.net> <20090628110650.GA8061@redhat.com>
In-Reply-To: <20090628110650.GA8061@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig37C7A75A2BD82DB6F14B88A5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig37C7A75A2BD82DB6F14B88A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 09:28:27AM -0400, Gregory Haskins wrote:
>  =20
>> @@ -65,25 +134,39 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, i=
nt sync, void *key)
>>  	unsigned long flags =3D (unsigned long)key;
>> =20
>>  	/*
>> -	 * Assume we will be called with interrupts disabled
>> +	 * Called with interrupts disabled
>>  	 */
>>  	if (flags & POLLIN)
>> -		/*
>> -		 * Defer the IRQ injection until later since we need to
>> -		 * acquire the kvm->lock to do so.
>> -		 */
>> +		/* An event has been signaled, inject an interrupt */
>>  		schedule_work(&irqfd->inject);
>> =20
>>  	if (flags & POLLHUP) {
>> -		/*
>> -		 * for now, just remove ourselves from the list and let
>> -		 * the rest dangle.  We will fix this up later once
>> -		 * the races in eventfd are fixed
>> -		 */
>> +		/* The eventfd is closing, detach from KVM */
>> +		struct kvm *kvm =3D irqfd->kvm;
>> +		unsigned long flags;
>> +
>>  		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> -		irqfd->wqh =3D NULL;
>> +
>> +		spin_lock_irqsave(&kvm->irqfds.lock, flags);
>> +
>> +		if (irqfd->active) {
>> +			/*
>> +			 * If the item is still active we can be sure that
>> +			 * no-one else is trying to shutdown this object at
>> +			 * the same time.
>> +			 *
>> +			 * Defer the shutdown to a thread so we can flush
>> +			 * all remaining inject jobs.  We use a slow-work
>> +			 * item to prevent a deadlock against the work-queue
>> +			 */
>> +			irqfd_deactivate(irqfd);
>> +			slow_work_enqueue(&irqfd->shutdown);
>>    =20
>
> Greg, in your patch for slow-work module removal, you write:
>   "Callers must ensure that their module has at least
>   one reference held while the work is enqueued."
>   Where does this guarantee come from, in this case?
>  =20
The general guarantee comes from the fact that modules naturally have to
have a reference to be able to call the enqueue function to begin with,
or the calling function was already racy.  In this particular case, we
can guarantee that the kvm vm fd is held while our slow-work is active,
and all slow work is flushed before it is released.  (I guess I am
assuming that VFS takes a module reference when an fd is opened, but I
have not verified that it actually does.  If it doesn't, I suppose KVM
is already racy w.r.t. unloading, independent of my patches)

-Greg


--------------enig37C7A75A2BD82DB6F14B88A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpHZxgACgkQlOSOBdgZUxloZwCfWcu3qY9Q5sPo/G1sNCnndkLx
/XkAnjE75csGAPuRJOY4iP1lQBjO5K6T
=6hiU
-----END PGP SIGNATURE-----

--------------enig37C7A75A2BD82DB6F14B88A5--
