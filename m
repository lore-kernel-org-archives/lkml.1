Return-Path: <linux-kernel-owner+w=401wt.eu-S937212AbXFGVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937212AbXFGVxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935104AbXFGVxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:53:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197AbXFGVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:53:14 -0400
Date: Thu, 7 Jun 2007 14:53:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 17/36] drivers edac updated pci monitor
Message-Id: <20070607145304.1738220a.akpm@linux-foundation.org>
In-Reply-To: <473489.48003.qm@web50110.mail.re2.yahoo.com>
References: <473489.48003.qm@web50110.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 07:41:44 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> From:	Dave Jiang <djiang@mvista.com>
> 
> Moving PCI to a per-instance device model
> 
>...
>
> +/*
> + * EDAC PCI component
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
> +#include <linux/types.h>
> +#include <linux/smp.h>
> +#include <linux/init.h>
> +#include <linux/sysctl.h>
> +#include <linux/highmem.h>
> +#include <linux/timer.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/sysdev.h>
> +#include <linux/ctype.h>
> +#include <linux/workqueue.h>
> +#include <asm/uaccess.h>
> +#include <asm/page.h>
> +
> +#include "edac_core.h"
> +#include "edac_module.h"
> +
> +static DEFINE_MUTEX(edac_pci_ctls_mutex);
> +static struct list_head edac_pci_list = LIST_HEAD_INIT(edac_pci_list);
> +
> +static inline void edac_lock_pci_list(void)
> +{
> +	mutex_lock(&edac_pci_ctls_mutex);
> +}
> +
> +static inline void edac_unlock_pci_list(void)
> +{
> +	mutex_unlock(&edac_pci_ctls_mutex);
> +}

It would be preferred if this locking were open-coded rather than wrapped
like this.

> +/*
> + * The alloc() and free() functions for the 'edac_pci' control info
> + * structure. The chip driver will allocate one of these for each
> + * edac_pci it is going to control/register with the EDAC CORE.
> + */
> +struct edac_pci_ctl_info * edac_pci_alloc_ctl_info(

s/* /*/

Please review whole patch(set)

> +	unsigned int sz_pvt,
> +	const char *edac_pci_name)
> +{
> +	struct edac_pci_ctl_info *pci;
> +	void *pvt;
> +	unsigned int size;
> +
> +	pci = (struct edac_pci_ctl_info *)0;

NULL

> +	pvt = edac_align_ptr(&pci[1], sz_pvt);
> +	size = ((unsigned long)pvt) + sz_pvt;
> +
> +	if ((pci = kzalloc(size, GFP_KERNEL)) == NULL)

coding style

> +		return NULL;
> +
> +	pvt = sz_pvt ? ((char *)pci) + ((unsigned long)pvt) : NULL;
> +
> +	pci->pvt_info = pvt;
> +
> +	pci->op_state = OP_ALLOC;
> +
> +	snprintf(pci->name, strlen(edac_pci_name)+1, "%s", edac_pci_name);
> +
> +	return pci;
> +}
> +EXPORT_SYMBOL_GPL(edac_pci_alloc_ctl_info);
> +
> +/*
> + * edac_pci_free_ctl_info()
> + * 	frees the memory allocated by edac_pci_alloc_ctl_info() function
> + */
> +void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci)
> +{
> +	kfree(pci);
> +}
> +EXPORT_SYMBOL_GPL(edac_pci_free_ctl_info);
> +	wait_for_completion(&pci->complete);
> +}
> +
>
> ...
>
> +/*
> + * edac_pci_del_device()
> + * 	Remove sysfs entries for specified edac_pci structure and
> + * 	then remove edac_pci structure from global list
> + *
> + * @dev:
> + * 	Pointer to 'struct device' representing edac_pci structure
> + * 	to remove
> + *
> + * Return:
> + * 	Pointer to removed edac_pci structure,
> + * 	or NULL if device not found
> + */
> +struct edac_pci_ctl_info * edac_pci_del_device(struct device *dev)
> +{
> +	struct edac_pci_ctl_info *pci;
> +
> +	debugf0("%s()\n", __func__);
> +
> +	edac_lock_pci_list();
> +
> +	if ((pci = find_edac_pci_by_dev(dev)) == NULL) {

coding style

> +		edac_unlock_pci_list();
> +		return NULL;
> +	}
> +
> +	pci->op_state = OP_OFFLINE;
> +
> +	edac_pci_workq_teardown(pci);
> +
> +	edac_pci_remove_sysfs(pci);
> +
> +	del_edac_pci_from_global_list(pci);
> +
> +	edac_unlock_pci_list();
> +
> +	edac_printk(KERN_INFO, EDAC_PCI,
> +		"Removed device %d for %s %s: DEV %s\n",
> +		pci->pci_idx,
> +		pci->mod_name,
> +		pci->ctl_name,
> +		dev_name(pci));
> +
> +	return pci;
> +}
> +EXPORT_SYMBOL_GPL(edac_pci_del_device);
> +
> +static inline int edac_pci_get_log_pe(struct edac_pci_ctl_info *pci)
> +{
> +	return pci->log_parity_error;
> +}
> +
> +static inline int edac_pci_get_panic_on_pe(struct edac_pci_ctl_info
> *pci)
> +{
> +	return pci->panic_on_pe;
> +}
> +
> +void edac_pci_generic_check(struct edac_pci_ctl_info *pci)
> +{
> +	edac_pci_do_parity_check();
> +}
> +
> +static int edac_pci_idx = 0;

