Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZIBKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZIBKWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZIBKWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:22:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54858 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZIBKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=N6g7jHCAQ334gm3llyzwgxiKrwBDDzDVXdsp6h+4oDHkHxR4tfBcGvelIgg3Z7Yka9
         G2aQQDHNHZDtAbCzw/uYYWbyHcIMKkhL4kdKNn16/KEeMOttVzOhyqKWAB5q5Kyu0ofY
         NJWEny9MK2UZtuJNA/AsbmnOxdNr0/193Du2o=
MIME-Version: 1.0
From: Frederic Riss <frederic.riss@gmail.com>
Date: Wed, 2 Sep 2009 12:22:14 +0200
Message-ID: <87d3b2040909020322i40c09445t4555ffe5cb5b3e13@mail.gmail.com>
Subject: Is ARM kprobes unregistration SMP safe?
To: nico@cam.org, sagar.abhishek@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry if you get that mail twice. Made a silly email typo in the
first version.]

Hi,

ARM kprobes are using an illegal instruction to trigger the kprobe
code. the trap handler looks like that:

asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
{
       unsigned int instr;

       pc = (void __user *)instruction_pointer(regs);

       instr = *(u32 *) pc;

       /*
        * It is possible to have recursive kprobes, so we can't call
        * the kprobe trap handler with the undef_lock held.
        */
       if (instr == KPROBE_BREAKPOINT_INSTRUCTION && !user_mode(regs)) {
               kprobe_trap_handler(regs, instr);
               return;
       }
       [...]
}

And in arch/arm/kernel/kprobes.c we have:

void __kprobes arch_disarm_kprobe(struct kprobe *p)
{
       *p->addr = p->opcode;
       flush_insns(p->addr, 1);
}

In an SMP system, I don't see what prevents a core to take the
undefined instruction exception while the other core is unregistering the
corresponding kprobe. With the right timing, at the time the exception
handler reads the patched instruction, it can have been 'unpatched' by
arch_disarm_kprobe, and thus fail the KPROBE_BREAKPOINT_INSTRUCTION
test. Shouldn't arch_disarm_kprobe use stop_machine or something like
that?

Fred.
