Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYH3BOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYH3BOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 21:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYH3BOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 21:14:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbYH3BOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 21:14:06 -0400
Date: Fri, 29 Aug 2008 18:11:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>  <200808300031.16708.rjw@sisk.pl>  <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org> <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com> <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Btw, what was the original regression that commit was 
a2bd7274b47124d2fc4dfdb8c0591f545ba749dd trying to fix?

It's not listed in that commit, even though the commit has a "Bisected-by: 
David Witbrodt <dawitbro@sbcglobal.net>".

In fact, I can find it with google by searching for

	David Witbrodt bisect

and I see that it is 3def3d6ddf43dbe20c00c3cbc38dfacc8586998f.

I'm wondering why that commit wasn't just reverted? Because now that I see 
it, I notice that _that_ is the real bug to begin with.

That commit really was buggy. NO WAY can you insert the code/bss/data 
resources before you've done e820 handling, because it may well be that 
some strange e820 table contains things that cross the resources.

So that original thing was buggy, and made x86-64 do odd thigns. They were 
doubly odd, since x86-32 did it differently (and better, I think).

Then, when actally doing the common arch/x86/kernel/setup.c, the commit 
that does so _claims_ that the common code came from the 32-bit version, 
but that doesn't seem to be true, at least wrt this thing. The current 
setup.c comes from the *broken* cleanup of setup_64.c that had been 
bisected to be broken.

And that, in turn, happened in 41c094fd3ca54f1a71233049cf136ff94c91f4ae 
("x86: move e820_resource_resources to e820.c") which also did "and make 
32-bit resource registration more like 64 bit.", so it got the bug into 
32-bit code that had been introduced in 64-bit code.

Ugh.

So why was then that other broken commit added to paper it over, even 
though the original broken commit had been bisected and the breakage was 
known to have been due to _that_?

Hmm?

Yinghai - I'm hoping that the code movement is all over and done with, but 
you need to be a _lot_ more careful here. And Ingo, this really wasn't 
very well done.

			Linus
