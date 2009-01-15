Return-Path: <linux-kernel-owner+w=401wt.eu-S935190AbZAOXr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935190AbZAOXr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765895AbZAOXrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:47:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765785AbZAOXrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:47:37 -0500
Date: Thu, 15 Jan 2009 15:47:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nelson <arhuaco@freaks-unidos.net>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       andy@openmoko.com
Subject: Re: [PATCH 1/5] Add touchscreen filter API
Message-Id: <20090115154716.63de462f.akpm@linux-foundation.org>
In-Reply-To: <20090113233939.26361.18138.stgit@fugue.noexisteestedominiotanlargo.biz>
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
	<20090113233939.26361.18138.stgit@fugue.noexisteestedominiotanlargo.biz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 18:39:39 -0500
Nelson <arhuaco@freaks-unidos.net> wrote:

> From: Nelson Castillo <arhuaco@freaks-unidos.net>
> 
> Generic filters are not useful by themselves. They define an API that
> actual filters have to implement.
> 
> Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
> ---
> 
>  drivers/input/touchscreen/Kconfig     |    8 ++++
>  drivers/input/touchscreen/Makefile    |    1 +
>  drivers/input/touchscreen/ts_filter.c |   64 +++++++++++++++++++++++++++++++++
>  include/linux/ts_filter.h             |   56 +++++++++++++++++++++++++++++
>  4 files changed, 129 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/ts_filter.c
>  create mode 100644 include/linux/ts_filter.h
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 3d1ab8f..aed3eb0 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -11,6 +11,14 @@ menuconfig INPUT_TOUCHSCREEN
>  
>  if INPUT_TOUCHSCREEN
>  
> +menuconfig TOUCHSCREEN_FILTER
> +	boolean "Touchscreen Filtering"
> +	depends on INPUT_TOUCHSCREEN
> +	help
> +	  Select this to include kernel touchscreen filter support.  The filters
> +	  can be combined in any order in your machine init and the parameters
> +	  for them can also be set there.
> +
>  config TOUCHSCREEN_ADS7846
>  	tristate "ADS7846/TSC2046 and ADS7843 based touchscreens"
>  	depends on SPI_MASTER
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 15cf290..74ab26f 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -31,3 +31,4 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9705)	+= wm9705.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
> +obj-$(CONFIG_TOUCHSCREEN_FILTER)	+= ts_filter.o
> diff --git a/drivers/input/touchscreen/ts_filter.c b/drivers/input/touchscreen/ts_filter.c
> new file mode 100644
> index 0000000..1508388
> --- /dev/null
> +++ b/drivers/input/touchscreen/ts_filter.c

Confused.  Nothing appears to use the two functions which this file adds.

> @@ -0,0 +1,64 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + * Copyright (c) 2008 Andy Green <andy@openmoko.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/ts_filter.h>
> +
> +int ts_filter_create_chain(struct platform_device *pdev,
> +			   struct ts_filter_api **api, void **config,
> +			   struct ts_filter **list, int count_coords)
> +{
> +	int count = 0;
> +	struct ts_filter *last = NULL;
> +
> +	if (!api)
> +		return 0;
> +
> +	while (*api && count < MAX_TS_FILTER_CHAIN) {

Why does MAX_TS_FILTER_CHAIN exist?  Why impose limits?

> +		*list = ((*api)->create)(pdev, *config++, count_coords);
> +		if (!*list) {
> +			printk(KERN_ERR "Filter %d failed init\n", count);
> +			return count;
> +		}
> +		(*list)->api = *api++;
> +		if (last)
> +			last->next = *list;
> +		last = *list;
> +		list++;
> +		count++;
> +	}
> +
> +	return count;
> +}
> +EXPORT_SYMBOL_GPL(ts_filter_create_chain);
> +
> +void ts_filter_destroy_chain(struct platform_device *pdev,
> +			     struct ts_filter **list)
> +{
> +	struct ts_filter **first;
> +	int count = 0;
> +
> +	first = list;
> +	while (*list && count++ < MAX_TS_FILTER_CHAIN) {
> +		((*list)->api->destroy)(pdev, *list);
> +		list++;

This is wrong, isn't it?  It's treating the list as an array.  Should
advance to list->next.

> +	}
> +	*first = NULL;
> +}
> +EXPORT_SYMBOL_GPL(ts_filter_destroy_chain);

The list should be proected by a lock to prevent corruption.  A single
mutex which is static to this file should suffice.

> diff --git a/include/linux/ts_filter.h b/include/linux/ts_filter.h
> new file mode 100644
> index 0000000..1671044
> --- /dev/null
> +++ b/include/linux/ts_filter.h

I think it would be better to put all the header files from this
patchset into drivers/input/touchscreen/

> @@ -0,0 +1,56 @@
> +#ifndef __TS_FILTER_H__
> +#define __TS_FILTER_H__
> +
> +/*
> + * touchscreen filter
> + *
> + * (c) 2008 Andy Green <andy@openmoko.com>
> + */
> +
> +#include <linux/platform_device.h>
> +
> +#define MAX_TS_FILTER_CHAIN		4  /* max filters you can chain up */
> +#define MAX_TS_FILTER_COORDS		3  /* X, Y and Z (pressure) */
> +
> +struct ts_filter;
> +
> +/* operations that a filter can perform
> + */
> +struct ts_filter_api {
> +	struct ts_filter * (*create)(struct platform_device *pdev, void *config,
> +				     int count_coords);
> +	void (*destroy)(struct platform_device *pdev, struct ts_filter *filter);
> +	void (*clear)(struct ts_filter *filter);
> +	int (*process)(struct ts_filter *filter, int *coords);
> +	void (*scale)(struct ts_filter *filter, int *coords);
> +};
> +
> +/* this is the common part of all filters, the result
> + * we use this type as an otherwise opaque handle on to
> + * the actual filter.  Therefore you need one of these
> + * at the start of your actual filter struct
> + */

This layout, please:

/*
 * blah
 * blah
 */

The first sentence needs capitalisation and a grammar fix.

The second sentence needs a "."!

> +struct ts_filter {
> +	struct ts_filter *next; /* next in chain */
> +	struct ts_filter_api *api; /* operations to use for this object */
> +	int count_coords;
> +	int coords[MAX_TS_FILTER_COORDS];
> +};
> +
> +/*
> + * helper to create a filter chain from array of API pointers and
> + * array of config ints... leaves pointers to created filters in list
> + * array and fills in ->next pointers to create the chain
> + */
> +
> +extern int ts_filter_create_chain(struct platform_device *pdev,
> +				  struct ts_filter_api **api, void **config,
> +				  struct ts_filter **list, int count_coords);
> +
> +/* helper to destroy a whole chain from the list of filter pointers */
> +
> +extern void ts_filter_destroy_chain(struct platform_device *pdev,
> +				    struct ts_filter **list);
> +
> +#endif

