Return-Path: <linux-kernel-owner+w=401wt.eu-S1763987AbZAOKz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763987AbZAOKz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762307AbZAOKzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:55:03 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53111 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755694AbZAOKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:55:00 -0500
Date: Thu, 15 Jan 2009 11:54:53 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
In-Reply-To: <20090115030526.GA27726@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.00.0901151149080.16463@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Herbert,

On Thu, 15 Jan 2009, Herbert Xu wrote:
> On Wed, Jan 14, 2009 at 04:01:34PM +0100, Geert Uytterhoeven wrote:
> > It's used by the pr_*() macros in <linux/kernel.h>.
> > 
> > Since commit d091c2f58ba32029495a933b721e8e02fbd12caa ("Add 'pr_fmt()' format
> > modifier to pr_xyz macros."), this is the new way to have a common prefix in
> > all printed output.
> 
> But you don't actually print anything out in the module :)

But there are pr_debug()s ;-)

> > For compatibility with crypto_comp, we also need an alloc function for both
> > compress and decompress, so that makes 3 alloc functions.
> 
> Couldn't crypto_comp just call both alloc functions? I don't see
> why we need a third function.
> 
> > > 1) We know what the user wants to do without every algorithm
> > > reinventing their own signalling for it;
> > 
> > I guess you want to use the flags to indicate compress/decompress/both?
> > Unfortunately I'm still struggling to fully understand the type/mask handling,
> > so I would appreciate it if you could give me a hint how to handle that.
> 
> No, I mean that whether you want compression or decompression
> is signified by the which function you're calling.  If you want
> to do both then you call both.

By "both alloc function", do you mean the .setup_comp() and .setup_decomp()
functions? If yes, then I understand.

(Yesterday, I thought you meant to have separate alloc functions instead of the
one crypto_alloc_pcomp())

> > I assume "length" is the size of the passed params, so the algorithms can
> > return -EINVAL if they're passed the wrong size?
> 
> Well with the netlink parameters these can have variable lengths
> depending on how many parameters the user supplies.

IC.

> > > > +static inline struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name,
> > > > +						      u32 type, u32 mask)
> > > > +{
> > > > +	type &= ~CRYPTO_ALG_TYPE_MASK;
> > > > +	type |= CRYPTO_ALG_TYPE_PCOMPRESS;
> > > > +	mask |= CRYPTO_ALG_TYPE_MASK;
> > > > +
> > > > +	return __crypto_pcomp_cast(crypto_alloc_base(alg_name, type, mask));
> > > > +}
> > > 
> > > That's the old way to allocate tfm's which won't work since pcomp
> > > is using the new type API.  You should do it the way that shash
> > > does it.
> > 
> > I tried to do this, but stumbled across a dependency problem: as
> > crypto_alloc_tfm() needs a pointer to crypto_pcomp_type(), crypto_alloc_pcomp()
> > can no longer be static inline, and must be moved to crypto/pcompress.c.
> 
> Ah yes because crypto_comp is one of the original types that's
> still built-in.  Because there are so few compression users and
> algorithms (exactly 3 if you include null compression), I think
> we can dispense with the compatibility stuff altogether since
> we'll likely rip out fairly soon anyway.
> 
> So just create the new type, readd deflate using the new type
> alongside the existing deflate algorithm.  The system is capable
> of supporting two algorithms of the same name with different types.
> 
> Then once the other algorithm (lzo) is taken care of and all the
> users are converted I'll just kill the old type and algorithms.

I doubt whether it's a good idea to drop the compatibility soon, as the
underlying LZO library in the kernel doesn't support partial (de)compression,
and needs significant rework to do so.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
