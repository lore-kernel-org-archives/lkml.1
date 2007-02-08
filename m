Return-Path: <linux-kernel-owner+w=401wt.eu-S1423197AbXBHQdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423197AbXBHQdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423168AbXBHQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:33:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423197AbXBHQdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:33:40 -0500
Date: Thu, 8 Feb 2007 08:33:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <45CB3B28.60102@garzik.org>
Message-ID: <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Jeff Garzik wrote:
>
> Just did a pull for the first time since 2.6.20, and a /megaton/ of new
> warnings have appeared, on Fedora Core 6/x86-64 "make allyesconfig".

That was due to the Makefile rule breakage. Hopefully it now _really_ is 
fixed. The

	CFLAGS += $(call cc-option,-Wno-pointer-sign,)

part effectively got dropped.

> All of the new warnings spew appear to be "pointers differ in signedness"
> warning.  Granted, we should care about these

The thing is, I'm _really_ sad we have to use that -Wno-pointer-sign 
thing. It's a real and valid warning. It finds really ugly code issues 
(unlike a lot of the other things). So it got dropped by mistake, but that 
is one warning that I'd actually like to resurrect (unlike a lot of other 
gcc warnings that I just think are crap to begin with).

However, we've got a metric shitload of code that passes in pointers to 
the wrong sign, so a lot of it would involve mindless changes that are 
likely to break real things. 

And the thing is, sometimes -Wpointer-sign-compare is just horribly 
broken. For example, you cannot write a "strlen()" that doesn't complain 
about "unsigned char *" vs "char *". And that is just a BUG.

I'm continually amazed at how totally clueless some gcc warnings are. 
You'd think that the people writing them are competent. And then sometimes 
they show just how totally incompetent they are, by making it impossible 
to use "unsigned char" arrays together with standard functions.

So a _lot_ of the warnings are real. But with no way to shut up the ones 
that aren't, it sadly doesn't matter one whit ;(

(And adding casts is just much worse than shutting up the warning 
entirely)

There should be a rule about warnings: if you can't shut up stylistic 
warnings on a site-by-site level without adding horribly syntactic stuff 
that is worse than what the warning is all about, the warning shouldn't 
exist.

			Linus
