Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZFVJQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZFVJQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZFVJQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:16:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53947 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbZFVJQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:16:26 -0400
Date: Mon, 22 Jun 2009 10:16:26 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: Bad page state [was: Strange oopses in 2.6.30]
Message-ID: <20090622091626.GA3981@csn.ul.ie>
References: <1245506908.6327.36.camel@localhost> <4A3CFFEC.1000805@gmail.com> <20090622113652.21E7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090622113652.21E7.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:39:53AM +0900, KOSAKI Motohiro wrote:
> (cc to Mel and some reviewer)
> 
> > Flags are:
> > 0000000000400000 -- __PG_MLOCKED
> > 800000000050000c -- my page flags
> >         3650000c -- Maxim's page flags
> > 0000000000693ce1 -- my PAGE_FLAGS_CHECK_AT_FREE
> 
> I guess commit da456f14d (page allocator: do not disable interrupts in
> free_page_mlock()) is a bit wrong.
> 
> current code is:
> -------------------------------------------------------------
> static void free_hot_cold_page(struct page *page, int cold)
> {
> (snip)
>         int clearMlocked = PageMlocked(page);
> (snip)
>         if (free_pages_check(page))
>                 return;
> (snip)
>         local_irq_save(flags);
>         if (unlikely(clearMlocked))
>                 free_page_mlock(page);
> -------------------------------------------------------------
> 
> Oh well, we remove PG_Mlocked *after* free_pages_check().
> Then, it makes false-positive warning.
> 
> Sorry, my review was also wrong. I think reverting this patch is better ;)
> 

I think a revert is way overkill. The intention of the patch is sound -
reducing the number of times interrupts are disabled. Having pages
with the PG_locked bit is now somewhat of an expected situation. I'd
prefer to go with either

1. Unconditionally clearing the bit with TestClearPageLocked as the
   patch already posted does
2. Removing PG_locked from the free_pages_check()
3. Unlocking the pages as we go when an mlocked VMA is being torn town

The patch that addresses 1 seemed ok to me. What do you think?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
