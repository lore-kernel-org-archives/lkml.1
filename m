Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0CKD1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:27:54 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38817 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0CKD1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:27:52 -0500
Message-ID: <4B98632E.70806@necel.com>
Date: Thu, 11 Mar 2010 12:27:42 +0900
From: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Wu Zhangjin <wuzhangjin@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such
 as BTB and RAS
References: <cover.1268153722.git.wuzhangjin@gmail.com> <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
In-Reply-To: <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> As the Chapter 15: "Errata: Issue of Out-of-order in loongson"[1] shows, to
> workaround the Issue of Loongson-2F，We need to do:
> 
> "When switching from user model to kernel model, you should flush the branch
> target history such as BTB and RAS."

Just wondered, model or mode?

> This patch did clear BTB(branch target buffer), forbid RAS(row address strobe)
> via Loongson-2F's 64bit diagnostic register.

Are you sure that RAS represents "Row Address Strobe", not "Return
Address Stack?"

By the way, we have a similar local workaround for vr55xx processors
when switching from kernel mode to user mode.  It's not necessarily
related to out-of-order issues, but we need to prevent the processor
from doing instruction prefetch beyond "eret" instruction.

In the long term, it would be appreciated that the kernel has a set
of hooks when switching KUX-modes, so that each machine could have
his own, processor-specific treatmens.

  Shinya

> [1] Chinese Version: http://www.loongson.cn/uploadfile/file/200808211
> [2] English Version of Chapter 15:
> http://groups.google.com.hk/group/loongson-dev/msg/e0d2e220958f10a6?dmode=source
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  arch/mips/include/asm/stackframe.h |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm/stackframe.h
> index 3b6da33..b84cfda 100644
> --- a/arch/mips/include/asm/stackframe.h
> +++ b/arch/mips/include/asm/stackframe.h
> @@ -121,6 +121,25 @@
>  		.endm
>  #else
>  		.macro	get_saved_sp	/* Uniprocessor variation */
> +#ifdef CONFIG_CPU_LOONGSON2F
> +		/*
> +		 * Clear BTB(branch target buffer), forbid RAS(row address
> +		 * strobe) to workaround the Out-of-oder Issue in Loongson2F
> +		 * via it's diagnostic register.
> +		 */
> +		move k0, ra
> +		jal	1f
> +		nop
> +1:		jal	1f
> +		nop
> +1:		jal	1f
> +		nop
> +1:		jal	1f
> +		nop
> +1:		move	ra, k0
> +		li	k0, 3
> +		mtc0	k0, $22
> +#endif /* CONFIG_CPU_LOONGSON2F */
>  #if defined(CONFIG_32BIT) || defined(KBUILD_64BIT_SYM32)
>  		lui	k1, %hi(kernelsp)
>  #else
