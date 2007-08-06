Return-Path: <linux-kernel-owner+w=401wt.eu-S932496AbXHFTXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbXHFTXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXHFTWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:22:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610AbXHFTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:22:54 -0400
Date: Mon, 6 Aug 2007 12:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wait for page writeback when directly reclaiming
 contiguous areas
Message-Id: <20070806122204.924fa0e9.akpm@linux-foundation.org>
In-Reply-To: <7bdbf266c3f68dc57a9cf7469c2652a5@pinky>
References: <exportbomb.1186077923@pinky>
	<7bdbf266c3f68dc57a9cf7469c2652a5@pinky>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Aug 2007 19:18:43 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> @@ -458,8 +475,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		if (page_mapped(page) || PageSwapCache(page))
>  			sc->nr_scanned++;
>  
> -		if (PageWriteback(page))
> -			goto keep_locked;
> +		may_enter_fs = (sc->gfp_mask & __GFP_FS) ||
> +			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
> +
> +		if (PageWriteback(page)) {
> +			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
> +				wait_on_page_writeback(page);
> +			else
> +				goto keep_locked;
> +		}

this bit could do with a comment explaining the design decisions, please.
