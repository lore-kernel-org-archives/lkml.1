Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZFONUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZFONUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZFONUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:20:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47709 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZFONUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:20:21 -0400
Date: Mon, 15 Jun 2009 15:20:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL)
	configurable
Message-ID: <20090615132018.GA14555@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <1245033557-10968-3-git-send-email-swetland@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245033557-10968-3-git-send-email-swetland@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Signed-off-by: Brian Swetland <swetland@google.com>
> ---
>  arch/arm/mach-msm/Kconfig                    |   24 ++++++++++++++++++++++++
>  arch/arm/mach-msm/include/mach/debug-macro.S |   25 ++++++++++++++++++-------
>  arch/arm/mach-msm/include/mach/msm_iomap.h   |   12 ++++++++++++
>  arch/arm/mach-msm/include/mach/uncompress.h  |    7 +++++++
>  arch/arm/mach-msm/io.c                       |    3 +++
>  5 files changed, 64 insertions(+), 7 deletions(-)

I'm not sure if this is appropriate for mainline at this point. It
seems like few people have debug cable at this point...

> +config MSM_DEBUG_UART
> +	int
> +	default 1 if MSM_DEBUG_UART1
> +	default 2 if MSM_DEBUG_UART2
> +	default 3 if MSM_DEBUG_UART3

...and those that do, have it at fixed uart, no? 

> index 1db3c97..ab772cc 100644
> --- a/arch/arm/mach-msm/include/mach/debug-macro.S
> +++ b/arch/arm/mach-msm/include/mach/debug-macro.S
> @@ -14,15 +14,18 @@
>   *
>   */
>  
> +
> +
>  #include <mach/hardware.h>
>  #include <mach/msm_iomap.h>

It has enough lines, already...

> +#ifdef CONFIG_MSM_DEBUG_UART
>  	.macro	addruart,rx
>  	@ see if the MMU is enabled and select appropriate base address
>  	mrc	p15, 0, \rx, c1, c0
>  	tst	\rx, #1
> -	ldreq	\rx, =MSM_UART1_PHYS
> -	movne	\rx, #0
> +	ldreq	\rx, =MSM_DEBUG_UART_PHYS
> +	ldrne	\rx, =MSM_DEBUG_UART_BASE
>  	.endm
>  
>  	.macro	senduart,rd,rx
> @@ -32,13 +35,21 @@
>  
>  	.macro	waituart,rd,rx
>  	@ wait for TX_READY
> -	teq	\rx, #0
> -	bne	2f
> -1:	ldr	\rd, [\rx, #0x08]
> +1001:	ldr	\rd, [\rx, #0x08]
>  	tst	\rd, #0x04
> -	beq	1b
> -2:
> +	beq	1001b
> +1002:
> +	.endm

Is the 1002 label required?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
