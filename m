Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbXCYTR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbXCYTR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXCYTR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:17:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63700 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXCYTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:17:24 -0400
Date: Sun, 25 Mar 2007 12:17:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wink Saville <wink@saville.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Trec driver.
Message-Id: <20070325121729.f9e9be9e.randy.dunlap@oracle.com>
In-Reply-To: <11747803002933-git-send-email-wink@saville.com>
References: <11747802992043-git-send-email-wink@saville.com>
	<11747803002933-git-send-email-wink@saville.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 16:51:38 -0700 Wink Saville wrote:

> This is the Trec driver, Makefile, header files.
> Enable trec in Kernel hacking configuration menu.
> 
> Signed-off-by: Wink Saville <wink@saville.com>
> ---

> diff --git a/drivers/trec/trec.c b/drivers/trec/trec.c
> new file mode 100644
> index 0000000..0b04b71
> --- /dev/null
> +++ b/drivers/trec/trec.c
> @@ -0,0 +1,404 @@
...
> +
> +struct trec_dev_struct
> +{
> +	struct	cdev		cdev;			/* Character device structure */

Fit in 80 columns, please.

> +};
> +
> +MODULE_AUTHOR("Wink Saville");
> +MODULE_LICENSE("Dual BSD/GPL");
> +
> +/*
> + * Module parameters
> + */
> +int major = 240;	/* 240 a "local/expermental" device number for the moment */
> +int minor = 1;
> +
> +module_param(major, int, S_IRUGO);
> +module_param(minor, int, S_IRUGO);
> +
> +/*
> + * Forward declarations
> + */
> +static int trec_open(struct inode *inode, struct file *file);
> +static int trec_release(struct inode *inode, struct file *file);
> +
> +/*
> + * File operations
> + */
> +struct file_operations trec_f_ops = {
> +	.owner		=	THIS_MODULE,
> +	.open		=	trec_open,
> +	.release	=	trec_release,
> +};
> +
> +struct trec_struct {
> +	uint64_t	tsc;
> +	unsigned long	pc;
> +	unsigned long	tsk;
> +	unsigned int	pid;
> +	unsigned long	v1;
> +	unsigned long	v2;
> +};
> +
> +/*
> + * Change trec_buffer_struct.data to be a pointer to a PAGE in the future
> + */
> +#define TREC_DATA_SIZE 0x200
> +struct trec_buffer_struct {
> +	struct trec_buffer_struct *	next;
> +	struct trec_struct *		cur;
> +	struct trec_struct *		end;
> +	struct trec_struct		data[TREC_DATA_SIZE];

Kernel style is:
	sturct trec_struct		*cur;

> +};
> +
> +/*
> + * Number of buffers must be a multiple of two so we can
> + * snapshot the buffers and the minimum should be 4.
> + */
> +#define	TREC_COUNT 2
> +struct trec_buffer_struct 	trec_buffers[2][TREC_COUNT];
> +int				trec_idx = 0;
> +spinlock_t 			trec_lock = SPIN_LOCK_UNLOCKED;
> +
> +struct trec_buffer_struct *	trec_buffer_cur = NULL;
> +struct trec_buffer_struct *	trec_buffer_snapshot = NULL;

Pointer style.  + don't init to NULL.

> +
> +struct trec_dev_struct 		trec_dev;
> +
> +/**
> + * Print an address symbol if available to the buffer
> + * this is from traps.c
> + */

Don't use kernel-doc indicator ("/**") unless the function block
comment is actually in kernel-doc syntax (see
Documentation/kernel-doc-nano-HOWTO.txt).

> +static int snprint_address(char *b, int bsize, unsigned long address)
> +{
> +#ifdef CONFIG_KALLSYMS
> +	unsigned long offset = 0, symsize;
> +	const char *symname;
> +	char *modname;
> +	char *delim = ":";
> +	int n;
> +	char namebuf[128];
> +
> +	symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
> +	if (!symname) {
> +		n = 0;
> +	} else {
> +		if (!modname)
> +			modname = delim = ""; 		
> +		n = snprintf(b, bsize, "0x%016lx %s%s%s%s+0x%lx/0x%lx",
> +			address, delim, modname, delim, symname, offset, symsize);
> +	}
> +	return n;
> +#else
> +	return snprintf(b, bsize, "0x%016lx", address);
> +#endif
> +}

> +/*
> + * Snapshot the current trecs
> + */
> +void trec_snapshot(void)
> +{
> +	int flags;
> +
> +	spin_lock_irqsave(&trec_lock, flags);
> +	trec_buffer_snapshot = trec_buffer_cur;
> +	trec_idx = trec_idx ^ 1;
> +	trec_buffer_cur = &trec_buffers[trec_idx][0];
> +	spin_unlock_irqrestore(&trec_lock, flags);
> +}
> +EXPORT_SYMBOL(trec_snapshot);

What (if anything) prevents multiple snapshots from overwriting
each other, or from being overwritten while one is printing?

