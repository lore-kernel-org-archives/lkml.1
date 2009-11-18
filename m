Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbZKRWo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbZKRWo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZKRWo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:44:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbZKRWoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:44:06 -0500
Date: Wed, 18 Nov 2009 17:43:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <cover.1258580048.git.jbaron@redhat.com>
Subject: [RFC PATCH 0/6] jump label v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Refresh of the jump labeling patches. We introduce the following:

# ifdef CONFIG_X86_64
#  define JUMP_LABEL_NOP P6_NOP5
# else
#  define JUMP_LABEL_NOP ".byte 0xe9 \n\t .long 0\n\t"
# endif

# define JUMP_LABEL(tag, label, cond)                                       \
       do {                                                               \
               static const char __jlstrtab_##tag[]                       \
               __used __attribute__((section("__jump_strings")))  = #tag; \
               asm goto("1:"                                              \
                       JUMP_LABEL_NOP                                     \
                       ".pushsection __jump_table,  \"a\" \n\t"           \
                       _ASM_PTR "1b, %l[" #label "], %c0 \n\t"            \
                       ".popsection \n\t"                                 \
                       : :  "i" (__jlstrtab_##tag) :  : label);           \
       } while (0)

-------------

I'm using an atomic 5 byte no-op for x86_64 and a long jump for 32-bit x86.
My understanding is that not all 32-bit processors have an atomic 5 byte no-op,
and thus using a long jump or jump 0, for the off case is the safest.

which can then be used by the tracepoint code as:

#define DECLARE_TRACE(name, proto, args)                                \
       extern struct tracepoint __tracepoint_##name;                    \
       static inline void trace_##name(proto)                           \
       {                                                                \
               JUMP_LABEL(name, do_trace, __tracepoint_##name.state);   \
               return;                                                  \
do_trace:                                                               \
               __DO_TRACE(&__tracepoint_##name,                         \
                          TP_PROTO(proto), TP_ARGS(args));              \


--------------

Thus, in the disabled tracing case we have a no-op followed by a jump around
the disabled code. When we enable the tracepoint, we simply patch the no-op
with a jump to the 'do_trace' label. This relies on the 'asm goto' construct
which is already merged into gcc 4.5. In subsequent gcc versions, we also hope
to make use of 'cold' label for the 'do_trace' section. Thus, making the
disabled or straight line codepath, simply a no-op. 

As discussed in pervious mails I've seen an average improvement of 30 cycles
per-tracepoint on x86_64 systems that I've tested.

The first 2 patches of the series are a repost of Masami's text_poke_fixup()
function, which allows for efficient instruction patching. The final 4 patches,
implement the the jump patching mechanism for x86 and x86_64.

The implementation is a 'low' level one, in the sense that it is geared
specifically for tracepoints. However, I believe this mechanism will be more
generally useful for other parts of the kernel. Thus, I will propose 'higher'
level interfaces into the jump label code (layered on these 'low' level ones),
as we go.

thanks,

-Jason

Masami Hiramatsu (2):
	x86: Introduce generic jump patching without stop_machine
	kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE

Jason Baron(4):
  	move opcode defs from asm/kprobes.h to asm/alternative.h
  	jump-label-basic
  	jump-module-support
  	jump-label-tracepoints

 arch/x86/include/asm/alternative.h |   17 +++++
 arch/x86/include/asm/jump_label.h  |   35 +++++++++++
 arch/x86/include/asm/kprobes.h     |    3 -
 arch/x86/kernel/Makefile           |    2 +-
 arch/x86/kernel/alternative.c      |  120 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/jump_label.c       |   66 ++++++++++++++++++++
 arch/x86/kernel/kprobes.c          |    2 +-
 include/asm-generic/vmlinux.lds.h  |   11 +++-
 include/linux/jump_label.h         |   47 ++++++++++++++
 include/linux/module.h             |   12 +++-
 include/linux/tracepoint.h         |   35 ++++++-----
 kernel/kprobes.c                   |    2 +-
 kernel/module.c                    |   27 ++++++++-
 kernel/tracepoint.c                |   25 ++++++--
 14 files changed, 372 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h

