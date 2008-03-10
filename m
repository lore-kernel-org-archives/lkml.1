Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYCJQKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYCJQKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYCJQK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:10:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29168 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYCJQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:10:27 -0400
Date: Mon, 10 Mar 2008 08:51:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] [1/3] isolate ratelimit from printk.c for other use
Message-Id: <20080310085132.5c182ee9.randy.dunlap@oracle.com>
In-Reply-To: <20080310063115.GA6745@darkstar.te-china.tietoenator.com>
References: <20080310063115.GA6745@darkstar.te-china.tietoenator.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 14:31:15 +0800 Dave Young wrote:

> This series include 3 patch, they need to be applied in order.
> 1) isolate ratelimit from printk.c
> 2) add WARN_ON_SECS macro
> 3) use WARN_ON_SECS macro in rcupreempt.h
> 
> Please give some comments and suggestions for improvement, thanks.
> 
> ---
> 
> Due to the rcupreempt.h WARN_ON trigged, I got 2G syslog file. For some
> serious complaining of kernel, we need repeat the warnings, so here I
> isolate the ratelimit part of printk.c to a standalone file.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> include/linux/kernel.h |    1 
> kernel/printk.c        |   26 ------------------------
> lib/Makefile           |    2 -
> lib/ratelimit.c        |   51 +++++++++++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 54 insertions(+), 26 deletions(-)

> diff -uprN linux/lib/ratelimit.c linux.new/lib/ratelimit.c
> --- linux/lib/ratelimit.c	1970-01-01 07:00:00.000000000 +0700
> +++ linux.new/lib/ratelimit.c	2008-03-10 13:42:46.000000000 +0800
> @@ -0,0 +1,51 @@
> +/*
> + * ratelimit.c - Do something with rate limit.
> + *
> + * Isolated from kernel/printk.c by Dave Young <hidave.darkstar@gmail.com>
> + *
> + * This file is released under the GPLv2.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/jiffies.h>
> +#include <linux/module.h>
> +
> +/*
> + * __ratelimit - rate limiting
> + * @ratelimit_jiffies: minimum time in jiffies between too callbacks

s/too/two/

> + * @ratelimit_burst: number of callbacks we do before ratelimiting
> + *
> + * This enforces a rate limit: not more than @ratelimit_burst callbacks
> + * in every ratelimit_jiffies
> + */
> +int __ratelimit(int ratelimit_jiffies, int ratelimit_burst)
> +{
> +	static DEFINE_SPINLOCK(ratelimit_lock);
> +	static unsigned toks = 10 * 5 * HZ;
> +	static unsigned long last_msg;
> +	static int missed;
> +	unsigned long flags;
> +	unsigned long now = jiffies;
> +
> +	spin_lock_irqsave(&ratelimit_lock, flags);
> +	toks += now - last_msg;
> +	last_msg = now;
> +	if (toks > (ratelimit_burst * ratelimit_jiffies))
> +		toks = ratelimit_burst * ratelimit_jiffies;
> +	if (toks >= ratelimit_jiffies) {
> +		int lost = missed;
> +
> +		missed = 0;
> +		toks -= ratelimit_jiffies;
> +		spin_unlock_irqrestore(&ratelimit_lock, flags);
> +		if (lost)
> +			printk(KERN_WARNING "__ratelimit: %d messages"
> +				" suppressed.\n", lost);

Would be better not to split the string, e.g.:

			printk(KERN_WARNING "%s: %d messages suppressed\n",
				__func__, lost);

> +		return 1;
> +	}
> +	missed++;
> +	spin_unlock_irqrestore(&ratelimit_lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL(__ratelimit);

---
~Randy
