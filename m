Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZJEX67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZJEX67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZJEX66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:58:58 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:17295 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZJEX65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=NU0iNQvAKpER/OjjhdQjbD3i9e/nuWmEZmA36I0YJEQYJIIPHFr4f1dZbKgMm6LBDP
         t4rP1bwdBToY9ykRdMSFkHbILwcgKcTqmI+g8GBYpP2CTWHhzhUWF3W61w4P12FpdXfP
         Gqy+2eOD2ZZCKRQYqkqcdDA/SSGCFdrTKgOPo=
Message-ID: <4ACA87F9.2020902@gmail.com>
Date: Mon, 05 Oct 2009 19:57:45 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH v2 4/4] KVM: add scatterlist support to xinterface
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201937.4014.96148.stgit@dev.haskins.net> <4AC878BE.9050309@redhat.com>
In-Reply-To: <4AC878BE.9050309@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig23EBE781F32F009C7EDFE326"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig23EBE781F32F009C7EDFE326
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/02/2009 10:19 PM, Gregory Haskins wrote:
>> This allows a scatter-gather approach to IO, which will be useful for
>> building high performance interfaces, like zero-copy and low-latency
>> copy (avoiding multiple calls to copy_to/from).
>>
>> The interface is based on the existing scatterlist infrastructure.  Th=
e
>> caller is expected to pass in a scatterlist with its "dma" field
>> populated with valid GPAs.  The xinterface will then populate each
>> entry by translating the GPA to a page*.
>>
>> The caller signifies completion by simply performing a put_page() on
>> each page returned in the list.
>>
>> Signed-off-by: Gregory Haskins<ghaskins@novell.com>
>> ---
>>
>>   include/linux/kvm_xinterface.h |    4 ++
>>   virt/kvm/xinterface.c          |   72
>> ++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 76 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kvm_xinterface.h
>> b/include/linux/kvm_xinterface.h
>> index 684b6f8..eefb575 100644
>> --- a/include/linux/kvm_xinterface.h
>> +++ b/include/linux/kvm_xinterface.h
>> @@ -9,6 +9,7 @@
>>   #include<linux/kref.h>
>>   #include<linux/module.h>
>>   #include<linux/file.h>
>> +#include<linux/scatterlist.h>
>>
>>   struct kvm_xinterface;
>>   struct kvm_xvmap;
>> @@ -36,6 +37,9 @@ struct kvm_xinterface_ops {
>>                       u64 addr,
>>                       unsigned long len,
>>                       unsigned long flags);
>> +    unsigned long (*sgmap)(struct kvm_xinterface *intf,
>> +                   struct scatterlist *sgl, int nents,
>> +                   unsigned long flags);
>>       void (*release)(struct kvm_xinterface *);
>>   };
>>
>> diff --git a/virt/kvm/xinterface.c b/virt/kvm/xinterface.c
>> index c356835..16729f6 100644
>> --- a/virt/kvm/xinterface.c
>> +++ b/virt/kvm/xinterface.c
>> @@ -467,6 +467,77 @@ fail:
>>
>>   }
>>
>> +static unsigned long
>> +xinterface_sgmap(struct kvm_xinterface *intf,
>> +         struct scatterlist *sgl, int nents,
>> +         unsigned long flags)
>> +{
>> +    struct _xinterface     *_intf   =3D to_intf(intf);
>> +    struct task_struct     *p       =3D _intf->task;
>> +    struct mm_struct       *mm      =3D _intf->mm;
>> +    struct kvm             *kvm     =3D _intf->kvm;
>> +    struct kvm_memory_slot *memslot =3D NULL;
>> +    bool                    kthread =3D !current->mm;
>> +    int                     ret;
>> +    struct scatterlist     *sg;
>> +    int                     i;
>> +
>> +    down_read(&kvm->slots_lock);
>> +
>> +    if (kthread)
>> +        use_mm(_intf->mm);
>> +
>> +    for_each_sg(sgl, sg, nents, i) {
>> +        unsigned long           gpa    =3D sg_dma_address(sg);
>> +        unsigned long           len    =3D sg_dma_len(sg);
>> +        unsigned long           gfn    =3D gpa>>  PAGE_SHIFT;
>> +        off_t                   offset =3D offset_in_page(gpa);
>> +        unsigned long           hva;
>> +        struct page            *pg;
>> +
>> +        /* ensure that we do not have more than one page per entry */=

>> +        if ((PAGE_ALIGN(len + offset)>>  PAGE_SHIFT) !=3D 1) {
>> +            ret =3D -EINVAL;
>> +            break;
>> +        }
>> +
>> +        /* check for a memslot-cache miss */
>> +        if (!memslot
>> +            || gfn<  memslot->base_gfn
>> +            || gfn>=3D memslot->base_gfn + memslot->npages) {
>> +            memslot =3D gfn_to_memslot(kvm, gfn);
>> +            if (!memslot) {
>> +                ret =3D -EFAULT;
>> +                break;
>> +            }
>> +        }
>> +
>> +        hva =3D (memslot->userspace_addr +
>> +               (gfn - memslot->base_gfn) * PAGE_SIZE);
>> +
>> +        if (kthread || current->mm =3D=3D mm)
>> +            ret =3D get_user_pages_fast(hva, 1, 1,&pg);
>> +        else
>> +            ret =3D get_user_pages(p, mm, hva, 1, 1, 0,&pg, NULL);
>>   =20
>=20
> One of these needs the mm semaphore.

Indeed.  Good catch.

>=20
>> +
>> +        if (ret !=3D 1) {
>> +            if (ret>=3D 0)
>> +                ret =3D -EFAULT;
>> +            break;
>> +        }
>> +
>> +        sg_set_page(sg, pg, len, offset);
>> +        ret =3D 0;
>> +    }
>> +
>> +    if (kthread)
>> +        unuse_mm(_intf->mm);
>> +
>> +    up_read(&kvm->slots_lock);
>> +
>> +    return ret;
>> +}
>> +
>>   static void
>>   xinterface_release(struct kvm_xinterface *intf)
>>   {
>> @@ -483,6 +554,7 @@ struct kvm_xinterface_ops _xinterface_ops =3D {
>>       .copy_from   =3D xinterface_copy_from,
>>       .vmap        =3D xinterface_vmap,
>>       .ioevent     =3D xinterface_ioevent,
>> +    .sgmap       =3D xinterface_sgmap,
>>       .release     =3D xinterface_release,
>>   };
>>
>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   =20
>=20
>=20



--------------enig23EBE781F32F009C7EDFE326
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrKh/kACgkQP5K2CMvXmqHA1QCeK/lGBa3MIntnIUYlaGPsvPSs
wzkAn2fXyThyvf+6pnMpD7vZLkbct5oI
=F4qu
-----END PGP SIGNATURE-----

--------------enig23EBE781F32F009C7EDFE326--
