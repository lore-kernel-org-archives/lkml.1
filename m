Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZBQRss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZBQRss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZBQRsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:48:40 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:14425 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZBQRsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:48:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=L0Mw0AcKXlCpOeqky+Mf+TPACh+Gl3cqFprGjQdI3G0LmDe5pqNRIxiGwPBhnsFav2
         fCRknjdSgZj4J9IshseCpK3LNOUnHZKETopNZVytjY5A+1ZSiRE2OnpHrsbeajF7EP+o
         kXqAPXVI5cpf6UNKIt2FMLo/BpLxPqjR7azbQ=
Message-ID: <499af874.07a0660a.0de0.1aff@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Date: Tue, 17 Feb 2009 18:35:34 +0100
Subject: [PATCH] tracing/function-graph-tracer: trace the idle tasks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the function graph tracer is activated, it iterates over the task_list
to allocate a stack to store the return addresses.
But the per cpu idle tasks are not iterated by using do_each_thread / while_each_thread.
So we have to iterate on them manually.

This fixes somes weirdness in the traces and many losses of traces.
Examples on two cpus:

 0)   Xorg-4287    |   2.906 us    |              }
 0)   Xorg-4287    |   3.965 us    |            }
 0)   Xorg-4287    |   5.302 us    |          }
 ------------------------------------------
 0)   Xorg-4287    =>    <idle>-0
 ------------------------------------------

 0)    <idle>-0    |   2.861 us    |                        }
 0)    <idle>-0    |   0.526 us    |                        set_normalized_timespec();
 0)    <idle>-0    |   7.201 us    |                      }
 0)    <idle>-0    |   8.214 us    |                    }
 0)    <idle>-0    |               |                    clockevents_program_event() {
 0)    <idle>-0    |               |                      lapic_next_event() {
 0)    <idle>-0    |   0.510 us    |                        native_apic_mem_write();
 0)    <idle>-0    |   1.546 us    |                      }
 0)    <idle>-0    |   2.583 us    |                    }
 0)    <idle>-0    | + 12.435 us   |                  }
 0)    <idle>-0    | + 13.470 us   |                }
 0)    <idle>-0    |   0.608 us    |                _spin_unlock_irqrestore();
 0)    <idle>-0    | + 23.270 us   |              }
 0)    <idle>-0    | + 24.336 us   |            }
 0)    <idle>-0    | + 25.417 us   |          }
 0)    <idle>-0    |   0.593 us    |          _spin_unlock();
 0)    <idle>-0    | + 41.869 us   |        }
 0)    <idle>-0    | + 42.906 us   |      }
 0)    <idle>-0    | + 95.035 us   |    }
 0)    <idle>-0    |   0.540 us    |    menu_reflect();
 0)    <idle>-0    | ! 100.404 us  |  }
 0)    <idle>-0    |   0.564 us    |  mce_idle_callback();
 0)    <idle>-0    |               |  enter_idle() {
 0)    <idle>-0    |   0.526 us    |    mce_idle_callback();
 0)    <idle>-0    |   1.757 us    |  }
 0)    <idle>-0    |               |  cpuidle_idle_call() {
 0)    <idle>-0    |               |    menu_select() {
 0)    <idle>-0    |   0.525 us    |      pm_qos_requirement();
 0)    <idle>-0    |   0.518 us    |      tick_nohz_get_sleep_length();
 0)    <idle>-0    |   2.621 us    |    }
[...]
 1)    <idle>-0    |   0.518 us    |              touch_softlockup_watchdog();
 1)    <idle>-0    | + 14.355 us   |            }
 1)    <idle>-0    | + 22.840 us   |          }
 1)    <idle>-0    | + 25.949 us   |        }
 1)    <idle>-0    |               |        handle_irq() {
 1)    <idle>-0    |   0.511 us    |          irq_to_desc();
 1)    <idle>-0    |               |          handle_edge_irq() {
 1)    <idle>-0    |   0.638 us    |            _spin_lock();
 1)    <idle>-0    |               |            ack_apic_edge() {
 1)    <idle>-0    |   0.510 us    |              irq_to_desc();
 1)    <idle>-0    |               |              move_native_irq() {
 1)    <idle>-0    |   0.510 us    |                irq_to_desc();
 1)    <idle>-0    |   1.532 us    |              }
 1)    <idle>-0    |   0.511 us    |              native_apic_mem_write();
 ------------------------------------------
 1)    <idle>-0    =>    cat-5073
 ------------------------------------------

 1)    cat-5073    |   3.731 us    |                    }
 1)    cat-5073    |               |                    run_local_timers() {
 1)    cat-5073    |   0.533 us    |                      hrtimer_run_queues();
 1)    cat-5073    |               |                      raise_softirq() {
 1)    cat-5073    |               |                        __raise_softirq_irqoff() {
 1)    cat-5073    |               |                          /* nr: 1 */
 1)    cat-5073    |   2.718 us    |                        }
 1)    cat-5073    |   3.814 us    |                      }

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4e6c87e..aee95ae 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2562,7 +2562,7 @@ free:
 static int start_graph_tracing(void)
 {
 	struct ftrace_ret_stack **ret_stack_list;
-	int ret;
+	int ret, cpu;
 
 	ret_stack_list = kmalloc(FTRACE_RETSTACK_ALLOC_SIZE *
 				sizeof(struct ftrace_ret_stack *),
@@ -2571,6 +2571,10 @@ static int start_graph_tracing(void)
 	if (!ret_stack_list)
 		return -ENOMEM;
 
+	/* The cpu_boot init_task->ret_stack will never be freed */
+	for_each_online_cpu(cpu)
+		ftrace_graph_init_task(idle_task(cpu));
+
 	do {
 		ret = alloc_retstack_tasklist(ret_stack_list);
 	} while (ret == -EAGAIN);
-- 
1.6.1


