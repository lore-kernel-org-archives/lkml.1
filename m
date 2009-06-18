Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZFRWw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZFRWw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZFRWws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:52:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbZFRWwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:52:47 -0400
Message-Id: <20090618224409.916725341@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 18 Jun 2009 18:44:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][for 2.6.31] function graph gcc issue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The bug I spent two days debugging that Jake found was due to gcc
making a copy of the return address into the stack frame and not
using it to actually return. The function graph tracer would modify
the copy and not the actual location that was used to return to.
Thus the accounting of the function graph tracer was corrupted and
a nasty crash followed.

I found that 32bit x86 when compiled with optimize for size caused
this issue in the latest gcc (4.4.0). The first patch makes the
function graph tracer depend on !X86_32 || !CC_OPTIMIZE_FOR_SIZE.
This way we keep from getting into trouble with a know configuration
that breaks.

Then next patch adds to x86 (both 32bit and 64bit) a test of the
frame pointer to make sure that the return actually goes to where
we expect it to.

When debugging Jakes bug, The first instance was easy to find. It was
the timer_stats_update_stats that had a forced cacheline struct as a local.
I changed that and it seemed to fix the boot up test. When I enabled
function graph at run time, the system crashed again, but this time the
crash was hard to find where the issue was. I wrote up this test (patch 2)
and I found the problem immediately. In case gcc changes, we want to be
able to detect it right away before the tracer does anything dangerous.


Please pull the latest tip/tracing/urgent-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent-1


Steven Rostedt (2):
      function-graph: disable when both x86_32 and optimize for size are configured
      function-graph: add stack frame test

----
 arch/powerpc/kernel/ftrace.c         |    2 +-
 arch/s390/kernel/ftrace.c            |    2 +-
 arch/x86/Kconfig                     |    1 +
 arch/x86/kernel/entry_32.S           |    2 +
 arch/x86/kernel/entry_64.S           |    2 +
 arch/x86/kernel/ftrace.c             |    6 +++-
 include/linux/ftrace.h               |    4 ++-
 kernel/trace/Kconfig                 |    8 +++++++
 kernel/trace/trace_functions_graph.c |   36 ++++++++++++++++++++++++++++++---
 9 files changed, 54 insertions(+), 9 deletions(-)
-- 
