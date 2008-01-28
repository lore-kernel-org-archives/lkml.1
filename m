Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYA1Fde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYA1Fde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYA1FdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:33:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbYA1Fc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:32:59 -0500
Date: Sun, 27 Jan 2008 21:33:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "minchan kim" <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@mbligh.org>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] remove duplicating priority setting in try_to_free_p
Message-Id: <20080127213312.517b8014.akpm@linux-foundation.org>
In-Reply-To: <28c262360801252329q7232edc2l2d0e4ed17c054832@mail.gmail.com>
References: <28c262360801252329q7232edc2l2d0e4ed17c054832@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008 02:29:23 -0500 "minchan kim" <minchan.kim@gmail.com> wrote:

> shrink_zones in try_to_free_pages already set zone through
> note_zone_scanning_priority.
> So, setting prev_priority in try_to_free_pages is needless.
> 
> This patch is made by 2.6.24-rc8.
> 
> Signed-off-by: barrios <minchan.kim@gmail.com>
> ---
>  mm/vmscan.c |   17 -----------------
>  1 files changed, 0 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e5a9597..fc55c23 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1273,23 +1273,6 @@ unsigned long try_to_free_pages(struct z
>     if (!sc.all_unreclaimable)
>         ret = 1;
>  out:
> -   /*
> -    * Now that we've scanned all the zones at this priority level, note
> -    * that level within the zone so that the next thread which performs
> -    * scanning of this zone will immediately start out at this priority
> -    * level.  This affects only the decision whether or not to bring
> -    * mapped pages onto the inactive list.
> -    */
> -   if (priority < 0)
> -       priority = 0;
> -   for (i = 0; zones[i] != NULL; i++) {
> -       struct zone *zone = zones[i];
> -
> -       if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
> -           continue;
> -
> -       zone->prev_priority = priority;
> -   }
>     return ret;
>  }

(your mail client is replacing tabs with spaces)

I think this is actually a bugfix.  The code you're removing doesn't do the 

	if (priority < zone->prev_priority)

thing.

otoh with this change, the only thing which will cause prev_priority to
increase (ie: lower priority) is kswapd, which seems odd.

So:

a) this is a functional change and needs more thought and lots of runtime
   testing.  I'll duck it for now.

b) the prev_priority stuff is still screwed up.
