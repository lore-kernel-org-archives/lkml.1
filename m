Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbZE0LsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbZE0LsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZE0Lr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:47:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55088 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbZE0Lr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:47:58 -0400
Message-ID: <4A1D285C.9050008@novell.com>
Date: Wed, 27 May 2009 07:47:40 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191539.20860.1385.stgit@dev.haskins.net> <4A1D01F8.8080508@redhat.com>
In-Reply-To: <4A1D01F8.8080508@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig02ED220576A8DC3C4853CE94"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig02ED220576A8DC3C4853CE94
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> iosignalfd is a mechanism to register PIO/MMIO regions to trigger an
>> eventfd
>> signal when written to by a guest.  Host userspace can register any
>> arbitrary
>> IO address with a corresponding eventfd and then pass the eventfd to a=

>> specific end-point of interest for handling.
>>
>> Normal IO requires a blocking round-trip since the operation may cause=

>> side-effects in the emulated model or may return data to the caller.
>> Therefore, an IO in KVM traps from the guest to the host, causes a
>> VMX/SVM
>> "heavy-weight" exit back to userspace, and is ultimately serviced by
>> qemu's
>> device model synchronously before returning control back to the vcpu.
>>
>> However, there is a subclass of IO which acts purely as a trigger for
>> other IO (such as to kick off an out-of-band DMA request, etc).  For
>> these
>> patterns, the synchronous call is particularly expensive since we real=
ly
>> only want to simply get our notification transmitted asychronously and=

>> return as quickly as possible.  All the sychronous infrastructure to
>> ensure
>> proper data-dependencies are met in the normal IO case are just
>> unecessary
>> overhead for signalling.  This adds additional computational load on t=
he
>> system, as well as latency to the signalling path.
>>
>> Therefore, we provide a mechanism for registration of an in-kernel
>> trigger
>> point that allows the VCPU to only require a very brief, lightweight
>> exit just long enough to signal an eventfd.  This also means that any
>> clients compatible with the eventfd interface (which includes userspac=
e
>> and kernelspace equally well) can now register to be notified. The end=

>> result should be a more flexible and higher performance notification A=
PI
>> for the backend KVM hypervisor and perhipheral components.
>>
>> To test this theory, we built a test-harness called "doorbell".  This
>> module has a function called "doorbell_ring()" which simply increments=
 a
>> counter for each time the doorbell is signaled.  It supports signallin=
g
>> from either an eventfd, or an ioctl().
>>
>> We then wired up two paths to the doorbell: One via QEMU via a
>> registered
>> io region and through the doorbell ioctl().  The other is direct via
>> iosignalfd.
>>
>> You can download this test harness here:
>>
>> ftp://ftp.novell.com/dev/ghaskins/doorbell.tar.bz2
>>
>> The measured results are as follows:
>>
>> qemu-mmio:       110000 iops, 9.09us rtt
>> iosignalfd-mmio: 200100 iops, 5.00us rtt
>> iosignalfd-pio:  367300 iops, 2.72us rtt
>>
>> I didn't measure qemu-pio, because I have to figure out how to
>> register a
>> PIO region with qemu's device model, and I got lazy.  However, for
>> now we
>> can extrapolate based on the data from the NULLIO runs of +2.56us for
>> MMIO,
>> and -350ns for HC, we get:
>>
>> qemu-pio:      153139 iops, 6.53us rtt
>> iosignalfd-hc: 412585 iops, 2.37us rtt
>>
>> these are just for fun, for now, until I can gather more data.
>>
>> Here is a graph for your convenience:
>>
>> http://developer.novell.com/wiki/images/7/76/Iofd-chart.png
>>
>> The conclusion to draw is that we save about 4us by skipping the
>> userspace
>> hop.
>>
>> +/* writes trigger an event */
>> +static void
>> +iosignalfd_write(struct kvm_io_device *this, gpa_t addr, int len,
>> +         const void *val)
>> +{
>> +    struct _iosignalfd *iosignalfd =3D (struct _iosignalfd
>> *)this->private;
>> +
>> +    eventfd_signal(iosignalfd->file, 1);
>> +}
>>  =20
>
> I much prefer including kvm_io_device inside _iosignalfd and using
> container_of() instead of ->private.  But that is of course unrelated
> to this patch and is not a requirement.
>
>> +
>> +static int
>> +kvm_assign_iosignalfd(struct kvm *kvm, struct kvm_iosignalfd *args)
>> +{
>> +    int                 pio =3D args->flags & KVM_IOSIGNALFD_FLAG_PIO=
;
>> +    struct kvm_io_bus  *bus =3D pio ? &kvm->pio_bus : &kvm->mmio_bus;=

>> +    struct _iosignalfd *iosignalfd;
>> +    struct file        *file;
>> +    int                 ret;
>> +
>> +    file =3D eventfd_fget(args->fd);
>> +    if (IS_ERR(file)) {
>> +        ret =3D PTR_ERR(file);
>> +        printk(KERN_ERR "iosignalfd: failed to get %d eventfd: %d\n",=

>> +               args->fd, ret);
>>  =20
>
> drop the printk, we don't want to let users spam dmesg.
>
>> +        return ret;
>> +    }
>> +
>> +    iosignalfd =3D kzalloc(sizeof(*iosignalfd), GFP_KERNEL);
>> +    if (!iosignalfd) {
>> +        printk(KERN_ERR "iosignalfd: memory pressure\n");
>>  =20
>
> here too.
>
>> +    ret =3D kvm_io_bus_register_dev(bus, &iosignalfd->dev);
>> +    if (ret < 0) {
>> +        printk(KERN_ERR "iosignalfd: failed to register IODEV: %d\n",=

>> +               ret);
>>  =20
>
> and here etc.

Ack on the printk removals.


>
> What happens if you register to iosignalfds for the same address but
> with different cookies (a very practical scenario)?

This is really only supported at the iosignal interface level.  Today,
you can do this and the registration will succeed, but at run-time an
IO-exit will stop at the first in_range() hit it finds.  Therefore, you
will only get service on the first/lowest registered range.

I knew this was a limitation of the current io_bus, but I put the
feature into iosignalfd anyway so that the user/kern interface was
robust enough to support the notion should we ever need it (and can thus
patch io_bus at that time).  Perhaps that is short-sighted because
userspace would never know its ranges weren't really registered properly.=


I guess its simple enough to have io_bus check all devices for a match
instead of stopping on the first.  Should I just make a patch to fix
this, or should I fix iosignalfd to check for in_range matches and fail
if it finds overlap?  (We could then add a CAP_OVERLAP_IO bit in the
future if we finally fix the io_bus capability).  I am inclined to lean
towards option 2, since its not known whether this will ever be useful,
and io_bus scanning is in a hot-path.

Thinking about it some more, I wonder if we should just get rid of the
notion of overlap to begin with.  Its a slippery slope (should we also
return to userspace after scanning and matching io_bus to see if it has
any overlap too?).  I am not sure if it would ever be used (real
hardware doesn't have multiple devices at the same address), and we can
always have multiple end-points mux from one iosignalfd if we really
need that.  Thoughts?

-Greg




--------------enig02ED220576A8DC3C4853CE94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodKGAACgkQlOSOBdgZUxlw3gCggFdJJobrYcV3ZO6rkJfAgjv3
XLgAoIDwQzVnwk5Ttzw23Ev2pkaVH9gx
=T4Pr
-----END PGP SIGNATURE-----

--------------enig02ED220576A8DC3C4853CE94--
