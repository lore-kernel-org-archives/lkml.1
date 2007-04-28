Return-Path: <linux-kernel-owner+w=401wt.eu-S1030901AbXD1CJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901AbXD1CJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030915AbXD1CJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:09:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030901AbXD1CJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:09:53 -0400
Date: Fri, 27 Apr 2007 19:09:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300 generic irq
Message-Id: <20070427190935.68606a3a.akpm@linux-foundation.org>
In-Reply-To: <m2abwvttya.wl%ysato@users.sourceforge.jp>
References: <m2abwvttya.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 17:34:37 +0900
Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> h8300 using generic irq handler patch.
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 

Minor things:

>
> --- /dev/null
> +++ b/arch/h8300/kernel/irq.c
> @@ -0,0 +1,211 @@
> +/*
> + * linux/arch/h8300/kernel/irq.c
> + *
> + * Copyright 2007 Yoshinori Sato <ysato@users.sourceforge.jp>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/seq_file.h>
> +#include <linux/init.h>
> +#include <linux/random.h>
> +#include <linux/bootmem.h>
> +#include <linux/irq.h>
> +
> +#include <asm/system.h>
> +#include <asm/traps.h>
> +#include <asm/io.h>
> +#include <asm/setup.h>
> +#include <asm/errno.h>
> +
> +/*#define DEBUG*/
> +
> +extern unsigned long *interrupt_redirect_table;
> +extern const int h8300_saved_vectors[];
> +extern const unsigned long h8300_trap_table[];
> +int h8300_enable_irq_pin(unsigned int irq);
> +void h8300_disable_irq_pin(unsigned int irq);

Please always avoid putting extern declarations into C files.  Please them
in a header file which is visible tot he definition site asw well as all
callers/users.

For something which is defined in assembly code (like
interrupt_redirect_table) it isn't so clear, because we cannot do
typechecking.  But I think it's still best to include the declaration in a
header file so that we only have to declare it once.  Plus it _is_ a global
symbol.

> +
> +/*
> + * h8300 interrupt controler implementation
> + */
> +struct irq_chip h8300irq_chip = {
> +	.name		= "H8300-INTC",
> +	.startup	= h8300_startup_irq,
> +	.shutdown	= h8300_shutdown_irq,
> +	.enable		= h8300_enable_irq,
> +	.disable	= h8300_disable_irq,
> +	.ack		= NULL,
> +	.end		= h8300_end_irq,
> +};

I think this could have static scope.

> +void ack_bad_irq(unsigned int irq)
> +{
> +	printk("unexpected IRQ trap at vector %02x\n", irq);
> +}

printks should generally have facility levels (KERN_*)

> +		panic("interrupt vector serup failed.");

typo

> +	for ( i = 0; i < NR_IRQS; i++) {

	for (i = 0

> +		if (i == *saved_vector) {
> +			ramvec_p++;
> +			saved_vector++;
> +		} else {
> +			if ( i < NR_TRAPS ) {

			if (i < NR_TRAPS)


