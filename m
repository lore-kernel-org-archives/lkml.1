Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbZGQOvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbZGQOvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbZGQOvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:51:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934346AbZGQOvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:51:04 -0400
Date: Fri, 17 Jul 2009 10:50:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com
Subject: [ANNOUNCE][RFC] trace-cmd - command line reader for ftrace
Message-ID: <alpine.DEB.2.00.0907171009050.9337@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since using echo and cat can sometimes be annoying to set up the tracer, 
I've been asked several times if I could come up with a tool to do it for 
you. For the last few weeks I've been working on one. The most difficult 
job was to parse out the "print_fmt" of the format files in the event.

This code is somewhat a proof of concept and is in alpha form. Although it 
is still very functional and useful. I can imagine that this could also be 
sucked into Ingo Molnar's "perf" utility.

The code is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

Just download it, go into the directory and run "make". Here's some 
examples of uses:

(still need to be root to run the record part, but not the report).

To enable all events and run some command:

 # ./trace-cmd record -e all ls /bin

Then to see the information:

 # ./trace-cmd report
version = 0.5
cpus=4
       trace-cmd-10995 [003] 235302.428904: kmem_cache_alloc: call_site=ffffffff810df1e4 ptr=0xffff880027585a68 bytes_req=168 bytes_alloc=168 gfp_flags=GFP_KERNEL
       trace-cmd-11003 [000] 235302.428909: kmalloc: call_site=ffffffff810a1740 ptr=0xffff880024150b40 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL|GFP_ZERO
       trace-cmd-10995 [003] 235302.428912: kmem_cache_free: call_site=ffffffff810de423 ptr=0xffff880027585a68
           <...>-11000 [002] 235302.428913: kmalloc: call_site=ffffffff810a1740 ptr=0xffff8800360b9f60 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL|GFP_ZERO
       trace-cmd-11003 [000] 235302.428917: kfree: call_site=ffffffff810a1904 ptr=0xffff880024150b40
       trace-cmd-10995 [003] 235302.428917: kmem_cache_alloc: call_site=ffffffff81049db7 ptr=0xffff88003f960f00 bytes_req=1696 bytes_alloc=1696 gfp_flags=GFP_KERNEL
       trace-cmd-10995 [003] 235302.428921: kmem_cache_alloc: call_site=ffffffff8106d548 ptr=0xffff88003f97b540 bytes_req=192 bytes_alloc=192 gfp_flags=GFP_KERNEL

To see just a subsystem:

 # ./trace-cmd record -e irq ls /bin
version = 0.5
cpus=4
       trace-cmd-11017 [000] 235469.067157: softirq_entry: softirq=1 action=TIMER
       trace-cmd-11017 [000] 235469.067161: softirq_exit: softirq=1 action=TIMER
       trace-cmd-11017 [000] 235469.067162: softirq_entry: softirq=8 action=RCU
       trace-cmd-11017 [000] 235469.067163: softirq_exit: softirq=8 action=RCU
       trace-cmd-11016 [001] 235469.067221: softirq_entry: softirq=1 action=TIMER
       trace-cmd-11016 [001] 235469.067226: softirq_exit: softirq=1 action=TIMER
       trace-cmd-11016 [001] 235469.067226: softirq_entry: softirq=8 action=RCU
       trace-cmd-11016 [001] 235469.067228: softirq_exit: softirq=8 action=RCU

I'm only cutting the top part of the trace, where it shows the trace-cmd 
running. This is still alpha, and I plan on adding default code to 
only trace the current running command, or allow you to trace all (as it 
does now). But the 'ls' is still in the trace:

              ls-11018 [001] 235469.118138: softirq_entry: softirq=1 action=TIMER
              ls-11018 [001] 235469.118140: softirq_exit: softirq=1 action=TIMER
              ls-11018 [001] 235469.118141: softirq_entry: softirq=8 action=RCU
              ls-11018 [001] 235469.118142: softirq_exit: softirq=8 action=RCU

To list the available trace events:

 # ./trace-cmd list -e
skb:kfree_skb
block:block_rq_abort
block:block_rq_insert
block:block_rq_issue
block:block_rq_requeue
block:block_rq_complete
block:block_bio_bounce
block:block_bio_complete
block:block_bio_backmerge
block:block_bio_frontmerge
block:block_bio_queue
block:block_getrq
block:block_sleeprq
block:block_plug
block:block_unplug_timer
block:block_unplug_io
block:block_split
block:block_remap
kmem:kmalloc
kmem:kmem_cache_alloc
kmem:kmalloc_node
kmem:kmem_cache_alloc_node
kmem:kfree
kmem:kmem_cache_free
workqueue:workqueue_insertion
workqueue:workqueue_execution
workqueue:workqueue_creation
workqueue:workqueue_destruction
irq:irq_handler_entry
irq:irq_handler_exit
irq:softirq_entry
irq:softirq_exit
sched:sched_kthread_stop
sched:sched_kthread_stop_ret
sched:sched_wait_task
sched:sched_wakeup
sched:sched_wakeup_new
sched:sched_switch
sched:sched_migrate_task
sched:sched_process_free
sched:sched_process_exit
sched:sched_process_wait
sched:sched_process_fork
sched:sched_signal_send


