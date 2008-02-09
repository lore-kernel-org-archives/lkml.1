Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYBIOeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYBIOeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYBIOeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:34:04 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:58476 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYBIOeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:34:02 -0500
Message-ID: <47ADB9D3.6070604@web.de>
Date: Sat, 09 Feb 2008 15:33:55 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@web.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] kgdb, x86: Add arch specfic kgdb support
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com> <1202564114-18587-2-git-send-email-jason.wessel@windriver.com> <1202564114-18587-3-git-send-email-jason.wessel@windriver.com> <1202564114-18587-4-git-send-email-jason.wessel@windriver.com> <1202564114-18587-5-git-send-email-jason.wessel@windriver.com> <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18uhAlK9gKCLO4Av7NFemv6ihu1bLnlYzNc0SS2
	4Ll2n1TpEBQxEuhMJFGVUXAwFohVpfYFX7ZlFhEiSj48ys1t9G
	DjBc/7718=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jason.wessel@windriver.com wrote:
> --- /dev/null
> +++ b/include/asm-x86/kgdb.h
> @@ -0,0 +1,79 @@
> +#ifdef __KERNEL__
> +#ifndef _ASM_KGDB_H_
> +#define _ASM_KGDB_H_
> +
> +/*
> + * Copyright (C) 2001-2004 Amit S. Kale
> + * Copyright (C) 2008 Wind River Systems, Inc.
> + */
> +
> +#include <asm-generic/kgdb.h>
> +
> +/*
> + * BUFMAX defines the maximum number of characters in inbound/outbound
> + * buffers at least NUMREGBYTES*2 are needed for register packets
> + * Longer buffer is needed to list all threads
> + */
> +#define BUFMAX			1024
> +
> +/*
> + *  Note that this register image is in a different order than
> + *  the register image that Linux produces at interrupt time.
> + *
> + *  Linux's register image is defined by struct pt_regs in ptrace.h.
> + *  Just why GDB uses a different order is a historical mystery.
> + */
> +#ifdef CONFIG_X86_32
> +enum regnames { _AX,	/* 0 */
> +	_CX,	/* 1 */
> +	_DX,	/* 2 */
> +	_BX,	/* 3 */
> +	_SP,	/* 4 */
> +	_BP,	/* 5 */
> +	_SI,	/* 6 */
> +	_DI,	/* 7 */
> +	_PC,	/* 8 also known as eip */
> +	_PS,	/* 9 also known as eflags */
> +	_CS,	/* 10 */
> +	_SS,	/* 11 */
> +	_DS,	/* 12 */
> +	_ES,	/* 13 */
> +	_FS,	/* 14 */
> +	_GS		/* 15 */
> +};
> +#else /* ! CONFIG_X86_32 */
> +enum regnames { _AX,	/* 0 */
> +	_DX,	/* 1 */
> +	_CX,	/* 2 */
> +	_BX,	/* 3 */
> +	_SI,	/* 4 */
> +	_DI,	/* 5 */
> +	_BP,	/* 6 */
> +	_SP,	/* 7 */
> +	_R8,	/* 8 */
> +	_R9,	/* 9 */
> +	_R10,	/* 10 */
> +	_R11,	/* 11 */
> +	_R12,	/* 12 */
> +	_R13,	/* 13 */
> +	_R14,	/* 14 */
> +	_R15,	/* 15 */
> +	_PC,	/* 16 */
> +	_PS		/* 17 */
> +};
> +#endif /* CONFIG_X86_32 */
> +
> +/* Number of bytes for gdb registers */
> +#ifdef CONFIG_X86_32
> +#define NUMREGBYTES		64
> +#else /* ! CONFIG_X86_32 */
> +#define NUMREGBYTES		((_PS+1)*8)
> +#endif /* CONFIG_X86_32 */
> +
> +#ifndef __ASSEMBLY__
> +#define BREAKPOINT()		asm("   int $3");
> +#define BREAK_INSTR_SIZE	1
> +#define CACHE_FLUSH_IS_SAFE	1
> +#endif				/* !__ASSEMBLY__ */
> +#endif				/* _ASM_KGDB_H_ */
> +#endif				/* __KERNEL__ */

Please fold into the next version:

diff --git a/include/asm-x86/kgdb.h b/include/asm-x86/kgdb.h
index c2803a8..0ba150b 100644
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -1,4 +1,3 @@
-#ifdef __KERNEL__
 #ifndef _ASM_KGDB_H_
 #define _ASM_KGDB_H_
 
@@ -70,10 +69,7 @@ enum regnames { _AX,	/* 0 */
 #define NUMREGBYTES		((_PS+1)*8)
 #endif /* CONFIG_X86_32 */
 
-#ifndef __ASSEMBLY__
 #define BREAKPOINT()		asm("   int $3");
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
-#endif				/* !__ASSEMBLY__ */
-#endif				/* _ASM_KGDB_H_ */
-#endif				/* __KERNEL__ */
+#endif /* _ASM_KGDB_H_ */

