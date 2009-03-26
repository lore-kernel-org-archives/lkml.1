Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZCZW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZCZW7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZCZW7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:59:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52792 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZCZW7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:59:38 -0400
Message-ID: <49CC08A2.5030602@redhat.com>
Date: Thu, 26 Mar 2009 18:58:42 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the patches of kprobe-based event tracer for x86, version 3.
Since this feature seems to attract some developers, I'd like to
push these basic patches into -tip tree so that they can easily
play it.

This version supports only x86(-32/-64) (If someone is interested in
porting this to other architectures, I'd happy to help :)), and
no respawn-able probe support (this would be better to push -mm tree.)

This can be applied on the linux-2.6-tip tree.

This patchset includes following changes:
- Add kprobe-tracer plugin [1/4]
- Fix kernel_trap_sp() on x86 according to systemtap runtime. [2/4]
- Support register and memory fetching [3/4]
- Support symbol-based memory fetching (for global variables) [4/4]

Future items:
- .init function tracing support.
- Add kernel_trap_sp() and fetch_*() on other archs.
- Support name-based register fetching (ax, bx, and so on)
- Support indirect memory fetch from registers etc.
- Support primitive types(long, ulong, int, uint, etc) for args.
- Check insertion point safety by using instruction decoder.

We may need to separate above arch-dependent variables fetching
infrastructure.

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
/debug/tracing/kprobe_probes.

Synopsis of kprobe_probes:
  p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]     : set a probe
  r SYMBOL[+0] [FETCHARGS]                      : set a return probe

 FETCHARGS:
  rN    : Fetch Nth register (N >= 0)
  sN    : Fetch Nth entry of stack (N >= 0)
  @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
  @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
  aN    : Fetch function argument. (N >= 1)(*)
  rv    : Fetch return value.(**)
  rp    : Fetch return address.(**)

  (*) aN may not correct on asmlinkaged functions and at function body.
  (**) only for return probe.

E.g.
  echo p do_sys_open a1 a2 a3 a4 > /debug/tracing/kprobe_probes

 This sets a kprobe on the top of do_sys_open() function with recording
1st to 4th arguments.

  echo r do_sys_open rv rp >> /debug/tracing/kprobe_probes

 This sets a kretprobe on the return point of do_sys_open() function with
recording return value and return address.

  echo > /debug/tracing/kprobe_probes

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

 Documentation/ftrace.txt      |   67 ++++
 arch/x86/include/asm/ptrace.h |    4 +-
 kernel/trace/Kconfig          |    9 +
 kernel/trace/Makefile         |    1 +
 kernel/trace/trace_kprobe.c   |  760 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 839 insertions(+), 2 deletions(-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


