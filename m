Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0BOQTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:19:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0BOQTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:19:02 -0500
Date: Mon, 15 Feb 2010 17:17:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
Message-ID: <20100215161752.GA19962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 05d43ed8a89c159ff641d472f970e3f1baa66318
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Jan 28 22:14:43 2010 -0800

> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -181,14 +181,8 @@ do {							\
>  void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp);
>  #define compat_start_thread start_thread_ia32
>
> -#define COMPAT_SET_PERSONALITY(ex)			\
> -do {							\
> -	if (test_thread_flag(TIF_IA32))			\
> -		clear_thread_flag(TIF_ABI_PENDING);	\
> -	else						\
> -		set_thread_flag(TIF_ABI_PENDING);	\
> -	current->personality |= force_personality32;	\
> -} while (0)
> +void set_personality_ia32(void);
> +#define COMPAT_SET_PERSONALITY(ex) set_personality_ia32()

OK, but what about force_personality32? With this patch it becomes
unused?

> +void set_personality_ia32(void)
> +{
> +	/* inherit personality from parent */
> +
> +	/* Make sure to be in 32bit mode */
> +	set_thread_flag(TIF_IA32);
> +
> +	/* Prepare the first "return" to user space */
> +	current_thread_info()->status |= TS_COMPAT;

Can't understand why we need TS_COMPAT. I assume this is correct,
this was copied from flush_thread().

What TS_COMPAT actually means? I thought it just means "the task
is inside 32-bit syscall".

If a 64bit task execs a 32bit app, can't this TS_COMPAT break, say,
syscall_get_arguments() ?

Just curious, I don't really understand COMPAT issues anyway.

Oleg.

