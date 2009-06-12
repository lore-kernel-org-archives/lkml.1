Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbZFLVZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbZFLVZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbZFLVZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:25:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42694 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZFLVZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:25:09 -0400
Date: Fri, 12 Jun 2009 17:24:34 -0400
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Message-Id: <cover.1244837725.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/7] add syscall tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

The following is an implementation of Frederic's syscall tracer on top of
tracepoints. It adds the ability to toggle the entry/exit of each syscall
via the standard events/syscalls/syscall_blah/enable interface. The 
implementation is done by adding 2 tracepoints. One on entry and one for exit.

This implementation required a few 'core' api changes. I've added 
'DECLARE_TRACE_REG()' macro which takes a register and and an unregister
function as arguments. This allowed me to toggle the ftrace tif flag
when the first tracepoint callback is added and the last is removed. Current
callers of 'DECLARE_TRACE()' are not impacted.

Another change was to call arch_init_ftrace_syscalls via an 'arch_initall'. In
this implmentation I needed to access the syscalls_metadata structure at
runtime in order to determine which syscalls were 'traceable'. Although the
implementation uses SYSCALL_DEFINE() to set up the the trace events, for
some reason at runtime there is no syscalls_metadata, associated with some of
the SYSCALL_DEFINE() calls. I'm not quite sure why that is. However, by
calling arch_init_ftrace_syscalls() at boot I can make sure the lists are in
sync.

thanks,

-Jason 


 arch/x86/include/asm/ftrace.h |    4 +-
 arch/x86/kernel/ftrace.c      |   24 +++++-
 arch/x86/kernel/ptrace.c      |    6 +-
 include/linux/syscalls.h      |   63 +++++++++++++++
 include/linux/tracepoint.h    |   27 ++++++-
 include/trace/syscall.h       |   37 +++++++---
 kernel/trace/trace_events.c   |   29 +++++---
 kernel/trace/trace_syscalls.c |  172 +++++++++++++++++++----------------------
 kernel/tracepoint.c           |   38 +++++++++
 9 files changed, 278 insertions(+), 122 deletions(-)

