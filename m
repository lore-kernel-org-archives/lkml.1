Return-Path: <linux-kernel-owner+w=401wt.eu-S1945937AbXBBP5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945937AbXBBP5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945950AbXBBP5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:57:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945937AbXBBP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:57:30 -0500
Date: Fri, 2 Feb 2007 07:56:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070202104900.GA13941@elte.hu>
Message-ID: <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Feb 2007, Ingo Molnar wrote:
> 
> My only suggestion was to have a couple of transparent kernel threads 
> (not fibrils) attached to a user context that does asynchronous 
> syscalls! Those kernel threads would be 'switched in' if the current 
> user-space thread blocks - so instead of having to 'create' any of them 
> - the fast path would be to /switch/ them to under the current 
> user-space, so that user-space processing can continue under that other 
> thread!

But in that case, you really do end up with "fibrils" anyway. 

Because those fibrils are what would be the state for the blocked system 
calls when they aren't scheduled.

We may have a few hundred thousand system calls a second (maybe that's not 
actually reasonable, but it should be what we *aim* for), and 99% of them 
will hopefully hit the cache and never need any separate IO, but even if 
it's just 1%, we're talking about thousands of threads.

I do _not_ think that it's reasonable to have thousands of threads state 
around just "in case". Especially if all those threadlets are then 
involved in signals etc - something that they are totally uninterested in. 

I think it's a lot more reasonable to have just the kernel stack page for 
"this was where I was when I blocked". IOW, a fibril-like thing. You need 
some data structure to set up the state *before* you start doing any 
threads at all, because hopefully the operation will be totally 
synchronous, and no secondary thread is ever really needed!

What I like about fibrils is that they should be able to handle the cached 
case well: the case where no "real" scheduling (just the fibril stack 
switches) takes place.

Now, most traditional DB loads would tend to use AIO only when they "know" 
that real IO will take place (the AIO call itself will probably be 
O_DIRECT most of the time). So I suspect that a lot of those users will 
never really have the cached case, but one of my hopes is to be able to do 
exactly the things that we have *not* done well: asynchronous file opens 
and pathname lookups, which is very common in a file server.

If done *really* right, a perfectly normal app could do things like 
asynchronous stat() calls to fill in the readdir results. In other words, 
what *I* would like to see is the ability to have something *really* 
simple like "ls" use this, without it actually being a performance hit 
for the common case where everythign is cached.

Have you done "ls -l" on a big uncached directory where the inodes 
are all over the disk lately? You can hear the disk whirr. THAT is the 
kind of "normal user" thing I'd like to be able to fix, and the db case is 
actually secondary. The DB case is much much more limited (ok, so somebody 
pointed out that they want slightly more than just read/write, but 
still.. We're talking "special code".)

> [ finally, i think you totally ignored my main argument, state machines.

I ignored your argument, because it's not really relevant. The fact that 
networking (and TCP in particular) has state machines is because it is a 
packetized environment. Nothing else is. Think pathname lookup etc. They 
are all *fundamentally* environments with a call stack.

So the state machine argument is totally bogus - it results in a 
programming model that simply doesn't match the *normal* setup. You want 
the kernel programming model to appear "linear" even when it isn't, 
because it's too damn hard to think nonlinearly.

Yes, we could do pathname lookup with that kind of insane setup too. But 
it would be HORRID!

			Linus
