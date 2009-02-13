Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZBMQT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZBMQT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZBMQTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:19:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbZBMQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:19:48 -0500
Date: Fri, 13 Feb 2009 08:18:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
 (repost)
In-Reply-To: <20090213155507.GA2838@Krystal>
Message-ID: <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com>
 <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Feb 2009, Mathieu Desnoyers wrote:
> 
> I created also
> 
> _STORE_SHARED()
> _LOAD_SHARED()
> 
> which identify the variables which need to have cache flush done before
> (load) or after (store). So we get both speed and identification when
> needed (if we need to do batch updates linked with a single cache flush).
> e.g.

The thing is, THAT JUST ABSOLUTELY SUCKS.

Lookie here - we don't want to flush the cache at every load of a shared 
variable. There's no reason to. If you don't care about the orderign, you 
might as well get the old values. That's what memory ordering _means_, for 
chissake! In the absense of locks, loads may get stale values. It's that 
easy.

A lot of code wants to access multiple variables, and they are potentially 
nearby, and in the same cacheline. Making them all use _LOAD_SHARED() adds 
absolutely no value - and makes it MUCH MUCH SLOWER.

So what's the answer?

I already outlined it: either you use locks (which will do the magic for 
you), or you use memory barriers. In no case do you make the access magic, 
unless you have a compiler issue where you are afraid that the compiler 
would turn it into _multiple_ accesses and potentially get inconsistent 
results.

So the point about ACCESS_ONCE() is not, and never has been, about 
re-ordering. We know that the CPU may re-order the accesses and give us 
stale values (or values from the "future" wrt the other accesses around 
it). That's not the point. The point of ACCESS_ONCE() is that we get 
exactly _one_ value, and not two different ones (or none at all) because 
of the compiler either re-loading it several times or not re-loading it at 
all.

Anybody who confuses ACCESS_ONCE() with ordering is simply confused.

And we don't want to make any "load with cache flush" either. Which side 
should the cache flush be on? Before? After? Both? Atomically? There is no 
sane semantics for that.

The only remaining sane semantics is to depend on memory barriers, and 
then make a magic memory barrier that is extra weak and doesn't order 
anythign at all, but just says "syncronize very weakly".

And I think we have that in "cpu_relax()". Because if you have somebody 
doing shared memory accesses in a loop without any memory barriers or 
locks or anything (ie the _ordering_ doesn't matter, only that some value 
has been seen), then dang it, I can't see how you can _possibly_ use 
anything else than that "cpu_relax()" somewhere in that loop.

			Linus
