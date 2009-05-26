Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZEZOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZEZOP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEZOPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:15:21 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64476 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZEZOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SeAr/dyG2KO1irz97GyOfKw5u9AvnvBNdpSjJDzrewSEY2Ol4DCxiCRH8V7n+l1st9
         RQSPK0ylkX3DNfTEe2LrkVroAvSPWFu5Qow/wLIONnaz5J2TJVjzV+NcniRnqGM/UXHs
         kk1a5AfiWiDVWHFEee+lha33FokHZ3o1yt5OE=
Date: Tue, 26 May 2009 18:15:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <alexander@mail.messagingengine.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       The stable team <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i386: fix return to 16-bit stack from NMI handler
Message-ID: <20090526141517.GA5068@lenovo>
References: <alpine.DEB.2.00.0905242021460.3810@diotoir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905242021460.3810@diotoir>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Sun, May 24, 2009 at 08:24:09PM +0200]
> The nmi handler changes esp on return from the kernel to a process
> with a 16-bit stack. To reproduce, compile and run the following
> program with the nmi watchdog enabled (nmi_watchdog=2 on the command
> line). Using gdb you can see that the high bits of esp contain garbage,
> while the low bits are still correct. This is what the 'espfix' code is
> supposed to fix, but the nmi handler does not include it.
>
> The nmi code cannot call the irqtrace infrastructure. Otherwise, the tail
> of the normal iret-code is correct for the nmi code path too. To be
> able to share this code-path, I moved the TRACE_IRQS_IRET a bit earlier.
> This code-path now includes the espfix code, which explicitly disables
> interrupts. This short interrupts-off section is now not traced anymore.
> The preempt-return-to-kernel path now includes the preliminary test to
> decide if the espfix code should be called. This is never the case, but
> doing it this way keeps the patch simple and the few extra instructions
> should not affect timing in any significant way.
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/mman.h>
> #include <unistd.h>
> #include <sys/syscall.h>
> #include <asm/ldt.h>
>
> int modify_ldt(int func, void *ptr, unsigned long bytecount)
> {
> 	return syscall(SYS_modify_ldt, func, ptr, bytecount);
> }
>
> /* this is assumed to be usable */
> #define SEGBASEADDR 0x10000
> #define SEGLIMIT 0xffff
>
> /* 16-bit segment */
> struct user_desc desc = {
> 	.entry_number = 0,
> 	.base_addr = SEGBASEADDR,
> 	.limit = SEGLIMIT,
> 	.seg_32bit = 0,
> 	.contents = 0, /* ??? */
> 	.read_exec_only = 0,
> 	.limit_in_pages = 0,
> 	.seg_not_present = 0,
> 	.useable = 1
> };
>
> int main(void)
> {
> 	setvbuf(stdout, NULL, _IONBF, 0);
>
> 	/* map a 64 kb segment */
> 	char *pointer = mmap((void *)SEGBASEADDR, SEGLIMIT+1,
>                         PROT_EXEC|PROT_READ|PROT_WRITE,
>                         MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> 	if (pointer == NULL) {
> 		printf("could not map space\n");
> 		return 0;
> 	}
>
> 	/* write ldt, new mode */
> 	int err = modify_ldt(0x11, &desc, sizeof(desc));
> 	if (err) {
> 		printf("error modifying ldt: %i\n", err);
> 		return 0;
> 	}
>
> 	for (int i=0; i<1000; i++) {
> 	asm volatile (
> 		"pusha\n\t"
> 		"mov %ss, %eax\n\t" /* preserve ss:esp */
> 		"mov %esp, %ebp\n\t"
> 		"push $7\n\t" /* index 0, ldt, user mode */
> 		"push $61440\n\t" /* esp */
> 		"lss (%esp), %esp\n\t" /* switch to new stack */
> 		"push %eax\n\t" /* save old ss:esp on new stack */
> 		"push %ebp\n\t"
>
> 		"mov %esp, %edx\n\t"
>
> 		/* wait a bit */
> 		"mov $10000000, %ecx\n\t"
> 		"1: loop 1b\n\t"
>
> 		"cmp %esp, %edx\n\t"
> 		"je 1f\n\t"
> 		"ud2\n\t" /* esp changed inexplicably! */
> 		"1:\n\t"
> 		"lss (%esp), %esp\n\t" /* restore old ss:esp */
> 		"popa\n\t");
>
> 		printf("\rx%ix", i);
> 	}
>
> 	return 0;
> }
>
> The bug is present in 2.6.28, and probably even much earlier.
>
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: The stable team <stable@kernel.org>
>
> ---
>
> Hi Ingo, Peter, Cyrill, ...
>
> Mucking with entry_32.S and trying to exercise all code paths, I found
> the problem described above. Please check this patch carefully for side
> effects I may have overlooked!
>
> Greetings,
> 	Alexander
>

Really good catch, Alexander!

At least at moment I can't imagine more simple/cleaner solution.
I've added Andi and Thomas to CC list as well. Just to be sure...

	-- Cyrill
