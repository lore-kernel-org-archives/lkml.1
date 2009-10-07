Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZJGWh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZJGWh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZJGWh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbZJGWh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:37:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes v3 0/7] tracing/kprobes,
	perf: perf probe support take 3
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
Date: Wed, 07 Oct 2009 18:27:33 -0400
Message-ID: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches introduce 'perf probe' command and update kprobe-tracer.
perf probe command allows you to add new probe points by C line number
and local variable names.

This version fixes some bugs, remove -r option (because perf always be
used for online kernel) and rename kprobe-tracer special vars.

Usage
-----
 perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]

    -k, --vmlinux <file>  vmlinux/module pathname
    -P, --probe <p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
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
./perf probe -P 'p:myprobe @fs/read_write.c:285 file buf count'
Adding new event: p:myprobe vfs_read+57 file=%bx buf=%si count=%ax

2) Add a new kretprobe probe on a function return.
./perf probe -P 'r:myretprobe vfs_read $retval'
Adding new event: r:myretprobe vfs_read+0 $retval

3) Check it in the perf list.
./perf list
...
  rNNN                                       [raw hardware event descriptor]

  kprobes:myprobe                            [Tracepoint event]
  kprobes:myretprobe                         [Tracepoint event]
  skb:kfree_skb                              [Tracepoint event]
...

4) Record the event by perf
./perf record -f -e kprobes:myprobe:record  -F 1 -a ls
...
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.081 MB perf.data (~3540 samples) ]

5) Trace the event
./perf trace
            perf-11445 [000] 95862.048894383: myprobe: (c04bbed5) file=dae15e80 buf=b78b2000 count=400
            perf-11445 [000] 95862.049066533: myprobe: (c04bbed5) file=dae15d80 buf=b78b2000 count=400
            perf-11445 [000] 95862.049134394: myprobe: (c04bbed5) file=dae15d80 buf=b78b2000 count=400
            perf-11445 [000] 95862.049171495: myprobe: (c04bbed5) file=dae15a80 buf=b78b2000 count=400

NOTE
----
 perf still fails to parse format if arguments have special charactors
(e.g. $retval, +16($stack) etc.) So, tracing myretprobe will fail with this
version. This will be solved by naming arguments automatically if it
doesn't have C-language name.

TODO
----
 - Support sys_perf_counter_open (non-root)
 - Input from stdin/output to stdout
 - 64-bits return value on x86-32
 - Static variable
 - Fields of data structures (var->field)
 - Type support
   - Bit fields
 - Array (var[N])
 - Dynamic array indexing (var[var2])
 - String/dynamic arrays (var:string, var[N..M])
 - Force Type casting ((type)var)
 - Non-inline search
 - libdw, libdwfl
 - etc.

Thank you,

---

Masami Hiramatsu (7):
      perf: perf probe command supports without libdwarf
      perf: Add perf probe subcommand for kprobe-event setup helper
      tracing/kprobes: Rename fixed field name
      tracing/kprobes: Avoid field name confliction
      tracing/kprobes: Rename special variables
      tracing/kprobes: Remove '$ra' special variable
      tracing/kprobes: Add $ prefix to special variables


 Documentation/trace/kprobetrace.txt |   27 +
 kernel/trace/trace_kprobe.c         |  158 +++++---
 tools/perf/Makefile                 |   10 +
 tools/perf/builtin-probe.c          |  385 ++++++++++++++++++++
 tools/perf/builtin.h                |    1 
 tools/perf/perf.c                   |    1 
 tools/perf/util/probe-finder.c      |  690 +++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h      |   70 ++++
 8 files changed, 1269 insertions(+), 73 deletions(-)
 create mode 100644 tools/perf/builtin-probe.c
 create mode 100644 tools/perf/util/probe-finder.c
 create mode 100644 tools/perf/util/probe-finder.h

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
