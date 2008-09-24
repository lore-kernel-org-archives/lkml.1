Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYIXFzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYIXFzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYIXFzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:55:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbYIXFzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:55:38 -0400
Date: Tue, 23 Sep 2008 22:54:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/3] corruption check: run the corruption checks from a
 work queue
Message-Id: <20080923225452.e93186c0.akpm@linux-foundation.org>
In-Reply-To: <20080923215413.0da97008@infradead.org>
References: <20080923215335.05678239@infradead.org>
	<20080923215413.0da97008@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 21:54:13 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 22 Sep 2008 13:42:15 -0700
> Subject: [PATCH] corruption check: run the corruption checks from a work queue
> 
> the corruption checks are better off run from a work queue; there's nothing
> time critical about them and this way the amount of interrupt-context work
> is reduced.
> 
> ...
>
> +int start_periodic_check_for_corruption(void)
>  {
>  	if (!memory_corruption_check || corruption_check_period == 0)
> -		return;
> +		return 0;
>  
>  	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
>  	       corruption_check_period);
>  
>  	init_timer(&periodic_check_timer);
>  	periodic_check_timer.function = &periodic_check_for_corruption;
> -	periodic_check_for_corruption(0);
> +	mod_timer(&periodic_check_timer,
> +			round_jiffies(jiffies + corruption_check_period*HZ));
> +	return 0;
>  }

Could use schedule_delayed_work() and zap the timer altogether?


