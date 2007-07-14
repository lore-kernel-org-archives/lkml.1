Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbXGNRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbXGNRkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbXGNRk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:40:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:22950 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbXGNRk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:40:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OVe93kVsBH1mVQ3hE+1xxJ9Oi52TNqxARKkmzwJfv355PyKThHIHU4kr+wSdvtUCb0V1jDs57ysRxDxhRjYB3DrY9eGqhqlRFcyKVX+eoKPIeMIwc35ILT1Gg7jRVgc7ouky93pbhLQ055lDchAbvVL6cmfhMbY4pGEVphUoXuM=
Message-ID: <29495f1d0707141040q7bf0deb5m21f9151fdee66558@mail.gmail.com>
Date: Sat, 14 Jul 2007 10:40:25 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Joe Jin" <joe.jin@oracle.com>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Cc: "Andrew Morton" <akpm@linux-foundation.org>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20070713121846.GA25236@joejin-pc.cn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	 <20070712221842.f5e47065.akpm@linux-foundation.org>
	 <20070713064004.GA21833@joejin-pc.cn.oracle.com>
	 <20070712234938.c77f3a48.akpm@linux-foundation.org>
	 <20070713080336.GB21833@joejin-pc.cn.oracle.com>
	 <20070713011543.22797645.akpm@linux-foundation.org>
	 <20070713121846.GA25236@joejin-pc.cn.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Joe Jin <joe.jin@oracle.com> wrote:
> >
> > Patch gone too ;) I deleted it.  I was hoping that you'd send me the final
> > finished product (please).
> >
>
> Ha.., the patch against 2.6.22, at your patch have use htlb_alloc_mask, but I
> cannot found it at 2.6.22 kernel tree, I think you must use difference kernel
> tree :)

I believe this patch will be unnecessary if my "Fix hugetlb pool
allocation with empty nodes" patch gets pulled into -mm.
alloc_fresh_huge_page() now takes a mempolicy which is created by the
two callers, rather than reinventing interleaving itself. I believe
this will avoid the oops you saw. I am still waiting on some test
results (annoying -mm config changes) before I repost them (and they
depend on Christoph's fixes for memoryless nodes).

Thanks,
Nish

> --- linux-2.6.22/mm/hugetlb.c.orig      2007-07-12 15:02:19.000000000 +0800
> +++ linux-2.6.22/mm/hugetlb.c   2007-07-13 17:33:45.000000000 +0800
> @@ -101,13 +101,20 @@ static void free_huge_page(struct page *
>
>  static int alloc_fresh_huge_page(void)
>  {
> -       static int nid = 0;
> +       static int prev_nid;
>         struct page *page;
> -       page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
> -                                       HUGETLB_PAGE_ORDER);
> -       nid = next_node(nid, node_online_map);
> +       static DEFINE_SPINLOCK(nid_lock);
> +       int nid;
> +
> +       spin_lock(&nid_lock);
> +       nid = next_node(prev_nid, node_online_map);
>         if (nid == MAX_NUMNODES)
>                 nid = first_node(node_online_map);
> +       prev_nid = nid;
> +       spin_unlock(&nid_lock);
> +
> +       page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
> +                                       HUGETLB_PAGE_ORDER);
>         if (page) {
>                 set_compound_page_dtor(page, free_huge_page);
>                 spin_lock(&hugetlb_lock);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
