Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0CERZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:25:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab0CERZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:25:22 -0500
Date: Fri, 5 Mar 2010 09:23:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Daniel Stone <daniel@fooishbar.org>
cc: David Miller <davem@davemloft.net>, skeggsb@gmail.com, airlied@linux.ie,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, mingo@elte.hu, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100305160434.GE2505@tempa>
Message-ID: <alpine.LFD.2.00.1003050902330.3788@localhost.localdomain>
References: <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net> <20100305154009.GC2505@tempa> <20100305.074835.159078083.davem@davemloft.net> <20100305160434.GE2505@tempa>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Daniel Stone wrote:
> 
> So you're saying that there's no way to develop any reasonable body of
> code for the Linux kernel without committing to keeping your ABI
> absolutely rock-solid stable for eternity, no exceptions, ever?

I think that's what David ended up saying, but I think he is being _too_ 
strict.

It's not how we've done other things either. We've changed ABI's over time 
many times. And we've even had complete breakage of old tools (although 
that is very much reserved for system tools, not regular applications: I 
think we've been almost religious about "normal" apps not breaking, 
unless there was some really overriding reason like security that forced 
us to really remove some interface).

But most of the changes have been extending things, leaving the old 
interfaces around (often as wrappers around the new internal world order, 
sometimes by effectively having actual duplicated code).

And then the old interface is maintained for quite a while (sometimes 
decades, often years, and generally at least for several kernel versions 
so that people have time to upgrade, and a distro can generally pick a 
newer kernel without having to change anything else).

Sometimes we've done things that really end up requiring new tools. It's 
pretty rare, but it does happen. It happens a lot more for "esoteric" 
things that aren't every-day-in-your-face (I've seen at least _one_ mutter 
about "sysfs" in this thread ;) and might break something like a 
temperature sensor, for example.

So the machine might _work_ and you could go for days without even 
noticing, but you might have some very specific functionality missing. 
Maybe your power meter doesn't work, or maybe you need to upgrade your 
kernel profiler to get good profiles again. Things like that.

I suspect you as an X person know this very well, in fact. X itself has 
carried along a _lot_ of cruft exactly like this, that you guys have been 
removing only in the last few years - sometimes after decades of it being 
there. The whole switch to modern font handling is an obvious example of a 
_major_ fundamental feature change like that.

So in general, what the kernel strives for is that very kind of "the old 
model will still work - but it might be slow and emulated on top of a new 
way of dong things, and not get a lot of attention any more".

And sometimes, there's really no good way of maintaining two interfaces at 
the kernel level, and then you have the downstream tools that have to 
learn to pick either the old or the new one, so that the tool still works 
regardless.

And again, the old code _eventually_ bitrots or gets cleaned up, but what 
you really really want to avoid is to have a flag-day when you switch from 
one to the other, and you can't switch between adjacent versions of the 
kernel. 

In the 2.4.x/2.6.x split, for example, we did have system tools that 
needed to be upgraded if you came from a 2.4.x environment. You can still 
see signs of that in the kernel tree: we have that whole 
Documentation/Changes file that _still_ remains in our tree, even though 
it's purely historical.

But if you look at that Documentation/Changes file, I don't think there is 
_any_ flag-day issue except for the removal of "devfs". People _still_ 
talk about devfs in hushed tones. Everything else is about having to 
upgrade system tools _before_ upgrading the kernel (iow, they still worked 
on 2.4.x, but you needed recent enough versions of them to compile and run 
a 2.6.x kernel).

In other words, it wasn't a "flag day" (apart from the already mentioned 
devfs users, and possibly something else I can't think of). It was an 
upgrade, yes, and it required some other things to be recent, but you 
could go back-and-forth between kernels if you had to.

(Of course, it's now many years since that, so maybe my rose-colored 
glasses makes me forget the pain involved. And I obviously personally 
never made the whole 2.4.x -> 2.6.x jump, since I'd been running the 
development kernels in between. So maybe I forgot some painful part).

			Linus
