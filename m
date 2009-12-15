Return-Path: <linux-kernel-owner+w=401wt.eu-S1751828AbZLOHjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbZLOHjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZLOHjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:39:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZLOHjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:39:48 -0500
Message-ID: <4B273D1E.6070003@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 15:39:10 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V5 0/10] tracing: use defined fields to print formats
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

How this patchset works:

# cat events/irq/irq_handler_entry/format
name: irq_handler_entry
ID: 97
format:

A) ======> name, ID, and a string "format:"

        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:int common_lock_depth;    offset:8;       size:4; signed:1;

        field:int irq;  offset:12;      size:4; signed:1;
        field:__data_loc char[] name;   offset:16;      size:4; signed:1;

B) ========> fields.

print fmt: "irq=%d name=%s", REC->irq, __get_str(name)

C) ========> string "print fmt: " and the print format after it.

For B)
Ensure all fields are add into struct ftrace_event_call->fields. (patch#4)
Ensure all fields are correct. (patch#5)

For C)
add a print_fmt field (patch#6)
init print_fmt carefully (patch#6 and patch#7 patch#8)

So when we generate format file:
print name
print ID
print string "format:"
use struct ftrace_event_call->fields to print fields
use struct ftrace_event_call->print_fmt to print "print fmt: XXXXXXXXXXX"

-- Lai

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h  |    3
 include/linux/syscalls.h      |    8 --
 include/trace/ftrace.h        |  168 +++++++++---------------------------------
 include/trace/syscall.h       |    4 -
 kernel/trace/trace_events.c   |   78 ++++++++++---------
 kernel/trace/trace_export.c   |   94 ++++-------------------
 kernel/trace/trace_kprobe.c   |  103 +++++++++++--------------
 kernel/trace/trace_syscalls.c |   96 ++++++++++++------------
 8 files changed, 192 insertions(+), 362 deletions(-)

