Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZBTI4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZBTI4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZBTI4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:56:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZBTI4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:56:42 -0500
Date: Fri, 20 Feb 2009 09:56:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfd] function-graph augmentation
Message-ID: <20090220085627.GE24555@elte.hu>
References: <1235077304.4612.662.camel@laptop> <20090219212807.GA5084@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219212807.GA5084@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Feb 19, 2009 at 10:01:44PM +0100, Peter Zijlstra wrote:
> > Hi,
> > 
> > I was thinking how best to augment the function graph tracer with
> > various information. It seemed useful to add argument/return tracer
> > entries which, when found after a function entry, or function exit entry
> > would be rendered in the trace.
> > 
> > So supposing something like;
> > 
> >  3)               |  handle_mm_fault() {                                        
> >  3)               |    count_vm_event() {                                       
> >  3)   0.243 us    |      test_ti_thread_flag();                                 
> >  3)   0.754 us    |    }                                                        
> >  3)   0.249 us    |    pud_alloc();                                             
> >  3)   0.251 us    |    pmd_alloc();                                             
> >  3)               |    __do_fault() {                                           
> >  3)               |      filemap_fault() {                                      
> >  3)               |        find_lock_page() {                                   
> >  3)               |          find_get_page() {                                  
> >  3)   0.248 us    |            test_ti_thread_flag();                           
> >  3)   0.844 us    |          }                                                  
> >  3)   1.341 us    |        }                                                    
> >  3)   1.837 us    |      }                                                      
> >  3)   0.275 us    |      _spin_lock();                                          
> >  3)   0.257 us    |      page_add_file_rmap();                                  
> >  3)   0.233 us    |      native_set_pte_at();                                   
> >  3)               |      _spin_unlock() {                                       
> >  3)   0.248 us    |        test_ti_thread_flag();                               
> >  3)   0.742 us    |      }                                                      
> >  3)               |      unlock_page() {                                        
> >  3)   0.243 us    |        page_waitqueue();                                    
> >  3)   0.237 us    |        __wake_up_bit();                                     
> >  3)   1.209 us    |      }                                                      
> >  3)   6.274 us    |    }                                                        
> >  3)   8.806 us    |  } 
> > 
> > Say we found:
> > 
> > trace_graph_entry -- handle_mm_fault()
> > trace_func_arg -- address:0xffffffff
> > trace_func_arg -- write_access:1
> > 
> > We'd render:
> > 
> >  3)               |  handle_mm_fault(.address=0xffffffff, .write_access=1) {
> 
> 
> Good solution, except that I wonder about preemption races.
> Imagine the following scenario:
> 
> CPU#0
> trace_graph_entry -> commit to ring_buffer CPU#0
> 
> //entering a the function
> //task is scheduled out and reschduled later on CPU#1
> 
> CPU#1
> trace_func_arg -> commit to ring_buffer CPU#1
> 
> Later on the graph output process:
> 
> print("func(")
> search_for_args on buffer but don't find them because they are another
> cpu ring_buffer.
> 
> Well I guess it should be rare, but it can happen.
> Another race will be interrupts. And interrupt can fill a lot 
> of entries between a trace entry and the parameters.
> 
> And yet another thing: the ring buffer does not allow yet to 
> peek more than one entry further. But, I guess it doesn't 
> require a lot of change.
> 
> The other solution would be to have a hashtable of functions 
> for which we want to store the parameters where we can find 
> the number of parameters to store, and their type. This way we 
> could atomically submit those parameter entries and be more 
> sure they will follow the current one.

Hm, i dont really like this approach of doing it via the 
ring-buffer - it's fundamentally fragile. There's two solutions 
i can think of - one is to use the return stack and the other 
one is to also use dwarf2 data.

1)

Regarding return values there's not a lot of problems (except 
the bit size of the return value). No preemption and no IRQ 
troubles either since it's all atomic and we augment the entry 
that we emit - right?

Regarding entry parameters augmentation, it should be solved 
differently i believe.

When say handle_mm_fault() is augmented, we already create a 
function-return-stack entry for it. So when the tracepoint is 
executed, it should not try to find things in the ring buffer 
(which as you point out is racy and fragile:

 - preemption moves us to the wrong ringbuffer
 - IRQs can interact
 - it can take a long time to scan the ring-buffer
 - entries might be consumed already, etc., etc.

but we could delay the injection of the function entry event, up 
until we reach the tracepoint. We can do that by annotating 
handle_mm_fault() with a trace_arguments attribute for example.

In such a solution there's no 'distance' between the entry event 
and the extra-parameters event, so it's all atomic and neither 
preemption nor IRQs cause problems.

2)

Another, entirely different, and i think complementary approach, 
which exciting new possibilities would be to (also) 
automatically pick up arguments from the stack, on function 
entry.

If there's a (read-mostly, lockless-to-read and scalable) 
function attributes hash, then we could encode the parameters 
signature of functions (or at least, of certain functions) in 
the attributes hash. Then the tracer will know how many 
arguments to pick up from the stack.

This approach has the advantage that we could reconstruct the 
parameters of _arbitrary_ functions, without having to touch 
those functions. We already enumerate all functions during build 
time, it would take some more dwarf2 magic to recover the 
call/parameter signature. Oh, and at that time we could also 
record the _return type_ - easing the return value.

Note that it does not take a full, bloated DEBUG_INFO build - we 
can build a -g object to get the dwarf2 data and then strip out 
the dwarf2 data.

Arnaldo, what do you think about this, how feasible would it be 
to put dwarf2 magic into scripts/recordmcount.pl?

	Ingo
