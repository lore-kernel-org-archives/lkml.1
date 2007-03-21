Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbXCUJbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbXCUJbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXCUJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:31:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42226 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbXCUJbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:31:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] i386 GDT cleanups: Use per-cpu GDT immediately upon boot
References: <1174457426.11680.132.camel@localhost.localdomain>
	<1174458636.11680.143.camel@localhost.localdomain>
	<1174458730.11680.145.camel@localhost.localdomain>
	<1174458938.11680.150.camel@localhost.localdomain>
Date: Wed, 21 Mar 2007 03:31:03 -0600
In-Reply-To: <1174458938.11680.150.camel@localhost.localdomain> (Rusty
	Russell's message of "Wed, 21 Mar 2007 17:35:38 +1100")
Message-ID: <m1aby7c59k.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> Now we are no longer dynamically allocating the GDT, we don't need the
> "cpu_gdt_table" at all: we can switch straight from "boot_gdt_table"
> to the per-cpu GDT.  This means initializing the cpu_gdt array in C.
>
> The boot CPU uses the per-cpu var directly, then in smp_prepare_cpus()
> it switches to the per-cpu copy just allocated.  For secondary CPUs,
> the early_gdt_descr is set to point directly to their per-cpu copy.
>
> For UP the code is very simple: it keeps using the "per-cpu" GDT as
> per SMP, but we never have to move.

> diff -r a8a4e2f9da08 arch/i386/kernel/head.S
> --- a/arch/i386/kernel/head.S	Wed Mar 21 15:20:48 2007 +1100
> +++ b/arch/i386/kernel/head.S	Wed Mar 21 15:32:38 2007 +1100
> @@ -599,67 +599,10 @@ idt_descr:
>  	.word 0				# 32 bit align gdt_desc.address
>  ENTRY(early_gdt_descr)
>  	.word GDT_ENTRIES*8-1
> -	.long cpu_gdt_table
> -
> -/*
> - * The boot_gdt_table must mirror the equivalent in setup.S and is
> - * used only for booting.
> - */

It looks like you are killing a useful comment here for no good reason.

> +	.long per_cpu__cpu_gdt		/* Overwritten for secondary CPUs */
> +
>  	.align L1_CACHE_BYTES
>  ENTRY(boot_gdt_table)
>  	.fill GDT_ENTRY_BOOT_CS,8,0
>  	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
>  	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */


Eric
