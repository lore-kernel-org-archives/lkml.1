Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZE2ACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZE2ACy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZE2ABq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:01:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54086 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZE2ABk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:01:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v8 0/7] tracing: kprobe-based event tracer and x86
	instruction decoder
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Thu, 28 May 2009 20:03:26 -0400
Message-ID: <20090529000326.17532.70868.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patches of kprobe-based event tracer for x86, version 8,
which allows you to probe various kernel events through ftrace interface.

This version, I added per-probe filtering support which allows you to set
filters on each probe and shows formats of each probe. I think this is
more generic integration with ftrace, especially event-tracer.

This patchset also includes x86(-64) instruction decoder which
supports non-SSE/FP opcodes and includes x86 opcode map. The decoder
is used for finding the instruction boundaries when inserting new
kprobes. I think it will be possible to share this opcode map
with KVM's decoder.
The decoder is tested when building kernel, the test compares the 
results of objdump and the decoder right after building vmlinux.
You can enable that test by CONFIG_X86_DECODER_SELFTEST=y.

This series can be applied on the latest linux-2.6-tip tree.

This supports only x86(-32/-64) (but porting it on other arch
just needs kprobes/kretprobes and register and stack access APIs).

This patchset includes following changes:
- Add x86 instruction decoder [1/7] (FIXED)
- Add x86 instruction decoder selftest [2/7] (FIXED)
- Check insertion point safety in kprobe [3/7]
- Cleanup fix_riprel() with insn decoder [4/7]
- Add arch-dep register and stack fetching functions [5/7]
- Add dynamic event_call support to ftrace [6/7] (NEW)
- Add kprobe-based event tracer [7/7] (UPDATED)


Enhancement ideas will be added after merging:
- .init function tracing support.
- Support primitive types(long, ulong, int, uint, etc) for args.


Kprobe-based Event Tracer
=========================

Overview
--------
This tracer is similar to the events tracer which is based on Tracepoint
infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
and kretprobe). It probes anywhere where kprobes can probe(this means, all
functions body except for __kprobes functions).

Unlike the function tracer, this tracer can probe instructions inside of
kernel functions. It allows you to check which instruction has been executed.

Unlike the Tracepoint based events tracer, this tracer can add new probe points
on the fly.

Similar to the events tracer, this tracer doesn't need to be activated via
current_tracer, instead of that, just set probe points via
/debug/tracing/kprobe_events.


Synopsis of kprobe_events
-------------------------
  p[:EVENT] SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: set a probe
  r[:EVENT] SYMBOL[+0] [FETCHARGS]			: set a return probe

 EVENT			: Event name
 SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted
 MEMADDR		: Address where the probe is inserted

 FETCHARGS		: Arguments
  %REG	: Fetch register REG
  sN	: Fetch Nth entry of stack (N >= 0)
  @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
  @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
  aN	: Fetch function argument. (N >= 0)(*)
  rv	: Fetch return value.(**)
  ra	: Fetch return address.(**)
  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.(***)

  (*) aN may not correct on asmlinkaged functions and at the middle of
      function body.
  (**) only for return probe.
  (***) this is useful for fetching a field of data structures.


Per-Probe Event Filtering
-------------------------
 Per-probe event filtering feature allows you to set different filter on each
probe and gives you what arguments will be shown in trace buffer. If an event
name is specified right after 'p:' or 'r:' in kprobe_events, the tracer adds
an event under tracing/events/kprobes/<EVENT>, at the directory you can see
'id', 'enabled', 'format' and 'filter'.

enabled:
  You can enable/disable the probe by writing 1 or 0 on it.

format:
  It shows the format of this probe event. It also shows aliases of arguments
 which you specified to kprobe_events.

filter:
  You can write filtering rules of this event. And you can use both of aliase
 names and field names for describing filters.


Usage examples
--------------
To add a probe as a new event, write a new definition to kprobe_events
as below.

  echo p:myprobe do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events

 This sets a kprobe on the top of do_sys_open() function with recording
1st to 4th arguments as "myprobe" event.

  echo r:myretprobe do_sys_open rv ra >> /debug/tracing/kprobe_events

 This sets a kretprobe on the return point of do_sys_open() function with
recording return value and return address as "myretprobe" event.
 You can see the format of these events via
tracing/events/kprobes/<EVENT>/format.

  cat /debug/tracing/events/kprobes/myprobe/format
