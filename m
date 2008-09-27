Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYI0HQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYI0HQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 03:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYI0HQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 03:16:48 -0400
Received: from gw.goop.org ([64.81.55.164]:34556 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYI0HQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 03:16:48 -0400
Message-ID: <48DDDDDE.7060707@goop.org>
Date: Sat, 27 Sep 2008 00:16:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] ioremap sanity check to catch mapping requests exceeding
 the BAR sizes
References: <20080926014334.GF15609@linux-os.sc.intel.com>
In-Reply-To: <20080926014334.GF15609@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> +int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
> +{
> +	struct resource *p = &iomem_resource;
> +	int err = 0;
> +	loff_t l;
> +
> +	read_lock(&resource_lock);
> +	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
> +		/*
> +		 * We can probably skip the resources with out
> +		 * IORESOURCE_IO attribute?
>   

Any attempt to use ioremap on memory is a bug, so you should warn about
that too.

> +		 */
> +		if (p->start >= addr + size)
> +			continue;
> +		if (p->end < addr)
> +			continue;
> +		if (p->start <= addr && (p->end >= addr + size - 1))
> +			continue;
> +		printk(KERN_WARNING "resource map sanity check conflict "
> +		       " 0x%llx 0x%llx 0x%llx 0x%llx %s\n",
> +		       addr, addr + size - 1, p->start, p->end, p->name);
> +		err = -1;
> +		break;
> +	}
> +	read_unlock(&resource_lock);
> +
> +	return err;

    J
