Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab0BCUJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:09:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab0BCUJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:09:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=L4OmqxyJIBIA:10 a=7U3hwN5JcxgA:10 a=20KFwNOVAAAA:8 a=guwLQvUHReTW3fpXwAEA:9 a=i5Hm69lMh7MilcQ9GKt-OYb0TwUA:4 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH] vmscan: balance local_irq_disable() and
 local_irq_enable()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org
In-Reply-To: <1265226801-6199-2-git-send-email-jkacur@redhat.com>
References: <1265226801-6199-1-git-send-email-jkacur@redhat.com>
	 <1265226801-6199-2-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 15:09:06 -0500
Message-ID: <1265227746.24386.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

t On Wed, 2010-02-03 at 20:53 +0100, John Kacur wrote:
> Balance local_irq_disable() and local_irq_enable() as well as
> spin_lock_irq() and spin_lock_unlock_irq
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  mm/vmscan.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c26986c..b895025 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1200,8 +1200,9 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
>  		if (current_is_kswapd())
>  			__count_vm_events(KSWAPD_STEAL, nr_freed);
>  		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
> +		local_irq_enable();
>  
> -		spin_lock(&zone->lru_lock);
> +		spin_lock_irq(&zone->lru_lock);
>  		/*
>  		 * Put back any unfreeable pages.
>  		 */


The above looks wrong. I don't know the code, but just by looking at
where the locking and interrupts are, I can take a guess.

Lets add a little more of the code:

                local_irq_disable();
                if (current_is_kswapd())
                        __count_vm_events(KSWAPD_STEAL, nr_freed);
                __count_zone_vm_events(PGSTEAL, zone, nr_freed);

                spin_lock(&zone->lru_lock);
                /*

I'm guessing the __count_zone_vm_events and friends need interrupts
disabled here, probably due to per cpu stuff. But if you enable
interrupts before the spin_lock() you may let an interrupt come in and
invalidate what was done above it.

So no, I do not think enabling interrupts here is a good thing.

-- Steve


