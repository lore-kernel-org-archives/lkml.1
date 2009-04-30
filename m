Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbZD3A1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbZD3A1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZD3A1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48086 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbZD3A1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Of2zGZuJhomNxoh/dvDhjdnCzsL1X3+mlKZezlhy1xZab44wmKir25t8fpXoF8u0nK
         5jx/Qr3DQ7XZFjOKVLtqj86xsNtjl340jf+/g5yFrO0BeHJG0Y746zwOVPnAQNWrQqkX
         5lP7BSX3WHn4iraaJvv0SkFJfqrkE5vutnV20=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 00/19] tracing/workqueue: events support/enhancements, worklets tracing, fixes
Date: Thu, 30 Apr 2009 02:27:01 +0200
Message-Id: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset brings various features for the workqueue tracer.

The support of events tracing (tracepoint expanding):
	- workqueue_creation
	- workqueue_flush
	- workqueue_destruction

    Also for the worklets:
	- worklet_enqueue
	- worklet_enqueue_delayed
	- worklet_execute
	- worklet_complete
	- worklet_cancel

Now, most of the lifecycle of worklets and workqueues is available.

The histogram tracing now also supports the worklets. You can
measure the max and average execution time of a worklet.

A good bunch of Oleg's comments have been addressed, at least the
critical ones (races which can cause freed pointer dereferences, memory
leak, etc...). The rest is more about the design itself, such as using
the workqueue as the identifier instead of the thread and other things
that are in discussion.

Thanks!

Frederic.

The following changes since commit a0e39ed378fb6ba916522764cd508fa7d42ad495:
  Heiko Carstens (1):
        tracing: fix build failure on s390

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue

Frederic Weisbecker (6):
      tracing/workqueue: turn cpu_workqueue_stats::inserted into unsigned int
      tracing/workqueue: add execution time average column
      tracing/workqueue: add open/release file handlers
      tracing/workqueue: defer workqueue stat release if needed
      tracing/workqueue: use the original cpu affinity on probe_workqueue_destruction
      tracing/workqueue: provide documentation for the workqueue tracer

KOSAKI Motohiro (2):
      workqueue_tracepoint: introduce workqueue_handler_exit tracepoint and rename workqueue_execution to workqueue_handler_entry
      tracing/workqueue: add max execution time mesurement for per worklet

Zhaolei (11):
      ftrace, workqueuetrace: make workqueue tracepoints use TRACE_EVENT macro
      trace_workqueue: use list_for_each_entry() instead of list_for_each_entry_safe()
      trace_workqueue: remove cpu_workqueue_stats->first_entry
      trace_workqueue: remove blank line between each cpu
      trace_workqueue: add worklet information
      workqueue_tracepoint: add workqueue_flush and worklet_cancel tracepoint
      workqueue_tracepoint: change tracepoint name to fit worklet and workqueue lifecycle
      workqueue_trace: separate worklet_insertion into worklet_enqueue and worklet_enqueue_delayed
      tracing/workqueue: turn workfunc_stats::inserted into unsigned int
      tracing/workqueue: avoid accessing task_struct's member variable in stat file read
      tracing/workqueue: use list_for_each_entry instead of list_for_each_entry_safe in probe_workqueue_destruction()

 Documentation/trace/workqueue.txt |  114 ++++++++++
 include/trace/events/workqueue.h  |  200 +++++++++++++++++
 include/trace/workqueue.h         |   25 --
 kernel/trace/trace_stat.c         |    8 +
 kernel/trace/trace_stat.h         |    3 +
 kernel/trace/trace_workqueue.c    |  444 +++++++++++++++++++++++++++++--------
 kernel/workqueue.c                |   45 +++--
 7 files changed, 697 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/trace/workqueue.txt
 create mode 100644 include/trace/events/workqueue.h
 delete mode 100644 include/trace/workqueue.h
