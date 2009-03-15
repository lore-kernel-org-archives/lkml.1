Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZCOQlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZCOQlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZCOQlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:41:47 -0400
Received: from gw.goop.org ([64.81.55.164]:53973 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZCOQlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:41:46 -0400
Message-ID: <49BD2FC7.5050903@goop.org>
Date: Sun, 15 Mar 2009 09:41:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sergio Luis <eeeesti@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: asm doubt
References: <ce0170d90903150716t14033a9dr3b3bf028933dde7c@mail.gmail.com>
In-Reply-To: <ce0170d90903150716t14033a9dr3b3bf028933dde7c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergio Luis wrote:
> Hi there,
>
> taking a look at arch/x86/power/cpu_(32|64).c, I saw the 32.c one
> using the following macros
>
> #define savesegment(seg, value)                         \
>         asm("mov %%" #seg ",%0":"=r" (value) : : "memory")
>
>
> #define loadsegment(seg, value)                 \
>         asm volatile("\n"                       \
>                      "1:\t"                     \
>                      "movl %k0,%%" #seg "\n"    \
>                      "2:\n"                     \
>                      ".section .fixup,\"ax\"\n" \
>                      "3:\t"                     \
>                      "movl %k1, %%" #seg "\n\t" \
>                      "jmp 2b\n"                 \
>                      ".previous\n"              \
>                      _ASM_EXTABLE(1b,3b)        \
>                      : :"r" (value), "r" (0) : "memory")
>
>
> saving and loading segment registers as in
>
> savesegment(es, ctxt->es);
> loadsegment(es, ctxt->es);
>
> the code in cpu_64.c doesn't make use of such macros, doing the following:
>
> saving:
>  asm volatile ("movw %%es, %0" : "=m" (ctxt->es));
>
> loading:
> asm volatile ("movw %0, %%es" :: "r" (ctxt->es));
>
> So, my question is... what's the actual difference between both
> versions? Aren't the macros suitable for the 64 version as well?
>   

In 32-bit mode, moving to a segment register can fault if the underlying 
GDT/LDT entry is invalid.  In 64-bit mode, segment registers are mostly 
decorative and have no function, and moving arbitrary values into them 
doesn't fault, making the exception catching unnecessary.

But it would be good to use the same syntax to load segment registers 
for both architectures to help with unification.

    J
