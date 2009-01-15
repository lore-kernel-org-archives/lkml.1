Return-Path: <linux-kernel-owner+w=401wt.eu-S934805AbZAOXse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805AbZAOXse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935036AbZAOXrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:47:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934906AbZAOXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:47:51 -0500
Date: Thu, 15 Jan 2009 15:47:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nelson <arhuaco@freaks-unidos.net>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       andy@openmoko.com
Subject: Re: [PATCH 2/5] Add group filter
Message-Id: <20090115154721.e003487f.akpm@linux-foundation.org>
In-Reply-To: <20090113233947.26361.68914.stgit@fugue.noexisteestedominiotanlargo.biz>
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
	<20090113233947.26361.68914.stgit@fugue.noexisteestedominiotanlargo.biz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 18:39:47 -0500
Nelson <arhuaco@freaks-unidos.net> wrote:

> From: Nelson Castillo <arhuaco@freaks-unidos.net>
> 
> This filter is useful to reject samples that are not reliable.
> We consider that a sample is not reliable if it deviates from the Majority.
> 
> Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
> ---
> 
>  drivers/input/touchscreen/Kconfig           |   12 +
>  drivers/input/touchscreen/Makefile          |    1 
>  drivers/input/touchscreen/ts_filter_group.c |  221 +++++++++++++++++++++++++++
>  include/linux/ts_filter_group.h             |   39 +++++
>  4 files changed, 273 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/ts_filter_group.c
>  create mode 100644 include/linux/ts_filter_group.h
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index aed3eb0..09f55dd 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -19,6 +19,18 @@ menuconfig TOUCHSCREEN_FILTER
>  	  can be combined in any order in your machine init and the parameters
>  	  for them can also be set there.
>  
> +if TOUCHSCREEN_FILTER
> +
> +config TOUCHSCREEN_FILTER_GROUP
> +	bool "Group Touchscreen Filter"
> +	depends on INPUT_TOUCHSCREEN && TOUCHSCREEN_FILTER
> +	default Y
> +	help
> +	  Say Y here if you want to use the Group touchscreen filter, it
> +	  avoids using atypical samples.
> +
> +endif
> +
>  config TOUCHSCREEN_ADS7846
>  	tristate "ADS7846/TSC2046 and ADS7843 based touchscreens"
>  	depends on SPI_MASTER
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 74ab26f..9ccb21a 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -32,3 +32,4 @@ wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9712)	+= wm9712.o
>  wm97xx-ts-$(CONFIG_TOUCHSCREEN_WM9713)	+= wm9713.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_FILTER)	+= ts_filter.o
> +obj-$(CONFIG_TOUCHSCREEN_FILTER_GROUP)	+= ts_filter_group.o
> diff --git a/drivers/input/touchscreen/ts_filter_group.c b/drivers/input/touchscreen/ts_filter_group.c
> new file mode 100644
> index 0000000..73e3625
> --- /dev/null
> +++ b/drivers/input/touchscreen/ts_filter_group.c
> @@ -0,0 +1,221 @@
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
> + * Copyright (C) 2008 by Openmoko, Inc.
> + * Author: Nelson Castillo <arhuaco@freaks-unidos.net>
> + * All rights reserved.
> + *
> + * This filter is useful to reject samples that are not reliable. We consider
> + * that a sample is not reliable if it deviates form the Majority.
> + *
> + * 1) We collect S samples.
> + *
> + * 2) For each dimension:
> + *
> + *  - We sort the points.
> + *  - Points that are "close enough" are considered to be in the same set.
> + *  - We choose the set with more elements. If more than "threshold"
> + *    points are in this set we use the first and the last point of the set
> + *    to define the valid range for this dimension [min, max], otherwise we
> + *    discard all the points and go to step 1.
> + *
> + * 3) We consider the unsorted S samples and try to feed them to the next
> + *    filter in the chain. If one of the points of each sample
> + *    is not in the allowed range for its dimension, we discard the sample.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/sort.h>
> +#include <linux/ts_filter_group.h>
> +
> +static void ts_filter_group_clear_internal(struct ts_filter_group *tsfg,
> +					   int attempts)
> +{
> +	tsfg->N = 0;
> +	tsfg->tries_left = attempts;
> +}
> +
> +static void ts_filter_group_clear(struct ts_filter *tsf)
> +{
> +	struct ts_filter_group *tsfg = (struct ts_filter_group *)tsf;

Please use container_of() for this, rather than the open-coded cast.

- Improved readability

- Doesn't require that ts_filter_group.tsf be the first member.

- Removes a nastycast.

(Applies to the whole patchset)

> +	ts_filter_group_clear_internal(tsfg, tsfg->config->attempts);
> +
> +	if (tsf->next) /* chain */
> +		(tsf->next->api->clear)(tsf->next);
> +}

