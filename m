Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZBKHoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZBKHoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZBKHoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:44:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:46371 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZBKHoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:44:08 -0500
Message-ID: <499281B5.2070502@kernel.org>
Date: Wed, 11 Feb 2009 16:43:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: Use pt_regs pointer in do_device_not_available()
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-2-git-send-email-brgerst@gmail.com>
In-Reply-To: <1234277507-4987-2-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 07:44:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
> The generic exception handler (error_code) passes in the pt_regs
> pointer and the error code (unused in this case).  The commit
> "x86: fix math_emu register frame access" changed this to pass by
> value, which doesn't work correctly with stack protector enabled.
> Change it back to use the pt_regs pointer.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/include/asm/traps.h |    2 +-
>  arch/x86/kernel/traps.c      |    9 +++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index cf3bb05..0d53425 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -41,7 +41,7 @@ dotraplinkage void do_int3(struct pt_regs *, long);
>  dotraplinkage void do_overflow(struct pt_regs *, long);
>  dotraplinkage void do_bounds(struct pt_regs *, long);
>  dotraplinkage void do_invalid_op(struct pt_regs *, long);
> -dotraplinkage void do_device_not_available(struct pt_regs);
> +dotraplinkage void do_device_not_available(struct pt_regs *, long);
>  dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
>  dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
>  dotraplinkage void do_segment_not_present(struct pt_regs *, long);
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 3b7b2e1..71a8f87 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -905,19 +905,20 @@ void math_emulate(struct math_emu_info *info)
>  }
>  #endif /* CONFIG_MATH_EMULATION */
>  
> -dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
> +dotraplinkage void __kprobes
> +do_device_not_available(struct pt_regs *regs, long error_code)

What do you think about just taking pt_regs and accessing
regs->orig_eax instead of having separate call convention for pt_regs
ones and trap ones?  Too much work without enough benefit?

Thanks.

-- 
tejun
