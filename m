Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZCDCyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZCDCyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZCDCw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:52:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZCDCwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:52:53 -0500
Message-Id: <20090304024921.153061228@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 21:49:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RFC only, not for pulling, unless everyone is fine with these :-)

After telling the folks from Google that I had splice code that I needed
to get working, I finally got around to doing it.

Not only did I get the splice code working, but I also made a perl
script (might want to cover you eyes if you look at that code) that
can automagically create the output from the binary files reading
the format arguments in the /debugfs/tracing/events/<subsys>/<event>/format
file.

>From previous patches, we have in include/trace/sched_event_types.h:

#undef TRACE_SYSTEM
#define TRACE_SYSTEM sched

TRACE_EVENT_FORMAT(sched_switch,
	TPPROTO(struct rq *rq, struct task_struct *prev,
		struct task_struct *next),
	TPARGS(rq, prev, next),
	TPFMT("task %s:%d ==> %s:%d",
	      prev->comm, prev->pid, next->comm, next->pid),
	TRACE_STRUCT(
		TRACE_FIELD(pid_t, prev_pid, prev->pid)
		TRACE_FIELD(int, prev_prio, prev->prio)
		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
				    next_comm,
				    TPCMD(memcpy(TRACE_ENTRY->next_comm,
						 next->comm,
						 TASK_COMM_LEN)))
		TRACE_FIELD(pid_t, next_pid, next->pid)
		TRACE_FIELD(int, next_prio, next->prio)
	),
	TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
	);

By making that, we automagically get this file:

 # cat /debug/tracing/events/sched/sched_switch/format 
name: sched_switch
ID: 29
format:
	field:unsigned char type;	offset:0;	size:1;
	field:unsigned char flags;	offset:1;	size:1;
	field:unsigned char preempt_count;	offset:2;	size:1;
	field:int pid;	offset:4;	size:4;
	field:int tgid;	offset:8;	size:4;

	field:pid_t prev_pid;	offset:12;	size:4;
	field:int prev_prio;	offset:16;	size:4;
	field special:char next_comm[TASK_COMM_LEN];	offset:20;	size:16;
	field:pid_t next_pid;	offset:36;	size:4;
	field:int next_prio;	offset:40;	size:4;

print fmt: "prev %d:%d ==> next %s:%d:%d"


Now with this patch set, we create a way to read the ftrace ring buffers
directly, as a binary page. Splice has been used such that the user
could splice the ring buffers without need to copy the pages.
The pages are taken from the ring buffers and can be placed directly
into files, without extra copies.

 # ls /debug/tracing/binary_buffers/
0  1  2  3  4  5  6  7

One can either just use the read/write to grab live data from these
buffers, or they could use splice. I have a simple file that reads
this buffers using splice. Note, it only runs on one file, you
can make multiple copies to run more. The ring buffers in ftrace
are per cpu and they are not dependent on each other.

Also, if there is no data in the buffer, it returns -EAGAIN.

 # find /debug/tracing/events -name 'type' | while read f; do
>    echo raw > $f; done

 # find /debug/tracing/events -name 'enable' | while read f; do
>   echo 1 > $f; done

 # ./splice /debug/tracing/binary_buffers/0 /tmp/buf-0

Yes you can run multiple instances of this on different buffers.

 # ./rb-read.pl /tmp/buf-0

produces:

        0  [000]  7071.936459: (irq_handler_entry) irq 48
        0  [000]  7071.936462: (irq_handler_exit) irq 48 ret 1
        0  [000]  7071.988801: (sched_signal_send) sig: 14  task 0
        0  [000]  7071.988813: (sched_wakeup) task 0 success=1
        0  [000]  7071.988823: (sched_switch) prev 0:140 ==> next ntpd:6582272:0
     3303  [000]  7071.988916: (sched_switch) prev 0:120 ==> next swap:7497072:0
        0  [000]  7072.020370: (sched_wakeup) task 0 success=1
        0  [000]  7072.020407: (sched_switch) prev 0:140 ==> next even:808416116:0
       16  [000]  7071.936157: (sched_switch) prev 0:115 ==> next swap:7497072:0

Notice the "(sched_switch)" lines.

 The splice C code:
   http://www.kernel.org/pub/linux/kernel/people/rostedt/splice.c

 The perl script to parse:
   http://www.kernel.org/pub/linux/kernel/people/rostedt/rb-read.pl

 And yes I know, they are both ugly :-p

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/splice/tip/tracing/ftrace


Steven Rostedt (5):
      ring-buffer: reset write field for ring_buffer_read_page
      ring-buffer: fix ring_buffer_read_page
      ring-buffer: replace sizeof of event header with offsetof
      ring-buffer: make ring_buffer_read_page read from start on partial page
      tracing: add binary buffer files for use with splice

----
 include/linux/ring_buffer.h |    7 +-
 kernel/trace/ring_buffer.c  |  118 +++++++++++++------
 kernel/trace/trace.c        |  274 +++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h        |    1 +
 4 files changed, 357 insertions(+), 43 deletions(-)
-- 