Unneeded initialisation to zero.

> +#define EDAC_PCI_GENCTL_NAME	"EDAC PCI controller"
> +
> +struct edac_pci_gen_data {
> +	int edac_idx;
> +};
> +
>
> ...
>
> +++ linux-2.6.21.1/drivers/edac/Makefile
> @@ -11,9 +11,12 @@ obj-$(CONFIG_EDAC)			:= edac_stub.o
>  obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
>  
>  edac_core-objs	:= edac_mc.o edac_device.o edac_mc_sysfs.o
> edac_pci_sysfs.o
> -
>  edac_core-objs	+= edac_module.o edac_device_sysfs.o
>  
> +ifdef CONFIG_PCI
> +edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
> +endif

Can we avoid the ifdef here?  edac_core-objs-$(CONFIG_PCI) or similar?

>  /*
> + * edac_op_state_toString()
> + */
> +char * edac_op_state_toString(int opstate)

s/* /*/

Make it edac_op_state_to_string (NoStudlyCaps)

> +{
> +	if (opstate == OP_RUNNING_POLL)
> +		return "POLLED";
> +	else if (opstate == OP_RUNNING_INTERRUPT)
> +		return "INTERRUPT";
> +	else if (opstate == OP_RUNNING_POLL_INTR)
> +		return "POLL-INTR";
> +	else if (opstate == OP_ALLOC)
> +		return "ALLOC";
> +	else if (opstate == OP_OFFLINE)
> +		return "OFFLINE";
> +
> +	return "UNKNOWN";
> +}

that's a switch statement..  (or even an array lookup..)

>  #ifdef CONFIG_PCI
> -static int check_pci_parity = 0;	/* default YES check PCI parity */
> -static int panic_on_pci_parity;		/* default no panic on PCI Parity */
> +
> +#define EDAC_PCI_SYMLINK	"device"
> +
> +static int check_pci_errors = 0;	/* default YES check PCI parity */
> +static int panic_on_pci_parity = 0;	/* default no panic on PCI Parity

Unneeded initialisations

>  static struct edac_pci_dev_attribute *edac_pci_attr[] = {
> -	&edac_pci_attr_check_pci_parity,
> +	&edac_pci_attr_check_pci_errors,
> +	&edac_pci_attr_log_pci_errs,
>  	&edac_pci_attr_panic_on_pci_parity,
>  	&edac_pci_attr_pci_parity_count,
> +	&edac_pci_attr_pci_nonparity_count,
>  	NULL,
>  };

attribute_group?


