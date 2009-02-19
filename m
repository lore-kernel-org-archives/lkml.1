Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbZBSVCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbZBSVCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZBSVCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:02:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZBSVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:02:00 -0500
Subject: [rfd] function-graph augmentation
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 22:01:44 +0100
Message-Id: <1235077304.4612.662.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was thinking how best to augment the function graph tracer with
various information. It seemed useful to add argument/return tracer
entries which, when found after a function entry, or function exit entry
would be rendered in the trace.

So supposing something like;

 3)               |  handle_mm_fault() {                                        
 3)               |    count_vm_event() {                                       
 3)   0.243 us    |      test_ti_thread_flag();                                 
 3)   0.754 us    |    }                                                        
 3)   0.249 us    |    pud_alloc();                                             
 3)   0.251 us    |    pmd_alloc();                                             
 3)               |    __do_fault() {                                           
 3)               |      filemap_fault() {                                      
 3)               |        find_lock_page() {                                   
 3)               |          find_get_page() {                                  
 3)   0.248 us    |            test_ti_thread_flag();                           
 3)   0.844 us    |          }                                                  
 3)   1.341 us    |        }                                                    
 3)   1.837 us    |      }                                                      
 3)   0.275 us    |      _spin_lock();                                          
 3)   0.257 us    |      page_add_file_rmap();                                  
 3)   0.233 us    |      native_set_pte_at();                                   
 3)               |      _spin_unlock() {                                       
 3)   0.248 us    |        test_ti_thread_flag();                               
 3)   0.742 us    |      }                                                      
 3)               |      unlock_page() {                                        
 3)   0.243 us    |        page_waitqueue();                                    
 3)   0.237 us    |        __wake_up_bit();                                     
 3)   1.209 us    |      }                                                      
 3)   6.274 us    |    }                                                        
 3)   8.806 us    |  } 

Say we found:

trace_graph_entry -- handle_mm_fault()
trace_func_arg -- address:0xffffffff
trace_func_arg -- write_access:1

We'd render:

 3)               |  handle_mm_fault(.address=0xffffffff, .write_access=1) {

trace_graph_return -- handle_mm_fault()
trace_func_ret -- 2

We'd render:

 3)   8.806 us    |  } = 2

Then we can register with tracepoints inside functions to add these
generic trace_func_arg/_ret entries to augment the graph (and or
function) tracer.


Does that make sense?

