Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYDDSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYDDSnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYDDSnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:43:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44255 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYDDSnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:43:00 -0400
Date: Fri, 4 Apr 2008 19:42:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Derek M Jones <derek@knosof.co.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080404184221.GF9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403024117.GZ9785@ZenIV.linux.org.uk> <47F53E84.8080607@freedesktop.org> <20080404011951.GC9785@ZenIV.linux.org.uk> <47F63641.4090103@knosof.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F63641.4090103@knosof.co.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 03:08:01PM +0100, Derek M Jones wrote:
> >	* typedef *can* be variably-modified, but only in block scope.
> >Warning: this can get sticky for us - all sizes are evaluated when
> >typedef is reached.  IOW,
> >	typedef int a[n];
> >	a x;
> >	if (n++ == 5) {
> >		a y;
> >		int z[n];
> >	}
> >will have size of y equal to that of x, but *not* equal to that of z.
> 
> An opportunity for Sparse to issue a warning :-)

Not without data flow analysis, and sparse really doesn't do that class
of checks...

> Any side effect appearing in a sizeof operand ought to be flagged.
> There are people out there who think that the side effects occur (even
> in C90).

Not by default it shouldn't; it's about the only way to do polymorphic
typechecking a-la "this argument of macro is a function pointer and
that argument could be legitimately passed to it", etc.
 
> Sentence 1122: http://c0x.coding-guidelines.com/6.5.3.4.html
> "If the type of the operand is a variable length array type, the operand 
> is evaluated;"
> 
> But watch out for sentence 1584: 
> http://c0x.coding-guidelines.com/6.7.5.2.html
> "Where a size expression is part of the operand of a sizeof operator and
> changing the value of the size expression would not affect the result of
> the operator, it is unspecified whether or not the size expression is
> evaluated."

Dealt with below, but note that the wording in 6.7.5.2 is lousy: as stated
it covers not only intended sizeof(VM) with side effects in size expressions,
but sizeof(sizeof(int [n++])) as well, which certainly should *not* be
unspecified - the n++ is a part of operand of outer sizeof and it does not
affect its value (it's sizeof(size_t)), but it certainly should _not_ be
evaluated at all since the entire argument of the outer sizeof should not
be evaluated.

AFAICS, intended rules are:
	sizeof(expression of non-VLA type): constant, argument not evaluated
	sizeof(expression of VLA type): constant, argument evaluated
	sizeof(non-VM type): constant
	sizeof(VM type): unspecified whether all size expressions are evaluated

> This language feature came about because at least one vendor on the
> WG14 committee had a compiler that optimized away subexpressions
> within a sizeof that did not contribute to the result of the
> evaluation.  My attempt to stop the behavior being unspecified
> did not succeed :-(

The really interesting question is what the hell did gcc folks intend for
their ({ ... }) and typeof extensions...  Well, aside of "some cases
when ({ ... }) would result in VM type are clearly undefined behaviour" ;-/

BTW, I wish somebody would have come up with a sane set of type-surgery
primitives...  Part of that can be emulated with typeof, but you don't get
"turn qualified-type into type" and "give the type of Nth argument of
function type" that way.
