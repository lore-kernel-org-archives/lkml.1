Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZCVOYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZCVOYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZCVOYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:24:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZCVOYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:24:31 -0400
Date: Sun, 22 Mar 2009 15:24:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090322142409.GA3279@elte.hu>
References: <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere> <alpine.DEB.2.00.0903201705380.13615@gandalf.stny.rr.com> <20090321100129.GC7201@elte.hu> <20090321165804.GA21366@elte.hu> <alpine.DEB.2.00.0903211323560.13615@gandalf.stny.rr.com> <20090321190746.GC7148@linux.vnet.ibm.com> <20090321200919.GA23992@elte.hu> <20090321210154.GD7148@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321210154.GD7148@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > for one of the hung boxes in the past i waited 24 hours but it 
> > never unwedged itself. The box that hung today is still hanging 
> > and the RCU stall detector is still busy printing out those 
> > backtraces.
> 
> And on the last trace you emailed, the first and the last stall 
> warning are identical according to "diff".  In fact, they are all 
> identical. That is a bit unusual, one would normally expect to see 
> slight differences in the stack based on the scheduling clock 
> interrupt hitting the "longer than average loop" in different 
> places each time.
> 
> That would indicate either a very tight loop or a loop that has 
> interrupts enabled only in one spot.

With the help of Frederic's watchdog patch, i now have an ftrace 
dump of the hang:

 [<ffffffff8028f999>] ? test_ti_thread_flag+0x9/0x14
 [<ffffffff80a04dce>] ? _spin_unlock+0x4b/0x63
 [<ffffffff8036f186>] ? proc_register+0x1b5/0x1c0
 [<ffffffff8029da92>] ? register_irq_proc+0xc4/0xf5
 [<ffffffff8128f140>] ? early_idt_handler+0x0/0x6a
 [<ffffffff8128f700>] ? do_initcalls+0x1e/0x30
 [<ffffffff8128f72f>] ? do_basic_setup+0x1d/0x1f
 [<ffffffff8128fc04>] ? kernel_init+0x69/0xce
 [<ffffffff8020da1a>] ? child_rip+0xa/0x20
 [<ffffffff8020d3ad>] ? restore_args+0x0/0x30
 [<ffffffff8128fb9b>] ? kernel_init+0x0/0xce
 [<ffffffff8020da10>] ? child_rip+0x0/0x20
