Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZHQIvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZHQIvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZHQIvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:51:22 -0400
Received: from www.lumino.de ([85.159.12.10]:60586 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757415AbZHQIvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:51:22 -0400
Message-ID: <4A8919CB.4000709@lumino.de>
Date: Mon, 17 Aug 2009 10:50:19 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de>
In-Reply-To: <200908131839.41803.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 13 August 2009, Michael Schnell wrote:
>> I am planning to implement a Futex on the upcoming MMU-enabled NIOS
>> architecture.
> 
> Ah, I'm always interested in new architectures. Are you already using
> all the asm-generic header files that we have in 2.6.31? Please tell
> me if you find problems with those.

Thomas told me, that we'll have 2.6.31 very soon for mmu-NIOS
development, so we can use this as a basis for any appropriate work.

The recent discussion in lklm showed that a working Kernel code for
having non-SMP NIOS support the "futex" syscall is quite trivial and can
be borrowed from the "sh" implementation (simulating atomic code by
temporarily disabling the global interrupt). So we can concentrate on
the user land part.

While it seems, the hardware-Futex idea does not really hold, (e.g. as
signal handlers will dead-lock), I have a different solution in mind.

The Blackfin and other archs (supposedly sh) that - like NIOS - don't
feature atomic instructions, use a "common atomic area".

This area is prepared by the Kernel and holds functions for all
necessary would-be atomic functions in user-space and in Kernel space
(exchange, compare_and_exchange, add, sub, or, and, xor). The "atomic
area" is commonly accessible by all user land processes on the same
(virtual) address.

When the Kernel returns from interrupt, it checks if the PC had been in
the "atomic area" (which of course is quite unlikely) and if it is, it
checks if it is right within one of the functions (i.e. the result had
not been stored) and if yes, it resets the to-be restored PC to the
beginning of the appropriate function.

With an MMU, the area would be write-protected and executable and mapped
into the same location for any user land process. AFAIK, there are
standard means in the Kernel to allow for such a common code area (e.g.
used for fast system calls with some PC systems).

While this of course works (perfectly tested with Blackfin - though no
MMU there), I suppose we can achieve some improvements with FPGA
processors that allow for custom instructions to be executed in user-mode:

When using the "atomic area", the atomic functions can't be inlined, so
the cache usage is not perfect. The overhead in the ISR return code
should be as small as possible.

Moreover it should be possible to allow "hardware" (HDL-)  designers to
do additional improvements if they desire to take the pain in their designs.



So my suggestion is this:

With NIOS, doing a really good hardware design for atomic instructions
(i.e. load locked / store conditional) can't be done with user
instructions, as same can't do "normal" memory accesses through MMU and
cache. Such additional instructions would need to be provided by Altera
themselves (doable by an update of the Quartus software).

Thus, right now, the supposedly "best" way for a non-SMP but MMU enabled
NIOS-like FPGA-processor to provide some hardware support for atomicness
would be a custom instruction (say "lock 1") that disables the global
interrupt for the next three instructions by means of an additional
"custom ie" hardware flag.

Now atomic code could be like this:

 lock1
 ldw  r8, (r9)
 add  r7, r7, r8
 stw  r7, (r9)

or for compare_and_exchange
 lock1
 ldw  r8, (r9)
 bne  r7, r8, not_equal
 stw  r7, (r9)
not_equal:

Unfortunately, with NIOS, a custom  instruction can't access the global
interrupt bit of the processor, thus the designer would need to create a
gate for all possible hardware interrupt lines that are routed to the
processor (timing issues to be considered later...). This is not
possible with the standard design means (provided by< the
"SOPC-Builder") and would need a lot of additional HDL effort.

So would could add another variant of the custom instruction called
"lock 0". Same would reset the "custom ie" flag after reading it's state
into a register. With that the interrupt return code could very easily
detect the atomicness state without using an "atomic area".

Now atomic code could be like this:

 lock1
 ldw   r8, (r9)
 add   r7, r7, r8
 stw   r7, (r9)
 lock0 r0

or for compare_and_exchange
 lock1
 ldw  r8, (r9)
 bne  not_equal
 stw  r7, (r9)
not_equal:
 lock0 r0

The hardware designer could now either implement a hardware interrupt
disable (e.g. for three instructions) or just manage the flag by the
lock instruction variants without additional hardware implications.

The ISR return code now would do something like:

 lock0 r8

and when the flag  really had been set (which of course is very
unlikely) it would search backward from the return PC location (can be
in user space in user-space or in Kernel space) up to four instruction
words (32 bits each with the NIOS) to find the unique "lock1" code.

If it finds, that the store (on word address lock1 code + 3) has not yet
been executed, it sets the return to the address of the lock1 code to
have the complete sequence restarted. The very likely overhead to the
ISR is just two instructions: lock0 and conditional branch.

(If the hardware features the real interrupt disable using the "custom
ie" flag, of course the flag is _never_ set when the interrupt return
code is executed. Thus an improved hardware would not necessarily need a
modification in the Kernel configuration.)

I feel that this paradigm could provide excellent performance for user
and Kernel code, as well for Futex as for memory management library
code, minimal cache usage, very small ISR overhead, and minimal Kernel
footprint, and best extensibility for hardware designers.

Now my question is how - with an mmu-enabled NIOS - in the ISR return
code the user (or Kernel) space code near the return PC location can be
examination and whether the overhead to do that might be huge.

Thanks for any comments.

-Michael
