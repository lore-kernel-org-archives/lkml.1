Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZBPUCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZBPUCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZBPUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:02:26 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:32991 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbZBPUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tR8rkmdDnUNZPvXvXheCqCCVVVCNRLaoqX5QJD4DnWOL337EvEW1hayXXJW3T54Ny/
         dqXNlLNMrB+vHCkiPnnPUiU1olaRHpssBS0MoSaghQJKQP1WMfWzHhL57IbgHiOCNrZj
         lHYNK2XoaKVKBQsSm6QSv1G/pg2LI4JAbe3cY=
Date: Mon, 16 Feb 2009 21:02:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216200217.GA4694@nowhere>
References: <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain> <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr> <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr> <20090216132151.GA17996@elte.hu> <20090216160613.GA6785@linux.vnet.ibm.com> <20090216185616.GB6785@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216185616.GB6785@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 10:56:16AM -0800, Paul E. McKenney wrote:
> On Mon, Feb 16, 2009 at 08:06:13AM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 16, 2009 at 02:21:51PM +0100, Ingo Molnar wrote:
> > > 
> > > * Damien Wyart <damien.wyart@free.fr> wrote:
> > > 
> > > > * Ingo Molnar <mingo@elte.hu> [090216 13:26]:
> > > > > We do get 0x100 which is 1 << RCU_SOFTIRQ, i.e. the RCU softirq. Paul, 
> > > > > this indeed seems to be a CONFIG_TREE_RCU=y bug.
> > > > 
> > > > > What is weird is that RCU_SOFTIRQ gets set again and again - but there's 
> > > > > no raise_softirq() calls. Could you please do a two-CPU trace too via:
> > > > 
> > > > >    echo 3 > /debug/tracing/tracing_cpumask
> > > > 
> > > > > So that we can see what's happening on the other CPU?
> > > > 
> > > > > Also, could you please apply the debug patch below (or update to the 
> > > > > very latest -tip tree), so that we get trace entries of softirq triggers 
> > > > > too?
> > > > 
> > > > Ok, the new trace with these additional modifications is here:
> > > > http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_1300_ksoftirqd_pb_abstime_proc_mask3.txt.gz
> > > 
> > > thanks.
> > > 
> > > This confirms that SOFTIRQ_RCU gets raised here in the timer IRQ:
> > > 
> > >   136.255963 |   0)   sleep-2345   |               |          update_process_times() {
> > >   136.255964 |   0)   sleep-2345   |               |            account_process_tick() {
> > >   136.255965 |   0)   sleep-2345   |   0.779 us    |              account_system_time();
> > >   136.255966 |   0)   sleep-2345   |   2.262 us    |            }
> > >   136.255967 |   0)   sleep-2345   |               |            run_local_timers() {
> > >   136.255968 |   0)   sleep-2345   |   0.802 us    |              hrtimer_run_queues();
> > >   136.255969 |   0)   sleep-2345   |               |              raise_softirq() {
> > >   136.255970 |   0)   sleep-2345   |               |                raise_softirq_irqoff() {
> > >   136.255971 |   0)   sleep-2345   |               |                  __raise_softirq_irqoff() {
> > >   136.255972 |   0)   sleep-2345   |               |                    /* nr: 1 */
> > >   136.255973 |   0)   sleep-2345   |   2.194 us    |                  }
> > >   136.255974 |   0)   sleep-2345   |   3.832 us    |                }
> > >   136.255975 |   0)   sleep-2345   |   5.491 us    |              }
> > >   136.255976 |   0)   sleep-2345   |   8.667 us    |            }
> > >   136.255976 |   0)   sleep-2345   |   0.792 us    |            rcu_pending();
> > >   136.255978 |   0)   sleep-2345   |               |            rcu_check_callbacks() {
> > >   136.255979 |   0)   sleep-2345   |   0.781 us    |              idle_cpu();
> > >   136.255981 |   0)   sleep-2345   |               |              raise_softirq() {
> > >   136.255981 |   0)   sleep-2345   |               |                raise_softirq_irqoff() {
> > >   136.255982 |   0)   sleep-2345   |               |                  __raise_softirq_irqoff() {
> > >   136.255983 |   0)   sleep-2345   |               |                    /* nr: 8 */
> > >   136.255984 |   0)   sleep-2345   |   1.555 us    |                  }
> > >   136.255984 |   0)   sleep-2345   |   3.059 us    |                }
> > >   136.255985 |   0)   sleep-2345   |   4.594 us    |              }
> > >   136.255986 |   0)   sleep-2345   |   7.800 us    |            }
> > >   136.255987 |   0)   sleep-2345   |   0.737 us    |            printk_tick();
> > > 
> > > again and again.
> > 
> > Interesting...
> > 
> > I will take a look!
> 
> The above sequence is more or less normal behavior -- the RCU softirq
> handler rcu_process_callbacks() is being invoked once per tick, which
> appears to be HZ=1000 or thereabouts.  The system appears to be mostly
> idle during this time period.
> 
> One oddity is that the _bh call to __rcu_process_callbacks() is invoking
> force_quiescent_state() each time, and force_quiescent_state() isn't
> doing anything.  This is a possible mismatch between the conditions in
> rcu_pending() and force_quiescent_state(), and I will look into this.
> 
> However, this sequence is consuming less than 10 microseconds per
> millisecond, so cannot be the main cause of the softirq issues you
> are seeing, though if there really is a mismatch, it needs to be fixed,
> and I will attend to this.
> 
> The interesting portion of the trace is later on:
> 
>   137.896992 |   1)  ksoftir-2302  |               |  do_softirq() {
>   137.896993 |   1)  ksoftir-2302  |               |    __do_softirq() {
>   137.896993 |   1)  ksoftir-2302  |               |      /* #1 softirq pending: 00000100 */
>   137.896994 |   1)  ksoftir-2302  |               |      /* #2 softirq pending: 00000000 */
>   137.896995 |   1)  ksoftir-2302  |               |      rcu_process_callbacks() {
>   137.896995 |   1)  ksoftir-2302  |               |        __rcu_process_callbacks() {
>   137.896996 |   1)  ksoftir-2302  |   0.498 us    |          force_quiescent_state();
>   137.896997 |   1)  ksoftir-2302  |   1.588 us    |        }
>   137.896997 |   1)  ksoftir-2302  |               |        __rcu_process_callbacks() {
>   137.896998 |   1)  ksoftir-2302  |   0.475 us    |          force_quiescent_state();
>   137.896999 |   1)  ksoftir-2302  |               |          cpu_quiet() {
>   137.896999 |   1)  ksoftir-2302  |   0.526 us    |            _spin_lock_irqsave();
>   137.897000 |   1)  ksoftir-2302  |   0.511 us    |            _spin_unlock_irqrestore();
>   137.897001 |   1)  ksoftir-2302  |   2.528 us    |          }
>   137.897002 |   1)  ksoftir-2302  |   4.607 us    |        }
>   137.897002 |   1)  ksoftir-2302  |   7.825 us    |      }
>   137.897003 |   1)  ksoftir-2302  |   0.498 us    |      _local_bh_enable();
>   137.897004 |   1)  ksoftir-2302  | + 11.430 us   |    }
>   137.897005 |   1)  ksoftir-2302  | + 12.572 us   |  }
>   137.897005 |   1)  ksoftir-2302  |   0.549 us    |  _cond_resched();
>   137.897006 |   1)  ksoftir-2302  |   0.541 us    |  kthread_should_stop();
>   137.897007 |   1)  ksoftir-2302  |               |  schedule() {
>   137.897008 |   1)  ksoftir-2302  |               |    __schedule() {
>   137.897008 |   1)  ksoftir-2302  |   0.514 us    |      _spin_lock_irq();
>   137.897009 |   1)  ksoftir-2302  |   0.594 us    |      update_rq_clock();
>   137.897011 |   1)  ksoftir-2302  |               |      deactivate_task() {
>   137.897011 |   1)  ksoftir-2302  |               |        dequeue_task() {
>   137.897011 |   1)  ksoftir-2302  |               |          dequeue_task_fair() {
>   137.897012 |   1)  ksoftir-2302  |               |            update_curr() {
>   137.897012 |   1)  ksoftir-2302  |               |              calc_delta_fair() {
>   137.897013 |   1)  ksoftir-2302  |   0.506 us    |                calc_delta_mine();
>   137.897014 |   1)  ksoftir-2302  |   1.528 us    |              }
>   137.897015 |   1)  ksoftir-2302  |   2.563 us    |            }
>   137.897015 |   1)  ksoftir-2302  |   0.513 us    |            hrtick_start_fair();
>   137.897019 |   1)  ksoftir-2302  |   4.662 us    |          }
>   137.897019 |   1)  ksoftir-2302  |   8.213 us    |        }
>   137.897020 |   1)  ksoftir-2302  |   9.195 us    |      }
>   137.897020 |   1)  ksoftir-2302  |   0.960 us    |      find_busiest_group();
>   137.897022 |   1)  ksoftir-2302  |   0.493 us    |      msecs_to_jiffies();
>   137.897023 |   1)  ksoftir-2302  |   0.511 us    |      put_prev_task_fair();
>   137.897024 |   1)  ksoftir-2302  |               |      pick_next_task() {
>   137.897024 |   1)  ksoftir-2302  |   0.481 us    |        pick_next_task_fair();
>   137.897025 |   1)  ksoftir-2302  |   0.491 us    |        pick_next_task_rt();
>   137.897026 |   1)  ksoftir-2302  |   0.474 us    |        pick_next_task_fair();
>   137.897027 |   1)  ksoftir-2302  |   0.480 us    |        pick_next_task_idle();
>   137.897028 |   1)  ksoftir-2302  |   4.516 us    |      }
>   137.897029 |   1)  ksoftir-2302  |               |      perf_counter_task_sched_out() {
>   137.897029 |   1)  ksoftir-2302  |               |        __perf_counter_sched_out() {
>   137.897030 |   1)  ksoftir-2302  |   0.516 us    |          _spin_lock();
>   137.897031 |   1)  ksoftir-2302  |   1.486 us    |        }
>   137.897031 |   1)  ksoftir-2302  |   2.462 us    |      }
>   137.897032 |   1)  ksoftir-2302  |   0.516 us    |      __lock_text_start();
>   137.897045 |   ------------------------------------------
>  1)  ksoftir-2302  =>    <idle>-0   
>  ------------------------------------------
> 
>  1)    <idle>-0    |               |  /* nr: 8 */
>  ------------------------------------------
>  1)    <idle>-0    =>  ksoftir-2302 
>  ------------------------------------------
> 
>   137.897064 |   1)  ksoftir-2302  |               |      finish_task_switch() {
>   137.897064 |   1)  ksoftir-2302  |               |        perf_counter_task_sched_in() {
>   137.897065 |   1)  ksoftir-2302  |   0.508 us    |          _spin_lock();
>   137.897066 |   1)  ksoftir-2302  |   1.525 us    |        }
>   137.897066 |   1)  ksoftir-2302  |   2.617 us    |      }
>   137.897067 |   1)  ksoftir-2302  | + 58.928 us   |    }
>   137.897067 |   1)  ksoftir-2302  | + 59.926 us   |  }
>   137.897068 |   1)  ksoftir-2302  |               |  do_softirq() {
>   137.897068 |   1)  ksoftir-2302  |               |    __do_softirq() {
>   137.897069 |   1)  ksoftir-2302  |               |      /* #1 softirq pending: 00000100 */
>   137.897070 |   1)  ksoftir-2302  |               |      /* #2 softirq pending: 00000000 */
>   137.897070 |   1)  ksoftir-2302  |               |      rcu_process_callbacks() {
>   137.897071 |   1)  ksoftir-2302  |               |        __rcu_process_callbacks() {
>   137.897071 |   1)  ksoftir-2302  |               |          force_quiescent_state() {
>   137.897073 |   1)  ksoftir-2302  |   1.575 us    |        }
>   137.897073 |   1)  ksoftir-2302  |               |        __rcu_process_callbacks() {
>   137.897074 |   1)  ksoftir-2302  |   0.474 us    |          force_quiescent_state();
>   137.897075 |   1)  ksoftir-2302  |               |          cpu_quiet() {
>   137.897075 |   1)  ksoftir-2302  |   0.526 us    |            _spin_lock_irqsave();
>   137.897076 |   1)  ksoftir-2302  |   0.511 us    |            _spin_unlock_irqrestore();
>   137.897077 |   1)  ksoftir-2302  |   2.532 us    |          }
>   137.897078 |   1)  ksoftir-2302  |   4.632 us    |        }
>   137.897078 |   1)  ksoftir-2302  |   7.815 us    |      }
>   137.897079 |   1)  ksoftir-2302  |   0.501 us    |      _local_bh_enable();
>   137.897080 |   1)  ksoftir-2302  | + 11.405 us   |    }
>   137.897080 |   1)  ksoftir-2302  | + 12.542 us   |  }
> 
> Here the calls to rcu_process_callbacks() are only 75 microseconds apart,
> so that this function is consuming more than 10% of a CPU.  The strange
> thing is that I don't see a raise_softirq() in between, though perhaps
> it gets inlined or something that makes it invisible to ftrace.
> Certainly rcu_process_callbacks() can re-invoke itself, for example,
> when a large number of RCU callbacks has piled up.  However, there are
> only 29 calls to __call_rcu() over the entire time period, so that does
> not appear to be the cause.  Strangely enough, there appear to be no
> calls to rcu_do_batch() over the full trace, but this is invoked
> unconditionally from __rcu_process_callbacks().  So perhaps the trace
> wasn't covering that function?


I just checked an assembly dump of my vmlinux, and rcu_do_batch()
has been inlined. I don't understand why, this is a wide function.

 
> Whatever, this pattern continues for more than 300 milliseconds(!).
> 
> Would you be willing to enable CONFIG_RCU_TRACE and CONFIG_TREE_RCU,
> reproduce this and send the output of the debugfs files rcu/rcudata
> and rcu/rcuhier?  The commands for this would be:
> 
> 	mkdir /debug || :
> 	mount -t debugfs debugfs /debug
> 	cat /debug/rcu/rcuhier
> 	cat /debug/rcu/rcudata
> 
> I will try to reproduce locally as well.
> 
> 							Thanx, Paul

