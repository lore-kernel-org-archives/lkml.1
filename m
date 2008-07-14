Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYGNTac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYGNTac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYGNTaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbYGNTaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:30:24 -0400
Date: Mon, 14 Jul 2008 12:30:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
In-Reply-To: <487BA4CF.6060905@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807141214180.3305@woody.linux-foundation.org>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> <8763r8z570.fsf@basil.nowhere.org>
 <alpine.LFD.1.10.0807141139120.3305@woody.linux-foundation.org> <487BA4CF.6060905@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Andi Kleen wrote:
> 
> How about if the page fault handler checks for the value and prints
> a obvious string? It could do this reliably, unlike the "grep
> all registers for poison on #GP" method that was earlier proposed.

The GP handler, you mean.

Sure, that might work. I'm not convinced it's worth it, but it's certainly 
not difficult to do either. Something like this (TOTALLY UNTESTED!) might 
work.

It puts it in the general "__die()" routine because it was easier this way 
(we do want it below the "oops" thing, so that it gets captured by Arjan's 
scripts!), in case the deathnotes are useful for other cases too.

It could perhaps be extended to allow negative offsets off the 0xdead000.. 
pointer (right now those would be ignored because the '0xdead00..' part 
would turns into '0xdeacff..') but that would not matter for the 
particular case of the list poisoning (since that one adds the 0x0100100 
thing to it anyway).

Again: totally untested.

			Linus

---
 arch/x86/kernel/traps_64.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index f1a95d1..7487ce2 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -434,6 +434,29 @@ void dump_stack(void)
 
 EXPORT_SYMBOL(dump_stack);
 
+/*
+ * This depends intimately on the layout of pt_regs to
+ * show deathnotes in the GP registers.
+ */
+static void show_deathnotes(struct pt_regs *regs)
+{
+	static const char *names[16] = {
+		"r15", "r14", "r13", "r12",
+		"rbp", "rbx", "r11", "r10",
+		"r9",  "r8",  "rax", "rcx",
+		"rdx", "rsi", "rdi",
+	};
+	const unsigned long *r = &regs->r15;
+	int i;
+
+	for (i = 0; i < 15; i++) {
+		unsigned long value = r[i];
+		if ((value >> 48) != 0xdead)
+			continue;
+		printk("Deathnote %lx in register %s\n", value, names[i]);
+	}
+}
+
 void show_registers(struct pt_regs *regs)
 {
 	int i;
@@ -554,6 +577,7 @@ int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 	printk("\n");
 	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
+	show_deathnotes(regs);
 	show_registers(regs);
 	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
