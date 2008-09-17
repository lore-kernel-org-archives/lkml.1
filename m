Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIQD1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIQD1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 23:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYIQD1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 23:27:10 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50490 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYIQD1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 23:27:09 -0400
Date: Tue, 16 Sep 2008 23:27:08 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, davem@davemloft.net,
       arjan@linux.intel.com
Subject: Re: warn: Turn the netdev timeout WARN_ON() into a WARN()
Message-ID: <20080917032708.GA8431@havoc.gtf.org>
References: <200809170259.m8H2xClI020907@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809170259.m8H2xClI020907@hera.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 02:59:12AM +0000, Linux Kernel Mailing List wrote:
>     
>     this patch turns the netdev timeout WARN_ON_ONCE() into a WARN_ONCE(),
>     so that the device and driver names are inside the warning message.
>     This helps automated tools like kerneloops.org to collect the data
>     and do statistics, as well as making it more likely that humans
>     cut-n-paste the important message as part of a bugreport.
>     
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>  
> +#define WARN_ONCE(condition, format...)	({			\
> +	static int __warned;					\
> +	int __ret_warn_once = !!(condition);			\
> +								\
> +	if (unlikely(__ret_warn_once))				\
> +		if (WARN(!__warned, format)) 			\
> +			__warned = 1;				\
> +	unlikely(__ret_warn_once);				\
> +})
> +
>  #define WARN_ON_RATELIMIT(condition, state)			\
>  		WARN_ON((condition) && __ratelimit(state))
>  
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 9634091..ec0a083 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -215,10 +215,9 @@ static void dev_watchdog(unsigned long arg)
>  			    time_after(jiffies, (dev->trans_start +
>  						 dev->watchdog_timeo))) {
>  				char drivername[64];
> -				printk(KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
> +				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
>  				       dev->name, netdev_drivername(dev, drivername, 64));
>  				dev->tx_timeout(dev);
> -				WARN_ON_ONCE(1);


hrm, am I misunderstanding?

AFAICS, this change means the user is no longer notified [after
the first time] of a condition they really need to know about --
a hardware or driver bug.

These conditions can occur many hours or days apart, and the admin
needs to know EACH time it occurs, because it is a major networking
event, generally leading to a complete reset of the entire hardware.

And quite honestly, the backtrace is not useful (yes, even the one
that existing previously)...  THINK for a second.  The backtrace
is going to look exactly the same, since it is a timer-triggered
dev_watchdog() call.

NETDEV WATCHDOG timeouts are not easily fixable errors like lockdep
warnings, and the admin really does need to see each one.

Unless I am missing something, (1) this patch should be reverted,
and in additional, (2) I recommend removing the WARN_ON_ONCE()
because the backtrace is not helpful.

	Jeff



