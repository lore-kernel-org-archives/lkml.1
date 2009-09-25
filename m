Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbZIYTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbZIYTNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZIYTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZIYTNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:13:18 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC PATCH tracing/kprobes 0/5] tracing/kprobes,
	perf: perf kprobe support
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 25 Sep 2009 12:14:30 -0700
Message-ID: <20090925191424.12939.91503.stgit@omoto>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

These patches introduce perf kprobe command and update kprobe-tracer.
perf kprobe command allows you to add new probe points by C line number
and local variable names.

Usage
-----
 perf kprobe [<options>] -P PROBEDEF [-P PROBEDEF ...]

    -k, --vmlinux <file>  vmlinux/module pathname
    -r, --release <rel>   kernel release
    -P, --probe <p|r:[GRP/]NAME,FUNC[+OFFS][@SRC]|@SRC:LINE,ARG[,ARG,...]>
                          probe point definition, where
		p:	kprobe probe
		r:	kretprobe probe
		GRP:	Group name (optional)
		NAME:	Event name
		FUNC:	Function name
		OFFS:	Offset from function entry (in byte)
		SRC:	Source code path
		LINE:	Line number
		ARG:	Probe argument (local variable name or
			kprobe-tracer argument format is supported.)

Examples
--------
1) Add a new kprobe probe on a line of C source code.
./perf kprobe -P 'p:myprobe,@fs/bio.c:162,bv,idx'
Adding new event: p:myprobe bvec_free_bs+17 bv=%bx idx=%cx

2) Add a new kretprobe probe on a function return.
./perf kprobe -P 'r:myretprobe,vfs_read,$rv'
Adding new event: r:myretprobe vfs_read+0 $rv

3) Check it in the perf list.
./perf list
...
  rNNN                                       [raw hardware event descriptor]

  kprobes:myprobe                            [Tracepoint event]
  kprobes:myretprobe                         [Tracepoint event]
  skb:kfree_skb                              [Tracepoint event]
...

4) Check its format

$ cat /sys/kernel/debug/tracing/events/kprobes/myprobe/format
name: myprobe
ID: 687
format:
	field:unsigned short common_type;	offset:0;	size:2;
	field:unsigned char common_flags;	offset:2;	size:1;
	field:unsigned char common_preempt_count;	offset:3;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_lock_depth;	offset:8;	size:4;

	field: unsigned long __probe_ip;	offset:12;	size:4;
	field: int __probe_nargs;	offset:16;	size:4;
	field: unsigned long bv;	offset:20;	size:4;
	field: unsigned long idx;	offset:24;	size:4;


print fmt: "(%lx) bv=%lx idx=%lx", REC->__probe_ip, REC->bv, REC->idx


Syntax Issue
------------
This version picks '-P event-definition' syntax, but I think
'-p event -a arg' is also possible. I'd like to ask you
which you like or support both?


TODO
----
There are still many enhancements required for catching up
'tracing side' of systemtap. I think it should be done one by one.
I hope that systemtap developers cooperate with us on this
development.

 - Support sys_perf_counter_open (non-root)
 - Type support
 - Non-auto static variable
 - Fields of data structure (var->field)
 - Bit fields
 - Array (var[N])
 - Dynamic array indexing (var[var2])
 - String/dynamic arrays (var:string, var[N..M])
 - Force Type casting ((type)var)
 - Non-inline search
 - libdw, libdwfl

Thank you,

---

Masami Hiramatsu (5):
      perf: kprobe command supports without libdwarf
      perf: Support perf kprobe command for kprobe-event setup helper
      tracing/kprobes: Rename fixed field name
      tracing/kprobes: Avoid field name confliction
      tracing/kprobes: Rename special variables syntax


 Documentation/trace/kprobetrace.txt |   10 -
 kernel/trace/trace_kprobe.c         |  124 +++++-
 tools/perf/Makefile                 |   10 +
 tools/perf/builtin-kprobe.c         |  340 +++++++++++++++++
 tools/perf/builtin.h                |    1 
 tools/perf/perf.c                   |    1 
 tools/perf/util/probe-finder.c      |  684 +++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h      |   70 ++++
 8 files changed, 1200 insertions(+), 40 deletions(-)
 create mode 100644 tools/perf/builtin-kprobe.c
 create mode 100644 tools/perf/util/probe-finder.c
 create mode 100644 tools/perf/util/probe-finder.h

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
