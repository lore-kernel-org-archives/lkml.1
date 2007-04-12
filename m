Return-Path: <linux-kernel-owner+w=401wt.eu-S965589AbXDLT5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589AbXDLT5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXDLT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:57:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:28484 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965589AbXDLT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J/ZxYyGAeVMmkAG3DvMG1eHahCBzBgiomo/enLrEg618yjBZhAVEx+EgHJ3qKSjTsIR0bIGvqxA8StCEg+x9jTGSCKgOyDrHWmMHyETybxj6ZuCUCb93uwNvcb3sZ+fwKAccu/OWvCMvvdLVuGPSovjRqm0QrGP9d/MT5kfRISY=
Message-ID: <a781481a0704121257v19c82552gac7f60784c7bafa@mail.gmail.com>
Date: Fri, 13 Apr 2007 01:27:22 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Cc: "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
In-Reply-To: <1574.81.207.0.53.1176404759.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4610D25F.7080005@ceid.upatras.gr>
	 <009501c77c22$2b4960f0$0864a8c0@scs1>
	 <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
	 <000401c77cdd$5ef79910$0864a8c0@scs1>
	 <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
	 <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
	 <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
	 <3785.81.207.0.53.1176390072.squirrel@secure.samage.net>
	 <a781481a0704121138x2ecfa5b0lb791dc5680f08515@mail.gmail.com>
	 <1574.81.207.0.53.1176404759.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > There are some other better reasons for the bloat in the GNU MP lib,
> > though. Tasos' code uses the rsa_cipher() as a dual-purpose primitive.
> > Feed it the plaintext (p), public exponent (e) and public modulus (n),
> > and you get the ciphertext (c = p^e mod n). Feed it the ciphertext,
> > private exponent (d) and public modulus, and you get the plaintext (p
> > = c^d mod n) back. All modern RSA implementations, however, prefer
> > preserving the prime numbers (p, q, and their other derivatives such
> > as d mod (p-1), d mod (q-1) and inverse of q modulo p) generated at
> > the time of key generation along with the private exponent as the
> > complete "private key" (this is what is recommended by PKCS#1 too)
> > which enables us to use the chinese remainder theorem to decrypt
> > faster than simply do an (expensive) modulo exponentiation again.
>
> Which, according to the Wikipedia page on RSA, is susceptible to timing
> attacks, which requires measures to counter that (that might be needed in
> Tasos' implementation too though).

Of course, I'd rather code to the PKCS#1 RSA Cryptography Standard
than an entry-level Wikipedia page :-) Timing attacks are particularly
problematic on smart cards (too slow, and with predictable operation
times, if not using constant-time crypto implementations) and not
really worthwhile in practice on any other platform where there's
enough noise around to make accurate timing difficult (that
hyper-threading "vulnerability" discovered some time back comes to
mind). Even so, constant-time crypto implementations do take care of
them, though I agree the GPG code too lacks that.

> > Of course, that would then *force* other users such as modsign to
> > re-implement their own library for their needs again, thus defeating
> > the exercise of merging this bare-bones MPI library into the kernel in
> > the first place, as you have mentioned.
>
> Not if they go the other way round and strip everything except DSA functionality.
> The question is, is an MPI library wanted, or do people just want RSA or DSA?

I do agree that only those parts of an MPI lib that are really needed
by any users must be included. But then we don't want to end up in a
situation where we merge such a small MPI library that code and/or
functionality are being sadly duplicated across users who want
different asymmetric cryptosystems (note the 2 DLMs in mainline, for
example). When we want to support both RSA and DSA, which require a
diverse set of MPI operations and primitives, I don't see how we can
still continue to retain the simplistic and "spartan" RSA-only MPI lib
that this code provides.

Cheers,
S
