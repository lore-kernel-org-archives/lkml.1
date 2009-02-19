Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZBSVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZBSVi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZBSViR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:38:17 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:50728 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZBSViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UPfLPUhQi+5R8qJ6+W4u3H3P3EYbjor3tU/vufW4Leob5iYOtqDMaXQmaOohU4uA4K
         aWg8TYxlFoNsLb42dHOxBMyH/vLOowa/ecOLsL15FBtr/POUobDAKR5qwKhS8JI8uVr8
         FKxKZBJ5z4vY72aGHpih3+np/1PGEV7a83/tQ=
Date: Thu, 19 Feb 2009 22:38:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfd] function-graph augmentation
Message-ID: <20090219213810.GB5084@nowhere>
References: <1235077304.4612.662.camel@laptop> <20090219212807.GA5084@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219212807.GA5084@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 10:28:08PM +0100, Frederic Weisbecker wrote:
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
> Another race will be interrupts. And interrupt can fill a lot of entries
> between a trace entry and the parameters.
> 
> And yet another thing: the ring buffer does not allow yet to peek more than one entry
> further. But, I guess it doesn't require a lot of change.
> 
> The other solution would be to have a hashtable of functions for which we want to store the
> parameters where we can find the number of parameters to store, and their type.
> This way we could atomically submit those parameter entries and be more sure they will follow
> the current one.
> 
>  
> > trace_graph_return -- handle_mm_fault()
> > trace_func_ret -- 2
> > 
> > We'd render:
> > 
> >  3)   8.806 us    |  } = 2
> > 
> > Then we can register with tracepoints inside functions to add these
> > generic trace_func_arg/_ret entries to augment the graph (and or
> > function) tracer.
> 
> 
> We have some vague discussions about he return value.


Grr, s/have/had

Well, storing the return value as an unsigned long is generic.
It will probably match most of the return types...

Or we can follow the functions hashtable idea for return types: for most of the functions
we store an unsigned long that we will output in hex, for some other we can store special
values depending of the type given for the specific entry (or why not with a callback called
on output time).


> The most simple would be to pick it on the return value register and send it the rest of
> the trace. By default we can just print a hex value of an unsigned long size.
> That would be generic...
>  
> > 
> > Does that make sense?
> > 
> 

