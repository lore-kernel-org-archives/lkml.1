Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZIJXvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZIJXvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIJXvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZIJXvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:51:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based event
	tracer update and perf support
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Thu, 10 Sep 2009 19:52:58 -0400
Message-ID: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

This series fixes bugs and upgrades kprobe-based event tracer
as a dynamic event tracer on ftrace/perf tools. This also enhances
tracer output format to show each argument name and event name on
each entry.

With this series, users can add trace events dynamically on ftrace
and use those events with perf tools as below.

(Step.1) Define new events under new group

$ echo p:mygroup/myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 \
 > /debug/tracing/kprobes_events
$ echo r:mygroup/myretprobe do_sys_open rv >> /debug/tracing/kprobes_events
$ cat /debug/tracing/kprobes_events
p:myprobe do_sys_open+0 dfd=a0 filename=a1 flags=a2 mode=a3
r:myretprobe do_sys_open+0 rv=rv

(You can see that each argument has its name.)


(Step.2) Perf shows new events

$ perf list
...
   mygroup:myretprobe                         [Tracepoint event]
   mygroup:myprobe                            [Tracepoint event]
...


(Step.3) Record events with perf

$ perf record -f -e mygroup:myprobe:record -F 1 -a ls
...
[ perf record: Captured and wrote 0.081 MB perf.data (~3544 samples) ]


(Step.4) Perf trace shows the result

$ perf trace
version = 0.5
            perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=810d3f7 flags=98800 mode=1
            perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=8000 mode=1b6
            perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=98800 mode=bff7450c
            perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=8000 mode=1b6


(Step.5) You can also use return probes.

$ perf record -f -e mygroup:myretprobe:record -F 1 -a ls
...
[ perf record: Captured and wrote 0.081 MB perf.data (~3544 samples) ]
$ perf trace
version = 0.5
            perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=b
            perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=c
            perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=d
            perf-1408  [000]     0.000000: myretprobe: (c04b0a5c <- c04b0b7d) rv=c


TODO:
- Implement perf kprobe command to help defining new probes.


Thank you,

---

Masami Hiramatsu (7):
      tracing/kprobes: Support custom subsystem for each kprobe event
      tracing/kprobes: Show event name in trace output
      tracing/kprobes: Add argument name support
      tracing/kprobes: Add event profiling support
      tracing/kprobes: Cleanup kprobe tracer code.
      tracing/kprobes: Fix probe offset to be unsigned
      x86/ptrace: Fix regs_get_argument_nth() to add correct offset


 Documentation/trace/kprobetrace.txt |   65 +++---
 arch/x86/kernel/ptrace.c            |    2 
 kernel/trace/trace_kprobe.c         |  369 +++++++++++++++++++++++------------
 3 files changed, 274 insertions(+), 162 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
