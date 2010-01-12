Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265Ab0ALLJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0ALLJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 06:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144Ab0ALLJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 06:09:37 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60002 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0ALLJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 06:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k3QOVRjm0Fz7cHpOgadVeVVsKJMX7b/KJSu3do2fTM+EfCBBJCkEaUh35itjAs9r0y
         uHA1kTHENo5hkphuanBv9AQuAK7xSS+2GOeJA9nVj89tsmeviqQhd6TZSR4kHbzFlmBc
         Qjsma7FXEcoLz2sXI4T/Kqi0OjvS7/stCTrgw=
MIME-Version: 1.0
Date: Tue, 12 Jan 2010 19:09:35 +0800
Message-ID: <ce2c83091001120309q19d58b45kc27610fc31ce01dc@mail.gmail.com>
Subject: Did we really need to clear the IF flag at prepare_singlestep() of 
	x86 kprobes?
From: Dongdong Deng <libfetion@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, arjan@infradead.org, jkenisto@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kprobe experts,

I have a doubt about the handling "X86_EFLAGS_IF" at prepare_singlestep(),
Could you give me some suggestions?


arch/x86/kernel/kprobes.c:
406 static void __kprobes prepare_singlestep(struct kprobe *p, struct
pt_regs *regs)
407 {
408    clear_btf();
409    regs->flags |= X86_EFLAGS_TF;
410    regs->flags &= ~X86_EFLAGS_IF;
  ...
}


for 410 line: Kprobe is intend to disable interrupt during the single step.

I think it is enough that just setting X86_EFLAGS_TF as following reasons.


******************
Reason 1: "debug trap" was initalized as an interrupt gate

arch/x86/kernel/traps.c:892: set_intr_gate_ist(1, &debug, DEBUG_STACK);

The "debug trap" was initalized as an interrupt gate, thereby during the
hanld function of debug exceptions, the X86_EFLAGS_IF have been
cleared automatically.


******************
Reason 2: the priority among debug exceptions and interrupts

Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume
3A, page 5-11:

If more than one exception or interrupt is pending at an instruction
boundary, the
processor services them in a predictable order. Table 5-2 shows the
priority among
classes of exception and interrupt sources.
          Table 5-2. Priority Among Simultaneous Exceptions and Interrupts
Priority       Description
1 (Highest)    Hardware Reset and Machine Checks
               - RESET
               - Machine Check
2              Trap on Task Switch
               - T flag in TSS is set
3              External Hardware Interventions
               - FLUSH
               - STOPCLK
               - SMI
               - INIT
4              Traps on the Previous Instruction
               - Breakpoints
               - Debug Trap Exceptions (TF flag set or data/I-O breakpoint)
5             Nonmaskable Interrupts (NMI)
6             Maskable Hardware Interrupts


>From the table we could see debug exceptions lies in priority 4 and
external interrupt lies
in priority 6.

Thereby the processor will handle Debug Trap Exceptions first, then
handle external interrupt.




******************

Combining those reasons: maybe we could remove "regs->flags &= ~X86_EFLAGS_IF;".

(It just a example about X86_EFLAGS_IF and kprobe here.)
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 5b8c750..dfd719a 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -407,7 +407,6 @@ static void __kprobes prepare_singlestep(struct
kprobe *p, struct pt_regs *regs)
{
       clear_btf();
       regs->flags |= X86_EFLAGS_TF;
-       regs->flags &= ~X86_EFLAGS_IF;
       /* single step inline if the instruction is an int3 */
       if (p->opcode == BREAKPOINT_INSTRUCTION)
               regs->ip = (unsigned long)p->addr;



What do you think about it?

I know I must be make a mistake here, could you correct me?


Thanks,
Dongdong.
