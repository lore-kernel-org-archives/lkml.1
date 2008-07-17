Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYGQB7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYGQB7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 21:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYGQB7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 21:59:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38833 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbYGQB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 21:59:31 -0400
Date: Thu, 17 Jul 2008 10:57:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Limit irq nesting
Cc: kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807162128060.24301@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807162128060.24301@devserv.devel.redhat.com>
Message-Id: <20080717105532.157E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

> ---
>  include/linux/interrupt.h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc8/include/linux/interrupt.h
> ===================================================================
> --- linux-2.6.26-rc8.orig/include/linux/interrupt.h	2008-06-25 03:58:20.000000000 +0200
> +++ linux-2.6.26-rc8/include/linux/interrupt.h	2008-07-01 17:42:44.000000000 +0200
> @@ -16,6 +16,11 @@
>  #include <asm/system.h>
>  
>  /*
> + * Max number of interrupt handlers on a stack. To prevent stack overflow.
> + */
> +#define MAX_NESTED_INTERRUPTS	2
> +
> +/*
>   * These correspond to the IORESOURCE_IRQ_* defines in
>   * linux/ioport.h to select the interrupt line behaviour.  When
>   * requesting an interrupt without specifying a IRQF_TRIGGER, the

I have no objection to your approach.
but I don't know MAX_NESTED_INTERRUPTS is properly or not.

Could you explain why MAX_NESTED_INTERRUPTS is two?
Is it architecture independent properly number?



> @@ -95,7 +100,7 @@ extern void devm_free_irq(struct device 
>  #ifdef CONFIG_LOCKDEP
>  # define local_irq_enable_in_hardirq()	do { } while (0)
>  #else
> -# define local_irq_enable_in_hardirq()	local_irq_enable()
> +# define local_irq_enable_in_hardirq()	do { if (hardirq_count() < (MAX_NESTED_INTERRUPTS << HARDIRQ_SHIFT)) local_irq_enable(); } while (0)
>  #endif
>  
>  extern void disable_irq_nosync(unsigned int irq);


