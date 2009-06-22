Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZFVNE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZFVNE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFVNEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:04:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:19671 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZFVNEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=BnU7nSGaeZWXlGk1hdVJv+7qBXdrTwAviDk4VAlWiC/HVI+7e9566YD8ShSkT8bdez
         eG52TNWAgP9fpHf+lfAWARmUKf6/j+xO/KZdPFkq1iZr9zAbtcNCuSYRNmjHmssBMwn6
         SJcXJ7ySA5UoYdA+ciMAZ5aMdJpgE2CNNUuFI=
Message-ID: <4A3F8170.7000508@gmail.com>
Date: Mon, 22 Jun 2009 09:04:48 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com>
In-Reply-To: <20090622123022.GC12867@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig59326621C7BF12277D4A1185"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59326621C7BF12277D4A1185
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sorry, Michael.  I missed that you had other comments after the
grammatical one.  Will answer inline

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 08:13:48AM -0400, Gregory Haskins wrote:
>  =20
>>>> + * notification when the memory has been touched.
>>>> + * ----------------------------------------------------------------=
----
>>>> + */
>>>> +
>>>> +/*
>>>> + * Design note: We create one PIO/MMIO device (iosignalfd_group) wh=
ich
>>>> + * aggregates  one or more iosignalfd_items.  Each item points to e=
xactly one
>>>>        =20
>                    ^^                             ^^
>  =20
>>>> + * eventfd, and can be registered to trigger on any write to the gr=
oup
>>>> + * (wildcard), or to a write of a specific value.  If more than one=
 item is to
>>>>        =20
>                                                        ^^
>  =20
>>>> + * be supported, the addr/len ranges must all be identical in the g=
roup.  If a
>>>>        =20
>                                                                        =
       ^^
>  =20
>>>> + * trigger value is to be supported on a particular item, the group=
 range must
>>>> + * be exactly the width of the trigger.
>>>>    =20
>>>>        =20
>>> Some duplicate spaces in the text above, apparently at random places.=

>>>
>>>  =20
>>>      =20
>> -ENOPARSE ;)
>>
>> Can you elaborate?
>>    =20
>
>
> Marked with ^^
>
>  =20
>>>> + */
>>>> +
>>>> +struct _iosignalfd_item {
>>>> +	struct list_head     list;
>>>> +	struct file         *file;
>>>> +	u64                  match;
>>>> +	struct rcu_head      rcu;
>>>> +	int                  wildcard:1;
>>>> +};
>>>> +
>>>> +struct _iosignalfd_group {
>>>> +	struct list_head     list;
>>>> +	u64                  addr;
>>>> +	size_t               length;
>>>> +	size_t               count;
>>>> +	struct list_head     items;
>>>> +	struct kvm_io_device dev;
>>>> +	struct rcu_head      rcu;
>>>> +};
>>>> +
>>>> +static inline struct _iosignalfd_group *
>>>> +to_group(struct kvm_io_device *dev)
>>>> +{
>>>> +	return container_of(dev, struct _iosignalfd_group, dev);
>>>> +}
>>>> +
>>>> +static void
>>>> +iosignalfd_item_free(struct _iosignalfd_item *item)
>>>> +{
>>>> +	fput(item->file);
>>>> +	kfree(item);
>>>> +}
>>>> +
>>>> +static void
>>>> +iosignalfd_item_deferred_free(struct rcu_head *rhp)
>>>> +{
>>>> +	struct _iosignalfd_item *item;
>>>> +
>>>> +	item =3D container_of(rhp, struct _iosignalfd_item, rcu);
>>>> +
>>>> +	iosignalfd_item_free(item);
>>>> +}
>>>> +
>>>> +static void
>>>> +iosignalfd_group_deferred_free(struct rcu_head *rhp)
>>>> +{
>>>> +	struct _iosignalfd_group *group;
>>>> +
>>>> +	group =3D container_of(rhp, struct _iosignalfd_group, rcu);
>>>> +
>>>> +	kfree(group);
>>>> +}
>>>> +
>>>> +static int
>>>> +iosignalfd_group_in_range(struct kvm_io_device *this, gpa_t addr, i=
nt len,
>>>> +			  int is_write)
>>>> +{
>>>> +	struct _iosignalfd_group *p =3D to_group(this);
>>>> +
>>>> +	return ((addr >=3D p->addr && (addr < p->addr + p->length)));
>>>> +}
>>>>    =20
>>>>        =20
>>> What does this test? len is ignored ...
>>>
>>>  =20
>>>      =20
>> Yeah, I was following precedent with other IO devices.  However, this
>> *is* sloppy, I agree.  Will fix.
>>
>>    =20
>>>> +
>>>> +static int
>>>>    =20
>>>>        =20
>>> This seems to be returning bool ...
>>>  =20
>>>      =20
>> Ack
>>    =20
>>>  =20
>>>      =20
>>>> +iosignalfd_is_match(struct _iosignalfd_group *group,
>>>> +		    struct _iosignalfd_item *item,
>>>> +		    const void *val,
>>>> +		    int len)
>>>> +{
>>>> +	u64 _val;
>>>> +
>>>> +	if (len !=3D group->length)
>>>> +		/* mis-matched length is always a miss */
>>>> +		return false;
>>>>    =20
>>>>        =20
>>> Why is that? what if there's 8 byte write which covers
>>> a 4 byte group?
>>>  =20
>>>      =20
>> v7 and earlier used to allow that for wildcards, actually.   It of
>> course would never make sense to allow mis-matched writes for
>> non-wildcards, since the idea is to match the value exactly.  However,=

>> the feedback I got from Avi was that we should make the wildcard vs
>> non-wildcard access symmetrical and ensure they both conform to the si=
ze.
>>    =20
>>>  =20
>>>      =20
>>>> +
>>>> +	if (item->wildcard)
>>>> +		/* wildcard is always a hit */
>>>> +		return true;
>>>> +
>>>> +	/* otherwise, we have to actually compare the data */
>>>> +
>>>> +	if (!IS_ALIGNED((unsigned long)val, len))
>>>> +		/* protect against this request causing a SIGBUS */
>>>> +		return false;
>>>>    =20
>>>>        =20
>>> Could you explain what this does please?
>>>  =20
>>>      =20
>> Sure:  item->match is a fixed u64 to represent all group->length
>> values.  So it might have a 1, 2, 4, or 8 byte value in it.  When I
>> write arrives, we need to cast the data-register (in this case
>> represented by (void*)val) into a u64 so the equality check (see [A],
>> below) can be done.  However, you can't cast an unaligned pointer, or =
it
>> will SIGBUS on many (most?) architectures.
>>    =20
>
> I mean guest access. Does it have to be aligned?
>  =20

In order to work on arches that require alignment, yes.  Note that I
highly suspect that the pointer is already aligned anyway.  My
IS_ALIGNED check is simply for conservative sanity.
> You could memcpy the value...
>  =20

Then you get into the issue of endianness and what pointer to use.  Or
am I missing something?

>  =20
>>> I thought misaligned accesses are allowed.
>>>  =20
>>>      =20
>> If thats true, we are in trouble ;)
>>    =20
>
> I think it works at least on x86:
> http://en.wikipedia.org/wiki/Packed#x86_and_x86-64
>  =20

Right, understood.  What I meant specifically is that if the (void*)val
pointer is allowed to be misaligned we are in trouble ;).  I haven't
studied the implementation in front of the MMIO callback recently, but I
generally doubt thats the case.  More than likely this is some buffer
that was kmalloced and that should already be aligned to the machine word=
=2E

Kind Regards,
-Greg


--------------enig59326621C7BF12277D4A1185
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/gXAACgkQP5K2CMvXmqEPfQCghMA7+XXTzj5aVaScDsWGi/Wy
RY0An3RNw6ksbRiDlS1Fj0OQitAWDKX/
=jzqE
-----END PGP SIGNATURE-----

--------------enig59326621C7BF12277D4A1185--
