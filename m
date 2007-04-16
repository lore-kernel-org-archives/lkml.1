Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbXDPKsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbXDPKsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXDPKsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:48:06 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:58872 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbXDPKsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:48:05 -0400
Message-ID: <46235447.3080000@free.fr>
Date: Mon, 16 Apr 2007 12:47:35 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux.kernel@free.fr
Subject: Disabling x86 System Management Mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

According to Wikipedia:
http://en.wikipedia.org/wiki/Non-Maskable_Interrupt
http://en.wikipedia.org/wiki/System_Management_Mode

"SMM is an operating mode of the Intel 386SL and later microprocessor in 
which all normal execution (including the operating system) is 
suspended, and special separate software (usually firmware or a 
hardware-assisted debugger) is executed in high-privilege mode.

Operations in SMM take CPU time away from the OS, since the CPU state 
must be stored to memory (SMRAM) and any write back caches must be 
flushed. This can destroy real-time behavior and cause clock ticks to 
get lost."

AFAIU, even a hard real-time OS is "defenseless" against SMIs that
kick the CPU into SMM.

I'm planning on writing a few line of code to gather indirect evidence
that the CPU is periodically entering SMM.

I was considering a kernel module along the lines of...

for (i=0; i < N; ++i)
{
   schedule_timeout(1); /* sleep at least one jiffy */
   disable interrupts
   unsigned cycles = foo();
   /* update stats with cycles */
   enable interrupts
}

foo is a loop full of NOPs.
It takes up only a few lines in L1 cache.
The conditional jump is easy to predict.
There is a serializing instruction before and after.
As a result, foo's latency should be very consistent.
foo returns the number of cycles it ran. On the systems I have to work 
with, foo typically runs in ~800 microseconds.
I suppose disabling interrupts that long is bound to break something 
somewhere?

.globl foo
foo:
   push %ebx
   push %esi
   cpuid
   rdtsc
   mov MM, %ecx
   mov %eax, %esi
.align 16
.L1:
   nop
   nop
   ... (lots of nops)
   dec %ecx
   jnz .L1
.L2:
   cpuid
   rdtsc
   sub %esi, %eax
   pop %esi
   pop %ebx
   ret

If foo returns something out of the ordinary, even though interrupts 
were disabled, then it must have been interrupted by a non-maskable 
interrupt, probably a system management interrupt.

What do you think about this approach?
I'm open to comments and suggestions.

Regards.