> +/*
> + * trec_print
> + */
> +void trec_print_snapshot(void)
> +{
> +	int i;
> +	struct trec_buffer_struct *cur_buffer;
> +
> +	if (!trec_buffer_snapshot)
> +		trec_snapshot();
> +
> +	cur_buffer = trec_buffer_snapshot->next;
> +	for (i = 0; i < TREC_COUNT; i++) {
> +		struct trec_struct *cur;
> +
> +		for (cur = &cur_buffer->data[0];
> +			cur < cur_buffer->cur;
> +			cur += 1) {
> +			char b[256];
> +			int n;
> +			
> +			n = snprintf(b, sizeof(b), KERN_ERR "t=%20llu pid=%5u tsk=%p v1=%p v2=%p ",
> +				cur->tsc, cur->pid, (void *)cur->tsk, (void *)cur->v1, (void *)cur->v2);
> +			n += snprint_address(b+n, sizeof(b)-n, cur->pc);
> +			printk("%s\n", b);
> +		}
> +		cur_buffer = cur_buffer->next;
> +	}
> +}
> +EXPORT_SYMBOL(trec_print_snapshot);
> +
> +/*
> + * Sysrq support for trec's
> + */
> +#ifdef CONFIG_MAGIC_SYSRQ
> +/*
> + * trec print snapshot handler for sysrq
> + */
> +static void sysrq_handle_trec_print_snapshot(int key, struct tty_struct *tty) 
> +{
> +	trec_print_snapshot();
> +}
> +
> +/*
> + * trec snapshot handler for sysrq
> + */
> +static void sysrq_handle_trec_snapshot(int key, struct tty_struct *tty) 
> +{
> +	trec_snapshot();
> +}
> +
> +static struct sysrq_key_op sysrq_trec_snapshot_op = 
> +{
> +	.handler =	sysrq_handle_trec_snapshot,
> +	.help_msg =	"Trec snapshot(Y)",
> +	.action_msg =	"Trec snapshot",
> +};
> +
> +static struct sysrq_key_op sysrq_trec_print_snapshot_op = 
> +{
> +	.handler =	sysrq_handle_trec_print_snapshot,
> +	.help_msg =	"Print current trec snapshot",

(Z) should be on the help_msg, not on the action_msg.

> +	.action_msg =	"Trec print snapshot(Z)",
> +};
> +
> +/*
> + * Initilize trec sysrq support

      Initialize

> + */
> +static int __init setup_trec_sysrq(void)
> +{
> +	DPK("setup_trec_sysrq y=trec_snapshot z=trec_print_snapshot\n");
> +	register_sysrq_key('y', &sysrq_trec_snapshot_op);
> +	register_sysrq_key('z', &sysrq_trec_print_snapshot_op);
> +	return 0;
> +}
> +__initcall(setup_trec_sysrq);
> +#endif /* CONFIG_MAGIC_SYSRQ */

> +/*
> + * Init routine for the trec device
> + */
> +static int __init trec_device_init(void)
> +{
> +	int 		result;
> +	dev_t 		dev_number = 0;
> +	static struct 	class *trec_class;
> +
> +	DPK("trec_device_init: E\n");
> +
> +	if (major) {
> +		dev_number = MKDEV(major, minor);
> +		result = register_chrdev_region(dev_number, 1, "trec");
> +		DPK("trec_device_init: static major result=%d\n", result);
> +	} else {
> +		result = alloc_chrdev_region(&dev_number, minor, 1, "trec");
> +		major = MAJOR(dev_number);
> +		DPK("trec_device_init: dynamic major result=%d\n", result);
> +	}	
> +
> +	if (result < 0) {
> +		printk(KERN_WARNING "trec: can't get major %d\n", major);
> +		goto err;
> +	}
> +
> +	cdev_init(&trec_dev.cdev, &trec_f_ops);
> +	trec_dev.cdev.owner = THIS_MODULE;
> +	trec_dev.cdev.ops = &trec_f_ops;
> +	
> +	result = cdev_add(&trec_dev.cdev, dev_number, 1);
> +	if (result)
> +	{
> +		DPK("trec_device_init: cdev_add failed\n");
> +		goto err;
> +	}
> +
> +	/*
> +	 * Make a trec class and create the device
> +	 */
> +	trec_class = class_create(THIS_MODULE, "trec");
> +	class_device_create(trec_class, NULL, dev_number, NULL, "trec");
> +
> +	/*
> +	 * If the trec buffers have not been initialized do so
> +	 */
> +	if (trec_buffer_cur == NULL) {
> +		trec_init();
> +	}

Style: no braces on one-statement "blocks".

> +}

> diff --git a/include/asm-i386/trec.h b/include/asm-i386/trec.h
> new file mode 100644
> index 0000000..1de4dc6
> --- /dev/null
> +++ b/include/asm-i386/trec.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (C) 2007 Saville Software, Inc.
> + *
> + * This code may be used for any purpose whatsoever, but
> + * no warranty of any kind is provided.
> + */
> +
> +#ifndef _ASM_I386_TREC_H
> +#define _ASM_I386_TREC_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#if CONFIG_X86_TSC 
> +#include <asm/msr.h>
> +
> +/*
> + * read x86 time stamp counter.
> + */
> +static uint64_t inline rd_tsc(void)
> +{
> +	volatile uint64_t value;
> +
> +	rdtscll(value);
> +
> +	return value;
> +}
> +#else
> +	#define rd_tsc() (0)

We don't typically indent (#if/) #else block contents like this.

> +#endif /* CONFIG_X86_TSC */
> +
> +#endif /* !__ASSEMBLY__ */
> +
> +#endif /* _ASM_I386_TREC_H */

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 3f3e740..db53fdb 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -303,6 +303,13 @@ config STACKTRACE
>  	depends on DEBUG_KERNEL
>  	depends on STACKTRACE_SUPPORT
>  
> +config TREC
> + 	def_bool n
> + 	bool "Trace record support"
> + 	depends on DEBUG_KERNEL
> + 	help
> + 	  Trace records are a light weight tracing facility

                              lightweight   ...    facility.

> +
>  config DEBUG_KOBJECT
>  	bool "kobject debugging"
>  	depends on DEBUG_KERNEL


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