name: myprobe
ID: 23
format:
	field:unsigned short common_type;	offset:0;	size:2;
	field:unsigned char common_flags;	offset:2;	size:1;
	field:unsigned char common_preempt_count;	offset:3;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_tgid;	offset:8;	size:4;

	field: unsigned long ip;	offset:16;tsize:8;
	field: int nargs;	offset:24;tsize:4;
	field: unsigned long arg0;	offset:32;tsize:8;
	field: unsigned long arg1;	offset:40;tsize:8;
	field: unsigned long arg2;	offset:48;tsize:8;
	field: unsigned long arg3;	offset:56;tsize:8;

	alias: a0;	original: arg0;
	alias: a1;	original: arg1;
	alias: a2;	original: arg2;
	alias: a3;	original: arg3;

print fmt: "%lx: 0x%lx 0x%lx 0x%lx 0x%lx", ip, arg0, arg1, arg2, arg3


 You can see that the event has 4 arguments and alias expressions
corresponding to it.

  echo > /debug/tracing/kprobe_events

 This clears all probe points. and you can see the traced information via
/debug/tracing/trace.

  cat /debug/tracing/trace
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: 0x3 0x7fffd1ec4440 0x8000 0x0
           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <- do_sys_open: 0xfffffffffffffffe 0xffffffff81367a3a
           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: 0xffffff9c 0x40413c 0x8000 0x1b6
           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <- do_sys_open: 0x3 0xffffffff81367a3a
           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: 0xffffff9c 0x4041c6 0x98800 0x10
           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <- do_sys_open: 0x3 0xffffffff81367a3a


 Each line shows when the kernel hits a probe, and <- SYMBOL means kernel
returns from SYMBOL(e.g. "sys_open+0x1b/0x1d <- do_sys_open" means kernel
returns from do_sys_open to sys_open+0x1b).


Thank you,

---

Masami Hiramatsu (7):
      tracing: add kprobe-based event tracer
      tracing: ftrace dynamic ftrace_event_call support
      x86: add pt_regs register and stack access APIs
      kprobes: cleanup fix_riprel() using insn decoder on x86
      kprobes: checks probe address is instruction boudary on x86
      x86: x86 instruction decoder build-time selftest
      x86: instruction decoder API


 Documentation/trace/kprobes.txt        |  138 ++++
 arch/x86/Kconfig.debug                 |    9 
 arch/x86/Makefile                      |    3 
 arch/x86/include/asm/inat.h            |  127 +++
 arch/x86/include/asm/insn.h            |  136 ++++
 arch/x86/include/asm/ptrace.h          |   67 ++
 arch/x86/kernel/kprobes.c              |  197 +++--
 arch/x86/kernel/ptrace.c               |   60 ++
 arch/x86/lib/Makefile                  |   13 
 arch/x86/lib/inat.c                    |   82 ++
 arch/x86/lib/insn.c                    |  473 +++++++++++++
 arch/x86/lib/x86-opcode-map.txt        |  711 +++++++++++++++++++
 arch/x86/scripts/Makefile              |   19 +
 arch/x86/scripts/distill.awk           |   42 +
 arch/x86/scripts/gen-insn-attr-x86.awk |  314 +++++++++
 arch/x86/scripts/test_get_len.c        |   99 +++
 arch/x86/scripts/user_include.h        |   49 +
 include/linux/ftrace_event.h           |   13 
 include/trace/ftrace.h                 |   22 -
 kernel/trace/Kconfig                   |   12 
 kernel/trace/Makefile                  |    1 
 kernel/trace/trace.h                   |   22 +
 kernel/trace/trace_event_types.h       |   20 +
 kernel/trace/trace_events.c            |   54 +
 kernel/trace/trace_export.c            |   27 -
 kernel/trace/trace_kprobe.c            | 1174 ++++++++++++++++++++++++++++++++
 26 files changed, 3732 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/trace/kprobes.txt
 create mode 100644 arch/x86/include/asm/inat.h
 create mode 100644 arch/x86/include/asm/insn.h
 create mode 100644 arch/x86/lib/inat.c
 create mode 100644 arch/x86/lib/insn.c
 create mode 100644 arch/x86/lib/x86-opcode-map.txt
 create mode 100644 arch/x86/scripts/Makefile
 create mode 100644 arch/x86/scripts/distill.awk
 create mode 100644 arch/x86/scripts/gen-insn-attr-x86.awk
 create mode 100644 arch/x86/scripts/test_get_len.c
 create mode 100644 arch/x86/scripts/user_include.h
 create mode 100644 kernel/trace/trace_kprobe.c

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
