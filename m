Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbZGPSXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbZGPSXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbZGPSXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:23:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36359 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025AbZGPSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:23:03 -0400
Message-ID: <4A5F6FF4.2090706@novell.com>
Date: Thu, 16 Jul 2009 14:22:44 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <200907161852.42071.arnd@arndb.de>
In-Reply-To: <200907161852.42071.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5424B252079A88DCBA5D56F5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5424B252079A88DCBA5D56F5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> On Thursday 16 July 2009, Gregory Haskins wrote:
>  =20
>> Background: The original vbus code was tightly integrated with kvm.ko.=
  Avi
>> suggested that we abstract the interfaces such that it could live outs=
ide
>> of kvm.
>>    =20
>
> The code is still highly kvm-specific, you would not be able to use
> it with another hypervisor like lguest or vmware player, right?
>  =20

In its current form, it is kvm specific primarily because it was not a
explicit design constraint of mine to support others.  However, there is
no reason why we could not generalize the interface if that is a
desirable trait.  Ultimately I would like to have my project support
other things like lguest, so this is not a bad idea.  Otherwise, someone
will invariably be proposing an "lguest_xinterface" next ;)

>  =20
>> Example usage: QEMU instantiates a guest, and an external module "foo"=

>> that desires the ability to interface with the guest (say via
>> open("/dev/foo")).  QEMU may then issue a KVM_GET_VMID operation to ac=
quire
>> the u64-based vmid, and pass it to ioctl(foofd, FOO_SET_VMID, &vmid).
>> Upon receipt, the foo module can issue kvm_xinterface_find(vmid) to ac=
quire
>> the proper context.  Internally, the struct kvm* and associated
>> struct module* will remain pinned at least until the foo module calls
>> kvm_xinterface_put().
>>    =20
>
> Your approach allows passing the vmid from a process that does
> not own the kvm context. This looks like an intentional feature,
> but I can't see what this gains us.

This work is towards the implementation of lockless-shared-memory
subsystems, which includes ring constructs such as virtio-ring,
VJ-netchannels, and vbus-ioq.   I find that these designs perform
optimally when you allow two distinct contexts (producer + consumer) to
process the ring concurrently, which implies a disparate context from
the guest in question.  Note that the infrastructure we are discussing
does not impose a requirement for the contexts to be unique: it will
work equally well from the same or a different process.

For an example of this "producer/consumer" dynamic over shared memory in
action, please refer to my previous posting re: "vbus"

http://lkml.org/lkml/2009/4/21/408

I am working on v4 now, and this patch is part of the required support.

> =20
>
>  =20
>> As a final measure, we link the xinterface code statically
>> into the kernel so that callers are guaranteed a stable interface to
>> kvm_xinterface_find() without implicitly pinning kvm.ko or racing agai=
nst
>> it.
>>    =20
>
> I also don't understand this. Are you worried about driver modules
> breaking when an externally-compiled kvm.ko is loaded? The same could
> be achieved by defining your data structures kvm_xinterface_ops and
> kvm_xinterface in a kernel header that is not shipped by kvm-kmod but
> always taken from the kernel headers.
> It does not matter if the entry points are build into the kernel or
> exported from a kvm.ko as long as you define a fixed ABI.
>
> What is the problem with pinning kvm.ko from another module using
> its features?
>  =20

Well, there is always the chance that I am doing something dumb or
missing the point ;)

But my rationale was as follows:  The problem is that kvm is a little
weird in the module ref department: If I were to do it the standard way
and link xinterface.o into kvm.o (and have any xinterface_find() users
do a tristate+"depends on KVM"), this would work as I believe you are
suggesting.  That is to say: whenever I loaded "foo.ko", insmod would
automatically up the reference of kvm.ko.  The issue is that is not
quite what I really want ;)

I want to hold the reference to the entire .text chain, which includes
kvm.ko + [kvm-intel.ko | kvm-amd.ko].  If you look carefully, the
ops->owner that is assigned is actually the arch.ko.  In addition, I
wanted the kvm.ko lifetime to be associated with the lifetime of its
contexts actually in use, not the lifetime of its installed
dependencies.  Therefore, I did it this way.

But to your point, I suppose the dependency lifetime thing is not a huge
deal.  I could therefore modify the patch to simply link xinterface.o
into kvm.ko and still achieve the primary objective by retaining ops->own=
er.

Note that if we are going to generalize the interface to support other
guests as you may have been suggesting above, it should probably stay
statically linked (and perhaps live in ./lib or something)


> Can't you simply provide a function call to lookup the kvm context
> pointer from the file descriptor to achieve the same functionality?
>  =20
You mean so have: struct kvm_xinterface *kvm_xinterface_find(int fd)

(instead of creating our own vmid namespace) ?

Or are you suggesting using fget() instead of kvm_xinterface_find()?

> To take that thought further, maybe the dependency can be turned
> around: If every user (pci-uio, virtio-net, ...) exposes a file
> descriptor based interface to user space, you can have a kvm
> ioctl to register the object behind that file descriptor with
> an existing kvm context to associate it with a guest.

FWIW: We do that already for the signaling path (see irqfd and ioeventfd
in kvm.git).  Each side exposes interfaces that accept eventfds, and the
fds are passed around that way.

However, for the functions we are talking about now, I don't think it
really works well to go the other way.  I could be misunderstanding what
you mean, though.  What I mean is that it's KVM that is providing a
service to the other modules (in this case, translating memory
pointers), so what would an inverse interface look like for that?  And
even if you came up with one, it seems to me that its just "6 of one,
half-dozen of the other" kind of thing.

>  That would
> nicely solve the life time questions by pinning the external
> object for the life time of the kvm context

I suppose that is nice, but note that in practice both objects (the
kvm-guest and the "foo" module) are managed by the same entity (i.e.
QEMU) and therefore share the same approximate lifetime.

Kind Regards,
-Greg


--------------enig5424B252079A88DCBA5D56F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpfb/oACgkQlOSOBdgZUxkiugCff1vmfj1w212OyNix0Fube5Zh
X0IAn1h5E7B/u8iAlkjf/RLlNSbKG7gC
=MeZZ
-----END PGP SIGNATURE-----

--------------enig5424B252079A88DCBA5D56F5--
