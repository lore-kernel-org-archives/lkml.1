Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZEEOO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZEEOO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZEEOOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:14:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:59891 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbZEEOOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=suFr2L2dEHpk0JbxTyjzAwPVAeijjsFVvadLS7MeoMPsXe9SmvyF2kblbL6PhsFqaz
         eN/UWLj72XywYzBFN8MC6kcL/hmGUiPOnE00XlrlWVG3ZzlUp65Crq8IC72lbCVJ9VUo
         g6NPwPVaZbZdNCCB0li/ZFXqYuDxN9PMj1KuE=
Message-ID: <4A0049CD.3080003@gmail.com>
Date: Tue, 05 May 2009 10:14:37 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com>
In-Reply-To: <4A004676.4050604@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig19A9756A8B21243C580D9911"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig19A9756A8B21243C580D9911
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Avi Kivity wrote:
>> =20
>>> Gregory Haskins wrote:
>>>   =20
>>>> (Applies to Linus' tree, b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a)
>>>>
>>>> Please see patch 1/3 for a description.  This has been tested with
>>>> a KVM
>>>> guest on x86_64 and appears to work properly.  Comments, please.
>>>>        =20
>>> What about the hypercalls in include/asm/kvm_para.h?
>>>
>>> In general, hypercalls cannot be generic since each hypervisor
>>> implements its own ABI.
>>>    =20
>> Please see the prologue to 1/3.  Its all described there, including a
>> use case which I think answers your questions.  If there is still
>> ambiguity, let me know.
>>
>>  =20
>
> Yeah, sorry.
>
>>>   The abstraction needs to be at a higher level (pv_ops is such a
>>> level).
>>>    =20
>> Yep, agreed.  Thats exactly what this series is doing, actually.
>>  =20
>
> No, it doesn't.  It makes "making hypercalls" a pv_op, but hypervisors
> don't implement the same ABI.
Yes, that is true, but I think the issue right now is more of
semantics.  I think we are on the same page.

So you would never have someone making a generic
hypercall(KVM_HC_MMU_OP).  I agree.  What I am proposing here is more
akin to PIO-BAR + iowrite()/ioread().  E.g. the infrastructure sets up
the "addressing" (where in PIO this is literally an address, and for
hypercalls this is a vector), but the "device" defines the ABI at that
address.  So its really the "device end-point" that is defining the ABI
here, not the hypervisor (per se) and thats why I thought its ok to
declare these "generic".  But to your point below...

>
> pv_ops all _use_ hypercalls to implement higher level operations, like
> set_pte (probably the only place set_pte can be considered a high
> level operation).
>
> In this case, the higher level event could be
> hypervisor_dynamic_event(number); each pv_ops implementation would use
> its own hypercalls to implement that.

I see.  I had designed it slightly different where KVM could assign any
top level vector it wanted and thus that drove the guest-side interface
you see here to be more "generic hypercall".  However, I think your
proposal is perfectly fine too and it makes sense to more narrowly focus
these calls as specifically "dynamic"...as thats the only vectors that
we could technically use like this anyway.

So rather than allocate a top-level vector, I will add "KVM_HC_DYNAMIC"
to kvm_para.h, and I will change the interface to follow suit (something
like s/hypercall/dynhc).  Sound good?

Thanks, Avi,
-Greg



--------------enig19A9756A8B21243C580D9911
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoASc0ACgkQP5K2CMvXmqHTsgCeOflhi6vpcOaitYv/JMnsFBSn
+0QAn1FWMiwd+w5Xw4Wu7/b+T54GA4NL
=LVrH
-----END PGP SIGNATURE-----

--------------enig19A9756A8B21243C580D9911--
