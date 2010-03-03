Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0CCLzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:55:32 -0500
Received: from mail2.picochip.com ([82.111.145.34]:58040 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734Ab0CCLzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:55:24 -0500
Date: Wed, 3 Mar 2010 11:56:31 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Iles <jamie.iles@picochip.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ARM: perf: modify kuser rmb() call to compile for
	Thumb-2
Message-ID: <20100303115631.GC3928@wear.picochip.com>
References: <1267616878-2154-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267616878-2154-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Wed, 03 Mar 2010 11:55:04 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:47:58AM +0000, Will Deacon wrote:
> The Thumb-2 instruction set does not provide an encoding
> for sub pc, r0, #95 as present in the rmb() definition used
> by perf. This results in compilation failure when using a
> compiler targetting an instruction set other than ARM.
> 
> This patch redefines rmb() for ARM by casting the address
> of the kuser helper to a function pointer, therefore getting
> the compiler to take care of making the call.
> 
> Patch taken against tip/master.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Cc: Jamie Iles <jamie.iles@picochip.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  tools/perf/perf.h |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 75f941b..6fb379b 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -65,9 +65,7 @@
>   * Use the __kuser_memory_barrier helper in the CPU helper page. See
>   * arch/arm/kernel/entry-armv.S in the kernel source for details.
>   */
> -#define rmb()		asm volatile("mov r0, #0xffff0fff; mov lr, pc;" \
> -				     "sub pc, r0, #95" ::: "r0", "lr", "cc", \
> -				     "memory")
> +#define rmb()		((void(*)(void))0xffff0fa0)()
This will take care of doing the CPU barrier but don't we still need a
compiler memory barrier? I guess you could do:

#define rmb() ({ \
		((void(*)(void))0xffff0fa0)(); \
		asm volatile("" ::: "memory"); \
	})

Jamie