BUG: Function graph tracer hang!
Dumping ftrace buffer:
---------------------------------
 0)               |                          ack_apic_edge() {
 0)   0.000 us    |                            }
 0)   0.000 us    |                            irq_complete_move();
 0)               |                            move_native_irq() {
 0)   0.000 us    |                              }
 0)   0.000 us    |                            }
 0)               |                            ack_APIC_irq() {
 0)   0.000 us    |                                native_apic_mem_write();
 0)   0.000 us    |                              }
 0)   0.000 us    |                            }
 0)   0.000 us    |                          }
 0)               |                          _spin_unlock() {
 0)   0.000 us    |                            }
 0)   0.000 us    |                            preempt_schedule();
 0)   0.000 us    |                          }
 0)               |                          handle_IRQ_event() {
 0)   0.000 us    |                            }
 0)               |                            timer_interrupt() {
 0)               |                                tick_do_periodic_broadcast() {
 0)   0.000 us    |                                  }
 0)               |                                  cpumask_and() {
 0)   0.000 us    |                                    }
 0)   0.000 us    |                                  }
 0)               |                                  tick_do_broadcast() {
 0)   0.000 us    |                                    }
 0)               |                                    tick_handle_periodic() {
 0)               |                                        write_seqlock() {
 0)   0.000 us    |                                          }
 0)   0.000 us    |                                        }
 0)               |                                        do_timer() {
 1)   ==========> |
 1)               |      smp_apic_timer_interrupt() {
 1)               |          apic_write() {
 1)   0.000 us    |            }
 1)   0.000 us    |          }
 1)   0.000 us    |        }
 1)               |        exit_idle() {
 1)               |            mce_idle_callback() {
 1)   0.000 us    |              }
 1)   0.000 us    |            }
 1)   0.000 us    |            test_ti_thread_flag();
 1)   0.000 us    |          }
 1)   0.000 us    |        }
 1)               |        irq_enter() {
 1)   0.000 us    |          }
 1)               |          tick_check_idle() {
 1)   0.000 us    |            }
 1)               |            tick_nohz_stop_idle() {
 1)               |                ktime_get_ts() {
 1)               |                    clocksource_read() {
 1)   0.000 us    |                      }
 1)   0.000 us    |                    }
 1)   0.000 us    |                  }
 1)   0.000 us    |                  set_normalized_timespec();
 1)   0.000 us    |                }
 1)               |                timespec_to_ktime() {
 1)   0.000 us    |                  }
 1)   0.000 us    |                }
 1)   0.000 us    |              }
 1)               |              ktime_get() {
 1)               |                  getnstimeofday() {
 1)   0.000 us    |                      jiffies_read();
 1)   0.000 us    |                    }
 1)   0.000 us    |                  }
 1)   0.000 us    |                  set_normalized_timespec();
 1)   0.000 us    |                }
 1)               |                timespec_to_ktime() {
 1)   0.000 us    |                  }
 1)   0.000 us    |                }
 1)   0.000 us    |              }
 1)   0.000 us    |            }
 1)   0.000 us    |            tick_nohz_update_jiffies();
 1)   0.000 us    |          }
 1)   0.000 us    |        }
 1)               |        local_apic_timer_interrupt() {
 1)               |            tick_periodic() {
 1)               |                account_process_tick() {
 1)   0.000 us    |                  }
 1)   0.000 us    |                }
 1)               |                run_local_timers() {
 1)   0.000 us    |                  }
 1)               |                  raise_softirq() {
 1)   0.000 us    |                    }
 1)   0.000 us    |                  }
 1)   0.000 us    |                }
 1)               |                rcu_pending() {
 1)   0.000 us    |                    check_cpu_stall();
 0)               |                                            update_wall_time() {
 0)   0.000 us    |                                                jiffies_read();
 0)   0.000 us    |                                              }
 0)   0.000 us    |                                              clocksource_adjust();
 0)   0.000 us    |                                              update_xtime_cache();
 0)               |                                              change_clocksource() {
 0)   0.000 us    |                                                  _spin_lock_irqsave();
 0)               |                                                  _spin_unlock_irqrestore() {
 0)   0.000 us    |                                                    }
 0)   0.000 us    |                                                    preempt_schedule();
 0)   0.000 us    |                                                  }
 0)   0.000 us    |                                                }
 0)   0.000 us    |                                              }
 0)               |                                              update_vsyscall() {
 0)   0.000 us    |                                                  _spin_lock();
 0)   0.000 us    |                                                }
 0)               |                                                write_sequnlock() {
 0)   0.000 us    |                                                    test_ti_thread_flag();
 0)   0.000 us    |                                                    preempt_schedule();
 0)   0.000 us    |                                                  }
 0)   0.000 us    |                                                }
 0)   0.000 us    |                                              }
 0)   0.000 us    |                                            }
 0)   0.000 us    |                                            calc_load();
 0)   0.000 us    |                                          }
 0) ! 1000.000 us |                                        }
 0)               |                                        write_sequnlock() {
 0)   0.000 us    |                                            test_ti_thread_flag();
 0)   0.000 us    |                                            preempt_schedule();
 0)   0.000 us    |                                          }
 0)   0.000 us    |                                        }
 0)               |                                        update_process_times() {
 0)               |                                            account_system_time() {
 0)   0.000 us    |                                              }
 0)   0.000 us    |                                            }
 0)   0.000 us    |                                          }
 0)               |                                          run_local_timers() {
 0)   0.000 us    |                                            }
 0)               |                                            raise_softirq() {
 0)   0.000 us    |                                              }
 0)   0.000 us    |                                            }
 0)   0.000 us    |                                          }
 0)               |                                          rcu_pending() {
 0)   0.000 us    |                                              check_cpu_stall();
 0)   0.000 us    |                                            }
 0)   0.000 us    |                                          }
 0)               |                                          rcu_check_callbacks() {
 0)   0.000 us    |                                            }
 1) ! 1000.000 us |                  }
 1)               |                  __rcu_pending() {
 1)   0.000 us    |                    }
 1)   0.000 us    |                  }
 1) ! 1000.000 us |                }
 1)   0.000 us    |                printk_tick();
 1)               |                scheduler_tick() {
 1)               |                    ktime_get_ts() {
 1)               |                        clocksource_read() {
 1)   0.000 us    |                          }
 1)   0.000 us    |                        }
 1)   0.000 us    |                      }
 1)   0.000 us    |                      set_normalized_timespec();
 1)   0.000 us    |                    }
 1)               |                    timespec_to_ktime() {
 1)   0.000 us    |                      }
 1)   0.000 us    |                    }
 1)   0.000 us    |                  }
 1)   0.000 us    |                  _spin_lock();
 1)   0.000 us    |                  update_rq_clock();
 1)   0.000 us    |                  update_cpu_load();
 1)   0.000 us    |                  task_tick_idle();
 1)               |                  perf_counter_task_tick() {
 1)               |                      perf_swcounter_event() {
 1)   0.000 us    |                          perf_swcounter_ctx_event();
 1)   0.000 us    |                          perf_swcounter_ctx_event();
 1)   0.000 us    |                          test_ti_thread_flag();
 1)   0.000 us    |                        }
 1)   0.000 us    |                      }
 1)   0.000 us    |                    }
 1)   0.000 us    |                  }
 1)   0.000 us    |                }
 1) ! 1000.000 us |              }
 1) ! 1000.000 us |            }
 1) ! 1000.000 us |          }
 1) ! 1000.000 us |        }
 1) ! 1000.000 us |      }
 1)   <========== |
 1) ! 1000.000 us |    }
 1) ! 1000.000 us |  }
---------------------------------
FAILED!
initcall init_graph_trace+0x0/0x12 returned -1 after 324385776 usecs
initcall init_graph_trace+0x0/0x12 returned with error code -1 
calling  init_bts_trace+0x0/0x12 @ 1

Unfortunately it's rather short, due to the recent shrinking of the 
default ftrace buffer sizes.

Which makes me wonder ... maybe there's a connection?

Also, the time deltas look very weird. Either 0 or 1 msec. That's 
characteristic of a sched_clock() that has fallen back to a jiffies 
clocksource.

	Ingo
