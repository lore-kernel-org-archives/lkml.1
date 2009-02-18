Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZBRRaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZBRRaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZBRRa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:30:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57401 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZBRRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:30:28 -0500
Date: Wed, 18 Feb 2009 12:30:26 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] tracing/function-graph-tracer: provide
 documentation for the function graph tracer
In-Reply-To: <499ba227.077e420a.56d6.ffffc38b@mx.google.com>
Message-ID: <alpine.DEB.1.10.0902181229550.11411@gandalf.stny.rr.com>
References: <499ba227.077e420a.56d6.ffffc38b@mx.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Frederic,

I'll go through it later. I Really need to rewrite ftrace.txt to match 
what is in 29 now. That will soon be a high priority for me.

-- Steve


On Wed, 18 Feb 2009, Frederic Weisbecker wrote:

> This patch provides the documentation to use the function graph tracer on the ftrace.txt
> file.
> 
> I know how evil is my english, so don't hesitate to throw some tomatoes and I will fix
> the wicked sentences :-)
> 
> Note: I guess it could also find its way on 2.6.29, except that it describes the absolute timestamp
> field which is not present in the 2.6.29 version. May be I should split it up in two parts?
> 
> There are also some pending things such as explanations for set_ftrace_pid, hardirq signals and
> context switches.
> 
> I would also like to put a link to http://people.redhat.com/mingo/tip.git/tracing-quickstart.txt
> from which I picked some ideas and which provides a more quick start and a more practical use of this tracer,
> but I don't know if you would accept an external url.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  Documentation/ftrace.txt |  226 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 226 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
> index 758fb42..055bcd2 100644
> --- a/Documentation/ftrace.txt
> +++ b/Documentation/ftrace.txt
> @@ -129,6 +129,10 @@ of ftrace. Here is a list of some of the key files:
>  
>    set_ftrace_pid: Have the function tracer only trace a single thread.
>  
> +  set_graph_function: Select the function where the trace have to start
> +		with the function graph tracer (See the section
> +		"dynamic ftrace" for more details).
> +
>    available_filter_functions: This lists the functions that ftrace
>  		has processed and can trace. These are the function
>  		names that you can pass to "set_ftrace_filter" or
> @@ -143,6 +147,12 @@ Here is the list of current tracers that may be configured.
>  
>    function - function tracer that uses mcount to trace all functions.
>  
> +  function_graph_tracer - similar to the function tracer except that the
> +		function tracer probes the functions on their entry whereas the
> +		function graph tracer traces on both entry and exit of the
> +		functions. It then provides the ability to draw a graph of
> +		function calls like a primitive C code source.
> +
>    sched_switch - traces the context switches between tasks.
>  
>    irqsoff - traces the areas that disable interrupts and saves
> @@ -1226,6 +1236,163 @@ kernel module:
>  [...]
>  
>  
> +function graph tracer
> +---------------------------
> +
> +This tracer is similar to the function tracer except that it probes
> +a function on its entry and its exit.
> +This is done by setting a dynamically allocated stack of return addresses on each
> +task_struct. Then the tracer overwrites the return address of each function traced
> +to set a custom probe. Thus the original return address is stored on the stack of return
> +address in the task_struct.
> +
> +Probing on both extremities of a function leads to special features such as
> +
> +_ measure of function's time execution
> +_ having a reliable call stack to draw function calls graph
> +
> +This tracer is useful in several situations:
> +
> +_ you want to find the reason of a strange kernel behavior and need to see
> +  what happens in detail on any areas (or specific ones).
> +_ you are experiencing weird latencies but it's difficult to find its origin.
> +_ you want to find quickly which path is taken by a specific function
> +_ you just want to see what happens inside your kernel
> +
> +# tracer: function_graph
> +#
> +# CPU  DURATION                  FUNCTION CALLS
> +# |     |   |                     |   |   |   |
> +
> + 0)               |  sys_open() {
> + 0)               |    do_sys_open() {
> + 0)               |      getname() {
> + 0)               |        kmem_cache_alloc() {
> + 0)   1.382 us    |          __might_sleep();
> + 0)   2.478 us    |        }
> + 0)               |        strncpy_from_user() {
> + 0)               |          might_fault() {
> + 0)   1.389 us    |            __might_sleep();
> + 0)   2.553 us    |          }
> + 0)   3.807 us    |        }
> + 0)   7.876 us    |      }
> + 0)               |      alloc_fd() {
> + 0)   0.668 us    |        _spin_lock();
> + 0)   0.570 us    |        expand_files();
> + 0)   0.586 us    |        _spin_unlock();
> +
> +
> +There are several columns that can be dynamically enabled/disabled.
> +You can use every combination of options you want, depending on your needs.
> +
> +_ The cpu number on which the function executed is default enabled.
> +  It is sometimes better to only trace one cpu (see tracing_cpu_mask file)
> +  or you might sometimes see unordered function calls while cpu tracing switch.
> +
> +	hide: echo nofuncgraph-cpu > /debug/tracing/trace_options
> +	show: echo funcgraph-cpu > /debug/tracing/trace_options
> +
> +_ The duration (function's time of execution) is displayed on the closing bracket
> +  line of a function or on the same line than the current function in case of a leaf
> +  one. It is default enabled.
> +
> +	hide: echo nofuncgraph-duration > /debug/tracing/trace_options
> +	show: echo funcgraph-duration > /debug/tracing/trace_options
> +
> +_ The overhead field precedes the duration one in case of reached duration thresholds.
> +
> +	hide: echo nofuncgraph-overhead > /debug/tracing/trace_options
> +	show: echo funcgraph-overhead > /debug/tracing/trace_options
> +	depends on: funcgraph-duration
> +
> +  ie:
> +
> +  0)               |    up_write() {
> +  0)   0.646 us    |      _spin_lock_irqsave();
> +  0)   0.684 us    |      _spin_unlock_irqrestore();
> +  0)   3.123 us    |    }
> +  0)   0.548 us    |    fput();
> +  0) + 58.628 us   |  }
> +
> +  [...]
> +
> +  0)               |      putname() {
> +  0)               |        kmem_cache_free() {
> +  0)   0.518 us    |          __phys_addr();
> +  0)   1.757 us    |        }
> +  0)   2.861 us    |      }
> +  0) ! 115.305 us  |    }
> +  0) ! 116.402 us  |  }
> +
> +  + means that the function exceeded 10 usecs.
> +  ! means that the function exceeded 100 usecs.
> +
> +
> +_ The task/pid field displays the thread cmdline and pid which executed the function.
> +  It is default disabled.
> +
> +	hide: echo nofuncgraph-proc > /debug/tracing/trace_options
> +	show: echo funcgraph-proc > /debug/tracing/trace_options
> +
> +  ie:
> +
> +  # tracer: function_graph
> +  #
> +  # CPU  TASK/PID        DURATION                  FUNCTION CALLS
> +  # |    |    |           |   |                     |   |   |   |
> +  0)    sh-4802     |               |                  d_free() {
> +  0)    sh-4802     |               |                    call_rcu() {
> +  0)    sh-4802     |               |                      __call_rcu() {
> +  0)    sh-4802     |   0.616 us    |                        rcu_process_gp_end();
> +  0)    sh-4802     |   0.586 us    |                        check_for_new_grace_period();
> +  0)    sh-4802     |   2.899 us    |                      }
> +  0)    sh-4802     |   4.040 us    |                    }
> +  0)    sh-4802     |   5.151 us    |                  }
> +  0)    sh-4802     | + 49.370 us   |                }
> +
> +
> +_ The absolute time field is an absolute timestamp given by the clock since
> +  it started. A snapshot of this time is given on each entry/exit of functions
> +
> +	hide: echo nofuncgraph-abstime > /debug/tracing/trace_options
> +	show: echo funcgraph-abstime > /debug/tracing/trace_options
> +
> +  ie:
> +
> +  #
> +  #      TIME       CPU  DURATION                  FUNCTION CALLS
> +  #       |         |     |   |                     |   |   |   |
> +  360.774522 |   1)   0.541 us    |                                          }
> +  360.774522 |   1)   4.663 us    |                                        }
> +  360.774523 |   1)   0.541 us    |                                        __wake_up_bit();
> +  360.774524 |   1)   6.796 us    |                                      }
> +  360.774524 |   1)   7.952 us    |                                    }
> +  360.774525 |   1)   9.063 us    |                                  }
> +  360.774525 |   1)   0.615 us    |                                  journal_mark_dirty();
> +  360.774527 |   1)   0.578 us    |                                  __brelse();
> +  360.774528 |   1)               |                                  reiserfs_prepare_for_journal() {
> +  360.774528 |   1)               |                                    unlock_buffer() {
> +  360.774529 |   1)               |                                      wake_up_bit() {
> +  360.774529 |   1)               |                                        bit_waitqueue() {
> +  360.774530 |   1)   0.594 us    |                                          __phys_addr();
> +
> +
> +You can put some comments on specific functions by using ftrace_printk()
> +For example, if you want to put a comment inside the __might_sleep() function,
> +you just have to include <linux/ftrace.h> and call ftrace_printk() inside __might_sleep()
> +
> +ftrace_printk("I'm a comment!\n")
> +
> +will produce:
> +
> + 1)               |             __might_sleep() {
> + 1)               |                /* I'm a comment! */
> + 1)   1.449 us    |             }
> +
> +
> +You might find other useful features for this tracer on the "dynamic ftrace"
> +section such as tracing only specific functions or tasks.
> +
>  dynamic ftrace
>  --------------
>  
> @@ -1427,6 +1594,65 @@ Produces:
>  
>  We can see that there's no more lock or preempt tracing.
>  
> +
> +* Dynamic ftrace with the function graph tracer *
> +
> +
> +Although what has been explained above concerns both the function tracer and
> +the function_graph_tracer, the following concerns only the latter.
> +
> +If you want to trace only one function and all of its childs, you just have
> +to echo its name on set_graph_function:
> +
> +echo __do_fault > set_graph_function
> +
> +will produce the following:
> +
> + 0)               |  __do_fault() {
> + 0)               |    filemap_fault() {
> + 0)               |      find_lock_page() {
> + 0)   0.804 us    |        find_get_page();
> + 0)               |        __might_sleep() {
> + 0)   1.329 us    |        }
> + 0)   3.904 us    |      }
> + 0)   4.979 us    |    }
> + 0)   0.653 us    |    _spin_lock();
> + 0)   0.578 us    |    page_add_file_rmap();
> + 0)   0.525 us    |    native_set_pte_at();
> + 0)   0.585 us    |    _spin_unlock();
> + 0)               |    unlock_page() {
> + 0)   0.541 us    |      page_waitqueue();
> + 0)   0.639 us    |      __wake_up_bit();
> + 0)   2.786 us    |    }
> + 0) + 14.237 us   |  }
> + 0)               |  __do_fault() {
> + 0)               |    filemap_fault() {
> + 0)               |      find_lock_page() {
> + 0)   0.698 us    |        find_get_page();
> + 0)               |        __might_sleep() {
> + 0)   1.412 us    |        }
> + 0)   3.950 us    |      }
> + 0)   5.098 us    |    }
> + 0)   0.631 us    |    _spin_lock();
> + 0)   0.571 us    |    page_add_file_rmap();
> + 0)   0.526 us    |    native_set_pte_at();
> + 0)   0.586 us    |    _spin_unlock();
> + 0)               |    unlock_page() {
> + 0)   0.533 us    |      page_waitqueue();
> + 0)   0.638 us    |      __wake_up_bit();
> + 0)   2.793 us    |    }
> + 0) + 14.012 us   |  }
> +
> +You can also select several functions:
> +
> +echo sys_open > set_graph_function
> +echo sys_close >> set_graph_function
> +
> +Now if you want to go back to trace all functions
> +
> +echo > set_graph_function
> +
> +
>  trace_pipe
>  ----------
>  
> -- 
> 1.6.1
> 
> 
> 
> 
