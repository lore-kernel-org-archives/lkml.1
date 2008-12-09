Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYLINrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYLINrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYLINrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:47:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYLINrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:47:01 -0500
Date: Tue, 9 Dec 2008 14:46:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
Message-ID: <20081209134636.GA1926@elte.hu>
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> > There's a new "counter group record" facility that is a 
> > straightforward extension of the existing "irq record" notification 
> > type. This record type can be set on a 'master' counter, and if the 
> > master counter triggers an IRQ or an NMI, all the 'secondary' 
> > counters are read out atomically and are put into the counter-group 
> > record. The result can then be read() out by userspace via a single 
> > system call. (Based on extensive feedback from Paul Mackerras and 
> > David Miller, thanks guys!)
> 
> That is unfortunately not generic enough. You need a bit more 
> flexibility than master/secondaries, I am afraid.  What tools want is 
> to be able to express:
>
>    - when event X overflows, record values of events  J, K
>    - when event Y overflows, record values of events  Z, J

hm, the new group code in perfcounters-v2 can already do this. Have you 
tried to use it and it didnt work? If so then that's a bug. Nothing in 
the design prevents that kind of group readout.

[ We could (and probably will) enhance the grouping relationship some
  more, but group readouts are a fundamentally inferior mode of 
  profiling. (see below for the explanation) ]

> I am not making this up. I know tools that do just that, i.e., that is 
> collecting two distinct profiles in a single run. This is how, for 
> instance, you can collect a flat profile and the call graph in one run, 
> very much like gprof.

yeah, but it's still the fundamentally wrong thing to do.

Being able to extract high-quality performance information from the 
system is the cornerstone of our design, and chosing the right sampling 
model permeates the whole issue of single-counter versus group-readout.

I dont think finer design aspects of kernel support for performance 
counters can be argued without being on the same page about this, so 
please let me outline our view on these things, in (boringly) verbose 
detail - spiked with examples and code as well.

Firstly, sampling "at 1msec intervals" or any fixed period is a _very_ 
wrong mindset - and cross-sampling counters is a similarly wrong mindset.

When there are two (or more) hw metrics to profile, the ideally best 
(i.e. the statistically most stable and most relevant) sampling for the 
two statistical variables (say of l2_misses versus l2_accesses) is to 
sample them independently, via their own metric. Not via a static 1khz 
rate - or via picking one of the variables to generate samples.

[ Sidenote: as long as the hw supports such sort of independent sampling 
  - lets assume so for the sake of argument - not all CPUs are capable of 
  that - most modern CPUs do though. ]

Static frequency [time] sampling has a number of disadvantages that 
drastically reduce its precision and reduce its utility, and 'group' 
sampling where one counter controls the events has similar problems:

- It under-samples rare events such as cachemisses.

  An example: say we have a workload that executes 1 billion instructions 
  a second, of which 5000 generate a cachemiss. Only one in 200,000
  instructions generates a cachemiss. The chance for a static sampling 
  IRQ to hit exactly an instruction that causes the cachemiss is 1:200 
  (0.5%) in every second. That is very low probability, and the profile 
  would not be very helpful - even though it samples at a seemingly 
  adequate frequency of 1000 events per second!

  With per event counters and per event sampling that KernelTop uses, we 
  get an event next to the instruction that causes a cachemiss with a
  100% certainty, all the time. The profile and its per instruction
  aspects suddenly become a whole lot more accurate and whole lot more 
  interesting.

- Static frequency and group sampling also runs the risk of systematic 
  error/skew of sampling if any workload component has any correlation
  with the "1msec" global sampling period.

  For example: say we profile a workload that runs a timer every 20
  msecs. In such a case the profile could be skewed assymetrically
  against [or in favor of] that timer activity that it does every 10
  milliseconds.

  Good sampling wants the samples to be generated in proportion to the
  variable itself, not proportional to absolute time.

- Static sampling also over-samples when the workload activity goes
  down (when it goes more idle).

  For example: we profile a fluctuating workload that is sometimes only
  0.2% busy, i.e. running only for 2 milliseconds every second. Still we
  keep interrupting it at 1 khz - that can be a very brutal systematic
  skew if the sampling overhead is 2 microseconds, totalling to 2 msecs
  overhead every second - so 50% of what runs on the CPU will be sampling
  code - impacting/skewing the sampled code.

  Good sampling wants to 'follow' the ebb and flow of the actual hw
  events that the CPU has.

The best way to sample two metrics such as "cache accesses" and "cache 
misses" (or say "cache misses" versus "TLB misses") is to sample the two 
variables _independently_, and to build independent histograms out of 
them.

The combination (or 'grouping') of the measured variables is thus done at 
the output stage _after_ data acquisition, to provide a weighted 
histogram (or a split-view double histogram).

For example, in a "l2 misses" versus "l2 accesses" case, the highest 
quality of sampling is to use two independent sampling IRQs with such 
sampling parameters:

  - one notification every     200 L2 cache misses
  - one notification every  10,000 L2 cache accesses

[ this is a ballpark figure - the sample rate is a function of the
  averages of the workload and the characteristics of the CPU. ]

And at the output stage display a combination of:

  l2_accesses[pc]
  l2_misses[pc]
  l2_misses[pc] / l2_accesseses[pc]

