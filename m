Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXDLSih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXDLSih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030654AbXDLSih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:38:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:55101 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030721AbXDLSig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LQv6P8qbKGystRalLRU9BjvWhA/UmYDIQu5qcY6UUD8tOYrGUbBQp3GXXY2pwjeV+4PKK4EHY6z+YLV8ZBMbEiis+9LtQHrVTITcZDxOyhC8IDzoFdI3G5cnqqwrY5so8PYYcFqmGtHCIwjrKljZhDa+E9I8HpqeTAvDwp9QUo8=
Message-ID: <a781481a0704121138x2ecfa5b0lb791dc5680f08515@mail.gmail.com>
Date: Fri, 13 Apr 2007 00:08:34 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Cc: "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
In-Reply-To: <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4610D25F.7080005@ceid.upatras.gr>
	 <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
	 <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
	 <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
	 <000401c77cdd$5ef79910$0864a8c0@scs1>
	 <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
	 <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
	 <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
	 <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Indan,

On 4/12/07, Indan Zupancic <indan@nul.nu> wrote:
> I prefer clear, simple code that is easily audited to be correct or at least
> not cause problems, which is small enough to not add much bloat. I don't care
> about "very slow" or merely "slow" code. RSA/DSA isn't used as a symmetric block
> cipher, where it does make sense to optimize it to death.
>
> From the kernel's point of view it's all new and unused code, so it should be
> judged by its quality, not by its heritage.

Agreed, the GPG MPI library *is* significantly larger -- I'm looking
at the Fedora 4 kernel source here and their crypto/mpi/ comes to
about 5000 lines (not including comments). But there are reasons for
this -- they export far too many MPI operations. I suspect they just
ported the *entire* GNU MP lib.

For example, there's crypto/mpi/longlong.h, worth 1500 lines of
ugliness in itself. I see arch-specific assembly there for processors
that Linux doesn't even support. Wow.

There are some other better reasons for the bloat in the GNU MP lib,
though. Tasos' code uses the rsa_cipher() as a dual-purpose primitive.
Feed it the plaintext (p), public exponent (e) and public modulus (n),
and you get the ciphertext (c = p^e mod n). Feed it the ciphertext,
private exponent (d) and public modulus, and you get the plaintext (p
= c^d mod n) back. All modern RSA implementations, however, prefer
preserving the prime numbers (p, q, and their other derivatives such
as d mod (p-1), d mod (q-1) and inverse of q modulo p) generated at
the time of key generation along with the private exponent as the
complete "private key" (this is what is recommended by PKCS#1 too)
which enables us to use the chinese remainder theorem to decrypt
faster than simply do an (expensive) modulo exponentiation again.

Also, DSA signature generation and verification (which is what the
modsign guys use) doesn't exactly utilize the same MPI operations as
RSA does. If we really don't care about speed and DSA, we could strip
that library down to the basic and RSA-only operations Tasos' code
provides, and I'm quite sure we'd end up somewhere close to 1000 lines
there too.

Of course, that would then *force* other users such as modsign to
re-implement their own library for their needs again, thus defeating
the exercise of merging this bare-bones MPI library into the kernel in
the first place, as you have mentioned.

> I know you didn't want to talk about the user versus kernel space question,
> but I think it's a very important and interesting one. As you said, GPG is
> there around for years and tested, why making a new implementation in the kernel?
> Your argument holds for the whole as much as for parts of the infrastructure.
[...]
> And whether they can agree on a common implementation. If they all just want to do
> their own thing, and not combine resources, then it doesn't make any sense to merge
> anything at all, as it would be ignored anyway.

Yes, that "common implementation" bit is definitely crucial, which is
why merging a solid, feature-rich and fast MPI library could become
all the more important, in my opinion.

> As for the userspace issue, I get the impression that they didn't consider it very
> well, ignoring things like initramfs versus main filesystem and so on. It's also a
> gradual thing, some things can be done best in the kernel, and others in user space.
> Another alternative is to push it up into the boot loader. ;-)

Very true, it does make sense to explore userspace possibilities first.

Cheers,
S

> Greetings,
>
> Indan
