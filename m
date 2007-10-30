Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXJ3OlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXJ3OlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXJ3Ok4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:40:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:38076 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXJ3Ok4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YXkAgdWx95PxmKueV+83RhGZhz0hj+B8lQa98H1xnZHg+n1QkgaObPJH0yQsOnfoXXWcO2LyT9+k+mZyppRnxGPGnOJeSGgLK1kX1Cin44gmFO2Is/aTWavve38B6p6m9tryzp2WrTDQ88esO7h03Tj0jYL2zH1Ky505qh0n/p8=
Message-ID: <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com>
Date: Tue, 30 Oct 2007 23:40:55 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 2/2] MN10300: Add the MN10300/AM33 architecture to the kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071029122809.2846.58795.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	 <20071029122809.2846.58795.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, David Howells <dhowells@redhat.com> wrote:
> diff --git a/Documentation/mn10300/compartmentalisation.txt b/Documentation/mn10300/compartmentalisation.txt
(snip)
> + (1) CPU level
> +
> +     This involves support for a specific set of registers and instructions and
> +     some very low-level peripherals.
> +
> +     CPU-specific constants, definitions and sources are segregated by having
> +     the header files divided into CPU specific directories under the asm
> +     headers directory:
> +
> +       (*) include/asm-mn10300/cpu-am33v2/
> +
> +           Support for the AM33v2 CPU core.
> +
> +     The appropriate CPU is selected by a CONFIG_MN10300_CPU_XXXX option from
> +     the "Processor core support" choice menu in the arch/mn10300/Kconfig file.

Does this mean cpu-am33v3, cpu-am33v4, etc. will be created
when a new core comes up?

Isn't it possible to split codes by features, instead of target cores?

If the AM33v2 is the base architecture and a new core feature comes up
on AM33v3,
that core feature should be enabled by a new CONFIG_* or a dynamic switch.
Generally, drastic changes won't come up
as long as the new CPU core is on the same architecture.
Whole directory separation would be inappropriate for the CPU cores on
the same arch.
If similar codes were in multiple files and directories, it would be
hard to maintain them.

> + (2) Processor level
> +
> +     The "processor level" is a CPU core plus the other on-silicon
> +     peripherals.
> +
> +     Processor-specific header files are divided among directories in a similar
> +     way to the CPU level:
> +
> +       (*) include/asm-mn10300/proc-mn103e010/
> +
> +           Support for the AM33v2 CPU core.
> +
> +     The appropriate processor is selected by a CONFIG_MN10300_PROC_YYYY option
> +     from the "Processor support" choice menu in the arch/mn10300/Kconfig file.

Ditto. Splitting by features would be better.

> diff --git a/arch/mn10300/kernel/fpu-low.S b/arch/mn10300/kernel/fpu-low.S
(snip)
> +       .globl  fpu_init_state
> +       .type   fpu_init_state,@function
> +fpu_init_state:
> +       mov     epsw,d0
> +       or      EPSW_FE,epsw
> +
> +#ifdef CONFIG_MN10300_PROC_MN103E010
> +       nop
> +       nop
> +       nop
> +#endif

This should be conditioned by a feature.
Isn't it a feature or a limitation that several non-FPU instructions are
necessary just after the EPSW_FE is set?

> diff --git a/arch/mn10300/kernel/mn103e010-debug.c b/arch/mn10300/kernel/mn103e010-debug.c
(snip)
> diff --git a/arch/mn10300/kernel/mn103e010-serial-low.S b/arch/mn10300/kernel/mn103e010-serial-low.S
(snip)
> diff --git a/arch/mn10300/kernel/mn103e010-serial.c b/arch/mn10300/kernel/mn103e010-serial.c
(snip)
> diff --git a/arch/mn10300/kernel/mn103e010-serial.h b/arch/mn10300/kernel/mn103e010-serial.h
(snip)
> diff --git a/arch/mn10300/kernel/mn103e010-watchdog-low.S b/arch/mn10300/kernel/mn103e010-watchdog-low.S
(snip)
> diff --git a/arch/mn10300/kernel/mn103e010-watchdog.c b/arch/mn10300/kernel/mn103e010-watchdog.c

Are these specific to MN103E010, or applicable to some other LSIs?
If they are not specific to MN103E010, the file names aren't good.

> diff --git a/include/asm-mn10300/cpu-am33v2/dmactl-regs.h b/include/asm-mn10300/cpu-am33v2/dmactl-regs.h
(snip)
> +struct mn103e010_dmactl_regs {
> +       u32             ctr;
> +       const void      *src;
> +       void            *dst;
> +       u32             siz;
> +       u32             cyc;
> +} __attribute__((aligned(0x100)));
> +
> +extern volatile struct mn103e010_dmactl_regs mn103e010_dmactl_regs[4];

Stranger names here.


-- 
Suzuki Takashi
Japan
