Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZJASgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZJASgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZJASgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:36:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43030 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbZJASgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:36:51 -0400
Date: Thu, 1 Oct 2009 20:36:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
Message-ID: <20091001183655.GA9995@atrey.karlin.mff.cuni.cz>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254384558-1018-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Freezing isn't exactly the most latency sensitive operation and
> there's no reason to burn cpu cycles and power waiting for it to
> complete.  msleep(10) instead of yield().  This should improve
> reliability of emergency hibernation.

i don't see how it improves reliability, but its probably ok.

Well... for hibernation anyway. I can imagine cgroup users where
freeze is so fast that this matters. rjw cc-ed.		pavel

> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/power/process.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index cc2e553..9d26a0a 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -41,7 +41,7 @@ static int try_to_freeze_tasks(bool sig_only)
>  	do_gettimeofday(&start);
>  
>  	end_time = jiffies + TIMEOUT;
> -	do {
> +	while (true) {
>  		todo = 0;
>  		read_lock(&tasklist_lock);
>  		do_each_thread(g, p) {
> @@ -62,10 +62,15 @@ static int try_to_freeze_tasks(bool sig_only)
>  				todo++;
>  		} while_each_thread(g, p);
>  		read_unlock(&tasklist_lock);
> -		yield();			/* Yield is okay here */
> -		if (time_after(jiffies, end_time))
> +		if (!todo || time_after(jiffies, end_time))
>  			break;
> -	} while (todo);
> +
> +		/*
> +		 * We need to retry.  There's no reason to be
> +		 * over-anxious about it and waste power.
> +		 */
> +		msleep(10);
> +	}
>  
>  	do_gettimeofday(&end);
>  	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
