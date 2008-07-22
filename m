Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYGVDTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYGVDTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYGVDTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:19:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYGVDTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:19:37 -0400
Subject: Re: [git pull] x86: declaration fixes
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080721180439.GA13720@elte.hu>
References: <1216662432.28271.30.camel@jaswinder.satnam>
	 <20080721180439.GA13720@elte.hu>
Content-Type: text/plain; charset=utf8
Date: Tue, 22 Jul 2008 08:48:35 +0530
Message-Id: <1216696715.2823.9.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Mon, 2008-07-21 at 20:04 +0200, Ingo Molnar wrote:
> * Jaswinder Singh <jaswinder@infradead.org> wrote:
> 
> > Hello Ingo,
> > 
> > 2. [PATCH] x86: process_32.c declare cpu_number before they get used
> 
> why is cpu_number moved over from smp.h to current.h? I think it's more 
> logical in smp.h. If it's missing somewhere then add an #include 
> <asm/smp.h> to that file?
> 

Because cpu_number is used by everyone independent of smp.

In smp.h It was declared under #ifdef CONFIG_X86_32_SMP which was wrong.

> also, this change:
> 
> +++ b/include/linux/timer.h
> @@ -6,6 +6,10 @@
>  #include <linux/stddef.h>
>  #include <linux/debugobjects.h>
> 
> +#ifdef CONFIG_X86
> +#include <asm/timer.h>
> +#endif /* CONFIG_X86 */
> 
> is not really acceptable in a generic header, nor is:
> 
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -65,6 +67,10 @@ struct getcpu_cache;
>  #include <linux/quota.h>
>  #include <linux/key.h>
> 
> +#ifdef CONFIG_X86
> +#include <asm/syscalls.h>
> +#endif /* CONFIG_X86 */
> 
> i'd suggest we just do asm-x86/syscall.h and asm-x86/timer.h changes and 
> add #include <asm/syscall.h> and #include <asm/timer.h> to the affected 
> x86 .c files. Once every architecture has it, linux/syscall.h can be 
> extended with an unconditional asm/syscall.h include.
> 

Because ﻿checkpatch.pl raise objection for it.

$ ./scripts/checkpatch.pl ../test.patch 
WARNING: Use #include <linux/timer.h> instead of <asm/timer.h>
#9: FILE: arch/x86/kernel/time_32.c:40:
+#include <asm/timer.h>


>  +#ifdef CONFIG_X86_32
>   extern int timer_ack;
>  -extern int no_timer_check;
>   extern int recalibrate_cpu_khz(void);
>  +#endif /* CONFIG_X86_32 */
>  +
>  +extern int no_timer_check;
> 
> hm, why was this needed?
> 

Because timer_ack is only required for X86_32
and ﻿int recalibrate_cpu_khz(void) is declared inside ﻿#ifdef
CONFIG_X86_32 in arch/x86/kernel/tsc.c

Thank you,

Jaswinder Singh.

