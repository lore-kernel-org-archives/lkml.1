Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbZFRMKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbZFRMKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZFRMKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:10:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41810 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZFRMKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:10:03 -0400
Message-ID: <4A3A2E90.6090900@novell.com>
Date: Thu, 18 Jun 2009 08:09:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 2/2] KVM: add iosignalfd support
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134235.14362.64014.stgit@dev.haskins.net> <4A3A28DF.5090803@redhat.com>
In-Reply-To: <4A3A28DF.5090803@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDC6C96BB064497E4F34E2722"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDC6C96BB064497E4F34E2722
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/16/2009 04:42 PM, Gregory Haskins wrote:
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
>>
>> +config KVM_MAX_IOSIGNALFD_ITEMS
>> +    int "Maximum IOSIGNALFD items per address"
>> +    depends on KVM
>> +    default "32"
>> +    ---help---
>> +      This option influences the maximum number of fd's per PIO/MMIO
>> +      address that are allowed to register
>> +
>>   =20
>
> Is there a per-vm limit on iosignalfds?  if not, userspace can exhaust
> kernel memory in that way.

Yeah, its already naturally limited by the maximum number of MMIO/PIO
devices we can register (today this is 6 per VM).  I should have
documented that fact somewhere, tho.

>
> We could limit the just total number of iosignafds, it's somewhat more
> natural.
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index daece36..a4b427f 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -12,3 +12,5 @@ config HAVE_KVM_EVENTFD
>>
>>   config KVM_APIC_ARCHITECTURE
>>          bool
>> +
>> +
>>   =20
>
> Spurious, please drop.

Ack

>> +/*
>> + * Design note: We create one PIO/MMIO device (iosignalfd_group) whic=
h
>> + * aggregates  one or more iosignalfd_items.  Each item points to
>> exactly one
>> + * eventfd, and can be registered to trigger on any write to the grou=
p
>> + * (wildcard), or to a write of a specific value.  If more than one
>> item is to
>> + * be supported, the addr/len ranges must all be identical in the
>> group.  If a
>> + * trigger value is to be supported on a particular item, the group
>> range must
>> + * be exactly the width of the trigger.
>> + */
>> +
>> +struct _iosignalfd_item {
>> +    struct list_head     list;
>> +    struct file         *file;
>> +    unsigned char       *match;
>> +    struct rcu_head      rcu;
>> +};
>>   =20
>
> Why not u64 match?

Well, tbh it was primarily because it was starting to make my head hurt
w.r.t. endianness ;).  For instance, if someone wanted a u16 match, I
would presumably have to understand the relevant endianess of the u64 so
I compare the appropriate bytes against the data-register coming in from
the [MM|P]IO.  Using a pointer, I simply copy/memcmp the specified
number of bytes and never have to worry about endianness.

As a minor bonus, item->match =3D=3D NULL tells me its a wildcard.  If I =
had
item->match as a u64, I'd need a different state flag for "wildcard".=20
NBD, but thought I would point it out.

>
>> +static int
>> +iosignalfd_is_match(struct _iosignalfd_group *group,
>> +            struct _iosignalfd_item *item,
>> +            const void *val,
>> +            int len)
>> +{
>> +    if (!item->match)
>> +        /* wildcard is a hit */
>> +        return true;
>> +
>> +    if (len !=3D group->length)
>> +        /* mis-matched length is a miss */
>> +        return false;
>>   =20
>
> Should check length before match (i.e. require correctly sized access).=


Perhaps, but my thinking is that group->length only matters for
data-matching.  You could conceivably have a larger window registered if
you are using all wildcards.  Not sure if this is really useful, but its
the reason the code is that way today.

Thanks Avi,
-Greg



--------------enigDC6C96BB064497E4F34E2722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6LpAACgkQlOSOBdgZUxmaQgCeKrUBpvnNA/GgXBRBdbNLZOGE
aI0Anj/YiC2SO3srMhao69UtSTnqKq/l
=TPsy
-----END PGP SIGNATURE-----

--------------enigDC6C96BB064497E4F34E2722--
