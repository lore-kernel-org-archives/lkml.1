Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbZATMqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbZATMqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:46:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760466AbZATMpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:45:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42175 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbZATMpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:45:20 -0500
Date: Tue, 20 Jan 2009 13:45:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120124500.GE7790@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120123418.GG19505@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120123418.GG19505@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Tue, Jan 20, 2009 at 12:26:34PM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > Hi,
> > > 
> > > I'm looking at regressions since 2.6.16, and one is lat_mmap has slowed 
> > > down. On further investigation, a large part of this is not due to a 
> > > _regression_ as such, but the introduction of CONFIG_PARAVIRT=y.
> > > 
> > > Now, it is true that lat_mmap is basically a microbenchmark, however it 
> > > is exercising the memory mapping and page fault handler paths, so we're 
> > > talking about pretty important paths here. So I think it should be of 
> > > interest.
> > > 
> > > I've run the tests on a 2s8c AMD Barcelona system, binding the test to 
> > > CPU0, and running 100 times (stddev is a bit hard to bring down, and my 
> > > scripts needed 100 runs in order to pick up much smaller changes in the 
> > > results -- for CONFIG_PARAVIRT, just a couple of runs should show up the 
> > > problem).
> > > 
> > > Times I believe are in nanoseconds for lmbench, anyway lower is better.
> > > 
> > > non pv   AVG=464.22 STD=5.56
> > > paravirt AVG=502.87 STD=7.36
> > > 
> > > Nearly 10% performance drop here, which is quite a bit... hopefully 
> > > people are testing the speed of their PV implementations against non-PV 
> > > bare metal :)
> > 
> > Ouch, that looks unacceptably expensive. All the major distros turn 
> > CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
> > promise to have no measurable runtime overhead.
> > 
> > ( And i suspect the real life mmap cost is probably even more expensive,
> >   as on a Barcelona all of lmbench fits into the cache hence we dont see
> >   any real $cache overhead. )
> 
> The PV kernel has over 100K larger text size, nearly 40K alone in mm/ and
> kernel/. Definitely we don't see the worst of the icache or branch buffer 
> overhead on this microbenchmark. (wow, that's a nasty amount of bloat :( )
> 
>  
> > Jeremy, any ideas where this slowdown comes from and how it could be 
> > fixed?
> 
> I had a bit of a poke around the profiles, but nothing stood out. 
> However oprofile counted 50% more cycles in the kernel with PV than with 
> non-PV. I'll have to take a look at the user/system times, because 50% 
> seems ludicrous.... hopefully it's just oprofile noise.

If you have a Core2 test-system could you please try tip/master, which 
also has your do_page_fault-de-bloating patch applied?

<plug>

The other advantage of tip/master would be that you could try precise 
performance counter measurements via:

   http://redhat.com/~mingo/perfcounters/timec.c

and split out the lmbench test-case into a standalone .c file loop. 
Running it as:

   $ taskset 0 ./timec -e -5,-4,-3,0,1,2,3 ./mmap-test

Will give you very precise information about what's going on in that 
workload:

 Performance counter stats for 'mmap-test':

  628315.871980  task clock ticks     (msecs)

          42330  CPU migrations       (events)
         124980  context switches     (events)
       18698292  pagefaults           (events)
  1351875946010  CPU cycles           (events)
  1121901478363  instructions         (events)
    10654788968  cache references     (events)
      633581867  cache misses         (events)

You might also want to try an NMI profile via kerneltop:

   http://redhat.com/~mingo/perfcounters/kerneltop.c

just run it with no arguments on a perfcounters kernel and it will give 
you something like:

 ------------------------------------------------------------------------------
  KernelTop:   20297 irqs/sec  [NMI, 10000 cache-misses],  (all, 8 CPUs)
 ------------------------------------------------------------------------------

              events         RIP          kernel function
   ______     ______   ________________   _______________

            12816.00 - ffffffff803d5760 : copy_user_generic_string!
            11751.00 - ffffffff80647a2c : unix_stream_recvmsg
            10215.00 - ffffffff805eda5f : sock_alloc_send_skb
             9738.00 - ffffffff80284821 : flush_free_list
             6749.00 - ffffffff802854a1 : __kmalloc_track_caller
             3663.00 - ffffffff805f09fa : skb_dequeue
             3591.00 - ffffffff80284be2 : kmem_cache_alloc       [qla2xxx]
             3501.00 - ffffffff805f15f5 : __alloc_skb
             1296.00 - ffffffff803d8eb4 : list_del       [qla2xxx]
             1110.00 - ffffffff805f0ed2 : kfree_skb

	Ingo
