Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZHNJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZHNJs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZHNJs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:48:28 -0400
Received: from www.lumino.de ([85.159.12.10]:49075 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753158AbZHNJs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:48:27 -0400
Message-ID: <4A8532EA.20506@lumino.de>
Date: Fri, 14 Aug 2009 11:48:26 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de>
In-Reply-To: <200908131839.41803.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
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

Hi Arnd,
Thanks a lot for answering.

I've not really started coding, as I need to use the port of gcc 4,
Kernel, and libraries done by Montavista on behalf of Altera and going
to be managed by "uClinux-NIOS", currently in Taipei, Taiwan. The
releasing of the source code to "public domain" is expected within the
next few days and as of that I can start the project.

Currently I do my researches based on Kernel 2.6.30. I do suppose the
distribution will be upgraded to 2.6.31 soon.



> 
> Common trap. Just don't look at any x86 code when implementing
> a new architecture. The code isn't necessarily bad, but much of
> it has either too much compatibility crap for old interfaces, or
> it optimizes some functionality much more than you'd care for.
> 
> In case of futex, look at how arch/sh does it. As Mike Frysinger
> mentioned in http://lkml.org/lkml/2009/7/3/70 , the asm-generic
> version is currently lacking functionality and we should use
> the sh version for new stuff. 

OK, I'll take a look there.

> 
> Feel free to submit a patch that implements the operations correctly
> for non-SMP architectures in include/asm-generic/futex.h.

With NIOS this is not that obvious. At the moment we are discussing two
completely different ways to solve the problem of nonexistent atomic
operations.

A) do it like many other non-SMP archs do: in Kernel mode disable the
interrupt temporarily and in user mode (The hardware prevents disabling
interrupt here) use a common code page that holds the would-be atomic
code sequences and in Interrupt-exit code check the PC if we are in that
area and if necessary restart the atomic function.

B) take advantage of the possibility to implement custom instructions
with the FPGA based processor. Unfortunately it's not possible to
directly implement atomic operations nor is it possible to temporarily
disable interrupt with a custom instruction. So out first idea is to do
a hardware FUTEX with a custom instruction that can be used in
user-space to protect the three-instruction sequences that would
implement the atomic code sequences.

(A) would be more "standard" and is a well-verified paradigm, (B) would
offer less overhead (i.e. no overhead to UNRELATED interrupts at all)
and later could be portable to an SMP Kernel.

As even with B I suppose we would need to use the disable interrupt
trick in Kernel modem, I need to understand which code sequences really
are used and in which mode they run (the CPUs "System mode" or "user
mode", interrupt disabled or enabled.)


>> In a non-SMP environment do we need to use really atomic code here, or
>> does futex_atomic_op_inuser() run with interrupt disabled, anyway?
> 
> The sh version just disables interrupts to get atomicity.

Do you think I am correct assuming that sh CPU like NIOS also has a
"System Mode" (interrupt disabling is allowed) and a "User Mode" (trying
to disable the interrupt generates an "Illegal Instruction" trap). If so
 in that code sequence are in "System Mode".

> 
> You misread futex_wake_op(). The operation comes from the second parameter
> of the syscall, not the last one.
> 


Ooops, thanks a lot for looking this up for me !

I'll take another look !

Thanks again,
-Michael

