Return-Path: <linux-kernel-owner+w=401wt.eu-S935414AbYD1PK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414AbYD1PK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935105AbYD1PKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:10:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38908 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935299AbYD1PKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:10:44 -0400
Message-Id: <1209395443.25700.1250273669@webmail.messagingengine.com>
X-Sasl-Enc: dE8/pfkMKo3hTf5flRHMgVSPI9ySrlAmhtu33dngSzE1 1209395443
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1209327591.14173.74.camel@brick>
   <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
   <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de>
Date: Mon, 28 Apr 2008 17:10:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See patch below. It gives back the 1400 bytes on SPARC64 and other
> platforms that have no instruction for find bit.

Hi,

I, personally, see this patch as a stopgap measure. The real problem
is that the generic __ffs is inlined and ends up generating a lot
of instructions.

Until the generic implementation of __ffs is fixed not to be an
enormous inline function, this seems to be a reasonable thing
to do, though it's a shame that the optimization is now default-
off for architectures with a good implementation of __ffs.

Greetings,
    Alexander

> Thanks,
> 	tglx
> 
> ---------->
> 
> Subject: bitops: optional bitops mapsize optimization on config switch
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Mon, 28 Apr 2008 00:22:06 +0200
> 
> The mapsize optimizations which were moved from x86 to the generic
> code in commit 64970b68d2b3ed32b964b0b30b1b98518fde388e increased the
> binary size on non x86 architectures.
> 
> Make the optimization depend on a config switch so architecture
> maintainers can decide.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  arch/x86/Kconfig.cpu   |    1 +
>  include/linux/bitops.h |    6 ++++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/Kconfig.cpu
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig.cpu
> +++ linux-2.6/arch/x86/Kconfig.cpu
> @@ -282,6 +282,7 @@ config X86_CPU
>  	def_bool y
>  	select GENERIC_FIND_FIRST_BIT
>  	select GENERIC_FIND_NEXT_BIT
> +	select GENERIC_FIND_BIT_MAPSIZE_OPTIMIZE
>  
>  config X86_GENERIC
>  	bool "Generic x86 support"
> Index: linux-2.6/include/linux/bitops.h
> ===================================================================
> --- linux-2.6.orig/include/linux/bitops.h
> +++ linux-2.6/include/linux/bitops.h
> @@ -190,6 +190,7 @@ static __always_inline unsigned long
>  find_next_bit(const unsigned long *addr, unsigned long size,
>  		unsigned long offset)
>  {
> +#ifdef CONFIG_GENERIC_FIND_BIT_MAPSIZE_OPTIMIZE
>  	unsigned long value;
>  
>  	/* Avoid a function call if the bitmap size is a constant */
> @@ -209,7 +210,7 @@ find_next_bit(const unsigned long *addr,
>  		value = (*addr) & ((~0ul) << offset);
>  		return (value == 0) ? BITS_PER_LONG : __ffs(value);
>  	}
> -
> +#endif
>  	/* size is not constant or too big */
>  	return __find_next_bit(addr, size, offset);
>  }
> @@ -227,6 +228,7 @@ static __always_inline unsigned long
>  find_next_zero_bit(const unsigned long *addr, unsigned long size,
>  		unsigned long offset)
>  {
> +#ifdef CONFIG_GENERIC_FIND_BIT_MAPSIZE_OPTIMIZE
>  	unsigned long value;
>  
>  	/* Avoid a function call if the bitmap size is a constant */
> @@ -246,7 +248,7 @@ find_next_zero_bit(const unsigned long *
>  		value = (~(*addr)) & ((~0ul) << offset);
>  		return (value == 0) ? BITS_PER_LONG : __ffs(value);
>  	}
> -
> +#endif
>  	/* size is not constant or too big */
>  	return __find_next_zero_bit(addr, size, offset);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

