Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYKWJRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYKWJRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYKWJRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:17:35 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:5774 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYKWJRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:17:32 -0500
Date: Sun, 23 Nov 2008 10:15:32 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
Message-ID: <20081123091532.GA31515@mailshack.com>
References: <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123090828.GA31490@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sun, 23 Nov 2008 10:16:55 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.122; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: moves some code out of .kprobes.text

KPROBE_ENTRY switches code generation to .kprobes.text, and KPROBE_END
uses .popsection to get back to the previous section (.text, normally).
Also replace ENDPROC by END, for consistency.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 arch/x86/kernel/entry_64.S |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

Hi Ingo,

One more small change for today. The xen-related functions 
xen_do_hypervisor_callback and xen_failsafe_callback are put
in the .kprobes.text even in the current kernel: ignore_sysret
is enclosed in KPROBE_ENTRY / ENDPROC, instead of KPROBE_ENTRY /
KPROBE_END, but I guess the situation is harmless.

Greetings,
	Alexander

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ec0ed9c..477a428 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1190,7 +1190,7 @@ paranoid_schedule:
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
 	CFI_ENDPROC
-END(paranoid_exit)
+KPROBE_END(paranoid_exit)
 
 /*
  * Exception entry point. This expects an error code/orig_rax on the stack.
@@ -1282,7 +1282,7 @@ gs_change:
 	CFI_ADJUST_CFA_OFFSET -8
         ret
 	CFI_ENDPROC
-ENDPROC(native_load_gs_index)
+END(native_load_gs_index)
 
         .section __ex_table,"a"
         .align 8
@@ -1336,7 +1336,7 @@ ENTRY(kernel_thread)
 	UNFAKE_STACK_FRAME
 	ret
 	CFI_ENDPROC
-ENDPROC(kernel_thread)
+END(kernel_thread)
 
 child_rip:
 	pushq $0		# fake return address
@@ -1352,7 +1352,7 @@ child_rip:
 	mov %eax, %edi
 	call do_exit
 	CFI_ENDPROC
-ENDPROC(child_rip)
+END(child_rip)
 
 /*
  * execve(). This function needs to use IRET, not SYSRET, to set up all state properly.
@@ -1383,9 +1383,7 @@ ENTRY(kernel_execve)
 	UNFAKE_STACK_FRAME
 	ret
 	CFI_ENDPROC
-ENDPROC(kernel_execve)
-
-
+END(kernel_execve)
 
 	/* runs on exception stack */
 KPROBE_ENTRY(nmi)
@@ -1460,14 +1458,14 @@ ENTRY(call_softirq)
 	decl %gs:pda_irqcount
 	ret
 	CFI_ENDPROC
-ENDPROC(call_softirq)
+END(call_softirq)
 
 KPROBE_ENTRY(ignore_sysret)
 	CFI_STARTPROC
 	mov $-ENOSYS,%eax
 	sysret
 	CFI_ENDPROC
-ENDPROC(ignore_sysret)
+KPROBE_END(ignore_sysret)
 
 #ifdef CONFIG_XEN
 zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
-- 
1.5.4.3
