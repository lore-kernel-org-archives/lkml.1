Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXCGD2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXCGD2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161239AbXCGD2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:28:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161232AbXCGD2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:28:40 -0500
Date: Tue, 6 Mar 2007 19:28:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order()
In-Reply-To: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
Message-ID: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org>
References: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, David Howells wrote:
>  /**
> + * ilog2_up - rounded up log of base 2 of 32-bit or a 64-bit unsigned value
> + * @n - parameter
> + *
> + * constant-capable log of base 2 calculation
> + * - this can be used to initialise global variables from constant data, hence
> + *   the massive ternary operator construction
> + * - the result is rounded up
> + * - the result is undefined when n < 1
> + *
> + * selects the appropriately-sized optimised version depending on sizeof(n)
> + */
> +#define ilog2_up(n) ((n) == 1 ? 0 : ilog2((n) - 1) + 1)

This is wrong. It uses "n" twice, which makes it unsafe as a macro.

It would need to be an inline function, but then the global initializer 
comment is wrong.

Or it could use a "__builtin_constant_p()" (which gcc defines to not have 
side effects) to allow the multiple use for constant data.

Or we could require that "ilog2(0)" returns -1, and then we could just say

	#define ilog2_up(n) (ilog2((n)-1)+1)

Or.. ?

The whole "get_order()" macro also has some serious lack of parenthesis. 
In general, commit 39d61db0edb34d60b83c5e0d62d0e906578cc707 just was 
pretty damn bad!

I'm becoming a bit disgruntled about this whole thing, I have to admit. 
I'm just not sure the bugs here are worth it. Especially considering that 
__get_order() has apparently never even tested these things to begin with, 
since nobody but FRV has ever #defined the ARCH_HAS_ILOG2_U?? macros.

The whole *reason* for that mess seems to be bogus too, since at least 
ia64 still has its own inline "get_order()", which means that nobody can 
use get_order() for constant initializers *anyway*, quite unlike the 
comments say.

So the whole thing is:
 - buggy
 - untested
 - has untrue comments
 - makes no real sense

and I'm inclined to just revert 39d61db0 instead of adding more and more 
breakage to it, since it's simply not going to help with the fundamental 
problems!

		Linus
