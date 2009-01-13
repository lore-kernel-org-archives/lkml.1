Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZAMQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZAMQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZAMQvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:51:25 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:35933 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754008AbZAMQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:51:24 -0500
Date: Tue, 13 Jan 2009 16:51:15 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] async: Handle kthread_run() return codes.
Message-ID: <20090113165115.GR12431@fluff.org.uk>
References: <20090113174304.2186532c@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113174304.2186532c@gondolin>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 05:43:04PM +0100, Cornelia Huck wrote:
> If we fail to create the manager thread, fall back to non-fastboot.
> If we fail to create an async thread, try again when the manager
> thread runs again.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> ---
>  kernel/async.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.orig/kernel/async.c
> +++ linux-2.6/kernel/async.c
> @@ -315,11 +315,14 @@ static int async_manager_thread(void *un
>  		ec = atomic_read(&entry_count);
>  
>  		while (tc < ec && tc < MAX_THREADS) {

why not add the following to stop the wrapping of kthread_run:

+   	    		struct task_struct *kt;
			kt = kthread_run(async_thread, NULL, "async/%i", tc);
			if (IS_ERR(kt))
				goto schedule;

also, I belive the goto isn't necessary, just break out of the while

			if (IS_ERR(kt))
				break;
				
> -			kthread_run(async_thread, NULL, "async/%i", tc);
> +			if (IS_ERR(kthread_run(async_thread, NULL, "async/%i",
> +					       tc)))
> +				/* Try again later. */
> +				goto schedule;
>  			atomic_inc(&thread_count);
>  			tc++;
>  		}
> -
> +schedule:
>  		schedule();
>  	}
>  	remove_wait_queue(&async_new, &wq);
> @@ -330,7 +333,9 @@ static int async_manager_thread(void *un
>  static int __init async_init(void)
>  {
>  	if (async_enabled)
> -		kthread_run(async_manager_thread, NULL, "async/mgr");
> +		if (IS_ERR(kthread_run(async_manager_thread, NULL,
> +				       "async/mgr")))
> +			async_enabled = 0;
>  	return 0;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
