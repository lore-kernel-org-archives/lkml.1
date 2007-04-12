Return-Path: <linux-kernel-owner+w=401wt.eu-S1945948AbXDLJfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945948AbXDLJfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945951AbXDLJfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:35:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:51542 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945948AbXDLJfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=th3aGLjKTgor6huccbA/ElYJHbvTxbjhrKt/bMQb11rpwVcA9seim/vpsymbH6EYkrOek+WDFsWXgbn3zIOtScxry1FKK/ZR787vj4hDdmq7ZetPRisOy34NyC32BYn9bMaVj34DApelhuezRshtMKY/MlcDp2DAMxCcYBArKCQ=
Message-ID: <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
Date: Thu, 12 Apr 2007 15:05:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tasos Parisinos" <t.parisinos@sciensis.com>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Cc: "Indan Zupancic" <indan@nul.nu>, "Bill Davidsen" <davidsen@tmr.com>,
       "Andi Kleen" <andi@firstfloor.org>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
In-Reply-To: <000401c77cdd$5ef79910$0864a8c0@scs1>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de>
	 <4610EDF9.9000601@sciensis.com> <4616BC09.2080509@tmr.com>
	 <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
	 <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
	 <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
	 <000401c77cdd$5ef79910$0864a8c0@scs1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> I understand and i agree, thing is that i dont decide about which parts are given GPL.
> While the RSA module is given standalone, it can be still used by others to develop
> their own signing and authenticating mechanisms. For example some will decide to do
> hashing of code with md5 while others with sha1 and some will do padding compliant
> with pkcs1 other will implement other schemas e.t.c. I want to say although this is not
> really ready to be used for binary signing, it has the advantage to provide basic functionality
> and freedom to other developers to implement their own schemas.

Firstly, I'd like to steer clear of all the RSA-in-kernel-or-userspace
/ MPI-in-kernel-or-userspace arguments. True, MPI / RSA / (PKI? that
even requires some knowledge of ASN.1 etc to parse certificates) do
add a lot of bloat to the kernel. That said, I don't see any other
reason to _not_ do asymmetric crypto in the kernel either. In some
situations, that in fact simplifies the overall system by avoiding the
use of additional userspace components / daemons to do the key
management stuff.

I do have some comments on the submitted patch, though:

1. First, sorry, I don't think an RSA implementation not conforming to
PKCS #1 qualifies to be called RSA at all. That is definitely a *must*
-- why break strong crypto algorithms such as RSA by implementing them
in insecure ways? It shouldn't be too difficult for you to add, and
you _can_ still allow the user to choose the appropriate padding
scheme by taking it as an argument to the encrypt / decrypt API
functions (some possibilities I can think of are PKCS#1 v1.5 padding,
v2.0 i.e. OAEP padding, or null padding).

2. Of course, you can forget about what digest was used to compute the
plaintext input to RSA. We don't really care, as RSA should never be
used to operate on multiple blocks anyway and no real-world hybrid
cryptosystem uses it in such a way either. (RSA could be thought of as
a block cipher of block size == modulus size)

3. Please, try to re-use the MPI library from GnuPG that has already
been ported to the kernel -- not the mainline tree, but most
distributions such as Red Hat, Fedora, Debian, Suse(?) have maintained
an MPI library in crypto/ for the modsign stuff for years now -- that
would make your entire RSA module merely a set of wrappers
(implementing PKCS#1) to the core modular exponentiation functions in
that MPI library. It also contains implementations of optimized
algorithms for a lot of the mathematics involved, so you have only to
benefit from utilizing a library that has been used, maintained and
tested for years.

4. Anything in crypto/ belongs to the CryptoAPI. You definitely need
to integrate with it.
