Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbZBMSlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbZBMSlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZBMSkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:40:53 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52072 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750848AbZBMSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:40:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArUEAENKlUlMQWt2/2dsb2JhbACBbtBjhBwG
Date: Fri, 13 Feb 2009 13:40:49 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090213184048.GA7124@Krystal>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au> <20090213145653.GA6854@linux.vnet.ibm.com> <20090213151045.GA1574@Krystal> <20090213155507.GA2838@Krystal> <alpine.LFD.2.00.0902130808050.3099@localhost.localdomain> <20090213173352.GB4684@Krystal> <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:07:55 up 43 days, 18:06,  3 users,  load average: 0.36, 0.60,
	0.55
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 13 Feb 2009, Mathieu Desnoyers wrote:
> > 
> > The whole idea behind _LOAD_SHARED() is that it does not translate in
> > any different assembly output than a standard load. So no, it cannot be
> > possibly slower. It has no more side-effect than a simple comment in the
> > code, and that's its purpose : to identify those variables. So if we
> > find a code path doing
> > 
> >   _STORE_SHARED(x, v);
> >   smp_mc();
> >   while (_LOAD_SHARED(z) != val)
> >     cpu_relax();
> > 
> > We can verify very easily the code correctness :
> > 
> > A write cache flush is required after _STORE_SHARED
> > A read cache flush is required before _LOAD_SHARED
> > Read cache flushes are required to happen eventually between
> >   _LOAD_SHARED in the loop.
> 
> That makes no sense.
> 
> First off, you had the comment that LOAD_SHARED() would flush caches, so 
> your argument that it's just a load, nothing else, is in violation with 
> your own statements. And I told you why such a thing is INSANE.
> 

LOAD_SHARED -> cache flush + load
_LOAD_SHARED -> simple load

There is no contradiction here. And I agree that LOAD_SHARED will
generally produce slow code and that it is inappropriate for multiple
accesses between cache-line flushes.

> As to the underscore-version, what can it do? Nothing. It's perfectly fine 
> to have something like this:
> 
> 	while (_LOAD_SHARED(x) && _LOAD_SHARED(y)) {
> 		cpu_relax();
> 	}
> 
> and the thing is, there is no reason to do read-cache flushes between 
> those two _LOAD_SHARED. So warning about it would be incorrect, and all it 
> can do is be purely ugly "documentation" about the fact that it's doing a 
> shared load, because it's not really allowed to warn about the fact that 
> shared loads should have a cache flush in between, because THEY SHOULD 
> NOT.

Doing two _LOAD_SHARED of different variables without cache flush is
perfectly fine, but we could trigger the warning if some code reads
_the same_ variable twice without any flush in between. The only sane
way I can foresee this being correct is if an interrupt (or signal in
userspace) handler is expected to execute the cache flush for us.

> 
> But it is also _ugly_.
> 

Agreed. I'm under the impression the code is yelling at me when I read
it. :-) Probably that the capital lettering is ill-chosen.

> And more importantly - if you see it as a documentation thing, then it's 
> broken in the first place - you're documenting the places that you already 
> know about, and already know are important, rather than finding places 
> that might be buggy. So what does it help us? Nothing.

Given we have to to match the LOADs and the STOREs within the source
would possibly lead to interesting findings, as learning that such STORE
is really expected to be propagated to the other CPU just because we
notice its associated LOAD. So I think having such in-place
documentation might actually help finding bugs.

> 
> You might as well just document the cpu_relax(). Which it implicitly does: 
> it's a barrier in a tight loop.
> 
> In other words, I see no real point. Your [_][LOAD|STORE]_SHARED is ugly 
> and doesn't add value, or adds value (the cache flush) in really really 
> bad ways that aren't even very well-defined. 
> 

I guess we will have to wait until someone really want to port Linux to
a SMP architecture with non-coherent caches before we can measure the
value of such macro-ish documentation. Now is probably way too soon.

Thanks,

Mathieu

> 			Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
