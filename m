Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbZBMReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbZBMReK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZBMRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:33:56 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:56579 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbZBMRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:33:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FABQ+lUlMQWt2/2dsb2JhbACBbtBuhBgG
Date: Fri, 13 Feb 2009 12:33:52 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090213173352.GB4684@Krystal>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com> <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:57:05 up 43 days, 16:55,  4 users,  load average: 0.20, 0.21,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 13 Feb 2009, Mathieu Desnoyers wrote:
> > 
> > I created also
> > 
> > _STORE_SHARED()
> > _LOAD_SHARED()
> > 
> > which identify the variables which need to have cache flush done before
> > (load) or after (store). So we get both speed and identification when
> > needed (if we need to do batch updates linked with a single cache flush).
> > e.g.
> 
> The thing is, THAT JUST ABSOLUTELY SUCKS.
> 
> Lookie here - we don't want to flush the cache at every load of a shared 
> variable. There's no reason to. If you don't care about the orderign, you 
> might as well get the old values. That's what memory ordering _means_, for 
> chissake! In the absense of locks, loads may get stale values. It's that 
> easy.
> 
> A lot of code wants to access multiple variables, and they are potentially 
> nearby, and in the same cacheline. Making them all use _LOAD_SHARED() adds 
> absolutely no value - and makes it MUCH MUCH SLOWER.
> 

Hrm, I think there is a misunderstanding here, because _LOAD_SHARED() is
not much more than a simple comment.

The whole idea behind _LOAD_SHARED() is that it does not translate in
any different assembly output than a standard load. So no, it cannot be
possibly slower. It has no more side-effect than a simple comment in the
code, and that's its purpose : to identify those variables. So if we
find a code path doing

  _STORE_SHARED(x, v);
  smp_mc();
  while (_LOAD_SHARED(z) != val)
    cpu_relax();

We can verify very easily the code correctness :

A write cache flush is required after _STORE_SHARED
A read cache flush is required before _LOAD_SHARED
Read cache flushes are required to happen eventually between
  _LOAD_SHARED in the loop.

It's basically the same as having something like an eventual :

_STORE_ORDERED(x, v);
smp_mb();
_LOAD_ORDERED(z);

Instead of relying on a comment around smp_mb(); stating which variables
it orders. I would understand if you dislike it, but I find it rather
useful to have this information in the source code around the variable
access rather than formulated as a comment around the barrier. Actually
having both the barrier comment *and* this identification seems rather
good for code review.

> So what's the answer?
> 
> I already outlined it: either you use locks (which will do the magic for 
> you), or you use memory barriers. In no case do you make the access magic, 
> unless you have a compiler issue where you are afraid that the compiler 
> would turn it into _multiple_ accesses and potentially get inconsistent 
> results.
> 
> So the point about ACCESS_ONCE() is not, and never has been, about 
> re-ordering. We know that the CPU may re-order the accesses and give us 
> stale values (or values from the "future" wrt the other accesses around 
> it). That's not the point. The point of ACCESS_ONCE() is that we get 
> exactly _one_ value, and not two different ones (or none at all) because 
> of the compiler either re-loading it several times or not re-loading it at 
> all.
> 
> Anybody who confuses ACCESS_ONCE() with ordering is simply confused.
> 
> And we don't want to make any "load with cache flush" either. Which side 
> should the cache flush be on? Before? After? Both? Atomically? There is no 
> sane semantics for that.
> 

We might want to simply scrap the "safe and slow" version without
underscores (LOAD_SHARED, STORE_SHARED) which contain smp_rmc and
smp_wmc statements within the macro. But Paul insisted that he likes
having the proper memory ordering/cache coherency enforced within the
accessor macros. Personnally, I see much more value in the simple
"comment-only" versions _LOAD_SHARED/_STORE_SHARED matched with an
explicit cache flush statement because in a lot of cases, we will want
to do a batch of read/writes between cache flushes. Note that memory
barriers are already implicit in a lot of kernel primitives, namely
rcu_dereference, cmpxchg, spinlock, ... so this is debatable I guess.

> The only remaining sane semantics is to depend on memory barriers, and 
> then make a magic memory barrier that is extra weak and doesn't order 
> anythign at all, but just says "syncronize very weakly".

I agree completely. What I am proposing here is just to add syntaxic
sugar to better identify the variables related to those extra weak
barriers.

> 
> And I think we have that in "cpu_relax()". Because if you have somebody 
> doing shared memory accesses in a loop without any memory barriers or 
> locks or anything (ie the _ordering_ doesn't matter, only that some value 
> has been seen), then dang it, I can't see how you can _possibly_ use 
> anything else than that "cpu_relax()" somewhere in that loop.
> 

It must also be matched with the equivalent write flush barrier at the
write side, so hiding this deep within cpu_relax() only at the read-side
seems to hide a lot of what must be performed by the cores to exchange
the data properly. (ok we don't care about write cache flush for
Blackfin particularly, but I don't see why we should not start thinking
about what non-coherent caches small embedded devices can bring)

It's also worth noting that Paul and I have no agenda to push anything
into the mainline kernel to enforce anything like "wmc"-type cache flush
barriers. We are barely trying to find the best semantic to express our
userspace RCU algorithm, and I happen to have noticed this loophole
about non-coherent cache architectures. But ideally it would be good to
stay in sync with the Linux kernel's primitives, so this is why your
criticism is much appreciated.

Thanks,

Mathieu

> 			Linus
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
