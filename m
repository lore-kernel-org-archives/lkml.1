Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbZEGUbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbZEGUbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZEGUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:31:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:18674 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZEGUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=tc+DzdmXyDdnYOrs4LeRRgMXvYSUNW3yjaUAXQudNa6IQFvb7kJDeu7Yd23lWKkMbU
         Ix9Y/DheuBIHvJqBzaSyE8vKLI2BzquDbPvsLjt6QpWgqNeMMwxW9DyVNw3ABQUyUgYG
         H6u20i1DXmOcxxuLsLH4tHnn3d1teDmFoTmls=
Message-ID: <4A03451E.9020304@gmail.com>
Date: Thu, 07 May 2009 16:31:26 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <200905072200.22007.arnd@arndb.de>
In-Reply-To: <200905072200.22007.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC81C27DA6E2085C3BB199673"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC81C27DA6E2085C3BB199673
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann wrote:
> On Thursday 07 May 2009, Gregory Haskins wrote:
>  =20
>> I guess technically mmio can just be a simple access of the page which=

>> would be problematic to trap locally without a PF.  However it seems
>> that most mmio always passes through a ioread()/iowrite() call so this=

>> is perhaps the hook point.  If we set the stake in the ground that mmi=
os
>> that go through some other mechanism like PFs can just hit the "slow
>> path" are an acceptable casualty, I think we can make that work.
>>
>> Thoughts?
>>    =20
>
> An mmio that goes through a PF is a bug, it's certainly broken on
> a number of platforms, so performance should not be an issue there.
>  =20

This may be my own ignorance, but I thought a VMEXIT of type "PF" was
how MMIO worked in VT/SVM.  I didn't mean to imply that the guest nor
the host took a traditional PF exception in their respective IDT, if
that is what you thought I meant here.  Rather, the mmio region is
unmapped in the guest MMU, access causes a VMEXIT to host-side KVM of
type PF, and the host side code then consults the guest page-table to
see if its an MMIO or not.  I could very well be mistaken as I have only
a cursory understanding of what happens in KVM today with this path.

After posting my numbers today, what I *can* tell you definitively that
its significantly slower to VMEXIT via MMIO.  I guess I do not really
know the reason for sure. :)
> Note that are four commonly used interface classes for PIO/MMIO:
>
> 1. readl/writel: little-endian MMIO
> 2. inl/outl: little-endian PIO
> 3. ioread32/iowrite32: converged little-endian PIO/MMIO
> 4. __raw_readl/__raw_writel: native-endian MMIO without checks
>
> You don't need to worry about the __raw_* stuff, as this should never
> be used in device drivers.
>
> As a simplification, you could mandate that all drivers that want to
> use this get converted to the ioread/iowrite class of interfaces and
> leave the others slow.
>  =20

I guess the problem that was later pointed out is that we cannot discern
which devices might be pass-through and therefore should not be
revectored through a HC.  But I am even less knowledgeable about how
pass-through works than I am about the MMIO traps, so I might be
completely off here.

In any case, thank you kindly for the suggestions.

Regards,
-Greg


--------------enigC81C27DA6E2085C3BB199673
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDRR4ACgkQP5K2CMvXmqHrhwCfb5whRE0W+Va24k032HC/hNHN
O7cAniRuxDvbAK5CDeEJmkAniz5z72CT
=G8i1
-----END PGP SIGNATURE-----

--------------enigC81C27DA6E2085C3BB199673--
