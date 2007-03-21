Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbXCUBTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbXCUBTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 21:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXCUBTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 21:19:55 -0400
Received: from waste.org ([66.93.16.53]:37718 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbXCUBTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 21:19:54 -0400
Date: Tue, 20 Mar 2007 20:07:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
Message-ID: <20070321010719.GM10459@waste.org>
References: <46005B4A.6050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46005B4A.6050307@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 06:08:10PM -0400, Rik van Riel wrote:
> -		"Active:       %8lu kB\n"
> -		"Inactive:     %8lu kB\n"
...
> +		"Active(anon):   %8lu kB\n"
> +		"Inactive(anon): %8lu kB\n"
> +		"Active(file):   %8lu kB\n"
> +		"Inactive(file): %8lu kB\n"

Potentially incompatible change. How about preserving the original
fields (by totalling), then adding the other fields in a second patch.

>  			if (!pagevec_add(&lru_pvec, page))
> -				__pagevec_lru_add(&lru_pvec);
> +				__pagevec_lru_add_file(&lru_pvec);

Wouldn't lru_file_add or file_lru_add be a better name? If the object
is a "file lru" then sticking "add" in the middle is a little ugly.

>  	spin_lock_irq(&zone->lru_lock);
>  	if (PageLRU(page) && !PageActive(page)) {
> -		del_page_from_inactive_list(zone, page);
> +	if (page_anon(page)) {
> +		del_page_from_inactive_anon_list(zone,page);
>  		SetPageActive(page);
> -		add_page_to_active_list(zone, page);
> +		add_page_to_active_anon_list(zone, page);
> +	} else {
> +		del_page_from_inactive_file_list(zone, page);
> +		SetPageActive(page);
> +		add_page_to_active_file_list(zone, page);
> +	}
>  		__count_vm_event(PGACTIVATE);
>  	}

Missing a level of indentation.

-- 
Mathematics is the supreme nostalgia of our time.
