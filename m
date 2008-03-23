Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYCWKjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYCWKjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbYCWKiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:38:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55651 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbYCWKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:38:51 -0400
Date: Sun, 23 Mar 2008 19:38:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [2/18] Add basic support for more than one hstate in hugetlbfs
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
In-Reply-To: <20080317015815.D43991B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015815.D43991B41E0@basil.firstfloor.org>
Message-Id: <20080323193340.B31D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi

sorry for very late review.

> @@ -497,11 +501,34 @@ static int __init hugetlb_init(void)
>  			break;
>  	}
>  	max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
> -	printk("Total HugeTLB memory allocated, %ld\n", h->free_huge_pages);
> +
> +	printk(KERN_INFO "Total HugeTLB memory allocated, %ld %dMB pages\n",
> +			h->free_huge_pages,
> +			1 << (h->order + PAGE_SHIFT - 20));
>  	return 0;
>  }

IA64 arch support 64k hugepage, assumption >1MB size is wrong.


> +/* Should be called on processing a hugepagesz=... option */
> +void __init huge_add_hstate(unsigned order)
> +{
> +	struct hstate *h;
> +	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
> +	BUG_ON(order <= HPAGE_SHIFT - PAGE_SHIFT);
> +	h = &hstates[max_hstate++];
> +	h->order = order;
> +	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
> +	hugetlb_init_hstate(h);
> +	parsed_hstate = h;
> +}

this function is called once by one boot parameter, right?
if so, this function cause panic when stupid user write many 
hugepagesz boot parameter.

Why don't you use following check.

 if (max_hstate >= HUGE_MAX_HSTATE) {
     printk("hoge hoge");
     return;
 }



- kosaki


