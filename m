Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYDDJUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYDDJUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYDDJTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:19:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYDDJTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:19:54 -0400
Date: Fri, 4 Apr 2008 10:19:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080404091949.GE9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org> <20080403013420.GV9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021848140.14670@woody.linux-foundation.org> <20080403015946.GX9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804021950260.14670@woody.linux-foundation.org> <20080403025546.GB9785@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403025546.GB9785@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 03:55:46AM +0100, Al Viro wrote:
> On Wed, Apr 02, 2008 at 07:51:08PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 3 Apr 2008, Al Viro wrote:
> > > 
> > > Um...  But that's _not_ a link-time constant - simply an int variable not
> > > defined in any object file...
> > 
> > Ahh, you're right, my bad. We could change it to take the address of it, 
> > though. I assume gcc is happy with that too?
> 
> gcc might be, but what are you going to do with it?  Expression is an
> integer one, after all - in cases that had triggered that thread it
> was used (after & 0xff) as array index.
> 
> Besides, logically it's _not_ a constant at all - not even a base + constant,
> after using it in such expression...

OK, I think I see how to do it.
	* new bit in ->flags - Weak_Int_Const
	* parser sets it by almost the same rules as Int_Const_Expr, except
that ?:, || and && simply inherit it from the first argument.
	* evaluate strips it in the same cases as Int_Const_Expr, except that
recalculation for ?:, || and && ignores everything except the first argument.
	* when expand sees VALUE && VALUE or VALUE || VALUE and the second
argument is not to be ignored, Weak_Int_Const on node is removed unless the
second argument also had it.
	* when expand sees VALUE ? : and overwrites it with appropriate
branch, have Weak_Int_Const on result iff both the original node and
overwriting argument used to have it.
	* bad_integer_constant_expression() checks either Int_Const_Expr or
Weak_Int_Const, depending on flag set by -W<something>

Should work, AFAICS...  If expression has no Weak_Int_Const out of parser,
it's definitely not an integer constant expression, even with lax rules.
If expression loses Weak_Int_Const on evaluate, we must have a cast to
something other than integer type in it => not an integer constant expression.
If expression loses Weak_Int_Const on expand, we must have found a
subexpression that _might_ be ignored, had not been an integer constant
expression by weak rules and actually was not ignored => not an integer
constant expression.

In no case we could gain Weak_Int_Const and if expand ended up with
EXPR_VALUE and no commas in evaluated subexpressions, having Weak_Int_Const
is equivalent to what we want.

Handling of expr->flags might get a bit clumsy, but other than that it seems
to be easy enough...  Comments?

One thing: behaviour of -Wall is getting more and more unpleasant.  On
kernel builds sparse gets hit with it due to CFLAGS and that kills all
defaults for sparse options.  That -Wall is there for gcc; having it make
sparse to lose all defaults is wrong, especially since gcc does *not*
turn each warning on on that.

For this flag it gets particulary nasty - we have two behaviours (strict
C99 and relaxed one) and the former warns on the things that are OK by
the latter.  So the natural thing to do would be to have -W<something>
to trigger the former, right?  Now think what we'll get on the kernel
build and recall what had started this thread...
