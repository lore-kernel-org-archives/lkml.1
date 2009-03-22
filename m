Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZCVSdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZCVSdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZCVSdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:33:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZCVSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:33:14 -0400
Date: Sun, 22 Mar 2009 14:33:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
In-Reply-To: <20090322170215.GA4468@elte.hu>
Message-ID: <alpine.DEB.2.00.0903221416360.3578@gandalf.stny.rr.com>
References: <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com> <20090321190746.GC7148@linux.vnet.ibm.com>
 <20090321200919.GA23992@elte.hu> <20090321210154.GD7148@linux.vnet.ibm.com> <20090322142409.GA3279@elte.hu> <20090322150657.GA17415@elte.hu> <20090322170215.GA4468@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Ingo Molnar wrote:

> 
> ok, with Frederic we figured out the problem.
> 
> What helped things most was this trace-dump output:
> 
>  0) + 15.281 us   |                }
>  0)               |                handle_irq() {
>  1) + 35.871 us   |                }
>  1)               |                timespec_to_ktime() {
>  0)   4.608 us    |                  }
>  0)               |                  generic_handle_irq_desc() {
>  1)   4.097 us    |                  }
>  1) + 14.171 us   |                }
>  0)   4.450 us    |                      _spin_lock();
>  1) + 60.127 us   |              }
>  1)               |              ktime_get() {
>  0)               |                      ack_apic_edge() {
>  1)               |                  getnstimeofday() {
>  0)   6.486 us    |                        }
>  0)   5.619 us    |                        irq_complete_move();
>  1)   5.158 us    |                      jiffies_read();
>  0)               |                        move_native_irq() {
>  1) + 15.495 us   |                    }
>  1) + 26.161 us   |                  }
>  0)   5.631 us    |                          }
>  1)   5.549 us    |                  set_normalized_timespec();
>  0) + 16.304 us   |                        }
>  0)               |                        ack_APIC_irq() {
>  1) + 48.377 us   |                }
>  1)               |                timespec_to_ktime() {
>  0)   5.762 us    |                            native_apic_mem_write();
>  1)   5.751 us    |                  }
>  0) + 16.162 us   |                          }
>  1) + 16.413 us   |                }
>  0) + 27.185 us   |                        }
>  1) + 81.519 us   |              }
>  0) + 80.245 us   |                      }
>  1) ! 154.606 us  |            }
>  0)               |                      _spin_unlock() {
>  1)   5.743 us    |            tick_nohz_update_jiffies();
>  0)   5.781 us    |                        }
>  1) ! 183.912 us  |          }
>  0)   5.327 us    |                        preempt_schedule();
>  1) ! 202.575 us  |        }
>  0) + 25.827 us   |                      }
> 
>  [...]
>  1) ! 2623.297 us |  }
> 
> i.e. all CPUs spend 2-3 milliseconds to handle a single tick. This 
> is on a Core2 Extreme Edition 2.93 GHz CPU, so this kind of cost was 
> unexpected.
> 
> Until i saw this:
> 
>  CONFIG_TRACE_BRANCH_PROFILING=y
>  CONFIG_PROFILE_ALL_BRANCHES=y
> 
> that explains it all. The above sequence is two CPUs 'lock stepped' 
> in a very high overhead series of cacheline ping-pongs. The 
> ping-pongs happen due to every branch in the kernel doing:
> 
>                 ______f.miss_hit[______r]++;
> 
> where the branch info metadata is defined as global variables:
> 
>                 static struct ftrace_branch_data                        \
>                         __attribute__((__aligned__(4)))                 \
>                         __attribute__((section("_ftrace_branch")))      \
> 
> not only is it global, it's also false cacheline-shared due to a 4 
> byte alignment.
> 
> The proper solution would be to use percpu data and percpu_add() 
> primitives for this.

Ug, that would increase the size tremendously.  Remember, we have a data 
structure for ever if statement in the kernel. I can't recall how much 
memory it takes up now, but it was quite a bit. I can't imagine what it 
would be like to multiply that by NR_CPUS.

Perhaps we could just check a single CPU?

	if (!smp_processor_id()) {
		[...]
	}

Have CPU 0 be profiled only? Or at least make it an option?

-- Steve

> 
> Anyway ... i turned off the branch tracer for my tests.