You can also trace a single trace point with one of two methods:

 # ./trace-cmd record -e sched:sched_wakeup ls /bin

Or simply:

 # ./trace-cmd record -e sched_wakeup ls /bin

 # ./trace-cmd report
version = 0.5
cpus=4
              ls-11038 [003] 235806.528155: sched_wakeup: task :12 [0] success=1
              ls-11038 [000] 235806.532473: sched_wakeup: task :10953 [120] success=1
            sshd-10953 [000] 235806.532515: sched_wakeup: task :11038 [120] success=0
       trace-cmd-11035 [000] 235806.536280: sched_wakeup: task :10809 [120] success=1
       trace-cmd-11037 [001] 235806.541029: sched_wakeup: task :2854 [120] success=1
       trace-cmd-11034 [003] 235806.545892: sched_wakeup: task :1 [120] success=1
       trace-cmd-11037 [001] 235806.546569: sched_wakeup: task :30521 [120] success=1
              ls-11038 [002] 235806.565837: sched_wakeup: task :10953 [120] success=1
            sshd-10953 [000] 235806.565950: sched_wakeup: task :11038 [120] success=0
            sshd-10953 [000] 235806.566039: sched_wakeup: task :11038 [120] success=0

This tool also works with tracers (plugins) as well as events

 # ./trace-cmd list -p
syscall blk kmemtrace power function_graph mmiotrace wakeup_rt wakeup 
preemptirqsoff preemptoff irqsoff function sched_switch initcall nop

 # ./trace-cmd record -p sched_switch ls /bin
 # ./trace-cmd report
version = 0.5
cpus=4
CPU 2 is empty
       trace-cmd-11054 [001] 235985.996230: wakeup: 11054:120:0  ==+ 11059:120:0 [001]
       trace-cmd-11054 [001] 235985.996236: context_switch: 11054:120:0  ==+ 11059:120:0 [001]
              ls-11059 [001] 235985.996507: wakeup: 11059:120:0  ==+ 10809:120:1 [001]
              ls-11059 [001] 235985.996515: context_switch: 11059:120:0  ==+ 10809:120:0 [001]
         emacs-x-10809 [001] 235985.996566: context_switch: 10809:120:1  ==+ 11059:120:0 [001]
              ls-11059 [001] 235986.000302: wakeup: 11059:120:1  ==+ 10953:120:1 [000]

Even the function graph works:

 # ./trace-cmd record -p function_graph ls /bin
 # ./trace-cmd report
version = 0.5
cpus=4
236149.191544 |   1) trace-cmd-11120 |   6.295 us   |  fget_light();
236149.191544 |   0) trace-cmd-11112 |   6.370 us   |  inotify_inode_queue_event();
236149.191544 |   2) trace-cmd-11118 |   6.230 us   |  fget_light();
236149.191545 |   3) trace-cmd-11117 |              |  check_preempt_wakeup() {
236149.191548 |   3) trace-cmd-11117 |   1.061 us   |    update_curr();
236149.191550 |   1) trace-cmd-11120 |              |  do_splice_to() {
236149.191550 |   2) trace-cmd-11118 |              |  do_splice_to() {
236149.191551 |   0) trace-cmd-11112 |   1.098 us   |  __fsnotify_parent();
236149.191551 |   3) trace-cmd-11117 |   0.959 us   |    wakeup_preempt_entity();
236149.191551 |   1) trace-cmd-11120 |              |    rw_verify_area() {
236149.191552 |   2) trace-cmd-11118 |              |    rw_verify_area() {
236149.191552 |   1) trace-cmd-11120 |              |      security_file_permission() {
236149.191552 |   3) trace-cmd-11117 |   0.831 us   |    resched_task();

I did add one filter to the output. That was --cpu.

 # ./trace-cmd report --cpu 0
