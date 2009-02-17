Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZBQSVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZBQSVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZBQSU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:20:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37655 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZBQSU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:20:57 -0500
Date: Tue, 17 Feb 2009 19:20:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: trace the idle tasks
Message-ID: <20090217182045.GA28195@elte.hu>
References: <499af874.07a0660a.0de0.1aff@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499af874.07a0660a.0de0.1aff@mx.google.com>
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

> When the function graph tracer is activated, it iterates over the task_list
> to allocate a stack to store the return addresses.
> But the per cpu idle tasks are not iterated by using do_each_thread / while_each_thread.
> So we have to iterate on them manually.
> 
> This fixes somes weirdness in the traces and many losses of traces.
> Examples on two cpus:
> 
>  0)   Xorg-4287    |   2.906 us    |              }
>  0)   Xorg-4287    |   3.965 us    |            }
>  0)   Xorg-4287    |   5.302 us    |          }
>  ------------------------------------------
>  0)   Xorg-4287    =>    <idle>-0
>  ------------------------------------------
> 
>  0)    <idle>-0    |   2.861 us    |                        }
>  0)    <idle>-0    |   0.526 us    |                        set_normalized_timespec();
>  0)    <idle>-0    |   7.201 us    |                      }
>  0)    <idle>-0    |   8.214 us    |                    }
>  0)    <idle>-0    |               |                    clockevents_program_event() {
>  0)    <idle>-0    |               |                      lapic_next_event() {
>  0)    <idle>-0    |   0.510 us    |                        native_apic_mem_write();
>  0)    <idle>-0    |   1.546 us    |                      }
>  0)    <idle>-0    |   2.583 us    |                    }
>  0)    <idle>-0    | + 12.435 us   |                  }
>  0)    <idle>-0    | + 13.470 us   |                }
>  0)    <idle>-0    |   0.608 us    |                _spin_unlock_irqrestore();
>  0)    <idle>-0    | + 23.270 us   |              }
>  0)    <idle>-0    | + 24.336 us   |            }
>  0)    <idle>-0    | + 25.417 us   |          }
>  0)    <idle>-0    |   0.593 us    |          _spin_unlock();
>  0)    <idle>-0    | + 41.869 us   |        }
>  0)    <idle>-0    | + 42.906 us   |      }
>  0)    <idle>-0    | + 95.035 us   |    }
>  0)    <idle>-0    |   0.540 us    |    menu_reflect();
>  0)    <idle>-0    | ! 100.404 us  |  }
>  0)    <idle>-0    |   0.564 us    |  mce_idle_callback();
>  0)    <idle>-0    |               |  enter_idle() {
>  0)    <idle>-0    |   0.526 us    |    mce_idle_callback();
>  0)    <idle>-0    |   1.757 us    |  }
>  0)    <idle>-0    |               |  cpuidle_idle_call() {
>  0)    <idle>-0    |               |    menu_select() {
>  0)    <idle>-0    |   0.525 us    |      pm_qos_requirement();
>  0)    <idle>-0    |   0.518 us    |      tick_nohz_get_sleep_length();
>  0)    <idle>-0    |   2.621 us    |    }
> [...]
>  1)    <idle>-0    |   0.518 us    |              touch_softlockup_watchdog();
>  1)    <idle>-0    | + 14.355 us   |            }
>  1)    <idle>-0    | + 22.840 us   |          }
>  1)    <idle>-0    | + 25.949 us   |        }
>  1)    <idle>-0    |               |        handle_irq() {
>  1)    <idle>-0    |   0.511 us    |          irq_to_desc();
>  1)    <idle>-0    |               |          handle_edge_irq() {
>  1)    <idle>-0    |   0.638 us    |            _spin_lock();
>  1)    <idle>-0    |               |            ack_apic_edge() {
>  1)    <idle>-0    |   0.510 us    |              irq_to_desc();
>  1)    <idle>-0    |               |              move_native_irq() {
>  1)    <idle>-0    |   0.510 us    |                irq_to_desc();
>  1)    <idle>-0    |   1.532 us    |              }
>  1)    <idle>-0    |   0.511 us    |              native_apic_mem_write();
>  ------------------------------------------
>  1)    <idle>-0    =>    cat-5073
>  ------------------------------------------
> 
>  1)    cat-5073    |   3.731 us    |                    }
>  1)    cat-5073    |               |                    run_local_timers() {
>  1)    cat-5073    |   0.533 us    |                      hrtimer_run_queues();
>  1)    cat-5073    |               |                      raise_softirq() {
>  1)    cat-5073    |               |                        __raise_softirq_irqoff() {
>  1)    cat-5073    |               |                          /* nr: 1 */
>  1)    cat-5073    |   2.718 us    |                        }
>  1)    cat-5073    |   3.814 us    |                      }
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ftrace.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)

Applied to tip:tracing/urgent, thanks Frederic!

	Ingo
