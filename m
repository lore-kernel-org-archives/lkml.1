Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbXHBTy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbXHBTy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXHBTyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:54:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbXHBTyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:54:21 -0400
Message-ID: <46B23666.3020205@redhat.com>
Date: Thu, 02 Aug 2007 15:54:14 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: richard kennedy <richard@rsk.demon.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] balance_dirty_pages - exit loop when no more pages	available
References: <1185901890.3133.33.camel@castor.rsk.org>
In-Reply-To: <1185901890.3133.33.camel@castor.rsk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2007 01:11 PM, richard kennedy wrote:

Peter, did you see this?

> exit loop in balance_dirty_pages when no more pages available to write
> 
> On a bdi that has very little traffic balance_dirty_pages can loop
> needlessly waiting until do_writepages has written enough pages.
> 
> do_writepages will return encountered_congestion==0 && nr_to_write > 0 
> when it has completed a pass but did not find enough pages available to
> write. balance_dirty_pages ignores this and keeps looping until a total
> of chunk pages was written. 
> 
> this patch adds an extra exit condition to break out of the loop in this
> case. 
> 
> I've tested this on my amd64 desktop, and I also have a version of this
> patch that includes a printk and a test case that occasionally does
> trigger this condition.  
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> ------
> --- linux-2.6.22.1/mm/page-writeback.c.orig	2007-07-30 16:36:09.000000000 +0100
> +++ linux-2.6.22.1/mm/page-writeback.c	2007-07-31 16:26:43.000000000 +0100
> @@ -250,6 +250,8 @@ static void balance_dirty_pages(struct a
>  			pages_written += write_chunk - wbc.nr_to_write;
>  			if (pages_written >= write_chunk)
>  				break;		/* We've done our duty */
> +			if (!wbc.encountered_congestion && wbc.nr_to_write > 0)
> +				break;	/* didn't find enough to do */
>  		}
>  		congestion_wait(WRITE, HZ/10);
>  	}
> 

