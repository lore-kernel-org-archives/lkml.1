Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZFEVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZFEVWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFEVWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:22:33 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:58833 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZFEVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:22:33 -0400
Date: Fri, 5 Jun 2009 23:24:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
Message-ID: <20090605212448.GA23871@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <20090604125306.GC24491@flint.arm.linux.org.uk> <20090604201649.GC13892@uranus.ravnborg.org> <20090605204805.GA22367@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605204805.GA22367@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 09:48:06PM +0100, Russell King wrote:
> On Thu, Jun 04, 2009 at 10:16:49PM +0200, Sam Ravnborg wrote:
> > On Thu, Jun 04, 2009 at 01:53:07PM +0100, Russell King wrote:
> > > On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > > > fix the following 'make headers_check' warning:
> > > 
> > > I think headers_check needs fixing - there's nothing wrong with the
> > > code as it presently stands except the tools obviously can't properly
> > > parse C preprocessor statements.
> > 
> > You are correct that headers_ceck is limited here and this patch
> > take some valid code and refactor it to make it headers_check compatible.
> 
> Okay, here's the question:
> 
> Does userspace require anything in the ifdef __ASSEMBLY__ bits?
> 
> In any case, passing -D__KERNEL__ or -U__KERNEL__ allows unifdef to
> do the right thing.
> 
> The problem which unifdef has is that if it finds a symbol in an
> evaluation that it doesn't know about, it fails the expansion
> entirely, rather than checking whether the expansion always results
> in something which should be omitted.  In other words:
> 
> #if defined(__KERNEL__) && (<unknown>)
> 
> results in basically an "unknown" answer from the evaluator, where
> we can see perfectly well that the expansion can never be true if
> __KERNEL__ is never set.
> 
> So, the trivial answer to the problem if:
> 
> #if defined(__KERNEL__) && something-depending-on-__ASSEMBLY__
> 
> is to tell unifdef whether we want __ASSEMBLY__ defined or not defined.
> This does shut up the headers_install warning from ARMs hwdef.h.

That would help this onn - right.
But we have 12 other places in include/linux and 2 other places in arch/arm/include/asm
that uses this construct.

So to me this is simple a matter of:
1) add a number of specific -Dxxx to unifdef to silence those warnings
2) simplify the logic in a few places
3) fix unifdef (or use somethign better)

If I had better time I had rewritten unifdef long time ago.
And of 1) or 2) I so far has used option 2) to avoid an endless
list of config entries.

If someone uses an expression that unifdef does not cope with then
the worst things that happens is that we export a piece
of useless stuff to userspace (they never see it) and in a few cases
we spit out false warnign as in this case.

Adding only -U__ASSEMBLY__ is fine by me.
But adding all the others are not OK and here I request the simplified
logic.

	Sam


> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
