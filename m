Return-Path: <linux-kernel-owner+w=401wt.eu-S1767150AbXEBWqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767150AbXEBWqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767151AbXEBWqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:46:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767150AbXEBWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:46:06 -0400
Date: Wed, 2 May 2007 15:45:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
Subject: Re: [PATCH] lib/hexdump
Message-Id: <20070502154557.b463c9c3.akpm@linux-foundation.org>
In-Reply-To: <20070502153556.3c995de7.randy.dunlap@oracle.com>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 15:35:56 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Based on ace_dump_mem() from Grant Likely for the Xilinx 
> SystemACE CompactFlash interface.
> 
> Add hex_dumper() to lib/hexdump.c and linux/kernel.h.
> 
> This patch adds the function 'hex_dumper' which can be used to perform a 
> hex + ASCII dump of data to syslog, in an easily viewable format, thus
> providing a common text hex dump format.
> 
> It does not provide a hexdump_to_buffer() function.
> if someone needs that, we'll have to add it.
> 
> Example usage:
> 	hex_dumper(KERN_DEBUG, data, length);
> 

Fair enough.  This is the sort of thing one could easily overdesign ;)

> 
>  include/linux/kernel.h |    1 
>  lib/Makefile           |    2 -
>  lib/hexdump.c          |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.21-git4.orig/include/linux/kernel.h
> +++ linux-2.6.21-git4/include/linux/kernel.h
> @@ -201,6 +201,7 @@ extern enum system_states {
>  #define TAINT_USER			(1<<6)
>  
>  extern void dump_stack(void);
> +extern void hex_dumper(const char *level, void *base, int len);
>  
>  #ifdef DEBUG
>  /* If you are writing a driver, please use dev_dbg instead */
> --- linux-2.6.21-git4.orig/lib/Makefile
> +++ linux-2.6.21-git4/lib/Makefile
> @@ -5,7 +5,7 @@
>  lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 rbtree.o radix-tree.o dump_stack.o \
>  	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
> -	 sha1.o irq_regs.o reciprocal_div.o
> +	 sha1.o irq_regs.o reciprocal_div.o hexdump.o
>  
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> --- /dev/null
> +++ linux-2.6.21-git4/lib/hexdump.c
> @@ -0,0 +1,51 @@
> +/*
> + * lib/hexdump.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation. See README and COPYING for
> + * more details.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/ctype.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +/**
> + * hex_dumper - print a text hex dump to syslog for a binary blob of data
> + * @level: kernel log level (e.g. KERN_DEBUG)
> + * @buf: data blob to dump
> + * @len: number of bytes in the @buf
> + *
> + * Given a buffer of u8 data, hex_dumper() will print a hex + ASCII dump
> + * to the kernel log at the specified kernel log level.
> + *
> + * E.g.:
> + *	hex_dumper(KERN_DEBUG, frame->data, frame->len);
> + *
> + * Prints the offsets of the block of memory, not addresses:
> + * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO

But I suspect it should be printing the addresses, for many callers.

In which case we'd need a separate arg (base_address or somesuch) so that
callers who want to show real virtual addresses can pass in `base' and
callers who want to display relative offsets can pass in 0.

Which implies that the address will need to be printed as a 16-digit number
on 64-bit kernels.

> + */
> +void hex_dumper(const char *level, void *base, int len)
> +{
> +	const u8 *ptr = base;
> +	int i, j;
> +
> +	for (i = 0; i < len; i += 16) {
> +		printk("%s%.8x:", level, i);
> +		for (j = 0; (j < 16) && (i + j) < len; j++) {
> +			if (!(j % 4))
> +				printk(" ");
> +			printk("%.2x", ptr[i + j]);
> +		}
> +		printk("-");
> +		for (j = 0; (j < 16) && (i + j) < len; j++) {
> +			printk("%c", isprint(ptr[i + j]) ? ptr[i + j] : '.');
> +			if (j == 7)
> +				printk(" ");
> +		}
> +		printk("\n");
> +	}
> +}
> +EXPORT_SYMBOL(hex_dumper);