Referencing the cahin members will need locking!

> +static struct ts_filter *ts_filter_group_create(struct platform_device *pdev,
> +						void *conf, int count_coords)
> +{
> +	struct ts_filter_group *tsfg;
> +	int i;
> +
> +	BUG_ON((count_coords < 1) || (count_coords > MAX_TS_FILTER_COORDS));

If this BUg triggers then you won't know which comparison caused it. 
Two separate BUG_ON()s will clear that up.

> +	tsfg = kzalloc(sizeof(struct ts_filter_group), GFP_KERNEL);
> +	if (!tsfg)
> +		return NULL;
> +
> +	tsfg->config = (struct ts_filter_group_configuration *)conf;

Unneeded and undesirable cast of void*.  Please check the whole
patchset for this.

> +	tsfg->tsf.count_coords = count_coords;
> +
> +	BUG_ON(tsfg->config->attempts <= 0);
> +
> +	tsfg->samples[0] = kmalloc((2 + count_coords) * sizeof(int) *
> +				   tsfg->config->extent, GFP_KERNEL);
> +	if (!tsfg->samples[0]) {
> +		kfree(tsfg);
> +		return NULL;
> +	}
> +	for (i = 1; i < count_coords; ++i)
> +		tsfg->samples[i] = tsfg->samples[0] + i * tsfg->config->extent;
> +	tsfg->sorted_samples = tsfg->samples[0] + count_coords *
> +			       tsfg->config->extent;
> +	tsfg->group_size = tsfg->samples[0] + (1 + count_coords) *
> +			       tsfg->config->extent;
> +
> +	ts_filter_group_clear_internal(tsfg, tsfg->config->attempts);
> +
> +	printk(KERN_INFO"  Created group ts filter len %d depth %d close %d "
> +			"thresh %d\n", tsfg->config->extent, count_coords,
> +			tsfg->config->close_enough, tsfg->config->threshold);
> +
> +	return &tsfg->tsf;
> +}
> +
> +static void ts_filter_group_destroy(struct platform_device *pdev,
> +				    struct ts_filter *tsf)
> +{
> +	struct ts_filter_group *tsfg = (struct ts_filter_group *)tsf;
> +
> +	kfree(tsfg->samples[0]); /* first guy has pointer from kmalloc */
> +	kfree(tsf);
> +}
> +
> +static void ts_filter_group_scale(struct ts_filter *tsf, int *coords)
> +{
> +	if (tsf->next)
> +		(tsf->next->api->scale)(tsf->next, coords);
> +}

Locking for the list?

Whoa, hang on.  This is sort-of recursive, isn't it?  So if the chain
has 1000 entries, we end up 1000 layers deep in function calls and we
run out of stack and get late night phone calls..

Yes, the limit of the length of the list will save us, but that's
sucky.  It would be trivial to change these functions to simply walk
the list.

> +static int int_cmp(const void *_a, const void *_b)
> +{
> +	const int *a = _a;
> +	const int *b = _b;
> +
> +	if (*a > *b)
> +		return 1;
> +	if (*a < *b)
> +		return -1;
> +	return 0;
> +}
> +
> +static int ts_filter_group_process(struct ts_filter *tsf, int *coords)

This function could do with a few comments.

This reader was surprised to see a call to sort() in a driver!

