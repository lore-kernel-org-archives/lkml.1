Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXDLOU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXDLOU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXDLOUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:20:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:49836 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbXDLOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X2A8SfUVmSNn45GI9whsUEK8/oHUWYf6iyd3yIZGI9TOKRAd3226AYRHYTY+SksEUdSFnaLhvNLHFLZJQWW+bMKkFZ7MHyNJRr1IVT6/JZVX3x5h5uz0aJ8rz4S6X5uZDx9TCpzevIoCjSAbNRYeREIP1qPu3466ipGK0/AZSx0=
Message-ID: <a781481a0704120720y5772cd56y75fff466551a2fda@mail.gmail.com>
Date: Thu, 12 Apr 2007 19:50:51 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Cc: "Tasos Parisinos" <t.parisinos@sciensis.com>,
       "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
In-Reply-To: <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4610D25F.7080005@ceid.upatras.gr> <4610EDF9.9000601@sciensis.com>
	 <4616BC09.2080509@tmr.com>
	 <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
	 <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
	 <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
	 <000401c77cdd$5ef79910$0864a8c0@scs1>
	 <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>
	 <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Firstly, I'd like to steer clear of all the RSA-in-kernel-or-userspace
> > / MPI-in-kernel-or-userspace arguments. True, MPI / RSA / (PKI? that
> > even requires some knowledge of ASN.1 etc to parse certificates) do
> > add a lot of bloat to the kernel. That said, I don't see any other
> > reason to _not_ do asymmetric crypto in the kernel either. In some
> > situations, that in fact simplifies the overall system by avoiding the
> > use of additional userspace components / daemons to do the key
> > management stuff.
>
> Because it can all be done in userspace? Can trap all binary loading from
> user-space too, though that must be done carefully, without changing the
> kernel.

Aarghh ... just the argument I wanted to steer clear of, isn't this?
Continuing, however, we _can_ do a lot of things in userspace, but
still might choose to do them in the kernel, for various reasons in
each case (performance, convenience, application transparency etc
etc). So many things come to mind -- filesystems, readahead, the
cryptoapi itself -- some less controversial, and some more so.

Of course, once an infrastructure is indeed merged into the kernel, it
better already have (or quickly develop) some users for itself. If it
doesn't, it does end up as rot. If it does, that pretty much solves
the maintenance problem there itself.

Getting specific to *this* particular case, I _can_ think of other
users in the kernel that could gladly use general asymmetric crypto
capabilities added to the cryptoapi -- encrypting file systems, module
signing (as of now they've just implemented DSA directly for
themselves, not through the cryptoapi) to name a few.

> > 1. First, sorry, I don't think an RSA implementation not conforming to
> > PKCS #1 qualifies to be called RSA at all. That is definitely a *must*
> > -- why break strong crypto algorithms such as RSA by implementing them
> > in insecure ways?
>
> It's still RSA, that it's not enough to get a complete and secure crypto
> system doesn't mean it isn't RSA anymore. Maybe you're right and having
> RSA without the rest makes no sense. But things like padding schemes change,
> the core RSA algorithm does't, so I think when adding anything that's unused
> by the rest of the kernel it has more chance if it's a low maintenance bare
> RSA implementation.

Well, then *all* the users of the RSA cryptoapi code would end up
duplicating the PKCS padding for themselves! (because if we don't care
about padding in a "low-maintenance-bare-RSA-implementation", then we
might as well not implement any RSA crypto at all :-) Also, padding
schemes are careful cryptographic constructions -- much like ciphers
themselves. Much thought has gone into PKCS#1 over the years (and it's
later revisions). We wouldn't want users to re-invent some kind of
insecure padding for themselves.

The way I think about this is: (1) RSA without PKCS#1 makes no sense,
and (2) PKCS#1 is *defined* only for RSA. Combine (1) and (2), and it
makes *all* sense to encapsulate the two in just one module.

Coming to padding standards, RSA has been around for ~20 years now,
and only 3 PKCS#1 padding schemes were ever defined (at least AFAICR).
That's not something that changes so frequently as to not implement it
in the core RSA code itself, especially when the penalties of not
doing so could be quite embarrassing indeed.

> > 3. Please, try to re-use the MPI library from GnuPG that has already
> > been ported to the kernel -- not the mainline tree, but most
> > distributions such as Red Hat, Fedora, Debian, Suse(?) have maintained
> > an MPI library in crypto/ for the modsign stuff for years now -- that
> > would make your entire RSA module merely a set of wrappers
> > (implementing PKCS#1) to the core modular exponentiation functions in
> > that MPI library. It also contains implementations of optimized
> > algorithms for a lot of the mathematics involved, so you have only to
> > benefit from utilizing a library that has been used, maintained and
> > tested for years.
>
> Right, and that MPI implementation isn't merged. Perhaps a smaller, simpler,
> not complexified by optimisations version has more chance. RSA is damn slow
> anyway, so better to concentrate on other things than speed, IMHO.

If RSA is slow, then optimizing it to make it fast (and thus have more
impact on relative performance) should make *more* sense, shouldn't
it? That MPI implementation is derived from GPG, which has been around
for a decade now. I'd much rather prefer well-known and
well-understood code that has been used, tested and maintained for a
decade than some recent/unused contraption, thank you.

> If you're going to add the full kitchen sink, it might not look that appealing
> anymore, and merging it will become much harder, especially as no one provided
> good arguments why it can't be done in user space.
>
> Perhaps, with that in mind, it's better to not merge the bare RSA version either,
> as it might give false hope for more, because it looks like most implementations
> should be done in user space (either because that's better anyway, or because of
> legal reasons).

Hmmm ... and again I'll excuse myself from the debate whether to
*actually* merge MPI and asymmetric crypto capabilities into the
mainline tree or not -- it's all about whether the potential users
named earlier really want to be able to do all that stuff in-kernel or
wouldn't mind writing userspace components for it.

Cheers,
S
