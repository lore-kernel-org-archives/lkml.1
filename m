Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbXE3NMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbXE3NMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXE3NMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:12:32 -0400
Received: from 1wt.eu ([62.212.114.60]:2786 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXE3NMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:12:31 -0400
Date: Wed, 30 May 2007 15:12:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tejun Heo <htejun@gmail.com>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: epoll,threading
Message-ID: <20070530131221.GC19105@1wt.eu>
References: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com> <465C809C.60507@gmail.com> <20070530072528.GP943@1wt.eu> <465D4DF1.5040500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465D4DF1.5040500@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 07:12:01PM +0900, Tejun Heo wrote:
> Hello,
> 
> Willy Tarreau wrote:
> > In my experience, it's not much the context switch by itself which
> > causes performance degradation, but the fact that with threads, you
> > have to put mutexes everywhere. And frankly, walking a list with
> > locks everywhere is quite slower than doing it in one run at a rate
> > of 3 or 4 cycles per entry. Also, local storage in function returns
> > is not possible anymore, and some functions even need to malloc()
> > instead of returning statically allocated data. I believe this is the
> > reason for openssl being twice as slow when compiled thread-safe than
> > in native mode.
> > 
> > So in fact, converting a threaded program to a pure async model
> > should not improve it much because of the initial architectural
> > design. But a program written from scratch to be purely async should
> > perform better simply because it has less operations to perform. And
> > there's no magics here : less cycles spend synchronizing and locking
> > = more cycles available for the real job.
> 
> The thing is that the synchronization overhead is something you'll have
> to pay anyway to support multiple processors.

But you don't need to sync *everything*. It is doable to have 1 thread
per processor, each with their own data, and sync the minimum information
(eg: statistics).

> Actually, supporting
> multiple processors on an async program is beyond painful.  Either you
> have to restrict all locking to busy locks or introduce new state for
> each possibly blocking synchronization point and what happens if they
> have to nest?  You kind of end up with stackable state thingie - an
> extremely restricted stack.

I have not said it is simple, I said that when it is justified, it is doable.

> If you're really serious about performance and scalability, you just
> have to support multiple processors and if you do it right the
> performance overhead shouldn't be too high.  Common servers will soon
> have 8 cores on two physical processors - paying some overhead for
> synchronization is pretty good deal for scalability.
> 
> >> In my experience with web caches, epoll or similar for idle clients
> >> and thread per active client scaled and performed pretty well - it
> >> needed more memory but the performance wasn't worse than
> >> asynchronous design and doing complex server in async model is a
> >> lot of pain.
> > 
> > It's true that an async model is a lot of pain. But it's always where
> > I got the best performance. For instance, with epoll(), I can achieve
> >  20000 HTTP reqs/s with 40000 concurrent sessions. The best
> > performance I have observed from threaded competitors was an order of
> > magnitude below on either value (sometimes both).
> 
> Well, it all depends on how you do it but an order of magnitude
> performance difference sounds too much to me.  Memory-wise scalability
> can be worse by orders of magnitude.

It is very often a problem because system limits have not evolved as fast
as requirements.

>  You need to restrict per-thread
> stack size and use epoll for idle threads, if you wanna scale.  Workers
> + async monitoring of idle clients scale pretty well.

I agree with a small pool of workers. But they must be dedicated to CPU
only, and perform no I/O. Then you can have 1 thread/CPU.

> > However, I agree that few uses really require to spend time writing
> > and debugging async programs.
> 
> Yeap, also there are several things which just are too painful in async
> server - e.g. adding coordination with another server (virus scan,
> sharing cached data), implementing pluggable extension framwork for
> third parties (and what happens if they should be able to stack!), and
> maintaining the damn thing while trying to add a few features.  :-)
> 
> IMHO, complex pure async server doesn't really make sense anymore.

That's clearly not my opinion, but I don't want to enter a flamewar on
the subject, it's not interesting. As long as people like us will push
the system to limits using either model, at least there will be
references for comparisons :-)

Cheers
Willy

