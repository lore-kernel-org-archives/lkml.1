Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZIXXsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZIXXsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIXXsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:48:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34449 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIXXsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:48:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Sep 2009 08:46:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: ngupta@vflare.org
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 2/3] virtual block device driver (ramzswap)
Message-Id: <20090925084630.990a4193.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4ABBA45A.8010305@vflare.org>
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
	<1253595414-2855-3-git-send-email-ngupta@vflare.org>
	<20090924141135.833474ad.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABBA45A.8010305@vflare.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 22:24:50 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> 
> On 09/24/2009 10:41 AM, KAMEZAWA Hiroyuki wrote:
> > On Tue, 22 Sep 2009 10:26:53 +0530
> > Nitin Gupta <ngupta@vflare.org> wrote:
> > 
> > <snip>
> >> +	if (unlikely(clen > max_zpage_size)) {
> >> +		if (rzs->backing_swap) {
> >> +			mutex_unlock(&rzs->lock);
> >> +			fwd_write_request = 1;
> >> +			goto out;
> >> +		}
> >> +
> >> +		clen = PAGE_SIZE;
> >> +		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> > Here, and...
> > 
> >> +		if (unlikely(!page_store)) {
> >> +			mutex_unlock(&rzs->lock);
> >> +			pr_info("Error allocating memory for incompressible "
> >> +				"page: %u\n", index);
> >> +			stat_inc(rzs->stats.failed_writes);
> >> +			goto out;
> >> +		}
> >> +
> >> +		offset = 0;
> >> +		rzs_set_flag(rzs, index, RZS_UNCOMPRESSED);
> >> +		stat_inc(rzs->stats.pages_expand);
> >> +		rzs->table[index].page = page_store;
> >> +		src = kmap_atomic(page, KM_USER0);
> >> +		goto memstore;
> >> +	}
> >> +
> >> +	if (xv_malloc(rzs->mem_pool, clen + sizeof(*zheader),
> >> +			&rzs->table[index].page, &offset,
> >> +			GFP_NOIO | __GFP_HIGHMEM)) {
> > 
> > Here.
> >     
> > Do we need to wait until here for detecting page-allocation-failure ?
> > Detecting it here means -EIO for end_swap_bio_write()....unhappy
> > ALERT messages etc..
> > 
> > Can't we add a hook to get_swap_page() for preparing this ("do we have
> > enough pool?") and use only GFP_ATOMIC throughout codes ?
> > (memory pool for this swap should be big to some extent.)
> >
> 
> Yes, we do need to wait until this step for detecting alloc failure since
> we don't really know when pool grow will (almost) surely wail.
> What we can probably do is, hook into OOM notify chain (oom_notify_list)
> and whenever we get this callback, we can start sending pages directly
> to backing swap and do not even attempt to do any allocation.
> 
> 
Hmm...then, I never see -EIO ?

>  
> >>From my user support experience for heavy swap customers,  extra memory allocation for swapping out is just bad...in many cases.
> > (*) I know GFP_IO works well to some extent.
> > 
> 
> We cannot use GFP_IO here as it can cause a deadlock:
> ramzswap alloc() --> not enough memory, try to reclaim some --> swap out ...
> ... some pages to ramzswap --> ramzswap alloc()
> 
Ah, sorry. just my mistake. I wanted to write GFP_NOIO.

Thanks,
-Kame



> Thanks,
> Nitin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

