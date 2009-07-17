Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbZGQA0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbZGQA0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933810AbZGQA0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:26:19 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46206 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbZGQA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:26:18 -0400
Message-ID: <4A5FC516.20907@novell.com>
Date: Thu, 16 Jul 2009 20:25:58 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <200907161852.42071.arnd@arndb.de> <4A5F6FF4.2090706@novell.com> <200907162146.07555.arnd@arndb.de>
In-Reply-To: <200907162146.07555.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFE15FDC9EC2AC7D8CB95ED3B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFE15FDC9EC2AC7D8CB95ED3B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> On Thursday 16 July 2009, Gregory Haskins wrote:
>  =20
>> Arnd Bergmann wrote: =20
>>    =20
>
>  =20
>>> Your approach allows passing the vmid from a process that does
>>> not own the kvm context. This looks like an intentional feature,
>>> but I can't see what this gains us.
>>>      =20
>> This work is towards the implementation of lockless-shared-memory
>> subsystems, which includes ring constructs such as virtio-ring,
>> VJ-netchannels, and vbus-ioq.   I find that these designs perform
>> optimally when you allow two distinct contexts (producer + consumer) t=
o
>> process the ring concurrently, which implies a disparate context from
>> the guest in question.  Note that the infrastructure we are discussing=

>> does not impose a requirement for the contexts to be unique: it will
>> work equally well from the same or a different process.
>>
>> For an example of this "producer/consumer" dynamic over shared memory =
in
>> action, please refer to my previous posting re: "vbus"
>>
>> http://lkml.org/lkml/2009/4/21/408
>>
>> I am working on v4 now, and this patch is part of the required support=
=2E
>>    =20
>
> Ok. I can see how your approach gives you more flexibility in this
> regard, but it does not seem critical.
>  =20

Yeah, and I think I missed your point the first time around.  I thought
you were asking about how the resulting memory API was used, but now I
see you were referring to the scope of the vmid namespace (vs
file-descriptors).

On that topic, yes the vmid implementation here differs from
file-descriptors in the sense that the namespace is global to the
kernel, instead of per-process.  And yes, I also agree with you that
this is not critical to the design, per se.  For instance, the use cases
I have in mind would work fine with the per-task fd namespace as well
since I will be within the same QEMU instance.

So ultimately, I think that means the fd idea you presented would work
equally well.=20

>  =20
>> But to your point, I suppose the dependency lifetime thing is not a hu=
ge
>> deal.  I could therefore modify the patch to simply link xinterface.o
>> into kvm.ko and still achieve the primary objective by retaining ops->=
owner.
>>    =20
>
> Right. And even if it's a separate module, holding an extra reference
> on kvm.ko will not cause any harm.
>  =20

Yep, agreed.
>  =20
>>> Can't you simply provide a function call to lookup the kvm context
>>> pointer from the file descriptor to achieve the same functionality?
>>>  =20
>>>      =20
>> You mean so have: struct kvm_xinterface *kvm_xinterface_find(int fd)
>>
>> (instead of creating our own vmid namespace) ?
>>
>> Or are you suggesting using fget() instead of kvm_xinterface_find()?
>>    =20
>
> I guess they are roughly equivalent. Either you pass a fd to
> kvm_xinterface_find, or pass the struct file pointer you get
> from fget. The latter is probably more convenient because it
> allows you to pass around the struct file in kernel contexts
> that don't have that file descriptor open.
>  =20

Interesting.  I like it.
>  =20
>>> To take that thought further, maybe the dependency can be turned
>>> around: If every user (pci-uio, virtio-net, ...) exposes a file
>>> descriptor based interface to user space, you can have a kvm
>>> ioctl to register the object behind that file descriptor with
>>> an existing kvm context to associate it with a guest.
>>>      =20
>> FWIW: We do that already for the signaling path (see irqfd and ioevent=
fd
>> in kvm.git).  Each side exposes interfaces that accept eventfds, and t=
he
>> fds are passed around that way.
>>
>> However, for the functions we are talking about now, I don't think it
>> really works well to go the other way.  I could be misunderstanding wh=
at
>> you mean, though.  What I mean is that it's KVM that is providing a
>> service to the other modules (in this case, translating memory
>> pointers), so what would an inverse interface look like for that?  And=

>> even if you came up with one, it seems to me that its just "6 of one,
>> half-dozen of the other" kind of thing.
>>    =20
>
> I mean something like=20
>
> int kvm_ioctl_register_service(struct file *filp, unsigned long arg)
> {
> 	struct file *service =3D fget(arg);
> 	struct kvm *kvm =3D filp->private_data;
>
> 	if (!service->f_ops->new_xinterface_register)
> 		return -EINVAL;
>
> 	return service->f_ops->new_xinterface_register(service, (void*)kvm,
> 				&kvm_xinterface_ops);
> }
>
> This would assume that we define a new file_operation specifically for =
this,
> which would simplify the code, but there are other ways to achieve the =
same.
> It would even mean that you don't need any static code as an interface =
layer.
>  =20

I suspect I will have a much harder time getting that type of
modification accepted in mainline ;)

I think I will go with your suggestion for the fd/file interface, tho.=20
I can get rid of the rbtree logic and re-use the lookup via fget, which
is a nice win.

Thanks Arnd!
-Greg


--------------enigFE15FDC9EC2AC7D8CB95ED3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpfxRoACgkQlOSOBdgZUxkdGACfWCnm0pwUt99wzI3OMXnh9pso
+WQAnRWgJrd67zYV4b1a1u1lleKk/+4C
=cfd8
-----END PGP SIGNATURE-----

--------------enigFE15FDC9EC2AC7D8CB95ED3B--
