Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZD2Gmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZD2Gmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZD2Gmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:42:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZD2Gmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:42:37 -0400
Subject: Re: [PATCH] vmscan: evict use-once pages first
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
In-Reply-To: <20090428192907.556f3a34@bree.surriel.com>
References: <20090428044426.GA5035@eskimo.com>
	 <20090428192907.556f3a34@bree.surriel.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 08:42:29 +0200
Message-Id: <1240987349.4512.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 19:29 -0400, Rik van Riel wrote:

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index eac9577..4c0304e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1489,6 +1489,21 @@ static void shrink_zone(int priority, struct zone *zone,
>  			nr[l] = scan;
>  	}
>  
> +	/*
> +	 * When the system is doing streaming IO, memory pressure here
> +	 * ensures that active file pages get deactivated, until more
> +	 * than half of the file pages are on the inactive list.
> +	 *
> +	 * Once we get to that situation, protect the system's working
> +	 * set from being evicted by disabling active file page aging
> +	 * and swapping of swap backed pages.  We still do background
> +	 * aging of anonymous pages.
> +	 */
> +	if (nr[LRU_INACTIVE_FILE] > nr[LRU_ACTIVE_FILE]) {
> +		nr[LRU_ACTIVE_FILE] = 0;
> +		nr[LRU_INACTIVE_ANON] = 0;
> +	}
> +

Isn't there a hole where LRU_*_FILE << LRU_*_ANON and we now stop
shrinking INACTIVE_ANON even though it makes sense to.

