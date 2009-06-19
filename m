Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZFSQQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZFSQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZFSQQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:16:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZFSQQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:16:47 -0400
Date: Fri, 19 Jun 2009 18:16:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090619161607.GA5332@elte.hu>
References: <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <20090615200619.GA10632@Krystal> <20090615204715.GA24554@elte.hu> <20090615210225.GA12919@Krystal> <20090615211209.GA27100@elte.hu> <alpine.LFD.2.01.0906151617030.6276@localhost.localdomain> <20090619152029.GA7204@elte.hu> <20090619155115.GA24111@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619155115.GA24111@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Mon, 15 Jun 2009, Ingo Molnar wrote:
> > > > 
> > > > See the numbers in the other mail: about 33 million pagefaults 
> > > > happen in a typical kernel build - that's ~400K/sec - and that 
> > > > is not a particularly really pagefault-heavy workload.
> > > 
> > > Did you do any function-level profiles?
> > > 
> > > Last I looked at it, the real cost of page faults were all in the 
> > > memory copies and page clearing, and while it would be nice to 
> > > speed up the kernel entry and exit, the few tens of cycles we 
> > > might be able to get from there really aren't all that important.
> > 
> > Yeah.
> > 
> > Here's the function level profiles of a typical kernel build on a 
> > Nehalem box:
> > 
> >  $ perf report --sort symbol
> > 
> >  #
> >  # (14317328 samples)
> >  #
> >  # Overhead  Symbol
> >  # ........  ......
> >  #
> >     44.05%  0x000000001a0b80
> 
> It makes me wonder how the following scenario is accounted :
> 
> - Execution of a newly forked/exec'd process instruction causes a 
>   fault. (traps, faults and interrupts can take roughly 2000 
>   cycles to execute)
>
> - PC sampling interrupt fires.
> 
> Will it account the execution time as part of user-space or 
> kernel-space execution ?

"It depends".

With call-chain profiling ("perf record --call-graph" + "perf report 
--sort parent") this will show up as:

#
# (19525018 samples)
#
# Overhead  Parent symbol       
# ........  ....................
#
    88.60%  [other]             
     4.96%  do_page_fault       
     1.74%  sys_write           
     1.18%  sys_openat          
     0.75%  sys_exit_group      
     0.74%  sys_execve          
     0.43%  sys_read            
     0.28%  sys_mmap            
     0.23%  sys_clone           
     0.21%  sys_close           
     0.17%  sys_munmap          
     0.15%  sys_poll            
     0.13%  sys_lstat           
     0.09%  sys_faccessat       
     0.05%  sys_mprotect        

This line:

     4.96%  do_page_fault       

Is the summed up overhead of all things page faults.

If you sort by a specific user-space symbol, then _its_ own 
generated page-faults will be displayed.

Say, you profile 'git gc' done in Git's repo with 10 KHz:

  perf record -g -f -F 10000 -- ./git gc

Raw outline of overhead categories:

 $ perf report --sort parent

 #
 # Overhead  Parent symbol       
 # ........  ....................
 #
    96.97%  [other]             
     1.32%  do_page_fault       
     0.54%  sys_write           
     0.21%  sys_exit_group      
     0.15%  sys_open            
     0.14%  sys_execve          
     0.13%  sys_mmap            
     0.11%  sys_poll            
     0.10%  sys_clone           

Note that do_page_fault has 1.32% total overhead there. But if you 
only look at main's overhead:

#
# Overhead  Symbol
# ........  ......
#
    33.12%  [.] lookup_object
    11.17%  [.] __GI_strlen
     5.14%  [.] decode_tree_entry
     2.94%  [.] __GI_memcpy
     2.58%  [.] find_pack_entry_one
     2.30%  [.] lookup_blob
     1.61%  [.] tree_entry
     1.16%  [.] process_tree
     ....
     0.08%  [k] page_fault
     0.02%  [k] do_page_fault
     0.02%  [k] page_fault
     0.02%  [k] filemap_fault
     0.02%  [k] __do_fault
     0.01%  [k] handle_mm_fault

The page fault overhead is down the bottom. Why? Because most 
pagefaults are not raised by 'main', but by the dynamic loader which 
runs sooner than that.

> Depending on how the sampling mechanism finds out if it is running 
> in kernel mode or userspace mode, this might make the userspace PC 
> appear as currently running even though the current execution 
> context is the very beginning of the page fault handler (1st 
> instruction servicing the fault).

It's much more nuanced than a binary 'user-space' versus 
'kernel-space' decision.

A true 'raw' call-chain looks like this:

0x25b0 [0x108]: PERF_EVENT (IP, 5): 3455: 0xffffffff810b63ad period: 310083
... chain: nr:28
.....  0: ffffffffffffff80
.....  1: ffffffff810b63ad
.....  2: ffffffff81018258
.....  3: ffffffff810aeddb
.....  4: ffffffff810af14d
.....  5: ffffffff81019042
.....  6: ffffffff8153245e
.....  7: ffffffff81533783
.....  8: ffffffff815337cd
.....  9: ffffffff8105fc8c
..... 10: ffffffff81531c2a
..... 11: ffffffff81531e0e
..... 12: ffffffff8153174a
..... 13: ffffffff810b68aa
..... 14: ffffffff810daa24
..... 15: ffffffff810c558e
..... 16: ffffffff810c78e9
..... 17: ffffffff81533739
..... 18: ffffffff815314ff
..... 19: ffffffff810b1716
..... 20: ffffffff810b22a2
..... 21: ffffffff810e5586
..... 22: ffffffff810e6080
..... 23: ffffffff810e61a8
..... 24: ffffffff8100bd9b
..... 25: fffffffffffffe00
..... 26: 0000003641ed6590
..... 27: 0000003646e046b3
 ... thread: git:3455
 ...... dso: [kernel]

25 kernel-context RIPs followed by a context separator 
(fffffffffffffe00) followed by two user-space RIPs.

So whether this is kernel-space or user-space sample depends on the 
analysis stage - how you decide to look at it via perf report. If 
you only look at the top surface via 'perf report --sort symbol' 
it's a "kernel-space" sample. If you look deeper, it could be a 
user-space one too.

The full list of contexts is:

enum perf_callchain_context {
        PERF_CONTEXT_HV                 = (__u64)-32,
        PERF_CONTEXT_KERNEL             = (__u64)-128,
        PERF_CONTEXT_USER               = (__u64)-512,

        PERF_CONTEXT_GUEST              = (__u64)-2048,
        PERF_CONTEXT_GUEST_KERNEL       = (__u64)-2176,
        PERF_CONTEXT_GUEST_USER         = (__u64)-2560,

        PERF_CONTEXT_MAX                = (__u64)-4095,
};

and a call-chain can in theory include all of these, in a nice stack 
of call-chain entries.

( Btw., we are planning to adding context separators for IRQ and 
  softirq contexts as well - to be able to isolate hardirq and 
  softirq workloads (separated away from the mostly unrelated 
  syscall level and user-level execution overhead). )

Hope this answers your questions,

	Ingo
