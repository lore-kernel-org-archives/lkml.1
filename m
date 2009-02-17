Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZBQTEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZBQTEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZBQTD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:03:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50852 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZBQTD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:03:56 -0500
Date: Tue, 17 Feb 2009 19:02:53 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Rosendahl Viktor (Nokia-D/Helsinki)" <Viktor.Rosendahl@nokia.com>,
       ext Tony Lindgren <tony@atomide.com>,
       "Moiseichuk Leonid (Nokia-D/Helsinki)" <leonid.moiseichuk@nokia.com>,
       "Kallioinen Juha (Nokia-D/Helsinki)" <juha.kallioinen@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       Eero Tamminen <eero.tamminen@nokia.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ARM fix syscall trace return value
Message-ID: <20090217190253.GA10322@flint.arm.linux.org.uk>
References: <20090217181805.GA15788@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217181805.GA15788@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:18:05PM -0500, Mathieu Desnoyers wrote:
> I am currently finding core bugs in the Linux kernel implementation of
> the ARM architecture. :-( e.g. return value not being sent to the
> syscall_trace function upon exit (upon which LTTng depends). (patch
> below)

Well then how can strace work?  The fact of the matter is that strace
can and does work, and so I suspect that the problem is not in the
kernel but whatever "LTTng" is trying to do.

> BTW, the patch below applies to 2.6.29-rc4.

And is wrong.

> Index: linux-omap-2.6/arch/arm/kernel/entry-common.S
> ===================================================================
> --- linux-omap-2.6.orig/arch/arm/kernel/entry-common.S	2009-02-17 16:58:14.000000000 +0000
> +++ linux-omap-2.6/arch/arm/kernel/entry-common.S	2009-02-17 17:24:33.000000000 +0000
> @@ -89,6 +89,7 @@
>  	mov	why, #1
>  	tst	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
>  	beq	ret_slow_syscall
> +	mov	r2, #0				@ fork returns 0 to the child

This may be incorrect.

>  	mov	r1, sp
>  	mov	r0, #1				@ trace exit [IP = 1]
>  	bl	syscall_trace
> @@ -292,7 +293,7 @@
>  
>  __sys_trace_return:
>  	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
> -	mov	r2, scno
> +	mov	r2, r0

This part is wrong.  'r2' *is* the syscall number.

The place to get the return value is by reading the registers, r0 to be
exact.  No other method is supported.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
