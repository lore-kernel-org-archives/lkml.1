Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbXKJA2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbXKJA2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 19:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbXKJA2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 19:28:23 -0500
Received: from gw.goop.org ([64.81.55.164]:35523 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXKJA2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 19:28:23 -0500
Message-ID: <4734FAF4.40800@goop.org>
Date: Fri, 09 Nov 2007 16:27:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: problem with x86-prepare-kprobes-code-for-unification.patch
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This code in kprobes_64.c from
x86-prepare-kprobes-code-for-unification.patch is problematic:

+static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
+{
+	switch (*insn) {
+	case 0xfa:		/* cli */
+	case 0xfb:		/* sti */
+	case 0xcf:		/* iret/iretd */
+	case 0x9d:		/* popf/popfd */
+		return 1;
+	}
+
+	/*
+	 * on 64 bit x86, 0x40-0x4f are prefixes so we need to look
+	 * at the next byte instead.. but of course not recurse infinitely
+	 */
+	if (*insn  >= 0x40 && *insn <= 0x4f && *insn > 0x4f)
+		return is_IF_modifier(++insn);
+	return 0;
+}


Firstly, the conditional in the if() doesn't seem to make much sense. 
It appears to be miscopied from:

-	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
-		return 1;


Secondly, the recursive inlining is making 4.0.2 complain:

/home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/kprobes_64.c: In function 'set_current_kprobe':
/home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/kprobes_64.c:152: sorry, unimplemented: inlining failed in call to 'is_IF_modifier': recursive inlining
/home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/kprobes_64.c:166: sorry, unimplemented: called from here

    J
