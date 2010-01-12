Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292Ab0ALQ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0ALQ0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143Ab0ALQ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:26:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0ALQ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:26:48 -0500
Date: Tue, 12 Jan 2010 11:26:22 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <cover.1263247113.git.jbaron@redhat.com>
Subject: [RFC PATCH 0/8] jump label v4 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

For background, see previous posting: http://marc.info/?l=linux-kernel&m=125858436505941&w=2

Refresh of the jump labeling patches. The largest update revolves around how
the jump labels are organized. I've added a hash table, using the name
of the tracepoints as the 'key'. (I might want to change this to a pointer,
for other users, but the string key works well for tracepoints). I've also
pre-sorted the jump tables by name. Thus, when a jump label is enabled/disabled
we look up its hash table entry and then walk the list of associated jump
labels. The implementation also associates module jump sections with the
appropriate keys as they are inserted and removed.

The first 2 patches of the series are a repost of Masami's text_poke_fixup()
function, which allows for efficient instruction patching. I believe this is
still an ongoing discussion, on the best safest approach here. Masami's
text_poke_fixup() has been working well for me. But I could certainly
substitute a 'stop_machine()' version or something similar if there is enough
interest, until we have a more efficient solution.

patches are against the latest -tip tree.

thanks,

-Jason

Masami Hiramatsu (2):
        x86: Introduce generic jump patching without stop_machine
        kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE

Mathieu Desnoyers (1):
	notifier atomic call chain notrace

Jason Baron(5):
        move opcode defs from asm/kprobes.h to asm/alternative.h
        jump label base
	x86: jump label support
        jump label tracepoint support
        jump label module support


 arch/x86/include/asm/alternative.h |   17 ++
 arch/x86/include/asm/jump_label.h  |   32 ++++
 arch/x86/include/asm/kprobes.h     |    3 -
 arch/x86/kernel/Makefile           |    2 +-
 arch/x86/kernel/alternative.c      |  120 ++++++++++++++
 arch/x86/kernel/jump_label.c       |   52 ++++++
 arch/x86/kernel/kprobes.c          |    2 +-
 arch/x86/kernel/ptrace.c           |    1 +
 include/asm-generic/vmlinux.lds.h  |   10 +-
 include/linux/jump_label.h         |   58 +++++++
 include/linux/module.h             |    5 +-
 include/linux/tracepoint.h         |   34 +++--
 kernel/Makefile                    |    2 +-
 kernel/jump_label.c                |  301 ++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                   |    2 +-
 kernel/module.c                    |    7 +
 kernel/notifier.c                  |    6 +-
 kernel/tracepoint.c                |    8 +
 18 files changed, 635 insertions(+), 27 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c

