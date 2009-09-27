Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZI0IfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZI0IfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZI0IfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:35:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbZI0IfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:35:04 -0400
Date: Sun, 27 Sep 2009 01:34:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
Subject: Re: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-Id: <20090927013458.53e43459.akpm@linux-foundation.org>
In-Reply-To: <20090925141014.GB15853@think>
References: <20090925141014.GB15853@think>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 10:10:14 -0400 Chris Mason <chris.mason@oracle.com> wrote:

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 8e1e5e1..27f8e0e 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -225,7 +225,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
>  {
>  	struct wb_writeback_args args = {
>  		.sb		= sb,
> -		.sync_mode	= WB_SYNC_ALL,
> +		.sync_mode	= WB_SYNC_NONE,
>  		.nr_pages	= LONG_MAX,
>  		.range_cyclic	= 0,
>  	};
> @@ -236,6 +236,13 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
>  
>  	bdi_queue_work(bdi, &work);
>  	bdi_wait_on_work_clear(&work);
> +
> +	args.sync_mode = WB_SYNC_ALL;
> +	args.nr_pages = LONG_MAX;
> +
> +	work.state = WS_USED | WS_ONSTACK;
> +	bdi_queue_work(bdi, &work);
> +	bdi_wait_on_work_clear(&work);
>  }

Those LONG_MAX's are a worry.  What prevents a very long
almost-livelock from occurring if userspace is concurrently dirtying
pagecache at a high rate?

