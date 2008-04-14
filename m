Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbYDNUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbYDNUs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYDNUsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:48:20 -0400
Received: from echo.digadd.de ([195.47.195.234]:52137 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751926AbYDNUsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:48:19 -0400
X-Greylist: delayed 1818 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 16:48:19 EDT
Message-ID: <4803BCD3.9020205@digadd.de>
Date: Mon, 14 Apr 2008 22:21:39 +0200
From: Christian Schmidt <lkml@digadd.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080323)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ptrace (PTRACE_GETREGS, ...) discrepancy for x86 emulation on x86_64?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm currently toying around a bit with the ptrace api on linux. First, a 
few specs:

Kernel 2.6.24.4, glibc 2.7, x86_64 arch.

I am using the 32bit emulation on this to debug a program "the old way", 
putting "int3" opcodes into the code via PTRACE_POKE and waiting for the 
trap. In theory, I should than use PTRACE_GETREGS, decrement the EIP 
register, restore the original opcode, write the registers back with 
PTRACE_SETREGS, and the program should continue.
What I see instead is that regs.eip if 0xffffffff, and the next register 
contains the expected code offset.

I wonder if the reason is:

/usr/src/linux-2.6.24.4/include/asm-x86/ptrace.h:

struct pt_regs {
         long ebx;
         long ecx;
         long edx;
         long esi;
         long edi;
         long ebp;
         long eax;
         int  xds;
         int  xes;
         int  xfs;
         /* int  xgs; */
         long orig_eax;
         long eip;
         int  xcs;
         long eflags;
         long esp;
         int  xss;
};

/usr/src/linux-2.6.24.4/arch/x86/ia32/ptrace32.c:

static int putreg32(struct task_struct *child, unsigned regno, u32 val)
{
         int i;
         __u64 *stack = (__u64 *)task_pt_regs(child);

         switch (regno) {
         case offsetof(struct user32, regs.fs):
                 if (val && (val & 3) != 3) return -EIO;
                 child->thread.fsindex = val & 0xffff;
                 break;
         case offsetof(struct user32, regs.gs):
                 if (val && (val & 3) != 3) return -EIO;
                 child->thread.gsindex = val & 0xffff;
                 break;

So GS is still set (somewhere), though not defined for userspace. Am I 
correct, and should I fix my includes? After uncommenting the "int xgs;" 
above the program works.

Regards,
Chris

PS: I'm not subscribed, direct CC: to me is appreciated
