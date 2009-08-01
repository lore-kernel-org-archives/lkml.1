Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbZHAHaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbZHAHaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZHAHay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:30:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:48022 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHAHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:30:54 -0400
Date: Sat, 1 Aug 2009 09:30:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ossama Othman <ossama.othman@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Message-ID: <20090801073053.GA30389@merkur.ravnborg.org>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b9e5010..3e36269 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -150,6 +150,18 @@ config ATMEL_SSC
>  
>  	  If unsure, say N.
>  
> +config MRST_RAR_HANDLER
> +	tristate "RAR handler driver for Intel Moorestown platform"
> +	depends on X86
> +	select RAR_REGISTER
> +	default n

n is default - so no need to spell it out.

> +	---help---
> +	  This driver provides a memory management interface to
> +	  restricted access regions available in the Intel Moorestown
> +	  platform.
> +
> +	  If unsure, say N.
> +
>  config MRST_VIB
>  	tristate "vibrator driver for Intel Moorestown platform"
>  	help
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 0238835..a69bc26 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -14,6 +14,8 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
>  obj-$(CONFIG_PHANTOM)		+= phantom.o
>  obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
>  obj-$(CONFIG_MSTWN_POWER_MGMT)	+= moorestown/
> +obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar.o
> +memrar-objs			:= memrar_allocator.o memrar_handler.o

Please use:
+ memrar-y := memrar_allocator.o memrar_handler.o

The foo-objs syntax is deprecated.


> +
> +
> +#include "memrar_allocator.h"
> +#include <linux/slab.h>
> +#include <linux/bug.h>

<linux/...> comes _before_ you own includes.
And an empty line in between.

> +
> +
> +struct memrar_allocator *memrar_create_allocator(unsigned long base,
> +						 size_t capacity,
> +						 size_t block_size)
> +{
> +	struct memrar_allocator *allocator = 0;

It is recommended to separate definition,
and assignment.
So this should look like this:

	struct memrar_allocator *allocator;

	allocator = 0;

> +
> +	/* Validate parameters. */
> +	if (/*
> +	     * Make sure we can allocate the entire memory allocator
> +	     * space.
> +	     */
> +		ULONG_MAX - capacity >= base
> +
> +		/* Zero capacity or block size are obviously invalid. */
> +		&& capacity != 0
> +		&& block_size != 0) {

Very ugly way to comment your if (..) IMHO
Put the comment abvoe the if.

> +		/*
> +		 * There isn't much point in creating a memory
> +		 * allocator that is only capable of holding one block
> +		 * but we'll allow, and issue a diagnostic.
> +		 */
> +		WARN(capacity < block_size * 2,
> +		     "Memory allocator is only large enough to "
> +		     "hold one block.\n");

Try to avoid breaking your printable line.
It is much easier to grep for the line when it is on a sinlge
line.
If you violate the 80 chars per line rule do to this then accept
that grepable lines is better than keeping them 80 or less wide.

This comment applies in several places.

> +			INIT_LIST_HEAD(&allocator->free_list.list);
> +
> +			first_node =
> +				kmalloc(sizeof(*first_node), GFP_KERNEL);

No need to break up this line.

> +			if (first_node != 0) {
> +				/* Full range of blocks is available. */
> +				first_node->begin = base;
> +				first_node->end =
> +					base + allocator->capacity;
> +				list_add(&first_node->list,
> +					 &allocator->free_list.list);
> +			} else {
> +				kfree(allocator);
> +				allocator = 0;
> +			}
> +		}
> +	}
> +
> +	return allocator;
> +}

I'm short on time - so this is the comments for today...

	Sam
