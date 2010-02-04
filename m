Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab0BDBWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 20:22:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932724Ab0BDBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 20:22:07 -0500
Date: Wed, 3 Feb 2010 17:21:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Message-Id: <20100203172147.2411966d.akpm@linux-foundation.org>
In-Reply-To: <201002040150.26503.rjw@sisk.pl>
References: <alpine.LFD.2.00.1001221841490.2266@localhost>
	<201002032334.37198.rjw@sisk.pl>
	<20100203150803.5a4b37fe.akpm@linux-foundation.org>
	<201002040150.26503.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 01:50:26 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -76,6 +76,30 @@ unsigned long totalreserve_pages __read_
>  int percpu_pagelist_fraction;
>  gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
>  
> +/*
> + * The following functions are used by the suspend/hibernate code to temporarily
> + * change gfp_allowed_mask in order to avoid using I/O during memory allocations
> + * while devices are suspended.  To avoid races with the suspend/hibernate code,
> + * they should always be called with pm_mutex held (gfp_allowed_mask also should
> + * only be modified with pm_mutex held, unless the suspend/hibernate code is
> + * guaranteed not to run in parallel with that modification).
> + */
> +
> +void set_gfp_allowed_mask(gfp_t mask)
> +{
> +	WARN_ON(!mutex_is_locked(&pm_mutex));
> +	gfp_allowed_mask = mask;
> +}
> +
> +gfp_t clear_gfp_allowed_mask(gfp_t mask)
> +{
> +	gfp_t ret = gfp_allowed_mask;
> +
> +	WARN_ON(!mutex_is_locked(&pm_mutex));
> +	gfp_allowed_mask &= ~mask;
> +	return ret;
> +}

Maybe put an ifdef CONFIG_foo around these so they don't get included
when they're unneeded?