version = 0.5
cpus=4
236149.191544 |   0) trace-cmd-11112 |   6.370 us   |  inotify_inode_queue_event();
236149.191551 |   0) trace-cmd-11112 |   1.098 us   |  __fsnotify_parent();
236149.191553 |   0) trace-cmd-11112 |   0.946 us   |  inotify_dentry_parent_queue_event();
236149.191555 |   0) trace-cmd-11112 |   1.138 us   |  fsnotify();
236149.191558 |   0) trace-cmd-11112 |              |  sys_close() {
236149.191558 |   0) trace-cmd-11112 |   0.963 us   |    _spin_lock();
236149.191560 |   0) trace-cmd-11112 |   0.973 us   |    _spin_unlock();
236149.191562 |   0) trace-cmd-11112 |              |    filp_close() {
236149.191563 |   0) trace-cmd-11112 |   0.869 us   |      dnotify_flush();
236149.191565 |   0) trace-cmd-11112 |   0.991 us   |      locks_remove_posix();
236149.191567 |   0) trace-cmd-11112 |              |      fput() {
236149.191568 |   0) trace-cmd-11112 |              |        __fput() {

Since the latency tracers look for max latencies, I do not use the splice 
command and create threads to record on the fly. It simply runs the code 
and then records the trace file directly. The latency tracers are:

  irqsoff
  preemptoff
  preempirqsoff
  wakeup
  wakeup_rt

 # ./trace-cmd record -p irqsoff ls /bin
# ./trace-cmd report 
version = 0.5
cpus=4
# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.30
# --------------------------------------------------------------------
# latency: 60 us, #88/88, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /                      
#                |||||     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||   \   |   /           
  <idle>-0       3d..1   10us : trace_hardirqs_off_thunk <-save_args
  <idle>-0       3d..1   11us : smp_apic_timer_interrupt <-apic_timer_interrupt
  <idle>-0       3d..1   11us : native_apic_mem_write <-smp_apic_timer_interrupt
  <idle>-0       3d..1   12us : exit_idle <-smp_apic_timer_interrupt
  <idle>-0       3d..1   13us : irq_enter <-smp_apic_timer_interrupt
  <idle>-0       3d..1   13us : idle_cpu <-irq_enter
  <idle>-0       3d.h1   14us : tick_check_idle <-irq_enter
  <idle>-0       3d.h1   14us : tick_check_oneshot_broadcast <-tick_check_idle
  <idle>-0       3d.h1   15us : tick_nohz_stop_idle <-tick_check_idle
  <idle>-0       3d.h1   15us : ktime_get <-tick_nohz_stop_idle
  <idle>-0       3d.h1   16us : ktime_get_ts <-ktime_get
  <idle>-0       3d.h1   16us : getnstimeofday <-ktime_get_ts
[...]
  <idle>-0       3d.h1   58us : irq_exit <-smp_apic_timer_interrupt
  <idle>-0       3d..2   59us : do_softirq <-irq_exit
  <idle>-0       3d..2   59us : __do_softirq <-call_softirq
  <idle>-0       3d..2   60us : __local_bh_disable <-__do_softirq
  <idle>-0       3d.s2   61us : __do_softirq <-call_softirq
  <idle>-0       3d.s2   61us : trace_hardirqs_on <-call_softirq

Note, you can disable the function tracer (which the latency tracers use)

 # ./trace-cmd record -p irqsoff -d ls /bin
 # ./trace-cmd report
# ./trace-cmd report 
version = 0.5
cpus=4
# tracer: irqsoff
#
# irqsoff latency trace v1.1.5 on 2.6.30
# --------------------------------------------------------------------
# latency: 48 us, #3/3, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
#    -----------------
#    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#
#                  _------=> CPU#            
#                 / _-----=> irqs-off        
#                | / _----=> need-resched    
#                || / _---=> hardirq/softirq 
#                ||| / _--=> preempt-depth   
#                |||| /                      
#                |||||     delay             
#  cmd     pid   ||||| time  |   caller      
#     \   /      |||||   \   |   /           
  <idle>-0       1dN.1   38us+: tick_nohz_restart_sched_tick <-cpu_idle
  <idle>-0       1dN.1   48us : tick_nohz_restart_sched_tick <-cpu_idle
  <idle>-0       1dN.1   49us : trace_hardirqs_on <-cpu_idle



Again, this is very much in alpha form. It may still be very buggy, and 
the format of the trace.dat file may soon change. Thus it is still in 
[RFC] release status, and nothing is considered stable.

Here's some todo's I have planned.

 1) get it in a form to be used by perf (if possible)
 2) add many more filters
   a) More ways to filter on the report side
   b) Add ways to filter on the recording side
    This includes:
      Using the /debug/tracing/event/*/filter files
      Using the set_ftrace_filter/notrace files
      Using the set_ftrace_pid
      set_graph_function
      enabling the backtrace functions
      enabling the tracing/options

And I'm sure there are many more.

So, please feel free to download this code and play with it. If you find 
bugs, please report. If you have other ideas that are not listed above, 
share them.

Have fun!

-- Steve

