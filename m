Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZBOOG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZBOOG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZBOOGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:06:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:51529 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbZBOOGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:06:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r8aoBPV7Pg0WMIxRBOsQMwfErSmp6WLKVPJg9ppPQbgroOFLk39kQDj9d1mZuFDkm+
         rnc15droplqawyPWpcUg39az6j1vMZL71zjhI3TJncrO71/cwMWXLqyYZ3+Y8+YaUitX
         tQrNkQS7A8WuM/mBQUc3CoX1HLSWQ/lWy5yx8=
Date: Sun, 15 Feb 2009 15:06:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215140641.GI5835@nowhere>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215110104.GB31351@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 12:01:04PM +0100, Ingo Molnar wrote:
> 
> * Damien Wyart <damien.wyart@free.fr> wrote:
> 
> > So I followed the tracing steps in the tutorial (with the 1 sec sleep),
> > which gave me this:
> > http://damien.wyart.free.fr/trace_2.6.29-rc5_ksoftirqd_prob.txt.gz
> 
> thanks. There's definitely some weirdness visible in the trace,
> for example:
> 
>   0)    gpm-1879    =>   ksoftir-4   
>   ------------------------------------------
> 
>   0)   0.964 us    |    finish_task_switch();
>   0) ! 1768184 us |  }
>   0)               |  do_softirq() {
>   0)               |    __do_softirq() {
>   0)               |      rcu_process_callbacks() {
> 
> the 1.7 seconds 'overhead' there must be a fluke - you'd notice it if
> ksoftirqd _really_ took that much time to execute.
> 
> One possibility for these symptoms would be broken scheduler timestamps.
> Could you enable absolute timestamp printing via:
> 
>     echo funcgraph-abstime  > trace_options
> 
> Also, my guess is that if you boot via idle=poll, the symptoms go away.
> This would strengthen the suspicion that it's scheduler-clock troubles.
> 
> 	Ingo

Looking at the following ksoftirqd quantum, there are some things I don't understand:

 ------------------------------------------
 0)    gpm-1879    =>   ksoftir-4   
 ------------------------------------------

 0)   0.681 us    |    finish_task_switch();
 0) ! 7670.083 us |  }
 0)               |  do_softirq() {
 0)               |    __do_softirq() {
 0)               |      rcu_process_callbacks() {
 0)               |        __rcu_process_callbacks() {
 0)               |          cpu_quiet() {
 0)   0.509 us    |            _spin_lock_irqsave();
 0)               |            cpu_quiet_msk() {
 0)   0.503 us    |              _spin_unlock_irqrestore();
 0)   1.546 us    |            }
 0)   3.617 us    |          }
 0)   4.804 us    |        }
 0)               |        __rcu_process_callbacks() {
 0)   0.496 us    |          force_quiescent_state();
 0)   1.608 us    |        }
 0)   8.043 us    |      }
 0)   0.533 us    |      _local_bh_enable();
 0) + 10.190 us   |    }
 0) + 11.337 us   |  }
 0)   0.537 us    |  _cond_resched();
 0)   0.536 us    |  kthread_should_stop();
 0)               |  schedule() {
 0)   0.516 us    |    _spin_lock_irq();
 0)   0.586 us    |    update_rq_clock();
 0)               |    deactivate_task() {
 0)               |      dequeue_task() {
 0)               |        dequeue_task_fair() {
 0)               |          update_curr() {
 0)   0.519 us    |            calc_delta_mine();
 0)   1.603 us    |          }
 0)   2.667 us    |        }
 0)   3.662 us    |      }
 0)   4.629 us    |    }
 0)   0.937 us    |    find_busiest_group();
 0)   0.493 us    |    msecs_to_jiffies();
 0)   0.501 us    |    put_prev_task_fair();
 0)               |    pick_next_task() {
 0)   0.501 us    |      pick_next_task_fair();
 0)   0.491 us    |      pick_next_task_rt();
 0)   0.494 us    |      pick_next_task_fair();
 0)   0.491 us    |      pick_next_task_idle();
 0)   4.591 us    |    }
 0)   0.501 us    |    __lock_text_start();
 0)   0.699 us    |    finish_task_switch();
 0) ! 289.895 us  |  }


