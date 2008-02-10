Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbYBJFAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbYBJFAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 00:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYBJE7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 23:59:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYBJE7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 23:59:53 -0500
Date: Sat, 9 Feb 2008 23:59:52 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ipvs: Cleanup sync daemon code
Message-ID: <20080210045952.GA8255@infradead.org>
References: <Pine.LNX.4.64.0802100029150.15729@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802100029150.15729@titan.stealer.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 12:38:11AM +0100, Sven Wegener wrote:
>  struct ip_vs_sync_thread_data {
> -	struct completion *startup;
> +	struct completion *startup; /* set to NULL once completed */

This is not needed anmore.  kthread_run guarantees that the newly
creates thread is run before returning to the caller.

> +/* wait queue for master sync daemon */
> +static DECLARE_WAIT_QUEUE_HEAD(sync_master_wait);

I don't think you need this one either.  You can use wake_up_process
on the task_struct pointer instead.

>  	spin_lock(&ip_vs_sync_lock);
>  	list_add_tail(&sb->list, &ip_vs_sync_queue);
> +	if (++ip_vs_sync_count == 10)
> +		wake_up_interruptible(&sync_master_wait);
>  	spin_unlock(&ip_vs_sync_lock);
>  }

> -static int sync_thread(void *startup)
> +static int sync_thread(void *data)

Btw, it might make sense to remove sync_thread and just call the
master and backup threads directly.
> +void __init ip_vs_sync_init(void)
> +{
> +	/* set up multicast address */
> +	mcast_addr.sin_family = AF_INET;
> +	mcast_addr.sin_port = htons(IP_VS_SYNC_PORT);
> +	mcast_addr.sin_addr.s_addr = htonl(IP_VS_SYNC_GROUP);
>  }

Why can't this be initialized at compile time by:

static struct sockaddr_in mcast_addr = {
	.sin_family		= AF_INET,
	.sin_port		= htons(IP_VS_SYNC_PORT),
	.sin_addr.s_addr	= htonl(IP_VS_SYNC_GROUP),
}

(the hton* might need __constant_hton* also I'm not sure without trying)

