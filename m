Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYB2Car@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYB2Car (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYB2Cag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:30:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58898 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbYB2C37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:29:59 -0500
Date: Fri, 29 Feb 2008 11:29:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 01/21] move isolate_lru_page() to vmscan.c
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20080228192928.004828816@redhat.com>
References: <20080228192908.126720629@redhat.com> <20080228192928.004828816@redhat.com>
Message-Id: <20080229112120.66E1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

> @@ -870,14 +840,17 @@ static int do_move_pages(struct mm_struc
>  				!migrate_all)
>  			goto put_and_set;
>  
> -		err = isolate_lru_page(page, &pagelist);
> +		err = isolate_lru_page(page);
> +		if (err) {
>  put_and_set:
> -		/*
> -		 * Either remove the duplicate refcount from
> -		 * isolate_lru_page() or drop the page ref if it was
> -		 * not isolated.
> -		 */
> -		put_page(page);
> +			/*
> +			 * Either remove the duplicate refcount from
> +			 * isolate_lru_page() or drop the page ref if it was
> +			 * not isolated.
> +			 */
> +			put_page(page);
> +		} else
> +			list_add_tail(&page->lru, &pagelist);

We think this portion change to following code.

---------------------------------------------
	err = isolate_lru_page(page);
	if (!err)
		list_add_tail(&page->lru, &pagelist);
put_and_set:
	put_page(page);	/* drop follow_page() reference */
---------------------------------------------

because nobody hope change page_count.


original do_move_pages: 
		follow_page:      page_count +1
		isolate_lru_page: page_count +1
		put_page:         page_count -1
                ----------------------------------
                total                        +1
this patch:
		follow_page:      page_count +1
		isolate_lru_page: page_count +1
                ----------------------------------
                total                        +2


- kosaki

