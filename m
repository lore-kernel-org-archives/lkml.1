Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbZICU0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbZICU0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 16:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbZICU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 16:26:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbZICU0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 16:26:02 -0400
Date: Thu, 3 Sep 2009 16:25:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, roland@redhat.com, rth@redhat.com,
       mingo@elte.hu
Message-Id: <cover.1252007851.git.jbaron@redhat.com>
Subject: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Problem:

Currenly, tracepoints are implemented using a conditional. The conditional
check requires checking a global variable for each tracepoint. Although,
the overhead of this check is small, it increases under memory pressure. As we
increase the number of tracepoints in the kernel this may become more of an
issue. In addition, tracepoints are often dormant (disabled), and provide no
direct kernel functionality. Thus, it is highly desirable to reduce their
impact as much as possible. Mathieu Desnoyers has already suggested a number of
requirements for a solution to this issue.

Solution:

In discussing this problem with Roland McGrath and Richard Henderson, we came 
up with a new 'asm goto' statement that allows branching to a label. Thus, this
patch set introdues a 'STATIC_JUMP_IF()' macro as follows:

#ifdef HAVE_STATIC_JUMP

#define STATIC_JUMP_IF(tag, label, cond)                               \
       asm goto ("1:"   /* 5-byte insn */                              \
          P6_NOP5                                                      \
               ".pushsection __jump_table,  \"a\" \n\t"                \
               _ASM_PTR "1b, %l[" #label "], %c0 \n\t"                 \
               ".popsection \n\t"                                      \
               : :  "i" (__sjstrtab_##tag) :  : label)

#else

#define STATIC_JUMP_IF(tag, label, cond)        \
        if (unlikely(cond))                     \
                goto label;

#endif /* !HAVE_STATIC_JUMP */


which can be used as:

        STATIC_JUMP_IF(trace, trace_label, jump_enabled);
        printk("not doing tracing\n");
if (0) {
trace_label:
        printk("doing tracing: %d\n", file);
}

---------------------------------------

Thus, if 'HAVE_STATIC_JUMP' is defined (which will depend ultimately on the
existence of 'asm goto' in the compiler version), we simply have a no-op
followed by a jump around the dormant (disabled) tracing code. The
'STATIC_JUMP_IF()' macro, produces a 'jump_table' which has the following
format:

[instruction address] [jump target] [tracepoint name]

Thus, to enable a tracepoint, we simply patch the 'instruction address' with
a jump to the 'jump target'. The current implementation is using ftrace
infrastructure to accomplish the patching, which uses 'stop_machine'. In
subsequent versions, we will update the mechanism to use more efficient
code patching techniques.

I've tested the performance of this using 'get_cycles()' calls around the
tracepoint call sites. For an Intel Core 2 Quad cpu (in cycles, averages):
		
		idle		after tbench run
		----		----------------
old code	 32		  88
new code	  2		   4


The performance improvement can be reproduced very reliably (using patch 4
in this series) on both Intel and AMD hardware.

In terms of code analysis the current code for the disabled case is a 'cmpl'
followed by a 'je' around the tracepoint code. so:

cmpl - 83 3d 0e 77 87 00 00 - 7 bytes
je   - 74 3e                - 2 bytes

total of 9 instruction bytes.

The new code is a 'nopl' followed by a 'jmp'. Thus:

nopl - 0f 1f 44 00 00 - 5 bytes
jmp  - eb 3e          - 2 bytes

total of 7 instruction bytes.

So, the new code also accounts for 2 less bytes in the instruction cache per tracepoint.

here's a link to the gcc thread introducing this feature:

http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01556.html

Todo:

-convert the patching to a more optimal implementation (not using stop machine)
-expand infrastructure for modules
-other use cases?
-mark the trace_label section with 'cold' attributes
-add module support
-add support for other arches (besides x86)

thanks,

-Jason

 arch/x86/kernel/ftrace.c          |   36 +++++
 arch/x86/kernel/test_nx.c         |    3 +
 include/asm-generic/vmlinux.lds.h |   11 ++
 include/linux/ftrace.h            |    3 +
 include/linux/jump_label.h        |   45 ++++++
 include/linux/tracepoint.h        |   50 +++++---
 kernel/Makefile                   |    2 +-
 kernel/jump_label.c               |  271 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_workqueue.c    |    2 +
 kernel/tracepoint.c               |  134 ++++++++++++++++++
 10 files changed, 540 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c

