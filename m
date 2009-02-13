Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbZBMRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbZBMRyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZBMRyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:54:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZBMRyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:54:09 -0500
Date: Fri, 13 Feb 2009 09:53:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
 (repost)
In-Reply-To: <20090213173352.GB4684@Krystal>
Message-ID: <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com>
 <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain> <20090213173352.GB4684@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Feb 2009, Mathieu Desnoyers wrote:
> 
> The whole idea behind _LOAD_SHARED() is that it does not translate in
> any different assembly output than a standard load. So no, it cannot be
> possibly slower. It has no more side-effect than a simple comment in the
> code, and that's its purpose : to identify those variables. So if we
> find a code path doing
> 
>   _STORE_SHARED(x, v);
>   smp_mc();
>   while (_LOAD_SHARED(z) != val)
>     cpu_relax();
> 
> We can verify very easily the code correctness :
> 
> A write cache flush is required after _STORE_SHARED
> A read cache flush is required before _LOAD_SHARED
> Read cache flushes are required to happen eventually between
>   _LOAD_SHARED in the loop.

That makes no sense.

First off, you had the comment that LOAD_SHARED() would flush caches, so 
your argument that it's just a load, nothing else, is in violation with 
your own statements. And I told you why such a thing is INSANE.

As to the underscore-version, what can it do? Nothing. It's perfectly fine 
to have something like this:

	while (_LOAD_SHARED(x) && _LOAD_SHARED(y)) {
		cpu_relax();
	}

and the thing is, there is no reason to do read-cache flushes between 
those two _LOAD_SHARED. So warning about it would be incorrect, and all it 
can do is be purely ugly "documentation" about the fact that it's doing a 
shared load, because it's not really allowed to warn about the fact that 
shared loads should have a cache flush in between, because THEY SHOULD 
NOT.

But it is also _ugly_.

And more importantly - if you see it as a documentation thing, then it's 
broken in the first place - you're documenting the places that you already 
know about, and already know are important, rather than finding places 
that might be buggy. So what does it help us? Nothing.

You might as well just document the cpu_relax(). Which it implicitly does: 
it's a barrier in a tight loop.

In other words, I see no real point. Your [_][LOAD|STORE]_SHARED is ugly 
and doesn't add value, or adds value (the cache flush) in really really 
bad ways that aren't even very well-defined. 

			Linus
