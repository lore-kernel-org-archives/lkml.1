Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbXCGLni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbXCGLni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXCGLni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:43:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbXCGLnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:43:37 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org> 
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org>  <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 07 Mar 2007 11:43:06 +0000
Message-ID: <8543.1173267786@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > +#define ilog2_up(n) ((n) == 1 ? 0 : ilog2((n) - 1) + 1)
> 
> This is wrong. It uses "n" twice, which makes it unsafe as a macro.

Damn.  I missed that.

> Or it could use a "__builtin_constant_p()" (which gcc defines to not have 
> side effects) to allow the multiple use for constant data.

I should have, yes.

> Or we could require that "ilog2(0)" returns -1, and then we could just say
> 
> 	#define ilog2_up(n) (ilog2((n)-1)+1)

I'd rather not do that as the inline assembly variants then have to special
case ilog2(0) rather than just having an undefined result.

> The whole "get_order()" macro also has some serious lack of parenthesis. 
> In general, commit 39d61db0edb34d60b83c5e0d62d0e906578cc707 just was 
> pretty damn bad!

Unfortunately, I can't disagree.

> I'm becoming a bit disgruntled about this whole thing, I have to admit. 
> I'm just not sure the bugs here are worth it. Especially considering that 
> __get_order() has apparently never even tested these things to begin with, 

It was tested...  I've just re-examined my test program and I've realised I've
only tested power-of-2 parameters.  Sigh.

> since nobody but FRV has ever #defined the ARCH_HAS_ILOG2_U?? macros.

Well, that should be CONFIG_ARCH_HAS_ILOG2_U?? macros, and powerpc defines
those too.

>  - buggy

True, for N being a non-power-of-two, unfortunately; and also where evaluating
N has side-effects.

>  - untested

Not true, just that my userspace test program isn't sufficiently exhaustive.

>  - has untrue comments

Unfortunately so.

>  - makes no real sense

Not true.

Various archs (including i386, x86_64, powerpc and frv) have instructions that
can be used to calculate integer log2(N).  The fallback position is to use a
loop:

	size = (size - 1) >> (PAGE_SHIFT - 1);
	order = -1;
	do {
		size >>= 1;
		order++;
	} while (size);

> and I'm inclined to just revert 39d61db0 instead of adding more and more 
> breakage to it, since it's simply not going to help with the fundamental 
> problems!

Probably a good idea.  I'll work on it some more and improve my test program
(which is actually quite simple to do).

David
