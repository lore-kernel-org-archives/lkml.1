Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbZC0BGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbZC0BGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934263AbZC0BGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:06:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934251AbZC0BGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:06:12 -0400
Date: Thu, 26 Mar 2009 18:03:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090326174704.cd36bf7b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
 <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Andrew Morton wrote:
> 
> userspace can get closer than the kernel can.

Andrew, that's SIMPLY NOT TRUE.

You state that without any amount of data to back it up, as if it was some 
kind of truism. It's not.

> > Why? Because no such number exists. It depends on the access patterns.
> 
> Those access patterns are observable!

Not by user space they aren't, and not dynamically. At least not as well 
as they are for the kernel.

So when you say "user space can do it better", you base that statement on 
exactly what? The night-time whisperings of the small creatures living in 
your basement?

The fact is, user space can't do better. And perhaps equally importantly, 
we have 16 years of history with user space tuning, and that history tells 
us unequivocally that user space never does anything like this.

Name _one_ case where even simple tuning has happened, and where it has 
actually _worked_?

I claim you cannot. And I have counter-examples. Just look at the utter 
fiasco that was user-space "tuning" of nice-levels that distros did. Ooh. 
Yeah, it didn't work so well, did it? Especially not when the kernel 
changed subtly, and the "tuning" that had been done was shown to be 
utter crap.

> > dynamically auto-tune memory use. And no, we don't expect user space to 
> > run some "tuning program for their load" either.
> > 
> 
> This particular case is exceptional - it's just too hard for the kernel
> to be able to predict the future for this one.

We've never even tried. 

The dirty limit was never about trying to tune things, it started out as 
protection against deadlocks and other catastrophic failures. We used to 
allow 50% dirty or something like that (which is not unlike our old buffer 
cache limits, btw), and then when we had a HIGHMEM lockup issue it got 
severly cut down. At no point was that number even _trying_ to limit 
latency, other than as a "hey, it's probably good to not have all memory 
tied up in dirty pages" kind of secondary way.

I claim that the whole balancing between inodes/dentries/pagecache/swap/ 
anonymous memory/what-not is likely a much harder problem. And no, I'm not 
claiming that we "solved" that problem, but we've clearly done a pretty 
good job over the years of getting to a reasonable end result.

Sure, you can still tune "swappiness" (nobody much does), but even there 
you don't actually tune how much memory you use for swap cache, you do 
more of a "meta-tuning" where you tune how the auto-tuning works.

That is something we have shown to work historically.

That said, the real problem isn't even the tuning. The real problem is a 
filesystem issue. If "fsync()" cost was roughly proportional to the size 
of the changes to the file we are fsync'ing, nobody would even complain. 

Everybody accepts that if you've written a 20MB file and then call 
"fsync()" on it, it's going to take a while. But when you've written a 2kB 
file, and "fsync()" takes 20 seconds, because somebody else is just 
writing normally, _that_ is a bug. And it is actually almost totally 
unrelated to the whole 'dirty_limit' thing.

At least it _should_ be. 

			Linus
