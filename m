Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbZFAV6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbZFAV6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbZFAVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:55:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581AbZFAVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:55:04 -0400
Date: Mon, 1 Jun 2009 14:55:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 1/4] dma-debug: add variables and checks for driver
 filter
Message-Id: <20090601145502.0653f979.akpm@linux-foundation.org>
In-Reply-To: <1243523971-12681-2-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
	<1243523971-12681-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 17:19:28 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the state variables for the driver filter and a function
> to check if the filter is enabled and matches to the current device. The
> check is built into the err_printk function.
> 

The path by which lib/dma-debug.c patches get into mainline seems to
be largely random.  Is it a dwmw2 tree?  An Ingo tree?  A Joerg tree? -mm?


> @@ -128,9 +137,47 @@ static inline void dump_entry_trace(struct dma_debug_entry *entry)
>  #endif
>  }
>  
> +static inline bool driver_filter(struct device *dev)
> +{
> +	/* driver filter off */
> +	if (likely(!current_driver_name[0]))
> +		return true;
> +
> +	/* driver filter on and initialized */
> +	if (current_driver && dev->driver == current_driver)
> +		return true;
> +
> +	/* driver filter on but not yet initialized */
> +	if (!current_driver && current_driver_name[0]) {
> +		struct device_driver *drv = get_driver(dev->driver);
> +		unsigned long flags;
> +		bool ret = false;
> +
> +		if (!drv)
> +			return false;
> +
> +		/* lock to protect against change of current_driver_name */
> +		read_lock_irqsave(&driver_name_lock, flags);
> +
> +		if (drv->name &&
> +		    strncmp(current_driver_name, drv->name, 63) == 0) {
> +			current_driver = drv;
> +			ret = true;
> +		}
> +
> +		read_unlock_irqrestore(&driver_name_lock, flags);
> +		put_driver(drv);
> +
> +		return ret;
> +	}
> +
> +	return false;
> +}
> +
>  #define err_printk(dev, entry, format, arg...) do {		\
>  		error_count += 1;				\
> -		if (show_all_errors || show_num_errors > 0) {	\
> +		if (driver_filter(dev) &&			\
> +		    (show_all_errors || show_num_errors > 0)) {	\
>  			WARN(1, "%s %s: " format,		\
>  			     dev_driver_string(dev),		\
>  			     dev_name(dev) , ## arg);		\

The patch attempts to inline the very large driver_filter() into every
err_printk() callsite.  That's not at all desirable!

