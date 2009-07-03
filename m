Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbZGCRbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbZGCRbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbZGCRba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:31:30 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:61249 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbZGCRb3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:31:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAMXcTUpMQWU3/2dsb2JhbACBUcw7hBIFgTo
Date: Fri, 3 Jul 2009 13:31:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu,
       jolsa@redhat.com, a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org, Paul.McKenney@us.ibm.com
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703173130.GA16089@Krystal>
References: <20090703152951.GA28837@gondor.apana.org.au> <4A4E25BB.8060408@gmail.com> <20090703154700.GD10256@Krystal> <20090703170621.GS8943@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090703170621.GS8943@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:21:43 up 125 days, 13:47,  3 users,  load average: 0.21, 0.17,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Jul 03, 2009 at 11:47:00AM -0400, Mathieu Desnoyers wrote:
> > * Eric Dumazet (eric.dumazet@gmail.com) wrote:
> > > Herbert Xu a écrit :
> > > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > >> Why don't we create a read_lock without acquire semantic instead (e.g.
> > > >> read_lock_nomb(), or something with a better name like __read_lock()) ?
> > > >> On architectures where memory barriers are needed to provide the acquire
> > > >> semantic, it would be faster to do :
> > > >>
> > > >> __read_lock();
> > > >> smp_mb();
> > > >>
> > > >> than :
> > > >>
> > > >> read_lock(); <- e.g. lwsync + isync or something like that
> > > >> smp_mb(); <- full sync.
> > > > 
> > > > Hmm, why do we even care when read_lock should just die?
> > > > 
> > > > Cheers,
> > > 
> > > +1 :)
> > > 
> > > Do you mean using a spinlock instead or what ?
> > > 
> > 
> > I think he meant RCU.
> > 
> > > Also, how many arches are able to have a true __read_lock()
> > > (or __spin_lock() if that matters), without acquire semantic ?
> > 
> > At least PowerPC, MIPS, recent ARM, alpha.
> 
> Are you guys sure you are in agreement about what you all mean by
> "acquire semantics"?
> 

I use acquire/release semantic with the following meaning :

...
read A
read_unlock()

read B

read_lock();
read C

read_unlock would provide release semantic by disallowing read A to move
after the read_unlock.

read_lock would provide acquire semantic by disallowing read C to move
before read_lock.

read B is free to move.


> Clearly, any correct __read_lock() implementation must enforce ordering
> with respect to the most recent __write_unlock(), but this does not
> necesarily imply all possible definitions of "acquire semantics".
> 

Yes, you are right. We could never remove _all_ memory barriers from
__read_lock()/__read_unlock implementations even if we require something
such as :

__read_lock()
smp_mb()

critical section.

smp_mb()
__read_unlock()

Because we also need to guarantee that consecutive unlock/lock won't be
reordered, which implies a barrier _outside_ of the read lock/unlock
atomic operations.

But anyway I'm not sure it's worth trying to optimize rwlocks, given
that for critical sections where the performance hit of a memory barrier
would be perceivable, we should really think about using RCU rather than
beating this dead horse. :)

Thanks,

Mathieu.


> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