> +{
> +	struct ts_filter_group *tsfg = (struct ts_filter_group *)tsf;
> +	int n;
> +	int i;
> +	int ret = 0; /* ask for more samples by default */
> +
> +	BUG_ON(tsfg->N >= tsfg->config->extent);
> +
> +	for (n = 0; n < tsf->count_coords; n++)
> +		tsfg->samples[n][tsfg->N] = coords[n];
> +
> +	if (++tsfg->N < tsfg->config->extent)
> +		return 0;	/* we meed more samples */
> +
> +	for (n = 0; n < tsfg->tsf.count_coords; n++) {
> +		int *v = tsfg->sorted_samples;
> +		int ngroups = 0;
> +		int best_size;
> +		int best_idx = 0;
> +		int idx = 0;
> +
> +		memcpy(v, tsfg->samples[n], tsfg->N * sizeof(int));
> +		sort(v, tsfg->N, sizeof(int), int_cmp, NULL);
> +
> +		tsfg->group_size[0] = 1;
> +		for (i = 1; i < tsfg->N; ++i) {
> +			if (v[i] - v[i - 1] <= tsfg->config->close_enough)
> +				tsfg->group_size[ngroups]++;
> +			else
> +				tsfg->group_size[++ngroups] = 1;
> +		}
> +		ngroups++;
> +
> +		best_size = tsfg->group_size[0];
> +		for (i = 1; i < ngroups; i++) {
> +			idx += tsfg->group_size[i - 1];
> +			if (best_size < tsfg->group_size[i]) {
> +				best_size = tsfg->group_size[i];
> +				best_idx = idx;
> +			}
> +		}
> +
> +		if (best_size < tsfg->config->threshold) {
> +			/* this set is not good enough for us */
> +			if (--tsfg->tries_left) {
> +				ts_filter_group_clear_internal
> +					(tsfg, tsfg->tries_left);
> +				return 0; /* ask for more samples */
> +			}
> +			return -1; /* we give up */
> +		}
> +
> +		tsfg->range_min[n] = v[best_idx];
> +		tsfg->range_max[n] = v[best_idx + best_size - 1];
> +	}
> +
> +	for (i = 0; i < tsfg->N; ++i) {
> +		int r;
> +
> +		for (n = 0; n < tsfg->tsf.count_coords; ++n) {
> +			coords[n] = tsfg->samples[n][i];
> +			if (coords[n] < tsfg->range_min[n] ||
> +			    coords[n] > tsfg->range_max[n])
> +				break;
> +		}
> +
> +		if (n != tsfg->tsf.count_coords) /* sample not OK */
> +			continue;
> +
> +		if (tsf->next) {
> +			r = (tsf->next->api->process)(tsf->next, coords);
> +			if (r)  {
> +				ret = r;
> +				break;
> +			}
> +		} else if (i == tsfg->N - 1) {
> +			ret = 1;
> +		}
> +	}
> +
> +	ts_filter_group_clear_internal(tsfg, tsfg->config->attempts);
> +
> +	return ret;
> +}
> +
> +struct ts_filter_api ts_filter_group_api = {
> +	.create = ts_filter_group_create,
> +	.destroy = ts_filter_group_destroy,
> +	.clear = ts_filter_group_clear,
> +	.process = ts_filter_group_process,
> +	.scale = ts_filter_group_scale,
> +};

This could&should have static scope, methinks.

Please check the whole patchset for inappropriately-global symbols.

Perhaps this could be const, too.  Nobody will be modifying it at
runtime!

> diff --git a/include/linux/ts_filter_group.h b/include/linux/ts_filter_group.h
> new file mode 100644
> index 0000000..1e74c8d
> --- /dev/null
> +++ b/include/linux/ts_filter_group.h
> @@ -0,0 +1,39 @@
> +#ifndef __TS_FILTER_GROUP_H__
> +#define __TS_FILTER_GROUP_H__
> +
> +#include <linux/ts_filter.h>
> +
> +/*
> + * Touchscreen group filter.
> + *
> + * Copyright (C) 2008 by Openmoko, Inc.
> + * Author: Nelson Castillo <arhuaco@freaks-unidos.net>
> + *
> + */
> +
> +struct ts_filter_group_configuration {
> +	int extent;
> +	int close_enough;
> +	int threshold;
> +	int attempts;
> +};
> +
> +struct ts_filter_group {
> +	struct ts_filter tsf;
> +	struct ts_filter_group_configuration *config;
> +
> +	int N;		/* How many samples we have */
> +	int *samples[MAX_TS_FILTER_COORDS];	/* the samples, our input */
> +
> +	int *group_size;	/* used for temporal computations */
> +	int *sorted_samples;	/* used for temporal computations */
> +
> +	int range_max[MAX_TS_FILTER_COORDS];	/* max computed ranges */
> +	int range_min[MAX_TS_FILTER_COORDS];	/* min computed ranges */
> +
> +	int tries_left;		/* We finish if we don't get enough samples */
> +};
> +
> +extern struct ts_filter_api ts_filter_group_api;
> +
> +#endif

I find that the best way of communicating your code to its readers is
to painstakingly document the data structures.  Comments which explain
the reason why a field exists, what its role in life is.  What locks
protect it, what its relationship is with other fields.

