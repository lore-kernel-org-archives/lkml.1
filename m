Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbZLFHgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbZLFHgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZLFHf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59919 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbZLFHfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BmMUgotYV3zeX2m2RtLPcYIoY3b76EasQJBcCOt06tHaeF6vFS1iL96uR/A8UsdlB8
         jq8jhA6L8j8TCOz8wSGXA2sQBQNneIVNRsB8obnAZtYZ5HLJk6GecqRzUbSa89gAxuoG
         /RsgOkISU0plFk1L0JKvaLgpq556clZ/C+KOo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 8/9] x86: Fixup wrong debug exception frame link in stacktraces
Date: Sun,  6 Dec 2009 08:34:57 +0100
Message-Id: <1260084898-11686-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While dumping a stacktrace, the end of the exception stack won't link
the frame pointer to the previous stack.

The interrupted stack will then be considered as unreliable and ignored
by perf, as the frame pointer is unreliable itself.

This happens because we overwrite the frame pointer that links to the
interrupted frame with the address of the exception stack. This is
done in order to reserve space inside.
But rbp has been chosen here only because it is not a scratch register,
so that the address of the exception stack remains in rbp after calling
do_debug(), we can then release the exception stack space without the
need to retrieve its address again.

But we can pick another non-scratch register to do that, so that we
preserve the link to the interrupted stack frame in the stacktraces.

Just randomly choose r12. Every registers are saved just before and
restored just after calling do_debug(). And r12 is not used in the
middle, which makes it a perfect candidate.

Example: perf record -g -a -c 1 -f -e mem:$(tasklist_lock_addr):rw

Before:
    44.18%  [k] _raw_read_lock
            |
            |
            ---  |--6.31%-- waitid
                 |
                 |--4.26%-- writev
                 |
                 |--3.63%-- __select
                 |
                 |--3.15%-- __waitpid
                 |          |
                 |          |--28.57%-- 0x8b52e00000139f
                 |          |
                 |          |--28.57%-- 0x8b52e0000013c6
                 |          |
                 |          |--14.29%-- 0x7fde786dc000
                 |          |
                 |          |--14.29%-- 0x62696c2f7273752f
                 |          |
                 |           --14.29%-- 0x1ea9df800000000
                 |
                 |--3.00%-- __poll

After:

    43.94%  [k] _raw_read_lock
            |
            --- _read_lock
               |
               |--60.53%-- send_sigio
               |          __kill_fasync
               |          kill_fasync
               |          evdev_pass_event
               |          evdev_event
               |          input_pass_event
               |          input_handle_event
               |          input_event
               |          synaptics_process_byte
               |          psmouse_handle_byte
               |          psmouse_interrupt
               |          serio_interrupt
               |          i8042_interrupt
               |          handle_IRQ_event
               |          handle_edge_irq
               |          handle_irq
               |          __irqentry_text_start
               |          ret_from_intr
               |          |
               |          |--30.43%-- __select
               |          |
               |          |--17.39%-- 0x454f15
               |          |
               |          |--13.04%-- __read
               |          |
               |          |--13.04%-- vread_hpet
               |          |
               |          |--13.04%-- _xcb_lock_io
               |          |
               |           --13.04%-- 0x7f630878ce87

Note: it does not only affect perf events but also other stacktraces in
x86-64. They were considered as unreliable once we quit the debug
stack frame.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/entry_64.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 722df1b..0f08a0c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1076,10 +1076,10 @@ ENTRY(\sym)
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-	PER_CPU(init_tss, %rbp)
-	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
+	PER_CPU(init_tss, %r12)
+	subq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
 	call \do_sym
-	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%rbp)
+	addq $EXCEPTION_STKSZ, TSS_ist + (\ist - 1) * 8(%r12)
 	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
 END(\sym)
-- 
1.6.2.3

