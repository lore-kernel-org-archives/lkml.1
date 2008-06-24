Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYFXJuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYFXJuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYFXJt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:49:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56323 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYFXJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:49:58 -0400
Date: Tue, 24 Jun 2008 18:49:05 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] putback_lru_page()/unevictable page handling rework v3
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found one bug ;)

> -int putback_lru_page(struct page *page)
> +#ifdef CONFIG_UNEVICTABLE_LRU
> +void putback_lru_page(struct page *page)
>  {
>  	int lru;
> -	int ret = 1;
>  	int was_unevictable;
>  
> -	VM_BUG_ON(!PageLocked(page));
>  	VM_BUG_ON(PageLRU(page));
>  
> +	was_unevictable = TestClearPageUnevictable(page);
> +
> +redo:
>  	lru = !!TestClearPageActive(page);
> -	was_unevictable = TestClearPageUnevictable(page); /* for page_evictable() */

(snip)

> +	mem_cgroup_move_lists(page, lru);
> +
> +	/*
> +	 * page's status can change while we move it among lru. If an evictable
> +	 * page is on unevictable list, it never be freed. To avoid that,
> +	 * check after we added it to the list, again.
> +	 */
> +	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
> +		if (!isolate_lru_page(page)) {
> +			put_page(page);
> +			goto redo;

at this point, We should call ClearPageUnevictable().
otherwise, BUG() is called on isolate_lru_pages().



