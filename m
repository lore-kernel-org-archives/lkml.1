Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbZBMPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbZBMPz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZBMPzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:55:16 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:52917 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbZBMPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:55:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAPghlUlMQWt2/2dsb2JhbACBbtEahBgG
Date: Fri, 13 Feb 2009 10:55:07 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090213155507.GA2838@Krystal>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com> <20090213151045.GA1574@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090213151045.GA1574@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:47:19 up 43 days, 15:45,  5 users,  load average: 0.31, 0.22,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sat, Feb 14, 2009 at 12:50:43AM +1100, Nick Piggin wrote:
> > > On Friday 13 February 2009 08:59:59 Paul E. McKenney wrote:
> > > > On Thu, Feb 12, 2009 at 01:15:08PM -0800, Linus Torvalds wrote:
> > > > > On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> > > > > > In other words, you are arguing for using ACCESS_ONCE() in the loops,
> > > > > > but keeping the old ACCESS_ONCE() definition, and declaring BF hardware
> > > > > > broken?
> > > > >
> > > > > Well, I _also_ argue that if you have a busy loop, you'd better have a
> > > > > cpu_relax() in there somewhere anyway. If you don't, you have a bug.
> > > > >
> > > > > So I think the BF approach is "borderline broken", but I think it should
> > > > > work, if BF just has whatever appropriate cache flush in its cpu_relax.
> > > >
> > > > OK, got it.  Keep ACCESS_ONCE() as is, make sure any busy-wait
> > > > loops contain a cpu_relax().  A given busy loop might or might not
> > > > need ACCESS_ONCE(), but that decision is independent of hardware
> > > > considerations.
> > > >
> > > > Ah, and blackfin's cpu_relax() does seem to have migrated from barrier()
> > > > to smp_mb() recently, so sounds good to me!!!
> > > 
> > > 
> > > Interesting. I don't know if you would say it is not cache coherent.
> > > Does anything in cache coherency definition require timeliness? Only
> > > causality I think.
> > > 
> > > However I think "infinite write buffering delay", or requiring "cache
> > > barriers" is insane to teach any generic code about. BF would be free
> > > to optimise arch functions, but for correctness surely it must also
> > > have a periodic interrupt that will expose stores to other CPUs.
> > 
> > I have great sympathy for this point of view!!!  So why not have the
> > blackfin folks get the appropriate instructions added in the gcc port
> > to their architecture?  (Yeah, I know, gcc has no way of knowing which
> > variables are shared and not...)
> > 
> > But perhaps we could decorate the affected variable declarations with
> > a macro that expands to some sort of gcc attribute in the blackfin case?
> > 
> 
> I think that just for the fact that it help identifying such variable
> accesses which are :
> 
> - performed atomically
> - unprotected by any form of locking
> 
> This seems like a good things to wrap such accesses into a macro which
> permits easy identification of those sites. A bit like rcu_dereference()
> does. Gradual use of this new macro could come incrementally too.
> 

I created also

_STORE_SHARED()
_LOAD_SHARED()

which identify the variables which need to have cache flush done before
(load) or after (store). So we get both speed and identification when
needed (if we need to do batch updates linked with a single cache flush).
e.g.


/*
 * Identify a shared load. A smp_rmc() or smp_mc() should come before the load.
 */
#define _LOAD_SHARED(p)	       ACCESS_ONCE(p)

/*
 * Load a data from shared memory, doing a cache flush if required.
 */
#define LOAD_SHARED(p) \
	({ \
		smp_rmc(); \
		_LOAD_SHARED(p); \
	})


/*
 * Identify a shared store. A smp_wmc() or smp_mc() should follow the store.
 */
#define _STORE_SHARED(x, v) \
	do { \
		(x) = (v); \
	} while (0)

/*
 * Store v into x, where x is located in shared memory. Performs the required
 * cache flush after writing.
 */
#define STORE_SHARED(x, v) \
	do { \
		_STORE_SHARED(x, v); \
		smp_wmc(); \
	} while (0)

Mathieu

> Mathieu
> 
> 
> > 							Thanx, Paul
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
