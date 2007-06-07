Return-Path: <linux-kernel-owner+w=401wt.eu-S965893AbXFGV6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbXFGV6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935516AbXFGV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:58:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59165 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935930AbXFGV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:58:35 -0400
Date: Thu, 7 Jun 2007 14:58:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 12/36] drivers edac add nmi ecc harvesting
Message-Id: <20070607145822.4b43469c.akpm@linux-foundation.org>
In-Reply-To: <866076.60576.qm@web50110.mail.re2.yahoo.com>
References: <866076.60576.qm@web50110.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 08:11:02 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> From:	Dave Jiang <djiang@mvista.com>
> 
> Provides a way for NMI reported errors on x86 to notify the EDAC
> subsystem pending ECC errors by writing to a software state variable.
> 
> Signed-off-by: Dave Jiang <djiang@mvista.com>
> Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
> 

(cc Andi: this affects x86 core code)

> 
> Here's the reworked patch. I added an EDAC stub to the kernel so we can
> have variables that are in the kernel even if EDAC is a module. I also
> implemented the idea of using the chip driver to select error detection
> mode via module parameter and eliminate the kernel compile option.
> Please review/test. Thx!
> 
> Also, I only made changes to some of the chipset drivers since I am
> unfamiliar with the other ones. We can add similar changes as we go.
> 
> 
> --- linux-2.6.22-rc1.orig/arch/i386/kernel/traps.c
> +++ linux-2.6.22-rc1/arch/i386/kernel/traps.c
> @@ -41,6 +41,10 @@
>  #include <linux/mca.h>
>  #endif
>  
> +#if defined(CONFIG_EDAC)
> +#include <linux/edac.h>
> +#endif

The ifdef here shouldn't be needed? (If it is, please fix it in edac.h)

>  #include <asm/processor.h>
>  #include <asm/system.h>
>  #include <asm/io.h>
> @@ -635,6 +639,14 @@ mem_parity_error(unsigned char reason, s
>  	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x on "
>  		"CPU %d.\n", reason, smp_processor_id());
>  	printk(KERN_EMERG "You have some hardware problem, likely on the PCI
> bus.\n");
> +
> +#if defined(CONFIG_EDAC)
> +	if(edac_handler_set()) {
> +		edac_atomic_assert_error();
> +		return;
> +	}
> +#endif

if-is-not-a-function

> +
>  	if (panic_on_unrecovered_nmi)
>                  panic("NMI: Not continuing");
>  
> Index: linux-2.6.22-rc1/arch/x86_64/kernel/traps.c
> ===================================================================
> --- linux-2.6.22-rc1.orig/arch/x86_64/kernel/traps.c
> +++ linux-2.6.22-rc1/arch/x86_64/kernel/traps.c
> @@ -34,6 +34,10 @@
>  #include <linux/bug.h>
>  #include <linux/kdebug.h>
>  
> +#if defined(CONFIG_EDAC)
> +#include <linux/edac.h>
> +#endif
> +
>  #include <asm/system.h>
>  #include <asm/io.h>
>  #include <asm/atomic.h>
> @@ -716,6 +720,13 @@ mem_parity_error(unsigned char reason, s
>  		reason);
>  	printk(KERN_EMERG "You have some hardware problem, likely on the PCI
> bus.\n");
>  
> +#if defined(CONFIG_EDAC)
> +	if(edac_handler_set()) {
> +		edac_atomic_assert_error();
> +		return;
> +	}
> +#endif

dittoes

>  /*
> + * handler for EDAC to check if NMI type handler has asserted
> interrupt
> + */
> +static int edac_assert_error_check_and_clear(void)
> +{
> +	int vreg;
> +
> +	if(edac_op_state == EDAC_OPSTATE_POLL)
> +		return 1;
> +
> +	vreg = atomic_read(&edac_err_assert);
> +	if(vreg) {
> +		atomic_set(&edac_err_assert, 0);
> +		return 1;
> +	}
> +
> +	return 0;
> +}

if-is-still-not-a-function ;)

Please check all patches for this.

> --- /dev/null
> +++ linux-2.6.22-rc1/drivers/edac/edac_stub.c
> @@ -0,0 +1,42 @@
> +/*
> + * common EDAC components that must be in kernel
> + *
> + * Author: Dave Jiang <djiang@mvista.com>
> + *
> + * 2007 (c) MontaVista Software, Inc. This file is licensed under
> + * the terms of the GNU General Public License version 2. This program
> + * is licensed "as is" without any warranty of any kind, whether
> express
> + * or implied.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/edac.h>
> +#include <asm/atomic.h>
> +#include <asm/edac.h>
> +
> +int edac_op_state = EDAC_OPSTATE_INVAL;
> +EXPORT_SYMBOL(edac_op_state);
> +
> +atomic_t edac_handlers = ATOMIC_INIT(0);
> +EXPORT_SYMBOL(edac_handlers);
> +
> +atomic_t edac_err_assert = ATOMIC_INIT(0);
> +EXPORT_SYMBOL(edac_err_assert);
> +
> +inline int edac_handler_set(void)
> +{
> +	if (edac_op_state == EDAC_OPSTATE_POLL)
> +		return 0;
> +
> +	return atomic_read(&edac_handlers);
> +}
> +EXPORT_SYMBOL(edac_handler_set);
> +
> +/*
> + * handler for NMI type of interrupts to assert error
> + */
> +inline void edac_atomic_assert_error(void)
> +{
> +	atomic_set(&edac_err_assert, 1);
> +}
> +EXPORT_SYMBOL(edac_atomic_assert_error);

Remove the `inline' keywords here

> Index: linux-2.6.22-rc1/drivers/edac/e752x_edac.c
> ===================================================================
> --- linux-2.6.22-rc1.orig/drivers/edac/e752x_edac.c
> +++ linux-2.6.22-rc1/drivers/edac/e752x_edac.c
> @@ -22,6 +22,7 @@
>  #include <linux/pci.h>
>  #include <linux/pci_ids.h>
>  #include <linux/slab.h>
> +#include <linux/edac.h>
>  #include "edac_mc.h"
>  
>  #define E752X_REVISION	" Ver: 2.0.1 " __DATE__
> @@ -948,6 +949,16 @@ static int e752x_probe1(struct pci_dev *
>  	debugf0("%s(): mci\n", __func__);
>  	debugf0("Starting Probe1\n");
>  
> +	/* make sure error reporting method is sane */
> +	switch(edac_op_state) {

switch-is-not-a-function-either!

> +		case EDAC_OPSTATE_POLL:
> +		case EDAC_OPSTATE_NMI:
> +			break;
> +		default:
> +			edac_op_state = EDAC_OPSTATE_POLL;
> +			break;
> +	}
> +