Note that if we had a third variable as well - say icache_misses[], we 
could combine the three metrics:

  l2_misses[pc] / l2_accesses[pc] / icache_misses[pc]

  ( such a view expresses the miss/access ratio in a branch-weighted
    fashion: it weighs down instructions that also show signs of icache 
    pressure and goes for the functions with a high dcache rate but low 
    icache pressure - i.e. commonly executed functions with a high data 
    miss rate. )

Sampling at a static frequency is acceptable as well in some cases, and 
will lead to an output that is usable for some things. It's just not the 
best sampling model, and it's not usable at all for certain important 
things such as highly derived views, good instruction level profiles or 
rare hw events.

I've uploaded a new version of kerneltop.c that has such a multi-counter 
sampling model that follows this statistical model:

    http://redhat.com/~mingo/perfcounters/kerneltop.c

Example of usage:

I've started a tbench 64 localhost workload on a 16way x86 box. I want to 
check the miss/refs ratio. I first did a sample one of the metrics, 
cache-references:

$ ./kerneltop -e 2 -c 100000 -C 2

------------------------------------------------------------------------------
 KernelTop:    1311 irqs/sec  [NMI, 10000 cache-refs],  (all, cpu: 2)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

            5717.00 - ffffffff803666c0 : copy_user_generic_string!
             355.00 - ffffffff80507646 : tcp_sendmsg
             315.00 - ffffffff8050abcb : tcp_ack
             222.00 - ffffffff804fbb20 : ip_rcv_finish
             215.00 - ffffffff8020a75b : __switch_to
             194.00 - ffffffff804d0b76 : skb_copy_datagram_iovec
             187.00 - ffffffff80502b5d : __inet_lookup_established
             183.00 - ffffffff8051083d : tcp_transmit_skb
             160.00 - ffffffff804e4fc9 : eth_type_trans
             156.00 - ffffffff8026ae31 : audit_syscall_exit


Then i checked the characteristics of the other metric [cache-misses]: 

$ ./kerneltop -e 3 -c 200 -C 2

------------------------------------------------------------------------------
 KernelTop:    1362 irqs/sec  [NMI, 200 cache-misses],  (all, cpu: 2)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

            1419.00 - ffffffff803666c0 : copy_user_generic_string!
            1075.00 - ffffffff804e4fc9 : eth_type_trans
            1059.00 - ffffffff804d8baa : dst_release
             949.00 - ffffffff80510004 : tcp_established_options
             841.00 - ffffffff804fbb20 : ip_rcv_finish
             569.00 - ffffffff804ce808 : skb_push
             454.00 - ffffffff80502b5d : __inet_lookup_established
             453.00 - ffffffff805001a3 : ip_queue_xmit
             298.00 - ffffffff804cf5d8 : skb_release_head_state
             247.00 - ffffffff804ce74b : skb_copy_and_csum_dev

then, to get the "combination" view of the two counters, i appended the 
two command lines:

 $ ./kerneltop -e 3 -c 200 -e 2 -c 10000 -C 2

------------------------------------------------------------------------------
 KernelTop:    2669 irqs/sec  [NMI, cache-misses/cache-refs],  (all, cpu: 2)
------------------------------------------------------------------------------

             weight         RIP          kernel function
             ______   ________________   _______________

              35.20 - ffffffff804ce74b : skb_copy_and_csum_dev
              33.00 - ffffffff804cb740 : sock_alloc_send_skb
              31.26 - ffffffff804ce808 : skb_push
              22.43 - ffffffff80510004 : tcp_established_options
              19.00 - ffffffff8027d250 : find_get_page
              15.76 - ffffffff804e4fc9 : eth_type_trans
              15.20 - ffffffff804d8baa : dst_release
              14.86 - ffffffff804cf5d8 : skb_release_head_state
              14.00 - ffffffff802217d5 : read_hpet
              12.00 - ffffffff804ffb7f : __ip_local_out
              11.97 - ffffffff804fc0c8 : ip_local_deliver_finish
               8.54 - ffffffff805001a3 : ip_queue_xmit

[ It's interesting to see that a seemingly common function, 
  copy_user_generic_string(), got eliminated from the top spots - because 
  there are other functions whose relative cachemiss rate is far more 
  serious. ]

The above "derived" profile output is relatively stable under kerneltop 
with the use of ~2600 sample irqs/sec and the 2 seconds default refresh. 
I'd encourage you to try to achieve the same quality of output with 
static 2600 hz sampling - it wont work with the kind of event rates i've 
worked with above, no matter whether you read out a single counter or a 
group of counters, atomically or not. (because we just dont get 
notification PCs at the relevant hw events - we get PCs with a time 
sample)

And that is just one 'rare' event type (cachemisses) - if we had two such 
sources (say l2 cachemisses and TLB misses) then such type of combined 
view would only be possible if we got independent events from both 
hardware events.

And note that once you accept that the highest quality approach is to 
sample the hw events independently, all the "group readout" approaches 
become a second-tier mechanism. KernelTop uses that model and works just 
fine without any group readout and it is making razor sharp profiles, 
down to the instruction level.

[ Note that there's special-cases where group-sampling can limp along
  with acceptable results: if one of the two counters has so many events
  that sampling by time or sampling by the rare event type gives relevant
  context info. But the moment both event sources are rare, the group
  model breaks down completely and produces meaningless results. It's
  just a fundamentally wrong kind of abstraction to mix together
  unrelated statistical variables. And that's one of the fundamental
  design problems i see with perfmon-v3. ]

	Ingo
