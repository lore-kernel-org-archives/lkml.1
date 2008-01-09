Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYAILqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYAILqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYAILqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:46:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36572
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbYAILqh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:46:37 -0500
Date: Wed, 09 Jan 2008 03:46:36 -0800 (PST)
Message-Id: <20080109.034636.115329743.davem@davemloft.net>
To: taldmd@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Compile-time error with gcc-4.3 on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <e02b4fed0801090131h40b0e236t49cc0ae4ac147d5c@mail.gmail.com>
References: <e02b4fed0801090131h40b0e236t49cc0ae4ac147d5c@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David Martin" <taldmd@gmail.com>
Date: Wed, 9 Jan 2008 10:31:45 +0100

Please report sparc problems to the Sparc mailing list,
sparclinux@vger.kernel.org, thanks.

> I get the following error compiling latest kernel from git on sparc64
> using gcc-4.3:
> 
>   CC      arch/sparc64/kernel/signal.o
> cc1: warnings being treated as errors
> arch/sparc64/kernel/signal.c: En la función 'do_notify_resume':
> include/asm/uaccess.h:233: error: el subíndice de la matriz está por
> arriba de los límites de la matriz
> make[1]: *** [arch/sparc64/kernel/signal.o] Error 1
> make: *** [arch/sparc64/kernel] Error 2
> 
> ("On function 'do_notify resume: error: matrix subindex is over matrix limits")

I think you mean "array" instead of "matrix" in your translation.

In fact, you should rerun should build failures with "LANG=C"
for the benefit of people reading your report.

Something is very wrong with the compiler, do_notify_resume() reads:

void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0, int restart_syscall,
		      unsigned long thread_info_flags)
{
	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
		do_signal(regs, orig_i0, restart_syscall);
}

uaccess.h, line 233 is:

static inline unsigned long __must_check
copy_to_user(void __user *to, const void *from, unsigned long size)
{
	unsigned long ret = ___copy_to_user(to, from, size);
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

copy_to_user() isn't being called in do_notify_resume() at all.

Perhaps it's probably warning about some call to copy_to_user() that
results from the inline expansion of do_signal() and all sub-calls.

But it's a bug that GCC isn't indicating exactly where the problem is,
and in what specific function.  My guess is that it's losing context
during all of the inline expansions.
