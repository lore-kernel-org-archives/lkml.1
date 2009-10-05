Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZJEXfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZJEXfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZJEXfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:35:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:28889 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZJEXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=xSZvuAw57MN/VwretUyPGmNAD8FkKna0pj0o2YmvH/1l2Yz3QyT17BLtT3aIFu3P4i
         bZjpcgSzz4pWx2VpjByxcdb6XTdU6jFsVISH0E/dhHXbHAgJn7jKWtJzjQazk2muQ8vo
         pv2njH+18rxi5v9CmorUUSDnJxBfzSJIcTtkw=
Message-ID: <4ACA8261.1070808@gmail.com>
Date: Mon, 05 Oct 2009 19:33:53 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <20091003200519.GB6601@amt.cnet>
In-Reply-To: <20091003200519.GB6601@amt.cnet>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig820436A81A397CBF1957FAEA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig820436A81A397CBF1957FAEA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Marcelo!

Marcelo Tosatti wrote:
> On Fri, Oct 02, 2009 at 04:19:27PM -0400, Gregory Haskins wrote:
>> What: xinterface is a mechanism that allows kernel modules external to=

>> the kvm.ko proper to interface with a running guest.  It accomplishes
>> this by creating an abstracted interface which does not expose any
>> private details of the guest or its related KVM structures, and provid=
es
>> a mechanism to find and bind to this interface at run-time.
>>
>> Why: There are various subsystems that would like to interact with a K=
VM
>> guest which are ideally suited to exist outside the domain of the kvm.=
ko
>> core logic. For instance, external pci-passthrough, virtual-bus, and
>> virtio-net modules are currently under development.  In order for thes=
e
>> modules to successfully interact with the guest, they need, at the ver=
y
>> least, various interfaces for signaling IO events, pointer translation=
,
>> and possibly memory mapping.
>>
>> The signaling case is covered by the recent introduction of the
>> irqfd/ioeventfd mechanisms.  This patch provides a mechanism to cover =
the
>> other cases.  Note that today we only expose pointer-translation relat=
ed
>> functions, but more could be added at a future date as needs arise.
>>
>> Example usage: QEMU instantiates a guest, and an external module "foo"=

>> that desires the ability to interface with the guest (say via
>> open("/dev/foo")).  QEMU may then pass the kvmfd to foo via an
>> ioctl, such as: ioctl(foofd, FOO_SET_VMID, &kvmfd).  Upon receipt, the=

>> foo module can issue kvm_xinterface_bind(kvmfd) to acquire
>> the proper context.  Internally, the struct kvm* and associated
>> struct module* will remain pinned at least until the foo module calls
>> kvm_xinterface_put().
>=20
>> --- /dev/null
>> +++ b/virt/kvm/xinterface.c
>> @@ -0,0 +1,409 @@
>> +/*
>> + * KVM module interface - Allows external modules to interface with a=
 guest
>> + *
>> + * Copyright 2009 Novell.  All Rights Reserved.
>> + *
>> + * Author:
>> + *      Gregory Haskins <ghaskins@novell.com>
>> + *
>> + * This file is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software Founda=
tion,
>> + * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/highmem.h>
>> +#include <linux/module.h>
>> +#include <linux/mmu_context.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/kvm_xinterface.h>
>> +
>> +struct _xinterface {
>> +	struct kvm             *kvm;
>> +	struct task_struct     *task;
>> +	struct mm_struct       *mm;
>> +	struct kvm_xinterface   intf;
>> +	struct kvm_memory_slot *slotcache[NR_CPUS];
>> +};
>> +
>> +struct _xvmap {
>> +	struct kvm_memory_slot    *memslot;
>> +	unsigned long              npages;
>> +	struct kvm_xvmap           vmap;
>> +};
>> +
>> +static struct _xinterface *
>> +to_intf(struct kvm_xinterface *intf)
>> +{
>> +	return container_of(intf, struct _xinterface, intf);
>> +}
>> +
>> +#define _gfn_to_hva(gfn, memslot) \
>> +	(memslot->userspace_addr + (gfn - memslot->base_gfn) * PAGE_SIZE)
>> +
>> +/*
>> + * gpa_to_hva() - translate a guest-physical to host-virtual using
>> + * a per-cpu cache of the memslot.
>> + *
>> + * The gfn_to_memslot() call is relatively expensive, and the gpa acc=
ess
>> + * patterns exhibit a high degree of locality.  Therefore, lets cache=

>> + * the last slot used on a per-cpu basis to optimize the lookup
>> + *
>> + * assumes slots_lock held for read
>> + */
>> +static unsigned long
>> +gpa_to_hva(struct _xinterface *_intf, unsigned long gpa)
>> +{
>> +	int                     cpu     =3D get_cpu();
>> +	unsigned long           gfn     =3D gpa >> PAGE_SHIFT;
>> +	struct kvm_memory_slot *memslot =3D _intf->slotcache[cpu];
>> +	unsigned long           addr    =3D 0;
>> +
>> +	if (!memslot
>> +	    || gfn < memslot->base_gfn
>> +	    || gfn >=3D memslot->base_gfn + memslot->npages) {
>> +
>> +		memslot =3D gfn_to_memslot(_intf->kvm, gfn);
>> +		if (!memslot)
>> +			goto out;
>> +
>> +		_intf->slotcache[cpu] =3D memslot;
>> +	}
>> +
>> +	addr =3D _gfn_to_hva(gfn, memslot) + offset_in_page(gpa);
>> +
>> +out:
>> +	put_cpu();
>> +
>> +	return addr;
>=20
> Please optimize gfn_to_memslot() instead, so everybody benefits. It
> shows very often on profiles.

Yeah, its not a bad idea.  The reason why I did it here is because the
requirements for sync (kvm-vcpu) vs async (xinterface) access is
slightly different.  Sync is probably optimal with per-vcpu caching,
whereas async is optimal with per-cpu.

That said, we could probably build the entire algorithm to be per-cpu as
a compromise and still gain benefits.  Perhaps I will split this out as
a separate patch for v3.

>=20
>> +
>> +	page_list =3D (struct page **) __get_free_page(GFP_KERNEL);
>> +	if (!page_list)
>> +		return NULL;
>> +
>> +	down_write(&mm->mmap_sem);
>> +
>> +	ret =3D get_user_pages(p, mm, addr, npages, 1, 0, page_list, NULL);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ptr =3D vmap(page_list, npages, VM_MAP, PAGE_KERNEL);
>> +	if (ptr)
>> +		mm->locked_vm +=3D npages;
>=20
> Why don't you use gfn_to_page (here and elsewhere in the patch).

Primarily ignorance, I suspect ;)

The truth is I ported this from one of our other connectors, which was
more userspace oriented and thus gup() made sense and gtp() was not an
option.  That said, it probably doesn't matter a ton in the vmap case,
because that is slow-path.  However, I will definitely look to change
over to the gtp() variant, especially if it affects any fast path code.

Thanks Marcelo,
-Greg


--------------enig820436A81A397CBF1957FAEA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrKgmEACgkQP5K2CMvXmqGvKwCfdrV9dKinDcZPdxUoX0EsbLtz
6dgAn1aTWkCQSQGXBuxVGEHyQbNzmh7+
=/nG2
-----END PGP SIGNATURE-----

--------------enig820436A81A397CBF1957FAEA--
