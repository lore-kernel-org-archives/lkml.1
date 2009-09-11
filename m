Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZIKX5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZIKX5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 19:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbZIKX5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 19:57:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172AbZIKX5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 19:57:19 -0400
Date: Fri, 11 Sep 2009 16:55:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: mtosatti@redhat.com, gregkh@suse.de, broonie@opensource.wolfsonmicro.com,
       johannes@sipsolutions.net, avi@qumranet.com, fengguang.wu@intel.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] devmem: introduce size_inside_page()
Message-Id: <20090911165543.d2485e0e.akpm@linux-foundation.org>
In-Reply-To: <20090911023200.649862599@intel.com>
References: <20090911022333.324128054@intel.com>
	<20090911023200.649862599@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 10:23:35 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Introduce size_inside_page() to replace duplicate /dev/mem code.
> 
> Also apply it to /dev/kmem, whose alignment logic was buggy.
> 
> 
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Avi Kivity <avi@qumranet.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |   60 +++++++++++++------------------------------
>  1 file changed, 19 insertions(+), 41 deletions(-)
> 
> --- linux.orig/drivers/char/mem.c
> +++ linux/drivers/char/mem.c
> @@ -35,6 +35,19 @@
>  # include <linux/efi.h>
>  #endif
>  
> +static inline unsigned long size_inside_page(unsigned long start,
> +					     unsigned long size)
> +{
> +	unsigned long sz;
> +
> +	if (-start & (PAGE_SIZE - 1))
> +		sz = -start & (PAGE_SIZE - 1);

What on earth is this doing?  Negating an unsigned number?

Can we get rid of these party tricks and use something more
conventional here?  In a separate patch I guess.

> +	else
> +		sz = PAGE_SIZE;
> +
> +	return min_t(unsigned long, sz, size);

Can use min() here.

> +}

Please have a think about the types.  Should we be using unsigned long,
or size_t?  Which makes more sense?  Which maps better onto reality?

I suspect that the min_t which you inherited was added somewhere
because someone didn't get the types right: int-vs-size_t or something.
If we actually get the types right, this sort of thing goes away.


> @@ -462,10 +451,8 @@ static ssize_t read_kmem(struct file *fi
>  		if (!kbuf)
>  			return -ENOMEM;
>  		while (count > 0) {
> -			int len = count;
> +			int len = size_inside_page(p, count);

int?


