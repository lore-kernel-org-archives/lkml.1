Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475Ab0AWBvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0AWBvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310Ab0AWBvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:51:39 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:6629 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0AWBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:51:39 -0500
Subject: Re: [RFC PATCH] net: NETDEV WATCHDOG should print something every
 time
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100122214333.14389.86017.stgit@jbrandeb-ich9b.jf.intel.com>
References: <20100122214333.14389.86017.stgit@jbrandeb-ich9b.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Sat, 23 Jan 2010 01:51:32 +0000
Message-ID: <1264211492.373.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2010 01:51:42.0406 (UTC) FILETIME=[9C767E60:01CA9BCE]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17146.005
X-TM-AS-Result: No--17.571700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 13:43 -0800, Jesse Brandeburg wrote:
> commit 5337407c changed NETDEV WATCHDOG messages into a message
> that will only print once per driver load.  This removed a significant amount
> of information from an admin who might be missing that his system was having
> NETDEV WATCHDOGs, esp since there is no other global counter available to
> count these events.
> 
> simply check the __warned flag and print a simple version of the message
> without the full stack dump if the (kerneloops related) WARN_ON_ONCE has
> already logged the hardware type and one hang.
[...]
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 18c435d..ad810a0 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -132,6 +132,11 @@ extern void warn_slowpath_null(const char *file, const int line);
>  	unlikely(__ret_warn_once);				\
>  })
>  
> +#define WARNED_ALREADY() ({					\
> +	static bool __warned;					\
> +	unlikely(__warned);					\
> +})

It is indeed unlikely that __warned will be true, given there is no
statement to set it...

I think this could be a generic macro:

#define first_time() ({						\
	static bool __been_here;				\
	__been_here++;						\
})

>  #define WARN_ON_RATELIMIT(condition, state)			\
>  		WARN_ON((condition) && __ratelimit(state))
>  
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 5173c1e..28fb14f 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -251,8 +251,13 @@ static void dev_watchdog(unsigned long arg)
>  
>  			if (some_queue_timedout) {
>  				char drivername[64];
> -				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
> -				       dev->name, netdev_drivername(dev, drivername, 64), i);
> +				/* FIXME: is there a way to const char string[] = "NETDEV WATCHDOG..." */
[...]

Maybe you could, you know, just write that declaration... though a
'static' in front wouldn't hurt.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

