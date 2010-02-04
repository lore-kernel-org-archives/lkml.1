Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab0BDXaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:30:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58358 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab0BDX34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:29:56 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/Mp/sHN93pFuqyfLwkN/p
Date: Thu, 4 Feb 2010 15:30:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-ID: <20100204233019.GY22747@atomide.com>
References: <20100205102030.c8b139a1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205102030.c8b139a1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [100204 15:17]:
> Hi all,
> 
> Today's linux-next merge of the omap tree got a conflict in
> arch/arm/mach-omap1/include/mach/debug-macro.S
> arch/arm/mach-omap2/include/mach/debug-macro.S between commit
> 7f62dc4756eaf761570b96250630d48f80397d64 ("ARM: 5910/1: ARM: Add tmp
> register for addruart and loadsp") from the arm tree and commit 209f5d2d2c8e385834d138ac593df86504a28ffe ("omap: Make
> uncompress code and DEBUG_LL code generic") from the omap tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, I'll sort it out in omap for-next tree so they merge
cleanly.

Tony

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-omap1/include/mach/debug-macro.S
> index 8c74cab,0187391..0000000
> --- a/arch/arm/mach-omap1/include/mach/debug-macro.S
> +++ b/arch/arm/mach-omap1/include/mach/debug-macro.S
> @@@ -11,7 -11,43 +11,43 @@@
>    *
>   */
>   
> + #include <linux/serial_reg.h>
> + 
> + #include <plat/serial.h>
> + 
> + 		.pushsection .data
> + omap_uart_phys:	.word	0x0
> + omap_uart_virt:	.word	0x0
> + 		.popsection
> + 
> + 		/*
> + 		 * Note that this code won't work if the bootloader passes
> + 		 * a wrong machine ID number in r1. To debug, just hardcode
> + 		 * the desired UART phys and virt addresses temporarily into
> + 		 * the omap_uart_phys and omap_uart_virt above.
> + 		 */
>  -		.macro	addruart,rx
>  +		.macro	addruart, rx, tmp
> + 
> + 		/* Use omap_uart_phys/virt if already configured */
> + 9:		mrc	p15, 0, \rx, c1, c0
> + 		tst	\rx, #1			@ MMU enabled?
> + 		ldreq	\rx, =omap_uart_phys	@ physical base address
> + 		ldrne	\rx, =omap_uart_virt	@ virtual base
> + 		ldr	\rx, [\rx, #0]
> + 		cmp	\rx, #0			@ is port configured?
> + 		bne	99f			@ already configured
> + 
> + 		/* Check 7XX UART1 scratchpad register for uart to use */
> + 		mrc	p15, 0, \rx, c1, c0
> + 		tst	\rx, #1			@ MMU enabled?
> + 		moveq	\rx, #0xff000000	@ physical base address
> + 		movne	\rx, #0xfe000000	@ virtual base
> + 		orr	\rx, \rx, #0x00fb0000	@ OMAP1UART1
> + 		ldrb	\rx, [\rx, #(UART_SCR << OMAP7XX_PORT_SHIFT)]
> + 		cmp	\rx, #0			@ anything in 7XX scratchpad?
> + 		bne	10f			@ found 7XX uart
> + 
> + 		/* Check 15xx/16xx UART1 scratchpad register for uart to use */
>   		mrc	p15, 0, \rx, c1, c0
>   		tst	\rx, #1			@ MMU enabled?
>   		moveq	\rx, #0xff000000	@ physical base address
> diff --cc arch/arm/mach-omap2/include/mach/debug-macro.S
> index 86979d7,eb05a22..0000000
> --- a/arch/arm/mach-omap2/include/mach/debug-macro.S
> +++ b/arch/arm/mach-omap2/include/mach/debug-macro.S
> @@@ -11,32 -11,107 +11,107 @@@
>    *
>   */
>   
> + #include <linux/serial_reg.h>
> + 
> + #include <plat/serial.h>
> + 
> + #define UART_OFFSET(addr)	((addr) & 0x00ffffff)
> + 
> + 		.pushsection .data
> + omap_uart_phys:	.word	0
> + omap_uart_virt:	.word	0
> + omap_uart_lsr:	.word	0
> + 		.popsection
> + 
> + 		/*
> + 		 * Note that this code won't work if the bootloader passes
> + 		 * a wrong machine ID number in r1. To debug, just hardcode
> + 		 * the desired UART phys and virt addresses temporarily into
> + 		 * the omap_uart_phys and omap_uart_virt above.
> + 		 */
>  -		.macro	addruart,rx
>  +		.macro	addruart, rx, tmp
> + 
> + 		/* Use omap_uart_phys/virt if already configured */
> + 10:		mrc	p15, 0, \rx, c1, c0
> + 		tst	\rx, #1			@ MMU enabled?
> + 		ldreq	\rx, =omap_uart_phys	@ physical base address
> + 		ldrne	\rx, =omap_uart_virt	@ virtual base address
> + 		ldr	\rx, [\rx, #0]
> + 		cmp	\rx, #0			@ is port configured?
> + 		bne	99f			@ already configured
> + 
> + 		/* Check UART1 scratchpad register for uart to use */
>   		mrc	p15, 0, \rx, c1, c0
>   		tst	\rx, #1			@ MMU enabled?
> - #ifdef  CONFIG_ARCH_OMAP2
>   		moveq	\rx, #0x48000000	@ physical base address
>   		movne	\rx, #0xfa000000	@ virtual base
> - 		orr	\rx, \rx, #0x0006a000
> - #ifdef CONFIG_OMAP_LL_DEBUG_UART2
> - 		add	\rx, \rx, #0x00002000	@ UART 2
> - #endif
> - #ifdef CONFIG_OMAP_LL_DEBUG_UART3
> - 		add	\rx, \rx, #0x00004000	@ UART 3
> - #endif
> - 
> - #elif defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_ARCH_OMAP4)
> - 		moveq	\rx, #0x48000000	@ physical base address
> - 		movne	\rx, #0xfa000000	@ virtual base
> - 		orr	\rx, \rx, #0x0006a000
> - #ifdef CONFIG_OMAP_LL_DEBUG_UART2
> - 		add	\rx, \rx, #0x00002000	@ UART 2
> - #endif
> - #ifdef CONFIG_OMAP_LL_DEBUG_UART3
> - 		add	\rx, \rx, #0x00fb0000	@ UART 3
> - 		add	\rx, \rx, #0x00006000
> - #endif
> - #endif
> + 		orr	\rx, \rx, #0x0006a000	@ uart1 on omap2/3/4
> + 		ldrb	\rx, [\rx, #(UART_SCR << OMAP_PORT_SHIFT)] @ scratchpad
> + 
> + 		/* Select the UART to use based on the UART1 scratchpad value */
> + 		cmp	\rx, #0			@ no port configured?
> + 		beq	21f			@ if none, try to use UART1
> + 		cmp	\rx, #OMAP2UART1	@ OMAP2/3/4UART1
> + 		beq	21f			@ configure OMAP2/3/4UART1
> + 		cmp	\rx, #OMAP2UART2	@ OMAP2/3/4UART2
> + 		beq	22f			@ configure OMAP2/3/4UART2
> + 		cmp	\rx, #OMAP2UART3	@ only on 24xx
> + 		beq	23f			@ configure OMAP2UART3
> + 		cmp	\rx, #OMAP3UART3	@ only on 34xx
> + 		beq	33f			@ configure OMAP3UART3
> + 		cmp	\rx, #OMAP4UART3	@ only on 44xx
> + 		beq	43f			@ configure OMAP4UART3
> + 		cmp	\rx, #OMAP3UART4	@ only on 36xx
> + 		beq	34f			@ configure OMAP3UART4
> + 		cmp	\rx, #OMAP4UART4	@ only on 44xx
> + 		beq	44f			@ configure OMAP4UART4
> + 		cmp	\rx, #ZOOM_UART		@ only on zoom2/3
> + 		beq	95f			@ configure ZOOM_UART
> + 
> + 		/* Configure the UART offset from the phys/virt base */
> + 21:		mov	\rx, #UART_OFFSET(OMAP2_UART1_BASE)	@ omap2/3/4
> + 		b	98f
> + 22:		mov	\rx, #UART_OFFSET(OMAP2_UART2_BASE)	@ omap2/3/4
> + 		b	98f
> + 23:		mov	\rx, #UART_OFFSET(OMAP2_UART3_BASE)
> + 		b	98f
> + 33:		mov	\rx, #UART_OFFSET(OMAP3_UART1_BASE)
> + 		add	\rx, \rx, #0x00fb0000
> + 		add	\rx, \rx, #0x00006000		@ OMAP3_UART3_BASE
> + 		b	98f
> + 34:		mov	\rx, #UART_OFFSET(OMAP3_UART1_BASE)
> + 		add	\rx, \rx, #0x00fb0000
> + 		add	\rx, \rx, #0x00028000		@ OMAP3_UART4_BASE
> + 		b	98f
> + 43:		mov	\rx, #UART_OFFSET(OMAP4_UART3_BASE)
> + 		b	98f
> + 44:		mov	\rx, #UART_OFFSET(OMAP4_UART4_BASE)
> + 		b	98f
> + 95:		mov	\rx, #ZOOM_UART_BASE
> + 		ldr	r1, =omap_uart_phys
> + 		str	\rx, [r1, #0]
> + 		mov	\rx, #ZOOM_UART_VIRT
> + 		ldr	r1, =omap_uart_virt
> + 		str	\rx, [r1, #0]
> + 		mov	\rx, #(UART_LSR << ZOOM_PORT_SHIFT)
> + 		ldr	r1, =omap_uart_lsr
> + 		str	\rx, [r1, #0]
> + 		b	10b
> + 
> + 		/* Store both phys and virt address for the uart */
> + 98:		add	\rx, \rx, #0x48000000	@ phys base
> + 		ldr	r1, =omap_uart_phys
> + 		str	\rx, [r1, #0]
> + 		sub	\rx, \rx, #0x48000000	@ phys base
> + 		add	\rx, \rx, #0xfa000000	@ virt base
> + 		ldr	r1, =omap_uart_virt
> + 		str	\rx, [r1, #0]
> + 		mov	\rx, #(UART_LSR << OMAP_PORT_SHIFT)
> + 		ldr	r1, =omap_uart_lsr
> + 		str	\rx, [r1, #0]
> + 
> + 		b	10b
> + 99:
>   		.endm
>   
>   		.macro	senduart,rd,rx
