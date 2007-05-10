Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbXEJKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbXEJKuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXEJKui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:50:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256AbXEJKuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:50:37 -0400
Date: Thu, 10 May 2007 03:49:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] ll_rw_blk: temporarily enable max_segments
 tweaking
Message-Id: <20070510034926.7ae29119.akpm@linux-foundation.org>
In-Reply-To: <11787925162730-git-send-email-jens.axboe@oracle.com>
References: <11787925152319-git-send-email-jens.axboe@oracle.com>
	<11787925162730-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 12:21:54 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> Expose this setting for now, so that users can play with enabling
> large commands without defaulting it to on globally.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/ll_rw_blk.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> index b01a5f2..cf05396 100644
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -3930,7 +3930,22 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
>  	return queue_var_show(max_hw_sectors_kb, (page));
>  }
>  
> +static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->max_phys_segments, page);
> +}
> +
> +static ssize_t queue_max_segments_store(struct request_queue *q, const char *page, size_t count)

100-col xterm?

> +{
> +	unsigned long segments;
> +	ssize_t ret = queue_var_store(&segments, page, count);
>  
> +	spin_lock_irq(q->queue_lock);
> +	q->max_phys_segments = segments;
> +	spin_unlock_irq(q->queue_lock);

Fishy locking?

> +	return ret;
> +}
>  static struct queue_sysfs_entry queue_requests_entry = {
>  	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
>  	.show = queue_requests_show,
> @@ -3954,6 +3969,12 @@ static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
>  	.show = queue_max_hw_sectors_show,
>  };
>  
> +static struct queue_sysfs_entry queue_max_segments_entry = {
> +	.attr = {.name = "max_segments", .mode = S_IRUGO |S_IWUSR },

whitespace went funny.

> +	.show = queue_max_segments_show,
> +	.store = queue_max_segments_store,
> +};
> +
>  static struct queue_sysfs_entry queue_iosched_entry = {
>  	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
>  	.show = elv_iosched_show,
> @@ -3965,6 +3986,7 @@ static struct attribute *default_attrs[] = {
>  	&queue_ra_entry.attr,
>  	&queue_max_hw_sectors_entry.attr,
>  	&queue_max_sectors_entry.attr,
> +	&queue_max_segments_entry.attr,
>  	&queue_iosched_entry.attr,
>  	NULL,
>  };

