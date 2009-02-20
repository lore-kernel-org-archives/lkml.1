Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZBTIjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZBTIjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBTIjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:39:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZBTIjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:39:22 -0500
Date: Fri, 20 Feb 2009 09:39:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfd] function-graph augmentation
Message-ID: <20090220083902.GD24555@elte.hu>
References: <1235077304.4612.662.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235077304.4612.662.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi,
> 
> I was thinking how best to augment the function graph tracer 
> with various information. It seemed useful to add 
> argument/return tracer entries which, when found after a 
> function entry, or function exit entry would be rendered in 
> the trace.
> 
> So supposing something like;
> 
>  3)               |  handle_mm_fault() {                                        
>  3)               |    count_vm_event() {                                       
>  3)   0.243 us    |      test_ti_thread_flag();                                 
>  3)   0.754 us    |    }                                                        
>  3)   0.249 us    |    pud_alloc();                                             
>  3)   0.251 us    |    pmd_alloc();                                             
>  3)               |    __do_fault() {                                           
>  3)               |      filemap_fault() {                                      
>  3)               |        find_lock_page() {                                   
>  3)               |          find_get_page() {                                  
>  3)   0.248 us    |            test_ti_thread_flag();                           
>  3)   0.844 us    |          }                                                  
>  3)   1.341 us    |        }                                                    
>  3)   1.837 us    |      }                                                      
>  3)   0.275 us    |      _spin_lock();                                          
>  3)   0.257 us    |      page_add_file_rmap();                                  
>  3)   0.233 us    |      native_set_pte_at();                                   
>  3)               |      _spin_unlock() {                                       
>  3)   0.248 us    |        test_ti_thread_flag();                               
>  3)   0.742 us    |      }                                                      
>  3)               |      unlock_page() {                                        
>  3)   0.243 us    |        page_waitqueue();                                    
>  3)   0.237 us    |        __wake_up_bit();                                     
>  3)   1.209 us    |      }                                                      
>  3)   6.274 us    |    }                                                        
>  3)   8.806 us    |  } 
> 
> Say we found:
> 
> trace_graph_entry -- handle_mm_fault()
> trace_func_arg -- address:0xffffffff
> trace_func_arg -- write_access:1
> 
> We'd render:
> 
>  3)               |  handle_mm_fault(.address=0xffffffff, .write_access=1) {
> 
> trace_graph_return -- handle_mm_fault()
> trace_func_ret -- 2
> 
> We'd render:
> 
>  3)   8.806 us    |  } = 2
> 
> Then we can register with tracepoints inside functions to add 
> these generic trace_func_arg/_ret entries to augment the graph 
> (and or function) tracer.
> 
> Does that make sense?

Yeah, it looks really nice that way.

	Ingo
