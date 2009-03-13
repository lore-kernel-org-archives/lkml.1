Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZCMAeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZCMAeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZCMAeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:34:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZCMAeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:34:13 -0400
Date: Fri, 13 Mar 2009 01:34:10 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc7-rt1
Message-ID: <20090313003410.GA1192@pengutronix.de>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <200903122143.33840.tim01@vlsi.informatik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903122143.33840.tim01@vlsi.informatik.tu-darmstadt.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tim,

On Thu, Mar 12, 2009 at 09:43:33PM +0100, Tim Sander wrote:
> So my question is, what pieces are missing on the ARM platform to get
> it working?
See the follow up mail I will write on Thomas announcement for my
current status.

> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index 68b9ec8..b501541 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -119,7 +119,8 @@ extern void iwmmxt_task_switch(struct thread_info *);
>   * We use bit 30 of the preempt_count to indicate that kernel
>   * preemption is occurring.  See <asm/hardirq.h>.
>   */
> -#define PREEMPT_ACTIVE 0x40000000
> +#define PREEMPT_ACTIVE         0x10000000
> +/*FIXME TIM #define PREEMPT_ACTIVE     0x40000000*/
I didn't need this anymore for -rc7-rt1.

>  /*
>   * thread information flags:
> diff --git a/arch/arm/plat-mxc/include/mach/memory.h 
> b/arch/arm/plat-mxc/include/mach/memory.h
> index 0b80839..b43a536 100644
> --- a/arch/arm/plat-mxc/include/mach/memory.h
> +++ b/arch/arm/plat-mxc/include/mach/memory.h
> @@ -19,4 +19,6 @@
>  #define PHYS_OFFSET            UL(0x80000000)
>  #endif
> 
> +#define arch_is_coherent()     1
> +
I suggested a better fix already last time.  Moreover I think imx isn't
coherent.

> diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
> index 6c9b9b9..130fbdd 100644
> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -93,6 +93,7 @@
>  #include <linux/bottom_half.h>
>  #include <linux/irqflags.h>
>  #include <linux/pickop.h>
> +#include <asm/memory.h>
Doing this in arch/arm/include/asm/bitops.h is less intrusive and it
seems to me the better place.  See my patch stack.
 
> @@ -560,8 +561,7 @@ static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
>  # ifdef CONFIG_DEBUG_SPINLOCK
>         BUG_ON(!test_bit(bitnum, addr));
>  # endif
> -       //FIXME TIM  clear_bit_unlock(bitnum, addr);
> -       clear_bit(bitnum,addr);
> +       clear_bit_unlock(bitnum, addr);
It would be easier to check your patch if it didn't contain reverts of
earlier changes.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