The two above is the internal of context_switch, which means it entered
there in schedule():

next = pick_next_task(rq, prev);
if (likely(prev != next)) {
	sched_info_switch(prev, next);
	perf_counter_task_sched_out(prev, cpu);

	rq->nr_switches++;
	rq->curr = next;
	++*switch_count;

	context_switch(rq, prev, next); /* unlocks the rq */
	/*
	 * the context switch might have flipped the stack from under
	 * us, hence refresh the local variables.
	 */
	cpu = smp_processor_id();
	rq = cpu_rq(cpu);
}

But after that we are still in ksoftirqd. As if it bypassed the if (prev != next)
and rescheduled itself.

Well, I guess it's a bit off topic here. Whatever if this a bug in the sched_clock(),
it reminds me a possible problem in sched_clock() I saw with tracers...



 0)               |  do_softirq() {
 0)               |    __do_softirq() {
 0)               |      rcu_process_callbacks() {
 0)               |        __rcu_process_callbacks() {
 0)               |          force_quiescent_state() {
 0)   0.478 us    |            __lock_text_start();
 0)   0.489 us    |            _spin_lock();
 0)               |            rcu_process_dyntick() {
 0)   0.496 us    |              _spin_lock_irqsave();
 0)   0.571 us    |              dyntick_save_progress_counter();
 0)               |              cpu_quiet_msk() {
 0)               |                rcu_start_gp() {
 0)   0.496 us    |                  _spin_unlock_irqrestore();
 0)   1.533 us    |                }
 0)   2.588 us    |              }
 0)   5.784 us    |            }
 0)   0.493 us    |            _spin_lock();
 0)   0.501 us    |            _spin_unlock_irqrestore();
 0) + 10.959 us   |          }
 0)               |          file_free_rcu() {
 0)   0.551 us    |            kmem_cache_free();
 0)   1.613 us    |          }
 0) + 14.486 us   |        }
 0)               |        __rcu_process_callbacks() {
 0)   0.458 us    |          force_quiescent_state();
 0)   1.573 us    |        }
 0) + 17.661 us   |      }
 0)   0.486 us    |      _local_bh_enable();
 0) + 20.014 us   |    }
 0) + 21.094 us   |  }
 0)   0.546 us    |  _cond_resched();
 0)   0.536 us    |  kthread_should_stop();
 0)               |  schedule() {
 0)   0.514 us    |    _spin_lock_irq();
 0)   0.596 us    |    update_rq_clock();
 0)               |    deactivate_task() {
 0)               |      dequeue_task() {
 0)               |        dequeue_task_fair() {
 0)               |          update_curr() {
 0)   0.500 us    |            calc_delta_mine();
 0)   1.570 us    |          }
 0)   2.632 us    |        }
 0)   3.632 us    |      }
 0)   4.594 us    |    }
 0)   0.846 us    |    find_busiest_group();
 0)   0.471 us    |    msecs_to_jiffies();
 0)   0.506 us    |    put_prev_task_fair();
 0)               |    pick_next_task() {
 0)   0.486 us    |      pick_next_task_fair();
 0)   0.481 us    |      pick_next_task_rt();
 0)   0.484 us    |      pick_next_task_fair();
 0)   0.493 us    |      pick_next_task_idle();
 0)   4.544 us    |    }
 0)   0.506 us    |    __lock_text_start();
 0)   0.554 us    |    finish_task_switch();
 0) + 30.202 us   |  }
 0)               |  do_softirq() {
 0)               |    __do_softirq() {
 0)               |      rcu_process_callbacks() {
 0)               |        __rcu_process_callbacks() {
 0)               |          cpu_quiet() {
 0)   0.493 us    |            _spin_lock_irqsave();
 0)               |            cpu_quiet_msk() {
 0)   0.504 us    |              _spin_unlock_irqrestore();
 0)   1.515 us    |            }
 0)   3.535 us    |          }
 0)   4.692 us    |        }
 0)               |        __rcu_process_callbacks() {
 0)   0.480 us    |          force_quiescent_state();
 0)   1.593 us    |        }
 0)   7.878 us    |      }
 0)   0.491 us    |      _local_bh_enable();
 0)   9.934 us    |    }
 0) + 11.037 us   |  }
 0)   0.529 us    |  _cond_resched();
 0)   0.506 us    |  kthread_should_stop();
 0)               |  schedule() {
 0)   0.499 us    |    _spin_lock_irq();
 0)   0.581 us    |    update_rq_clock();
 0)               |    deactivate_task() {
 0)               |      dequeue_task() {
 0)               |        dequeue_task_fair() {
 0)               |          update_curr() {
 0)   0.493 us    |            calc_delta_mine();
 0)   1.548 us    |          }
 0)   2.583 us    |        }
 0)   3.559 us    |      }
 0)   4.514 us    |    }
 0)   0.797 us    |    find_busiest_group();
 0)   0.481 us    |    msecs_to_jiffies();
 0)   0.499 us    |    put_prev_task_fair();
 0)               |    pick_next_task() {
 0)   0.481 us    |      pick_next_task_fair();
 0)   0.479 us    |      pick_next_task_rt();
 0)   0.483 us    |      pick_next_task_fair();
 0)   0.481 us    |      pick_next_task_idle();
 0)   4.488 us    |    }
 0)   0.506 us    |    __lock_text_start();
 0)   0.672 us    |    finish_task_switch();
 0) ! 928.567 us  |  }
 0)               |  do_softirq() {
 0)               |    __do_softirq() {
 0)               |      rcu_process_callbacks() {
 0)               |        __rcu_process_callbacks() {
 0)               |          force_quiescent_state() {
 0)   0.484 us    |            __lock_text_start();
 0)   0.511 us    |            _spin_lock();
 0)               |            rcu_process_dyntick() {
 0)   0.511 us    |              _spin_lock_irqsave();
 0)   0.564 us    |              dyntick_save_progress_counter();
 0)               |              cpu_quiet_msk() {
 0)               |                rcu_start_gp() {
 0)   0.503 us    |                  _spin_unlock_irqrestore();
 0)   1.548 us    |                }
 0)   2.582 us    |              }
 0)   6.102 us    |            }
 0)   0.501 us    |            _spin_lock();
 0)   0.501 us    |            _spin_unlock_irqrestore();
 0) + 11.265 us   |          }
 0)               |          file_free_rcu() {
 0)   0.579 us    |            kmem_cache_free();
 0)   1.643 us    |          }
 0)               |          file_free_rcu() {
 0)   0.549 us    |            kmem_cache_free();
 0)   1.588 us    |          }
 0) + 16.827 us   |        }
 0)               |        __rcu_process_callbacks() {
 0)   0.479 us    |          force_quiescent_state();
 0)   1.593 us    |        }
 0) + 20.024 us   |      }
 0)   0.500 us    |      _local_bh_enable();
 0) + 22.081 us   |    }
 0) + 23.163 us   |  }
 0)   0.523 us    |  _cond_resched();
 0)   0.536 us    |  kthread_should_stop();
 0)               |  schedule() {
 0)   0.506 us    |    _spin_lock_irq();
 0)   0.586 us    |    update_rq_clock();
 0)               |    deactivate_task() {
 0)               |      dequeue_task() {
 0)               |        dequeue_task_fair() {
 0)               |          update_curr() {
 0)   0.516 us    |            calc_delta_mine();
 0)   1.578 us    |          }
 0)   2.628 us    |        }
 0)   3.622 us    |      }
 0)   4.604 us    |    }
 0)   0.917 us    |    find_busiest_group();
 0)   0.484 us    |    msecs_to_jiffies();
 0)   0.501 us    |    put_prev_task_fair();
 0)               |    pick_next_task() {
 0)   0.486 us    |      pick_next_task_fair();
 0)   0.491 us    |      pick_next_task_rt();
 0)               |      pick_next_task_fair() {
 0)   0.486 us    |      pick_next_task_idle();
 0)   4.581 us    |    }
 0)   0.496 us    |    __lock_text_start();

