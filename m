Return-Path: <linux-kernel-owner+w=401wt.eu-S1751111AbZEWA1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbZEWA1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbZEWA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:26:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbZEWA01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:26:27 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v7 0/6] tracing: kprobe-based event tracer and x86
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
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 22 May 2009 20:28:30 -0400
Message-ID: <20090523002830.8948.51194.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patches of kprobe-based event tracer for x86, version 7,
which allows you to probe various kernel events through ftrace interface.
I added a selftest of x86 instruction decoder which makes a user-space
test tool of the x86 instruction decoder and compares the results of
objdump and the test tool right after building vmlinux. You can enable
that test by CONFIG_X86_DECODER_SELFTEST=y.

This version supports only x86(-32/-64) (but porting it on other arch
just needs kprobes/kretprobes and register and stack access APIs).

This patchset also includes x86(-64) instruction decoder which
supports non-SSE/FP opcodes and includes x86 opcode map. The decoder
is used for finding the instruction boundaries when inserting new
kprobes. I think it will be possible to share this opcode map
with KVM's decoder.

This series can be applied on the latest linux-2.6-tip tree.

This patchset includes following changes:
- Add x86 instruction decoder [1/6]
- Add x86 instruction decoder selftest [2/6]
- Check insertion point safety in kprobe [3/6]
- Cleanup fix_riprel() with insn decoder [4/6]
- Add arch-dep register and stack fetching functions [5/6]
- Add kprobe-based event tracer [6/6]

Future items:
- Support per-probe event-filtering interface.
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
  p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: set a probe
  r SYMBOL[+0] [FETCHARGS]			: set a return probe

 FETCHARGS:
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


Usage examples
--------------

  echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events

 This sets a kprobe on the top of do_sys_open() function with recording
1st to 4th arguments.

  echo r do_sys_open rv ra >> /debug/tracing/kprobe_events

 This sets a kretprobe on the return point of do_sys_open() function with
recording return value and return address.

  echo > /debug/tracing/kprobe_events

 This clears all probe points. and you can see the traced information via
/debug/tracing/trace.

  cat /debug/tracing/trace
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: 0x3 0x7fffd1ec4440 0x8000 0x0
           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <-do_sys_open: 0xfffffffffffffffe 0xffffffff81367a3a
           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: 0xffffff9c 0x40413c 0x8000 0x1b6
           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <-do_sys_open: 0x3 0xffffffff81367a3a
           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: 0xffffff9c 0x4041c6 0x98800 0x10
           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <-do_sys_open: 0x3 0xffffffff81367a3a


 Each line shows when the kernel hits a probe, and <- SYMBOL means kernel
returns from SYMBOL(e.g. "sys_open+0x1b/0x1d <- do_sys_open" means kernel
returns from do_sys_open to sys_open+0x1b).

Thank you,

---

Masami Hiramatsu (6):
      tracing: add kprobe-based event tracer
      x86: add pt_regs register and stack access APIs
      kprobes: cleanup fix_riprel() using insn decoder on x86
      kprobes: checks probe address is instruction boudary on x86
      x86: x86 instruction decoder build-time selftest
      x86: instruction decoder API


 Documentation/trace/kprobes.txt        |   81 +++
 arch/x86/Kconfig.debug                 |    9 
 arch/x86/Makefile                      |    3 
 arch/x86/include/asm/inat.h            |  127 +++++
 arch/x86/include/asm/insn.h            |  136 +++++
 arch/x86/include/asm/ptrace.h          |   67 ++
 arch/x86/kernel/kprobes.c              |  197 +++----
 arch/x86/kernel/ptrace.c               |   60 ++
 arch/x86/lib/Makefile                  |   13 
 arch/x86/lib/inat.c                    |   82 +++
 arch/x86/lib/insn.c                    |  473 +++++++++++++++++
 arch/x86/lib/x86-opcode-map.txt        |  711 +++++++++++++++++++++++++
 arch/x86/scripts/Makefile              |   19 +
 arch/x86/scripts/distill.awk           |   41 +
 arch/x86/scripts/gen-insn-attr-x86.awk |  314 +++++++++++
 arch/x86/scripts/test_get_len.c        |   81 +++
 arch/x86/scripts/user_include.h        |   49 ++
 kernel/trace/Kconfig                   |    9 
 kernel/trace/Makefile                  |    1 
 kernel/trace/trace.h                   |   22 +
 kernel/trace/trace_event_types.h       |   20 +
 kernel/trace/trace_kprobe.c            |  903 ++++++++++++++++++++++++++++++++
 22 files changed, 3313 insertions(+), 105 deletions(-)
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
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
