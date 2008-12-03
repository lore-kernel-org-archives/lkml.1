Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbYLCUlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbYLCUlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762881AbYLCUib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:38:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbYLCUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:38:30 -0500
Message-Id: <20081203203656.776893226@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Dec 2008 15:36:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 0/3] ftrace: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This series has three patches.

The first patch adds a new feature that I've been wanting to have for some
time and Arjan even requested. That is to pick a function and only
trace that function and its children. Dynamic ftrace and function
graph needs to be enabled for this.

To do the above, I added a "trace" flags field in the task structure.
The second patch uses this for the ftrace pid code. It searches for
the task based on the pid and sets the trace flag, then in the
ftrace function caller it only needs to check this flag.

This means we can now trace more than one pid without any more overhead.
It also means that we should be able to use the name space code that
the container guys want us to. But since I'm not very up on the
namespace code, I'm still using just the normal 'pid'. I've Cc'd the
container folks so perhaps they could write up a patch for me ;-)

Note: When writing to the set_ftrace_pid two things happen.
 - The task with the matching pid gets the trace flag set.
 - Any other task has its trace flag cleared.
 #2 needs to be addressed when converting to pid name spaces.
 Just because it is not enough to simply find the matching task.
 It may be good enough to just clear all tasks and then find the
 one that matches.

The last patch makes the function graph tracer honor the set_ftrace_pid.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (3):
      ftrace: graph of a single function
      ftrace: use task struct trace flag to filter on pid
      ftrace: trace single pid for function graph tracer

----
 include/linux/ftrace.h |   46 +++++++++
 include/linux/sched.h  |    4 +
 kernel/trace/ftrace.c  |  257 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.c   |   11 ++
 kernel/trace/trace.h   |   40 +++++++-
 5 files changed, 353 insertions(+), 5 deletions(-)
-- 
