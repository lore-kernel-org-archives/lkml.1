Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZJ2VFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZJ2VFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZJ2VFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:05:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49055 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZJ2VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:05:23 -0400
Message-Id: <20091029205151.852744305@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 16:51:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing function graph tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately I've been testing with an allyesconfig. When I ran the function graph
tracer, it immediately crashed the kernel. Thanks to the new frame pointer
test in function graph, it reported directly what the issue was and then
panicked the kernel to prevent any unexpected damage from happening.

It pointed the error to be with jtcp_rcv_established. Which is a jprobe
function added to tcp_rcv_established at bootup when CONFIG_NET_TCPPROBE
is enabled.

Jprobes and the function graph tracer use the same mechanism to trace
the exit of a function. Unfortunately, only one can be done at a time.
The function graph tracer replaces the return address with its own handler,
but so does jprobes. The two are not compatible.

The solution I am proposing with this patch set is to add a call in
ftrace that lets other code in the kernel permanently disable functions from
being traced by the function and function graph tracer. As a probe function
is registered with jprobes, it calls this new function and that entry
will be removed from being traced.

I tested this with this patch series and it does solve the problem.

Some issues though:

1) this only works when DYNAMIC_FTRACE is enabled. We can prevent
function graph tracing with jprobes when DYNAMIC_FTRACE is not
enabled through Kconfig dependencies. Or have the registering of
a jprobe permanently disable function graph tracing.

2) This also prevents the function tracer from being able to trace a
function probe, even though the function tracer is not at issue
with this bug.

Feedback welcomed.

-- Steve

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/trace


Steven Rostedt (3):
      tracing: Clean up ftrace.h header and add ftrace_set_notrace() declaration
      tracing: Add calls to permanently disable functions from tracing
      tracing/kprobes: Disable tracing registered jprobe callback functions

----
 include/linux/ftrace.h |   26 +++++++--
 kernel/kprobes.c       |    4 +
 kernel/trace/ftrace.c  |  147 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 150 insertions(+), 27 deletions(-)

