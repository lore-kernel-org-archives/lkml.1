Return-Path: <linux-kernel-owner+w=401wt.eu-S1765281AbZEIAr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765281AbZEIAr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 20:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764664AbZEIAqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 20:46:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764637AbZEIAqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 20:46:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
	instruction decoder
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>
Date: Fri, 08 May 2009 20:48:29 -0400
Message-ID: <20090509004829.5505.38720.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patches of kprobe-based event tracer for x86, version 5,
which allows you to probe various kernel events through ftrace interface.

This version supports only x86(-32/-64) (but porting it on other arch
just needs kprobes/kretprobes and register and stack access APIs).

This patchset also includes x86(-64) instruction decoder which
supports non-SSE/FP opcodes and includes x86 opcode map. I think
it will be possible to share this opcode map with KVM's decoder.

This series can be applied on the latest linux-2.6-tip tree.

This patchset includes following changes:
- Add x86 instruction decoder [1/7]
- Check insertion point safety in kprobe [2/7]
- Cleanup fix_riprel() with insn decoder [3/7]
- Add kprobe-tracer plugin [4/7]
- Fix kernel_trap_sp() on x86 according to systemtap runtime. [5/7]
- Add arch-dep register and stack fetching functions [6/7]
- Support fetching various status (register/stack/memory/etc.) [7/7]

Future items:
- .init function tracing support.
- Support primitive types(long, ulong, int, uint, etc) for args.


kprobe-based event tracer
---------------------------

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

Synopsis of kprobe_events:
  p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]     : set a probe
  r SYMBOL[+0] [FETCHARGS]                      : set a return probe

 FETCHARGS:
  %REG  : Fetch register REG
  sN    : Fetch Nth entry of stack (N >= 0)
  @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
  @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
  aN    : Fetch function argument. (N >= 0)(*)
  rv    : Fetch return value.(**)
  ra    : Fetch return address.(**)
  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.(***)

  (*) aN may not correct on asmlinkaged functions and at the middle of
      function body.
  (**) only for return probe.
  (***) this is useful for fetching a field of data structures.

E.g.
  echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events

 This sets a kprobe on the top of do_sys_open() function with recording
1st to 4th arguments.

  echo r do_sys_open rv rp >> /debug/tracing/kprobe_events

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
           <...>-2376  [001]   262.389131: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
           <...>-2376  [001]   262.391166: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
           <...>-2376  [001]   264.384876: do_sys_open: @do_sys_open+0 0xffffff9c 0x98db83e 0x8880 0x0
           <...>-2376  [001]   264.386880: sys_open: <-do_sys_open+0 0x5 0xc06e8ebb
           <...>-2084  [001]   265.380330: do_sys_open: @do_sys_open+0 0xffffff9c 0x804be3e 0x0 0x1b6
           <...>-2084  [001]   265.380399: sys_open: <-do_sys_open+0 0x3 0xc06e8ebb

 @SYMBOL means that kernel hits a probe, and <-SYMBOL means kernel returns
from SYMBOL(e.g. "sys_open: <-do_sys_open+0" means kernel returns from
do_sys_open to sys_open).

Thank you,

---

Masami Hiramatsu (7):
      tracing: add arguments support on kprobe-based event tracer
      x86: add pt_regs register and stack access APIs
      x86: fix kernel_trap_sp()
      tracing: add kprobe-based event tracer
      kprobes: cleanup fix_riprel() using insn decoder on x86
      kprobes: checks probe address is instruction boudary on x86
      x86: instruction decorder API


 Documentation/trace/ftrace.txt         |   70 +++
 arch/x86/include/asm/inat.h            |  125 +++++
 arch/x86/include/asm/insn.h            |  134 +++++
 arch/x86/include/asm/ptrace.h          |   70 +++
 arch/x86/kernel/kprobes.c              |  182 +++----
 arch/x86/kernel/ptrace.c               |   60 ++
 arch/x86/lib/Makefile                  |    9 
 arch/x86/lib/inat.c                    |   80 +++
 arch/x86/lib/insn.c                    |  471 +++++++++++++++++++
 arch/x86/lib/x86-opcode-map.txt        |  711 +++++++++++++++++++++++++++++
 arch/x86/scripts/gen-insn-attr-x86.awk |  314 +++++++++++++
 kernel/trace/Kconfig                   |    9 
 kernel/trace/Makefile                  |    1 
 kernel/trace/trace_kprobe.c            |  793 ++++++++++++++++++++++++++++++++
 14 files changed, 2922 insertions(+), 107 deletions(-)
 create mode 100644 arch/x86/include/asm/inat.h
 create mode 100644 arch/x86/include/asm/insn.h
 create mode 100644 arch/x86/lib/inat.c
 create mode 100644 arch/x86/lib/insn.c
 create mode 100644 arch/x86/lib/x86-opcode-map.txt
 create mode 100644 arch/x86/scripts/gen-insn-attr-x86.awk
 create mode 100644 kernel/trace/trace_kprobe.c

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
