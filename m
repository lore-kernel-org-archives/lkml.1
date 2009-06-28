Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZF1Mjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZF1Mjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 08:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZF1Mj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 08:39:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36880 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZF1Mj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 08:39:26 -0400
Message-ID: <4A476476.9050908@novell.com>
Date: Sun, 28 Jun 2009 08:39:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 4/4] KVM: add irqfd DEASSIGN feature
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132832.26748.35406.stgit@dev.haskins.net> <20090628104615.GA8020@redhat.com>
In-Reply-To: <20090628104615.GA8020@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBAD3DEC99C869215F33F2C05"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBAD3DEC99C869215F33F2C05
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 09:28:32AM -0400, Gregory Haskins wrote:
>  =20
>> DEASSIGN allows us to optionally disassociate an IRQFD from its underl=
ying
>> eventfd without destroying the eventfd in the process.  This is useful=

>> for conditions like live-migration which may have an eventfd associate=
d
>> with a device and an IRQFD.  We need to be able to decouple the guest
>> from the event source while not perturbing the event source itself.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>
>>  include/linux/kvm.h |    2 ++
>>  virt/kvm/eventfd.c  |   56 ++++++++++++++++++++++++++++++++++++++++++=
+++++++--
>>  2 files changed, 56 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 38ff31e..6710518 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -490,6 +490,8 @@ struct kvm_x86_mce {
>>  };
>>  #endif
>> =20
>> +#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
>> +
>>  struct kvm_irqfd {
>>  	__u32 fd;
>>  	__u32 gsi;
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index ca21e8a..2d4549c 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -180,8 +180,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_qu=
eue_head_t *wqh,
>>  	add_wait_queue(wqh, &irqfd->wait);
>>  }
>> =20
>> -int
>> -kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>> +static int
>> +kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>>  {
>>  	struct _irqfd *irqfd;
>>  	struct file *file =3D NULL;
>> @@ -303,6 +303,58 @@ irqfd_shutdown(struct _irqfd *irqfd)
>>  	irqfd_release(irqfd);
>>  }
>> =20
>> +/*
>> + * assumes kvm->irqfds.lock is held
>> + */
>> +static struct _irqfd *
>> +irqfd_find(struct kvm *kvm, int fd, int gsi)
>> +{
>> +	struct _irqfd *irqfd, *tmp, *ret =3D ERR_PTR(-ENOENT);
>> +	struct eventfd_ctx *eventfd;
>> +
>> +	eventfd =3D eventfd_ctx_fdget(fd);
>> +	if (IS_ERR(eventfd))
>> +		return ERR_PTR(PTR_ERR(eventfd));
>> +
>> +	spin_lock_irq(&kvm->irqfds.lock);
>> +
>> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
>> +		if (irqfd->eventfd =3D=3D eventfd && irqfd->gsi =3D=3D gsi) {
>> +			irqfd_deactivate(irqfd);
>> +			ret =3D irqfd;
>> +			break;
>> +		}
>> +	}
>> +
>> +	spin_unlock_irq(&kvm->irqfds.lock);
>> +	eventfd_ctx_put(eventfd);
>> +
>> +	return ret;
>> +}
>> +
>> +static int
>> +kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
>> +{
>> +	struct _irqfd *irqfd;
>> +
>> +	irqfd =3D irqfd_find(kvm, fd, gsi);
>> +	if (IS_ERR(irqfd))
>> +		return PTR_ERR(irqfd);
>> +
>> +	irqfd_shutdown(irqfd);
>> +
>> +	return 0;
>> +}
>>    =20
>
>
> I think that, to make this work properly, you must
> add irqfd to list the last thing so do.
> As it is, when you assign irqfd, the last thing you do is
>
>         irqfd->eventfd =3D eventfd;
>  =20

Yeah, I agree.  I actually already replied to this effect on the thread
for 3/4. ;)

> I think you should move this to within a spinlock.
>  =20

I think if I fix the ordering, the list spinlock should be sufficient.=20
Am I missing something?

>  =20
>> +
>> +int
>> +kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>> +{
>> +	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
>> +		return kvm_irqfd_deassign(kvm, fd, gsi);
>> +
>> +	return kvm_irqfd_assign(kvm, fd, gsi);
>> +}
>> +
>>    =20
>
>
> At some point we discussed limiting the number of
> irqfds that can be created in some way, so that userspace
> can not consume unlimited amount of kernel memory.
>
> What happened to that idea?
>  =20

Yeah, that is a good question.  I thought I had already done that, too,
but now I don't know what happened to the logic.  Perhaps it got lost on
a respin somewhere.  I will look into this and add the feature.

> This will happen naturally if
> - we keep fget on the file until irqfd goes away
> - we allow the same file be bound to only one irqfd
> but there might be other ways to do this
>
>  =20



--------------enigBAD3DEC99C869215F33F2C05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpHZHwACgkQlOSOBdgZUxnpjACdGdheiyJls1jruOsOPl8H5R47
dPUAnjzRWQ84/3Dn16Z+zxFioPzf+cpe
=4FJB
-----END PGP SIGNATURE-----

--------------enigBAD3DEC99C869215F33F2C05--
