Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0CMC67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:58:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab0CMC6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:58:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=zRefcBEBTQQA:10 a=GzHTLUccyWwA:10 a=VwQbUJbxAAAA:8 a=P3iEhR0dkrujfN_lWu0A:9 a=k9sVxnbiJBu8hp6irj-0Pt_WpIkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100313025655.104950166@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 12 Mar 2010 21:56:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/5][GIT PULL][2.6.34] tracing: urgent fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Li Zefan and Lai Jiangshan told me they were finding various bugs
with running a stress test. I asked for this test, and Li sent it
to me. Running the test I was also able to trigger the same bugs that
they were seeing. Unfortunately, these bugs were very hard to figure
out and it took me most of the week to fix them.

These bugs would most likely not happen in normal use, since they
all require multiple users writing to the control files of ftrace.
This stress test does just that, it creates several processes that
each write to a different part of a ftrace control system. One resizes
the ring buffer, the other enables and disables various options,
another changes the ftrace plugins, another enables and disables
various events, another enables and disables the tracer, etc.

Normal use generally has a single user that would only do one of these
actions at a time. But that is no excuse for not fixing the issues
that this test uncovered, so I took this very seriously.

Even the fix "tracing: Disable buffer switching when starting or
stopping trace" may look like it could happen if wakeup tracer is running,
but since opening the trace file would cause the wakeup tracer to stop,
it actually required another task to change the current tracer to
the wakeup tracer while the trace file was being read.

In any event, I've been running Li's ftrace_stress_test for a few
hours now, and it seems pretty stable with these patches. I'll continue
to run it to see if it finds anything else.

All of these patches I consider urgent and have also Cc'd stable on them.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Lai Jiangshan (1):
      ring-buffer: Move disabled check into preempt disable section

Steven Rostedt (4):
      function-graph: Init curr_ret_stack with ret_stack
      tracing: Use same local variable when resetting the ring buffer
      tracing: Disable buffer switching when starting or stopping trace
      tracing: Do not record user stack trace from NMI context

----
 kernel/trace/ftrace.c      |    2 +-
 kernel/trace/ring_buffer.c |   12 ++++++------
 kernel/trace/trace.c       |   24 ++++++++++++++++++++----
 3 files changed, 27 insertions(+), 11 deletions(-)
