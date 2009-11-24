Return-Path: <linux-kernel-owner+w=401wt.eu-S934400AbZKXXVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400AbZKXXVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934364AbZKXXVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:21:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934363AbZKXXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:21:31 -0500
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091124225342.GB5208@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
	 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
	 <20091124211423.GE5071@nowhere> <20091124221748.GA5208@nowhere>
	 <1259101602.22249.1122.camel@gandalf.stny.rr.com>
	 <20091124225342.GB5208@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 18:21:36 -0500
Message-Id: <1259104896.22249.1129.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 23:53 +0100, Frederic Weisbecker wrote:
> On Tue, Nov 24, 2009 at 05:26:42PM -0500, Steven Rostedt wrote:
> > > But it happens with trace_pipe reading.
> > 
> > Yep, but I think we should be able to handle it without modifying
> > trace_seq.
> 
> 
> 
> Yeah. I guess now that the bug window is isolated to the
> trace_pipe case, the fix will probably (hopefully) be easier.
> 

Hmm, there is something funky going on. I did the following:

# echo 1 > /debug/tracing/tracing_on
# echo function_graph > /debug/tracing/current_tracer
# sleep 10
# echo 0 > /debug/tracing/tracing_on
# cat /debug/tracing/per_cpu/cpu0/trace > /tmp/t1
# cat /debug/tracing/per_cpu/cpu0/trace_pipe > /tmp/t2
(wait)
Ctrl^C (seems to block for more input)


# diff -u /tmp/t1 /tmp/t2

This is some interesting results:

--- /tmp/t1     2009-11-24 18:11:03.000000000 -0500
+++ /tmp/t2     2009-11-24 18:12:20.000000000 -0500
@@ -1,7 +1,3 @@
-# tracer: function_graph
-#
-# CPU  DURATION                  FUNCTION CALLS
-# |     |   |                     |   |   |   |
  0)   0.543 us    |                        }
  0)   0.670 us    |                        _spin_unlock_irqrestore();
  0)   8.741 us    |                      }

( Just to get the idea, "-" is trace and "+" is trace_pipe )

@@ -84,7 +80,7 @@
  0)   <========== |
  0) ! 99918.45 us |  }
  0)               |  tick_nohz_restart_sched_tick() {
- 0)   0.570 us    |    tick_nohz_stop_idle();
+ 0)   0.570 us    |    }
  0)   0.733 us    |    rcu_exit_nohz();
  0)   0.612 us    |    select_nohz_load_balancer();
  0)   0.573 us    |    ktime_get();

trace_pipe lost the tick_nohz_stop_idle with '}'

@@ -272,7 +264,7 @@
  0)   0.663 us    |                  account_system_time();
  0)   1.939 us    |                }
  0)               |                run_local_timers() {
- 0)               |                  hrtimer_run_queues() {
+ 0)   0.615 us    |                  hrtimer_run_queues();
  0)   0.660 us    |                  raise_softirq();
  0)               |                  softlockup_tick() {
  0)   0.873 us    |                    __touch_softlockup_watchdog();

Now trace adds a '{' where it looks like trace_pipe was correct.

@@ -351,12 +343,12 @@
  0)   0.760 us    |                        _spin_unlock_irqrestore();
  0)   0.905 us    |                        _spin_lock_irqsave();
  0)   0.523 us    |                        __set_se_shares();
- 0)               |                        _spin_unlock_irqrestore() {
+ 0)   0.705 us    |                        _spin_unlock_irqrestore();
  0)   9.272 us    |                      }
  0)   0.573 us    |                      tg_nop();
  0)               |                      tg_shares_up() {
  0)   0.891 us    |                        _spin_lock_irqsave();
- 0)   0.530 us    |                        __set_se_shares();
+ 0)   0.530 us    |                        }
  0)   0.693 us    |                        _spin_unlock_irqrestore();
  0)   0.891 us    |                        _spin_lock_irqsave();
  0)   0.527 us    |                        __set_se_shares();

Again, trace adds the '{' and later trace_pipe loses
__set_se_shares(); ??

And this goes on and on.


So both seem to be a bit buggy. The above really should be almost
identical, besides the header.

-- Steve


