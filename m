Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYIZHjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYIZHjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYIZHjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:39:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbYIZHjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:39:22 -0400
Date: Fri, 26 Sep 2008 09:39:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jbarnes@virtuousgeek.org, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch] ioremap sanity check to catch mapping requests
	exceeding the BAR sizes
Message-ID: <20080926073902.GA30041@elte.hu>
References: <20080926014334.GF15609@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926014334.GF15609@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> [patch] ioremap sanity check to catch mapping requests exceeding the BAR sizes
> 
> Go through the iomem resource tree to check if any of the ioremap() requests
> span more than any slot in the iomem resource tree and do a WARN_ON() if we hit
> this check.
> 
> This will raise a red-flag, if some driver is mapping more than what
> is needed. And hopefully identify possible corruptions much earlier.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

applied to tip/core/resources, thanks Suresh.

one question:

> +	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
> +		/*
> +		 * We can probably skip the resources with out
> +		 * IORESOURCE_IO attribute?
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

i think all the checks you added are precise to the byte and you allow 
all the sensible ioremaps: which nest fully inside a single resource - 
and you reject all the other partial overlap or multiple overlap 
scenarios.

One potential thing to check for would be whether addr+size overlaps a 
4GB boundary? That would almost always be a bug, and it could also cause 
problems with the checks above if resource_t is 32 bits. The ioremap 
code should already prevent it though.

	Ingo
