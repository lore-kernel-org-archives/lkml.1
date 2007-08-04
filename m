Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbXHDQlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbXHDQlC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765245AbXHDQkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:40:35 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38420 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765222AbXHDQkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:40:33 -0400
Date: Sat, 4 Aug 2007 20:37:40 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Distributed storage.
Message-ID: <20070804163740.GB14175@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708021408.24876.phillips@phunq.net> <20070803102629.GB10089@2ka.mipt.ru> <200708031819.17039.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708031819.17039.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 06:19:16PM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> It depends on the characteristics of the physical and virtual block 
> devices involved.  Slow block devices can produce surprising effects.  
> Ddsnap still qualifies as "slow" under certain circumstances (big 
> linear write immediately following a new snapshot). Before we added 
> throttling we would see as many as 800,000 bios in flight.  Nice to 

Mmm, sounds tasty to work with such a system :)

> know the system can actually survive this... mostly.  But memory 
> deadlock is a clear and present danger under those conditions and we 
> did hit it (not to mention that read latency sucked beyond belief). 
> 
> Anyway, we added a simple counting semaphore to throttle the bio traffic 
> to a reasonable number and behavior became much nicer, but most 
> importantly, this satisfies one of the primary requirements for 
> avoiding block device memory deadlock: a strictly bounded amount of bio 
> traffic in flight.  In fact, we allow some bounded number of 
> non-memalloc bios *plus* however much traffic the mm wants to throw at 
> us in memalloc mode, on the assumption that the mm knows what it is 
> doing and imposes its own bound of in flight bios per device.   This 
> needs auditing obviously, but the mm either does that or is buggy.  In 
> practice, with this throttling in place we never saw more than 2,000 in 
> flight no matter how hard we hit it, which is about the number we were 
> aiming at.  Since we draw our reserve from the main memalloc pool, we 
> can easily handle 2,000 bios in flight, even under extreme conditions.
> 
> See:
>     http://zumastor.googlecode.com/svn/trunk/ddsnap/kernel/dm-ddsnap.c
>     down(&info->throttle_sem);
> 
> To be sure, I am not very proud of this throttling mechanism for various 
> reasons, but the thing is, _any_ throttling mechanism no matter how 
> sucky solves the deadlock problem.  Over time I want to move the 

make_request_fn is always called in process context, we can wait in it
for memory in mempool. Although that means we already in trouble.

I agree, any kind of high-boundary leveling must be implemented in
device itself, since block layer does not know what device is at the end
and what it will need to process given block request.

-- 
	Evgeniy Polyakov
