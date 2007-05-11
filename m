Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbXEKRZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbXEKRZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbXEKRZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:25:45 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:40907 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758862AbXEKRZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:25:43 -0400
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <46449F61.2060004@cosmosbay.com>
References: <20070511131541.992688403@chello.nl>
	 <20070511155621.GA13150@elte.hu>  <46449F61.2060004@cosmosbay.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 11 May 2007 19:18:33 +0200
Message-Id: <1178903913.2781.20.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-11 at 18:52 +0200, Eric Dumazet wrote:
> Ingo Molnar a écrit :
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> >> I was toying with a scalable rw_mutex and found that it gives ~10% 
> >> reduction in system time on ebizzy runs (without the MADV_FREE patch).
> >>
> >> 2-way x86_64 pentium D box:
> >>
> >> 2.6.21
> >>
> >> /usr/bin/time ./ebizzy -m -P
> >> 59.49user 137.74system 1:49.22elapsed 180%CPU (0avgtext+0avgdata 0maxresident)k
> >> 0inputs+0outputs (0major+33555877minor)pagefaults 0swaps
> >>
> >> 2.6.21-rw_mutex
> >>
> >> /usr/bin/time ./ebizzy -m -P
> >> 57.85user 124.30system 1:42.99elapsed 176%CPU (0avgtext+0avgdata 0maxresident)k
> >> 0inputs+0outputs (0major+33555877minor)pagefaults 0swaps
> > 
> > nice! This 6% runtime reduction on a 2-way box will i suspect get 
> > exponentially better on systems with more CPUs/cores.
> 
> As long you only have readers, yes.
> 
> But I personally find this new rw_mutex not scalable at all if you have some 
> writers around.
> 
> percpu_counter_sum is just a L1 cache eater, and O(NR_CPUS)

Yeah, that is true; there are two occurences, the one in
rw_mutex_read_unlock() is not strictly needed for correctness.

Write locks are indeed quite expensive. But given the ratio of
reader:writer locks on mmap_sem (I'm not all that familiar with other
rwsem users) this trade-off seems workable.

