Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZCEBUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZCEBUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCEBTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:19:50 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:53548 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZCEBTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Prx05Q5NSe4gVjUIrvOUPe4K0xtONIRYK1/b76s1WN7IkMXBpeezSEq8I4iy6NjzBS
         6r/oSPaPAW6OQwiSf2coBdVyXIERYU3nCu+LcoYf3LjLgV0zIbv61vR/ciG3OvTqlR33
         +DaKAwQ7Ok0F7Q1NgobkF7tWk0B0jv2HpmU24=
Date: Thu, 5 Mar 2009 02:19:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
	lightweight local clock
Message-ID: <20090305011941.GA9821@nowhere>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:49:22AM +0100, Frederic Weisbecker wrote:
> Impact: decrease hangs risks with the graph tracer on slow systems
> 
> Since the function graph tracer can spend too much time on timer interrupts,
> it's better now to use the more lightweight local clock. Anyway, the function graph
> traces are more reliable on a per cpu trace.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/ftrace.c             |    2 +-
>  kernel/trace/trace_functions_graph.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 3925ec0..40960c2 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -436,7 +436,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  		return;
>  	}
>  
> -	calltime = cpu_clock(raw_smp_processor_id());
> +	calltime = sched_clock();
>  
>  	if (ftrace_push_return_trace(old, calltime,
>  				self_addr, &trace.depth) == -EBUSY) {
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 2461732..c5038f4 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -112,7 +112,7 @@ unsigned long ftrace_return_to_handler(void)
>  	unsigned long ret;
>  
>  	ftrace_pop_return_trace(&trace, &ret);
> -	trace.rettime = cpu_clock(raw_smp_processor_id());
> +	trace.rettime = sched_clock();
>  	ftrace_graph_return(&trace);
>  
>  	if (unlikely(!ret)) {
> -- 
> 1.6.1
> 
> 


Note that these two patches solve the function graph tracer hangs you reported.
But there are still sometimes large latencies (which can reach 4 seconds) and
the reason seems to me obviously come from the timer interrupt tracing.
If you look at the following timer interrupt trace:

 0)   ==========> |
 0)               |          smp_apic_timer_interrupt() {
 0)               |            ack_APIC_irq() {
 0)               |              apic_write() {
 0)   3.597 us    |                native_apic_mem_write();
 0) + 13.203 us   |              }
 0) + 22.573 us   |            }
 0)               |            irq_enter() {
 0)   3.749 us    |              idle_cpu();
 0) + 14.016 us   |            }
 0)               |            tick_handle_periodic() {
 0)               |              tick_periodic() {
 0)   8.882 us    |                _spin_lock();
 0)               |                do_timer() {
 0)               |                  update_wall_time() {
 0)   3.720 us    |                    clocksource_read();
 0)   3.621 us    |                    update_xtime_cache();
 0)               |                    clocksource_get_next() {
 0)   6.355 us    |                      _spin_lock_irqsave();
 0)   5.862 us    |                      _spin_unlock_irqrestore();
 0) + 28.665 us   |                    }
 0) + 60.193 us   |                  }
 0) + 70.076 us   |                }
 0)   4.299 us    |                _spin_unlock();
 0)               |                update_process_times() {
 0)               |                  account_process_tick() {
 0)   4.603 us    |                    account_system_time();
 0) + 14.154 us   |                  }
 0)               |                  run_local_timers() {
 0)               |                    hrtimer_run_queues() {
 0)   3.784 us    |                      current_kernel_time();
 0)               |                      timespec_to_ktime() {
 0)   3.360 us    |                        ktime_set();
 0) + 12.532 us   |                      }
 0)               |                      timespec_to_ktime() {
 0)   3.216 us    |                        ktime_set();
 0) + 12.342 us   |                      }
 0)   6.177 us    |                      _spin_lock();
 0)   4.258 us    |                      _spin_unlock();
 0) + 74.455 us   |                    }
 0)               |                    raise_softirq() {
 0)               |                      raise_softirq_irqoff() {
 0) + 13.328 us   |                    }
 0)               |                    softlockup_tick() {
 0)   6.376 us    |                      get_timestamp();
 0) + 16.665 us   |                    }
 0) ! 126.019 us  |                  }
 0)               |                  rcu_pending() {
 0)               |                    __rcu_pending() {
 0)   3.753 us    |                      cpumask_check();
 0) + 14.203 us   |                    }
 0) + 23.865 us   |                  }
 0)               |                  rcu_check_callbacks() {
 0)   3.552 us    |                    idle_cpu();
 0)               |                    raise_rcu_softirq() {
 0)               |                      raise_softirq() {
 0)   3.340 us    |                        raise_softirq_irqoff();
 0) + 13.029 us   |                      }
 0) + 22.580 us   |                    }
 0) + 41.989 us   |                  }
 0)   3.597 us    |                  printk_tick();
 0)               |                  scheduler_tick() {
 0)               |                    ktime_get() {
 0)               |                      ktime_get_ts() {
 0)               |                        getnstimeofday() {
 0)   3.742 us    |                          clocksource_read();
 0) + 14.141 us   |                        }
 0)   3.291 us    |                        set_normalized_timespec();
 0) + 75.737 us   |                      }
 0)               |                      timespec_to_ktime() {
 0)   3.122 us    |                        ktime_set();
 0) + 12.275 us   |                      }
 0) ! 103.588 us  |                    }
 0)   6.814 us    |                    _spin_lock();
 0)   4.347 us    |                    update_rq_clock();
 0)               |                    task_tick_fair() {
 0)               |                      update_curr() {
 0)   3.280 us    |                        calc_delta_fair();
 0)               |                        update_min_vruntime() {
 0)   3.164 us    |                          max_vruntime();
 0) + 12.409 us   |                        }
 0)   3.415 us    |                        account_group_exec_runtime();
 0) + 40.947 us   |                      }
 0) + 50.545 us   |                    }
 0)               |                    perf_counter_task_tick() {
 0)               |                      perf_counter_task_sched_out() {
 0)               |                        __perf_counter_sched_out() {
 0)   6.940 us    |                          _spin_lock();
 0)   4.804 us    |                          _spin_unlock();
 0) + 28.069 us   |                        }
 0) + 37.414 us   |                      }
 0)               |                      perf_counter_task_sched_in() {
 0)   5.857 us    |                        _spin_lock();
 0)   4.405 us    |                        _spin_unlock();
 0) + 26.177 us   |                      }
 0) + 78.616 us   |                    }
 0)   4.018 us    |                    _spin_unlock();
 0)   3.187 us    |                    idle_cpu();
 0) ! 299.382 us  |                  }
 0)               |                  run_posix_cpu_timers() {
 0)   3.300 us    |                    task_cputime_zero();
 0)   3.256 us    |                    task_cputime_zero();
 0) + 21.977 us   |                  }
 0) ! 577.188 us  |                }
 0)   3.425 us    |                profile_tick();
 0) ! 698.681 us  |              }
 0) ! 707.982 us  |            }
 0)   3.275 us    |            perf_counter_unthrottle();
 0)               |            irq_exit() {
 0)               |              do_softirq() {
 0)               |                __do_softirq() {
 0)   4.372 us    |                  __local_bh_disable();
 0)               |                  run_timer_softirq() {
 0)   3.677 us    |                    hrtimer_run_pending();
 0)   7.721 us    |                    _spin_lock_irq();
 0)   3.441 us    |                    list_replace_init();
 0)   5.117 us    |                    _spin_unlock_irq();
 0) + 49.610 us   |                  }
 0)               |                  rcu_process_callbacks() {
 0)   5.340 us    |                    __rcu_process_callbacks();
 0)   3.695 us    |                    __rcu_process_callbacks();
 0) + 25.576 us   |                  }
 0)   4.666 us    |                  _local_bh_enable();
 0) ! 115.634 us  |                }
 0) ! 126.637 us  |              }
 0) ! 136.176 us  |            }
 0) ! 918.236 us  |          }
 0)   <========== |
 0) ! 1392.029 us |        }


It takes 1 ms to execute while tracing.
Considering my frequency is 250 Hz, it means 1/4 of the system is used
on timer interrupt while tracing.

For now the hang is fixed, but not the awful latency. And I'm just too frightened
to test it on 1000 Hz.

But I plan to add a kind of watchdog to check how many time we spent inside an
interrupt while graph tracing.
By checking this time against the current Hz value, I could decide to abort the tracing
for all irq.


