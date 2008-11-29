Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYK2HZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYK2HZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 02:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYK2HY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 02:24:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbYK2HY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 02:24:56 -0500
Date: Fri, 28 Nov 2008 23:24:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: bail out of direct reclaim after
 swap_cluster_max pages
Message-Id: <20081128232436.f9b92685.akpm@linux-foundation.org>
In-Reply-To: <20081128062358.7a2e091f@bree.surriel.com>
References: <20081128062358.7a2e091f@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 06:23:58 -0500 Rik van Riel <riel@redhat.com> wrote:

> When the VM is under pressure, it can happen that several direct reclaim
> processes are in the pageout code simultaneously.  It also happens that
> the reclaiming processes run into mostly referenced, mapped and dirty
> pages in the first round.
> 
> This results in multiple direct reclaim processes having a lower
> pageout priority, which corresponds to a higher target of pages to
> scan.
> 
> This in turn can result in each direct reclaim process freeing
> many pages.  Together, they can end up freeing way too many pages.
> 
> This kicks useful data out of memory (in some cases more than half
> of all memory is swapped out).  It also impacts performance by
> keeping tasks stuck in the pageout code for too long.
> 
> A 30% improvement in hackbench has been observed with this patch.
> 
> The fix is relatively simple: in shrink_zone() we can check how many
> pages we have already freed, direct reclaim tasks break out of the
> scanning loop if they have already freed enough pages and have reached
> a lower priority level.
> 
> We do not break out of shrink_zone() when priority == DEF_PRIORITY,
> to ensure that equal pressure is applied to every zone in the common
> case.
> 
> However, in order to do this we do need to know how many pages we already
> freed, so move nr_reclaimed into scan_control.
> 

Again, it's just awful to make a change which has already be tried and
rejected.  Especially as we don't really fully understand why it was
rejected (do we?).  The information we seek may well be in the mailing
list archives somewhere.

> +		/*
> +		 * On large memory systems, scan >> priority can become
> +		 * really large. This is fine for the starting priority;
> +		 * we want to put equal scanning pressure on each zone.
> +		 * However, if the VM has a harder time of freeing pages,
> +		 * with multiple processes reclaiming pages, the total
> +		 * freeing target can get unreasonably large.
> +		 */
> +		if (sc->nr_reclaimed > sc->swap_cluster_max &&
> +			priority < DEF_PRIORITY && !current_is_kswapd())
> +			break;

Fingers crossed, it might be that the `priority < DEF_PRIORITY' here
will save our bacon from <whatever it was>.  But it sure would be good
to know.

