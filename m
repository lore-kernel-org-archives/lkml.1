Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYCXKOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYCXKOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 06:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYCXKOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 06:14:35 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:11359 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbYCXKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 06:14:34 -0400
Date: Mon, 24 Mar 2008 11:14:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, paulus@samba.org,
       ralf@linux-mips.org, davem@davemloft.net, lethal@linux-sh.org,
       jdike@addtoit.com
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080324101431.GA9521@osiris.boeblingen.de.ibm.com>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu> <20080321132559.GA4128@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de> <20080322203223.GA31521@osiris.boeblingen.de.ibm.com> <20080323223455.GA746@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323223455.GA746@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 10:34:55PM +0000, Russell King wrote:
> On Sat, Mar 22, 2008 at 09:32:23PM +0100, Heiko Carstens wrote:
> > Generic code is not supposed to include irq.h. Replace this include
> > by linux/hardirq.h instead and add/replace an include of linux/irq.h
> > in asm header files where necessary.
> > This change should only matter for architectures that make use of
> > GENERIC_CLOCKEVENTS.
> > Architectures in question are mips, x86, arm, sh, powerpc, uml and sparc64.
> > 
> > I did some cross compile tests for mips, x86_64, arm, powerpc and sparc64.
> > This patch fixes also build breakages caused by the include replacement in
> > tick-common.h.
> 
> I generally dislike adding optional linux/* includes in asm/* includes -
> I'm nervous about this causing include loops.
> 
> However, there's a separate point to be discussed here.
> 
> That is, what interfaces are expected of every architecture in the kernel.
> If generic code wants to be able to set the affinity of interrupts, then
> that needs to become part of the interfaces listed in linux/interrupt.h
> rather than linux/irq.h.

Every architecture besides one... as usual :/

> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index f8ab4ce..355e3b0 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -102,6 +102,25 @@ extern void disable_irq_nosync(unsigned int irq);
>  extern void disable_irq(unsigned int irq);
>  extern void enable_irq(unsigned int irq);
> 
> +#ifdef CONFIG_SMP
> +
> +extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
> +extern int irq_can_set_affinity(unsigned int irq);
> +
> +#else /* CONFIG_SMP */
> +
> +static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int irq_can_set_affinity(unsigned int irq)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_SMP */
> +

Could you add something like

#ifdef CONFIG_GENERIC_HARDIRQS

/* added stuff from above */

#else /* CONFIG_GENERIC_HARDIRQS */

static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
{
	WARN_ON(1);
	return -EINVAL;
}

static inline int irq_can_set_affinity(unsigned int irq)
{
	return 0;
}
#endif /* CONFIG_GENERIC_HARDIRQS */

Then it should do the right thing on s390 as well.
