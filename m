Return-Path: <linux-kernel-owner+w=401wt.eu-S1764604AbZFROJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764604AbZFROJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763904AbZFROJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:09:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51083 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764409AbZFROJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:09:07 -0400
Message-ID: <4A3A4A7D.8050406@novell.com>
Date: Thu, 18 Jun 2009 10:09:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 2/2] KVM: add iosignalfd support
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134235.14362.64014.stgit@dev.haskins.net> <4A3A28DF.5090803@redhat.com> <4A3A2E90.6090900@novell.com> <4A3A315A.5090204@redhat.com>
In-Reply-To: <4A3A315A.5090204@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig043EB699B6EFA58429E7BBB0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig043EB699B6EFA58429E7BBB0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/18/2009 03:09 PM, Gregory Haskins wrote:
>>>> +config KVM_MAX_IOSIGNALFD_ITEMS
>>>> +    int "Maximum IOSIGNALFD items per address"
>>>> +    depends on KVM
>>>> +    default "32"
>>>> +    ---help---
>>>> +      This option influences the maximum number of fd's per PIO/MMI=
O
>>>> +      address that are allowed to register
>>>> +
>>>>
>>>>       =20
>>> Is there a per-vm limit on iosignalfds?  if not, userspace can exhaus=
t
>>> kernel memory in that way.
>>>     =20
>>
>> Yeah, its already naturally limited by the maximum number of MMIO/PIO
>> devices we can register (today this is 6 per VM).  I should have
>> documented that fact somewhere, tho.
>>   =20
>
> We need to raise this limit drastically and to expose it.

Any suggestions on a target #?  512?

>   I suggest counting an all iosignalfd_items as part of the iodevice
> limit, so we don't have a bunch of little limits which no one
> understands.
Yeah, I like this idea.

>
>>>> +struct _iosignalfd_item {
>>>> +    struct list_head     list;
>>>> +    struct file         *file;
>>>> +    unsigned char       *match;
>>>> +    struct rcu_head      rcu;
>>>> +};
>>>>
>>>>       =20
>>> Why not u64 match?
>>>     =20
>>
>> Well, tbh it was primarily because it was starting to make my head hur=
t
>> w.r.t. endianness ;).  For instance, if someone wanted a u16 match, I
>> would presumably have to understand the relevant endianess of the u64 =
so
>> I compare the appropriate bytes against the data-register coming in fr=
om
>> the [MM|P]IO.  Using a pointer, I simply copy/memcmp the specified
>> number of bytes and never have to worry about endianness.
>>   =20
>
> No, a u16 will naturally expand to a u64, and the emulator will
> generate the correct value.

Right, I understand that part.  What I mean specifically is at run-time
when the IO comes in.  I was thinking I would need to do a memcmp
against the u64 and the data-register and it was hurting my head trying
to figure out what pointer to pass to memcmp.

<lightbulb turns on>

Duh, I can just load the data-register into a u64 and check equality.=20
Nevermind, I am a dumbass ;)

>   As long as we don't allow mismatched access sizes, we should be fine.=

>
>> As a minor bonus, item->match =3D=3D NULL tells me its a wildcard.  If=
 I had
>> item->match as a u64, I'd need a different state flag for "wildcard".
>> NBD, but thought I would point it out.
>>   =20
>
> True, a pointer also supplies extra information.  But until we get
> garbage collection as part of the Java rewrite, resource management is
> a pain and I prefer as few pointers as possible.

Oh man!  And I was so looking forward to that rewrite.....

>
>>>> +static int
>>>> +iosignalfd_is_match(struct _iosignalfd_group *group,
>>>> +            struct _iosignalfd_item *item,
>>>> +            const void *val,
>>>> +            int len)
>>>> +{
>>>> +    if (!item->match)
>>>> +        /* wildcard is a hit */
>>>> +        return true;
>>>> +
>>>> +    if (len !=3D group->length)
>>>> +        /* mis-matched length is a miss */
>>>> +        return false;
>>>>
>>>>       =20
>>> Should check length before match (i.e. require correctly sized access=
).
>>>     =20
>>
>> Perhaps, but my thinking is that group->length only matters for
>> data-matching.  You could conceivably have a larger window registered =
if
>> you are using all wildcards.  Not sure if this is really useful, but i=
ts
>> the reason the code is that way today.
>>   =20
>
> My thinking is to have the code behave the same way.  If you require
> matching lengths on data match, require it on wildcard as well.

Ack

Thanks Avi,
-Greg



--------------enig043EB699B6EFA58429E7BBB0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6Sn0ACgkQlOSOBdgZUxnmfACdFCRMWjpE6zvaO4dASqWqgc5+
7zEAnjdOYtx3hGB09rXzPtWSm85avcQw
=ACfb
-----END PGP SIGNATURE-----

--------------enig043EB699B6EFA58429E7BBB0--
