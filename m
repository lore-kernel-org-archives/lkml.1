Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352Ab0AFD7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0AFD7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411Ab0AFD7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:59:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57093 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0AFD7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:59:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jan 2010 12:56:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	<20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
	<20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
	<20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>
	<20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001051917000.3630@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 19:27:07 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 6 Jan 2010, KAMEZAWA Hiroyuki wrote:
> >
> > My host boots successfully. Here is the result.
> 
> Hey, looks good. It does have that 3% trylock overhead:
> 
>       3.17%  multi-fault-all  [kernel]                  [k] down_read_trylock
> 
> but that doesn't seem excessive.
> 
> Of course, your other load with MADV_DONTNEED seems to be horrible, and 
> has some nasty spinlock issues, but that looks like a separate deal (I 
> assume that load is just very hard on the pgtable lock).
> 
It's zone->lock, I guess. My test program avoids pgtable lock problem.


> That said, profiles are hard to compare performance with - the main thing 
> that matters for performance is not how the profile looks, but how it 
> actually performs. So:
> 
> > Then, the result is much improved by XADD rwsem.
> > 
> > In above profile, rwsem is still there.
> > But page-fault/sec is good. I hope some "big" machine users join to the test.
> 
> That "page-fault/sec" number is ultimately the only thing that matters. 
> 
yes.

> > Here is peformance counter result of DONTNEED test. Counting the number of page
> > faults in 60 sec. So, bigger number of page fault is better.
> > 
> > [XADD rwsem]
> > [root@bluextal memory]#  /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-all 8
> > 
> >  Performance counter stats for './multi-fault-all 8' (5 runs):
> > 
> >        41950863  page-faults                ( +-   1.355% )
> >       502983592  cache-misses               ( +-   0.628% )
> > 
> >    60.002682206  seconds time elapsed   ( +-   0.000% )
> > 
> > [my patch]
> > [root@bluextal memory]#  /root/bin/perf stat -e page-faults,cache-misses --repeat 5 ./multi-fault-all 8
> > 
> >  Performance counter stats for './multi-fault-all 8' (5 runs):
> > 
> >        35835485  page-faults                ( +-   0.257% )
> >       511445661  cache-misses               ( +-   0.770% )
> > 
> >    60.004243198  seconds time elapsed   ( +-   0.002% )
> > 
> > Ah....xadd-rwsem seems to be faster than my patch ;)
> 
> Hey, that sounds great. NOTE! My patch really could be improved. In 
> particular, I suspect that on x86-64, we should take advantage of the 
> 64-bit counter, and use a different RW_BIAS. That way we're not limited to 
> 32k readers, which _could_ otherwise be a problem.
> 
> So consider my rwsem patch to be purely preliminary. Now that you've 
> tested it, I feel a lot better about it being basically correct, but it 
> has room for improvement.
> 

I'd like to stop updating my patch and wait and see how this issue goes.
Anyway, test on a big machine is appreciated because I cat test only on 
2 sockets host.

Thanks,
-Kame



 

