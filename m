Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZIXXSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZIXXSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIXXSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZIXXSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:18:06 -0400
Date: Thu, 24 Sep 2009 19:17:45 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com
Message-Id: <cover.1253831945.git.jbaron@redhat.com>
Subject: [PATCH 0/4] jump label patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

For background, I introduced this patchset in:
http://marc.info/?l=linux-kernel&m=125200966226921&w=2

This patchset updates the jump label mechanism to look like:

#define JUMP_LABEL(tag, label, cond)                                       \
        do {                                                               \
                static const char __jlstrtab_##tag[]                       \
                __used __attribute__((section("__jump_strings")))  = #tag; \
                asm goto ("1:"                                             \
                        "jmp %l[" #label "] \n\t"                          \
                        ".pushsection __jump_table,  \"a\" \n\t"           \
                        _ASM_PTR "1b, %l[" #label "], %c0, 0 \n\t"         \
                        ".popsection \n\t"                                 \
                        : :  "i" (__jlstrtab_##tag) :  : label);           \
        } while (0)

#endif


and usage case is:

#define DECLARE_TRACE(name, proto, args)                                 \
        extern struct tracepoint __tracepoint_##name;                    \
        static inline void trace_##name(proto)                           \
        {                                                                \
                JUMP_LABEL(name, trace_label, __tracepoint_##name.state);\
                __DO_TRACE(&__tracepoint_##name,                         \
                           TP_PROTO(proto), TP_ARGS(args));              \
trace_label:                                                             \
                return;                                                  \
        }                                                                \


So the idea now, is that by default we jump over the disabled code. In order to
enable the 'disabled' code, or tracing, we simply replace the jump with a
'jump 0'. Thus, we now avoid the issue of not having enough instruction space.
Thus, in most cases the jump we are patching is an '0xeb' opcode which is
simply 2 bytes (occasionally its an 0xeb). I have this patchset working nicely
on x86_64. I'm not sure if we need to recognize additional jump opcodes for
x86 32-bit....I have not yet tested there. In my x86_64 testing under memory
pressure I saw about a 30 cycle improvement with this code per tracepoint.
Additionally, this code reduces the icache bytes from 9 bytes (cmpl; je), to 
just 2 bytes (jmp).

The patchset makes use of text_poke_fixup() interface introduced by Masami in:
http://marc.info/?l=linux-kernel&m=125297186224609&w=2.

Thus, that patchset needs to be applied first. Patch is against the latest -tip
tree.

thanks,

-Jason



 arch/x86/include/asm/jump_label.h |   27 +++++++++++
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/jump_label.c      |   94 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |   11 ++++
 include/linux/jump_label.h        |   71 ++++++++++++++++++++++++++++
 include/linux/kernel.h            |    1 +
 include/linux/module.h            |   12 ++++-
 include/linux/tracepoint.h        |   31 +++++++------
 kernel/extable.c                  |    2 +-
 kernel/module.c                   |   31 ++++++++++++
 kernel/tracepoint.c               |   10 ++++
 11 files changed, 275 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h

