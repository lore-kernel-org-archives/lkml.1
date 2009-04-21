Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZDUKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZDUKry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZDUKrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:47:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34283 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZDUKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:47:44 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 16/25] Save text by reducing call sites of __rmqueue()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-17-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-17-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421193511.F16E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 19:47:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	} else {
> -		spin_lock_irqsave(&zone->lock, flags);
> -		page = __rmqueue(zone, order, migratetype);
> -		spin_unlock(&zone->lock);
> -		if (!page)
> +		LIST_HEAD(list);
> +		local_irq_save(flags);
> +
> +		/* Calling __rmqueue would bloat text, hence this */
> +		if (!rmqueue_bulk(zone, order, 1, &list, migratetype))
>  			goto failed;
> +		page = list_entry(list.next, struct page, lru);
> +		list_del(&page->lru);
>  	}

looks good
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




