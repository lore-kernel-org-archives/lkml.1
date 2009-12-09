Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZLIHPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZLIHPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZLIHPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:15:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbZLIHPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:15:42 -0500
Message-ID: <4B1F4E73.4000206@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:14:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 0/10] tracing: use defined fields to print formats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that ftrace_format_##call() and ftrace_define_fields_##call()
are duplicate more or less.

trace_define_field() defines fields and links them into
strcut ftrace_event_call. We reuse them to print formats
and remove ftrace_format_##call(). It make all things simpler.

Quote(From Steven):
"""
I totally agree that your patch is a nice clean up, and saves space and 
prevents more bugs. On the other hand, we are changing an API to users 
where all tools that parse this must be able to cope.
"""

But now, this new patchset does not change any API to userspace.
PATCH#1 fix a mistake of trace_kprobe's format. You can

1) apply PATCH#1, compile, reboot with new kernel,
   add kprobe_events, save all the format files.

2) apply PATCH#2...10 additionally, compile, reboot with new kernel,
   add kprobe_events, save all the format files.

Take diffs of these two sets of format files, there are nothing changed.

So, this patchset does not change any API.

And this patchset does a nice cleanup and removes hunk of codes:
# size vmlinux.o.old vmlinux.o
   text    data     bss     dec     hex filename
5640127  589938 1299464 7529529  72e439 vmlinux.o.old
5620506  589938 1298888 7509332  729554 vmlinux.o

Patches are partitioned for easy to review:
PATCH#1~5 prepare (PATCH#2 fix a regression)
PATCH#6 add "print_fmt" field to struct ftrace_event_call and and initialization code for it.
PATCH#7 "print_fmt" initialization code for trace_syscalls
PATCH#8 "print_fmt" initialization code for trace_kprobe
PATCH#9 use defined fields and "print_fmt" to print formats
PATCH#10 remove show_format and corresponding codes.

This patchset is ready for 2.6.33.

This patchset is applied upon Li Zefan's patchset:
[PATCH 00/13] tracing: various cleanups and small fixes (updated).
Because this patchset depends on [PATCH 01/13] and [PATCH 03/13] of this patchset.

But if [PATCH 01/13] of Li Zefan's is not applied, it's OK that just
don't apply PATCH#3 of mine.

If [PATCH 03/13] of Li Zefan's is not applied, you should apply Frederic's
[GIT PULL] tracing/kprobes: Fix field creation's bad error handling
Because my patchset rely correct fields.

Lai

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h  |    3
 include/linux/syscalls.h      |    8 --
 include/trace/ftrace.h        |  168 +++++++++---------------------------------
 include/trace/syscall.h       |    4 -
 kernel/trace/trace_events.c   |   71 ++++++++---------
 kernel/trace/trace_export.c   |   94 ++++-------------------
 kernel/trace/trace_kprobe.c   |  100 +++++++++----------------
 kernel/trace/trace_syscalls.c |   94 +++++++++++------------
 8 files changed, 176 insertions(+), 366 deletions(-)


