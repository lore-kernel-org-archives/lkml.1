Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXGEQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXGEQ16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbXGEQ1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:27:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbXGEQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:27:48 -0400
Date: Thu, 5 Jul 2007 17:27:41 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ben Elliston <elliston@au1.ibm.com>
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070705162741.GL21478@ftp.linux.org.uk>
References: <200707051403.16789.arnd@arndb.de> <OFC2AA6078.1DF7BE7E-ON4225730F.0044BE34-4225730F.0046B6F1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFC2AA6078.1DF7BE7E-ON4225730F.0044BE34-4225730F.0046B6F1@de.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 02:52:22PM +0200, Ulrich Weigand wrote:
> The Named Address Space extension is documented in chapter 5 of
> Technical Report 18037:
>   ISO/IEC JTC1 SC22 WG14 N1169
>   "Programming languages - C - Extensions to support embedded processors"
>   http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1169.pdf

Humm...  The only syntax for defining address spaces I see there is in
appendix B and frankly, it doesn't look right.  BTW, they forgot to
ban auto struct {<address_space> int x;} y - my preference would be
to ban address_space on struct/union members, but the tastes differ.
In any case, since they prohibit auto <address_space> int z, they'd
better find some approach prohibiting that one.

> We've currently implemented support for one Cell-specific address
> space qualifier according to that syntax.  Before submitting this
> for inclusion in GCC, we're planning to make the implementation
> more general to support arbitrary address space qualifiers;
> something like the sparse "__user" attribute would appear to be
> a natural use case for that syntax extension.
> 
> (CC'ing Ben Elliston, who is working on the GCC front-end
> implementation.)

OK.  AFAICS,
	a) __attribute__ is not an option since it doesn't act as
a qualifier (i.e. won't satisfy the requirements of section 5 in
there).  In constructs like int __attribute__((foo)) *p, attribite
applies to int *, not to int, according to gcc documentation.
	b) we still need noderef, unless implementation provides
some way to tie that to address space itself.
	c) we need some way to declare address spaces that would *not*
be subsets of generic one; rules for pointer conversions allow conversion
from nested address space on assignment and we definitely don't want
that for __user -> generic or __iomem -> generic.
	d) addressmod() doesn't look right for declaration of address space.
Looks like it's a macro anyway (it accepts macros for accessors, so it
can't live after preprocessing phase), so...  what syntax are you using
for declarations?
	e) [IMPORTANT] typeof() behaviour: at the very least, we want
some way to strip __user on typeof().  Even if it turns into a new
primitive (__unqualify__(type)).  gcc typeof leaves qualifiers in place.
We very definitely want a way to have an auto variable declared with
given type sans the address space; think of obvious uses in macros.
If __user et.al. are based on some sparse-only mechanism, we can special-case
them all we want, but if it becomes something gcc would understand...  We
will need the same semantics.
	So we either need gcc typeof() to remove address space qualifier
(IMO unlikely to happen) *or* an independent primitive that would strip
qualifiers from a type, so that with
	typedef const int C;
	typedef int A[2];
we would have
	__unqualify__(const int) => int
	__unqualify__(const int *) => const int * // qualifier inside
	__unqualify__(__user int) => int
	__unqualify__(int __user *) => int __user * // qualifier inside
	__unqualify__(int * __user) => int *
	__unqualify__(C) => int
	__unqualify__(const A) => int[2]
	__unqualify__(const int [2]) => int[2] // same type as in previous

