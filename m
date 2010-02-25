Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab0BYN3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0BYN3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:29:18 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3&10 00/18] perf-probe updates - optprobe,
	elfutils and lazy matching
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Thu, 25 Feb 2010 08:33:42 -0500
Message-ID: <20100225133342.6725.26971.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are several bugfixes and updates for perf-probe/kprobes.
This updates includes moving onto elfutils-libdw and
the lazy line matching support.
This version also includes the patchset of the kprobes jump
optimization so that we can ensure the 'perf-probe' will utilize
it by default. :)
This version changes nothing but merging previous two patch-sets and
updating against 2.6.33-tip.

- elfutils library is developed closely with gcc team,
  and it is simple and fast dwarf analysis library.

- lazy-matching is similar to glob matching but ignoring
  spaces in both of target and pattern.

- Kprobes jump optimization allows kprobes to replace breakpoint
  with a jump instruction for reducing probing overhead drastically.
  (See Documentation/kprobes.txt for details)

This is updated todo list. Most of them are related
to the 'type' support.

TODO:
  - Enhance probe-finder to decode call frame instructions.
  - Support sys_perf_counter_open (for non-root users)
  - Support tracing static variables (non global)
  - Support variable types from debuginfo (e.g. char, int, ...)
  - Support fields of data structures (var->field)
  - Support array (var[N])
  - Support dynamic array-indexing (var[var2])
  - Support string/dynamic arrays (*var, var[N..M])
  - Support force type-casting ((type)var)
  - Support the type of return value
  - More debugger like enhancements(%next, --disasm, etc.)
  - Better support for probes on modules
  - --list option shows the file-name/line-number of each events.
  - Support kprobes optimization on preemptive kernel.


How to check jump optimization
==============================
The jump replacement optimization is transparently and automatically
done in kprobes.
So, if you enables CONFIG_KPROBE_EVENT(a.k.a. kprobe-tracer) in
kernel config, all kprobes users including 'perf probe' can benefit
from this feature.

e.g.

 # perf probe schedule
Added new event:
  probe:schedule                           (on schedule+0)

You can now use it on all perf tools, such as:

        perf record -e probe:schedule -a sleep 1

 # cat /sys/kernel/debug/kprobes/list
 c069ce4c  k  schedule+0x0    [DISABLED]

 # echo 1 > /sys/kernel/debug/tracing/events/kprobes/probe1/enable

 # cat /sys/kernel/debug/kprobes/list
 c069ce4c  k  schedule+0x0    [OPTIMIZED]

Or 

 # perf record -f -a -e probe:schedule cat /sys/kernel/debug/kprobes/list
 c069cb8c  k  schedule+0x0    [OPTIMIZED]
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.036 MB perf.data (~1586 samples) ]


Note:
 Which probe can be optimized is depends on the actual kernel binary.
 So, in some cases, it might not be optimized. Please try to probe
 another place in that case.


Thank you,

---

Masami Hiramatsu (18):
      perf probe: Add lazy line matching support
      perf probe: show more lines after last line
      perf probe: Check function address range strictly in line finder
      perf probe: Use libdw callback routines
      perf probe: Use elfutils-libdw for analyzing debuginfo
      perf probe: Rename probe finder functions
      perf probe: Fix bugs in line range finder
      perf probe: Update perf probe document
      perf probe: Do not show --line option without dwarf support
      kprobes: Add documents of jump optimization
      kprobes/x86: Support kprobes jump optimization on x86
      x86: Add text_poke_smp for SMP cross modifying code
      kprobes/x86: Cleanup save/restore registers
      kprobes/x86: Boost probes when reentering
      kprobes: Jump optimization sysctl interface
      kprobes: Introduce kprobes jump optimization
      kprobes: Introduce generic insn_slot framework
      kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE


 Documentation/kprobes.txt               |  207 ++++++
 arch/Kconfig                            |   13 
 arch/x86/Kconfig                        |    1 
 arch/x86/include/asm/alternative.h      |    4 
 arch/x86/include/asm/kprobes.h          |   31 +
 arch/x86/kernel/alternative.c           |   60 ++
 arch/x86/kernel/kprobes.c               |  609 ++++++++++++++++---
 include/linux/kprobes.h                 |   44 +
 kernel/kprobes.c                        |  647 +++++++++++++++++---
 kernel/sysctl.c                         |   12 
 tools/perf/Documentation/perf-probe.txt |   58 ++
 tools/perf/Makefile                     |   10 
 tools/perf/builtin-probe.c              |   36 +
 tools/perf/util/probe-event.c           |   55 +-
 tools/perf/util/probe-finder.c          | 1002 ++++++++++++++-----------------
 tools/perf/util/probe-finder.h          |   53 +-
 tools/perf/util/string.c                |   55 +-
 tools/perf/util/string.h                |    1 
 18 files changed, 2063 insertions(+), 835 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
