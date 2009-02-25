Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbZBYQFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbZBYQFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZBYQFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:05:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZBYQFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:05:31 -0500
Date: Wed, 25 Feb 2009 08:04:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to
 __copy_from_user_*nocache()
In-Reply-To: <20090225072503.GD21903@elte.hu>
Message-ID: <alpine.LFD.2.00.0902250753030.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com> <200902242002.37555.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain> <200902251423.58861.nickpiggin@yahoo.com.au> <20090225072503.GD21903@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Ingo Molnar wrote:
> 
> The main artifact would be the unaligned edges around a bigger 
> write. In particular the tail portion of a big write will be 
> cached.

.. but I don't really agree that this is a problem.

Sure, it's "wrong", but does it actually matter? No. Is it worth adding 
complexity to existing interfaces for? I think not.

In general, I think that software should not mess with nontemporal stores. 
The thing is, software almost never knows enough about the CPU cache to 
make an intelligent choice.

So I didn't want to apply the nocache patches in the first place, but the 
performance numbers were pretty clear. I'll take "real numbers" over my 
personal dislikes any day. But now we have real numbers going the other 
way for small writes, and a patch to fix that.

But we have no amount of real numbers for the edge cases, and I don't 
think they matter. In fact, I don't think they _can_ matter, because it is 
inevitably always going to be an issue of "which CPU and which memory 
subsystem".

In other words, there is no "right" answer. There is no "perfect". But 
there is "we can fix the real numbers".

At the same time, we also do know:
 - caches work
 - CPU designers will continue to worry about the normal (cached) case, 
   and will do reasonable things with cache replacement.
 - ergo: w should always consider the cached case to be the _normal_ mode, 
   and it's the nontempral loads/stores that need to explain themselves.

So I do think we should just apply the simple patch. Not make a big deal 
out of it. We have numbers. We use cached memory copies for everything 
else. It's always "safe".

And we pretty much know that the only time we will ever really care about 
the nontemporal case is with big writes - where the "edge effects" 
essentially become total noise. 

		Linus
