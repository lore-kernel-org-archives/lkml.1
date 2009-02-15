Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZBOJAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZBOJAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZBOJAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:00:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZBOJAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:00:37 -0500
Date: Sun, 15 Feb 2009 10:00:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215090026.GA31147@elte.hu>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215080941.GA2295@localhost.localdomain>
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


* Damien Wyart <damien.wyart@free.fr> wrote:

> Hello,
> 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12650
> > Subject		: Strange load average and ksoftirqd behavior with 2.6.29-rc2-git1
> > Submitter	: Damien Wyart <damien.wyart@free.fr>
> > Date		: 2009-01-20 16:25 (26 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123246937207675&w=2
> 
> The problem is still there in 2.6.29-rc5, nothing has changed. I am
> surprised noone has looked at it as it is trivial to reproduce for me.
> 
> Load average is between 0.30 and 0.60 when the machine is idle, the two
> ksoftirqd threads get a very high total running time in top. This is on
> a P4 machine. On a recent laptop, the load is not as high, but the
> ksoftirqd threads also get a very high total running time.

Mind having a look at this anomaly with the function graph tracer? We are
interested in a representative trace that shows the weird ksoftirq activities.
[ which trace could possibly pinpoint their origin. ]

Here's the tracing quickstart:

   http://redhat.com/~mingo/tip.git/tracing-quickstart.txt

Also attached below. Let me know if you have trouble getting a good trace,
or if any of the steps were non-intuitive or burdensome to you.

Thanks,

	Ingo

------------------------------>

You probably came here because:

- you have a weird latency somewhere that you'd like to debug?
- you have some weird kernel behavior that you'd like to see in detail?
- you are curious how Linux kernel internals look like on a real system?

A good generic tool for that is the built-in function graph tracer (available
in v2.6.28 and later Linux kernels), which will provide system-wide tracing
output of any workload you are interested in.

Sample output:

 # tracer: function_graph
 #
 # CPU DURATION        FUNCTION CALLS
 # |    |   |          |   |   |   |

   1) + 39.757 us   |    }
   1) + 41.593 us   |  }
   1)               |  sys_rt_sigprocmask() {
   1)   0.399 us    |    _spin_lock_irq();
   1)   1.209 us    |  }
   1)               |  sys_read() {
   1)   0.425 us    |    fget_light();
   1)               |    vfs_read() {
   1)               |      rw_verify_area() {
   1)               |        security_file_permission() {
   1)   0.377 us    |          cap_file_permission();
   1)   1.048 us    |        }
   1)   1.803 us    |      }
   1)               |      tty_read() {
   1)   0.476 us    |        tty_paranoia_check();
   1)               |        tty_ldisc_ref_wait() {
   1)               |          tty_ldisc_try() {
   1)   0.365 us    |            _spin_lock_irqsave();
   1)   0.426 us    |            _spin_unlock_irqrestore();
   1)   1.837 us    |          }
   1)   2.544 us    |        }

To get the very latest version of the tracer, pick up the -tip tree (which,
amongst other trees, also includes the latest tracing tree and Linus's latest
upstream -git tree):

   http://people.redhat.com/mingo/tip.git/README

And enable the following .config options:

  CONFIG_DEBUG_KERNEL=y
  CONFIG_FUNCTION_TRACER=y
  CONFIG_FUNCTION_GRAPH_TRACER=y
  CONFIG_DYNAMIC_FTRACE=y

Boot into the new kernel and mount debugfs (if you dont have it mounted
already):

  mkdir /debug
  mount -t debugfs nodev /debug

That's all - now you can use the tracer. There's no user-space utilities
needed, everything is built into the kernel and all functionality can
be accessed via the /debug/tracing/* special files.

For example, the following commands in a shell prompt will capture a
1-second trace of whatever happens on your box right now:

  cd /debug/tracing/
  echo function_graph_tracer > current_tracer
  echo 1 > tracing_enabled
  sleep 1
  echo 0 > tracing_enabled
  cat trace > /tmp/trace.txt

/tmp/trace.txt will contain the trace. If you are trying to debug a bug,
send that file to kernel developers :)

Tracing can be expensive, especially if every single kernel function is
traced (which is the default).

To solve that problem you can limit the scope of traced functions via the
function filter:

  echo ""              > set_ftrace_filter        # clear all previous filters
  echo "schedule*"    >> set_ftrace_filter        # trace schedule functions
  echo "*switch_to*"  >> set_ftrace_filter        # trace context switches
  echo "*wake_up*"    >> set_ftrace_filter        # trace task wakeups

Note that if you want the rules to be additive then filters have to be
appended via '>>'. Using '>' will override all previous filters again.

Use "cat set_ftrace_filter" to see the currently traced functions. (if the
file is empty then it means 'all') Use "cat available_filter_functions" for
all kernel functions that can be traced. On a typical system there will
be tens of thousands to pick from (!).

Besides the default output you can find additional attributes in the
'trace_options' file. For example:

  echo funcgraph-proc > trace_options

Will instruct the tracer to output which process/PID generated a trace
entry:

  0)   bash-2623    |               |  sys_dup2() {
  0)   bash-2623    |               |    sys_dup3() {
  0)   bash-2623    |   0.262 us    |      _spin_lock();
  0)   bash-2623    |   0.290 us    |      expand_files();
  0)   bash-2623    |               |      filp_close() {
  0)   bash-2623    |   0.260 us    |        dnotify_flush();
  0)   bash-2623    |   0.305 us    |        locks_remove_posix();
  0)   bash-2623    |               |        fput() {
  0)   bash-2623    |               |          __fput() {
  0)   bash-2623    |   0.393 us    |            _cond_resched();

Have fun tracing, but beware, if there's even just a little bit of
a kernel developer in you then it can be highly addictive! ;-)

	Ingo
