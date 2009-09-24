Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZIXPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZIXPDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZIXPDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:03:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZIXPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:03:37 -0400
Subject: Re: [PATCH 03/10] writeback: stop background writeback when below
 background threshold
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, shaohua.li@intel.com,
       chris.mason@oracle.com, jack@suse.cz
In-Reply-To: <1253803236-20760-4-git-send-email-jens.axboe@oracle.com>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
	 <1253803236-20760-4-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 17:03:35 +0200
Message-Id: <1253804615.18939.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 16:40 +0200, Jens Axboe wrote:
> From: Wu Fengguang <fengguang.wu@intel.com>
> 
> Treat bdi_start_writeback(0) as a special request to do background write,
> and stop such work when we are below the background dirty threshold.
> 
> Also simplify the (nr_pages <= 0) checks. Since we already pass in
> nr_pages=LONG_MAX for WB_SYNC_ALL and background writes, we don't
> need to worry about it being decreased to zero.
> 
> Reported-by: Richard Kennedy <richard@rsk.demon.co.uk>
> CC: Jan Kara <jack@suse.cz>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---

> @@ -720,20 +730,16 @@ static long wb_writeback(struct bdi_writeback *wb,
>  
>  	for (;;) {
>  		/*
> +		 * Stop writeback when nr_pages has been consumed
>  		 */
> +		if (args->nr_pages <= 0)
>  			break;
>  
>  		/*
> +		 * For background writeout, stop when we are below the
> +		 * background dirty threshold
>  		 */
> +		if (args->for_background && !over_bground_thresh())
>  			break;


What I'm not getting is why this is conditional on for_background(),
shouldn't we always stop writeback when below the background threshold?

