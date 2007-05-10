Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXEJFlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXEJFlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 01:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXEJFlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 01:41:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbXEJFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 01:41:35 -0400
Date: Wed, 9 May 2007 22:41:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] Add hard_irq_disable()
Message-Id: <20070509224113.cca81a24.akpm@linux-foundation.org>
In-Reply-To: <20070510052622.3E8D5DDF4B@ozlabs.org>
References: <20070510052622.3E8D5DDF4B@ozlabs.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 15:25:58 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> --- linux-cell.orig/include/linux/interrupt.h	2007-05-10 14:51:22.000000000 +1000
> +++ linux-cell/include/linux/interrupt.h	2007-05-10 15:18:04.000000000 +1000
> @@ -241,6 +241,16 @@ static inline void __deprecated save_and
>  #define save_and_cli(x)	save_and_cli(&x)
>  #endif /* CONFIG_SMP */
>  
> +/* Some architectures might implement lazy enabling/disabling of
> + * interrupts. In some cases, such as stop_machine, we might want
> + * to ensure that after a local_irq_disable(), interrupts have
> + * really been disabled in hardware. Such architectures need to
> + * implement the following hook.
> + */
> +#ifndef hard_irq_disable
> +#define hard_irq_disable()	do { } while(0)
> +#endif

We absolutely require that the architecture's hard_irq_disable() be defined
when we do this.  If it happens that the definition of hard_irq_disable()
is implemented three levels deep in nested includes then we risk getting
into a situation where different .c files see different implementations of
hard_irq_disable(), which could lead to confusing results, to say the least.

Your implementation comes via the inclusion of system.h which then includes
hw_irq.h.  That's perhaps a little fragile and it would be better to

a) include in the comment the name of the arch file which must implement
   hard_irq_disable() and

b) include that file directly from this one.

Oh, and your comment layout style is wrong ;)
