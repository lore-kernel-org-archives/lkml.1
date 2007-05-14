Return-Path: <linux-kernel-owner+w=401wt.eu-S1033084AbXENMAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033084AbXENMAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032617AbXENL6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:58:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:38666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032751AbXENL6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:58:32 -0400
Date: Mon, 14 May 2007 13:58:31 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
Message-ID: <20070514115830.GD31234@wotan.suse.de>
References: <20070511131541.992688403@chello.nl> <20070511155621.GA13150@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511155621.GA13150@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 05:56:21PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > I was toying with a scalable rw_mutex and found that it gives ~10% 
> > reduction in system time on ebizzy runs (without the MADV_FREE patch).
> > 
> > 2-way x86_64 pentium D box:
> > 
> > 2.6.21
> > 
> > /usr/bin/time ./ebizzy -m -P
> > 59.49user 137.74system 1:49.22elapsed 180%CPU (0avgtext+0avgdata 0maxresident)k
> > 0inputs+0outputs (0major+33555877minor)pagefaults 0swaps
> > 
> > 2.6.21-rw_mutex
> > 
> > /usr/bin/time ./ebizzy -m -P
> > 57.85user 124.30system 1:42.99elapsed 176%CPU (0avgtext+0avgdata 0maxresident)k
> > 0inputs+0outputs (0major+33555877minor)pagefaults 0swaps
> 
> nice! This 6% runtime reduction on a 2-way box will i suspect get 
> exponentially better on systems with more CPUs/cores.

Is this with the MADV_DONTNEED kernel and glibc work?


> i also like the design, alot: instead of doing a full new lock type 
> (with per-arch changes, extra lockdep support, etc. etc) you layered the 
> new abstraction ontop of mutexes. This makes this hard locking 
> abstraction look really, really simple, while the percpu_counter trick 
> makes it scale _perfectly_ for the reader case. Congratulations!
> 
> given how nice this looks already, have you considered completely 
> replacing rwsems with this? I suspect you could test the correctness of 

Not to take anything away from this lock type (because it can have its
uses), but have you considered the size of this lock and its write side
performance? 

