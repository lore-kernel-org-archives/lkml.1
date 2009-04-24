Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZDXAH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZDXAH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZDXAHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:07:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52614 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZDXAHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:07:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 15/22] Do not disable interrupts in free_page_mlock()
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, cl@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com, peterz@infradead.org,
       penberg@cs.helsinki.fi
In-Reply-To: <20090423155951.6778bdd3.akpm@linux-foundation.org>
References: <1240408407-21848-16-git-send-email-mel@csn.ul.ie> <20090423155951.6778bdd3.akpm@linux-foundation.org>
Message-Id: <20090424090552.1044.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 24 Apr 2009 09:07:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -556,6 +555,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
> >  	unsigned long flags;
> >  	int i;
> >  	int bad = 0;
> > +	int clearMlocked = PageMlocked(page);
> >  
> >  	for (i = 0 ; i < (1 << order) ; ++i)
> >  		bad += free_pages_check(page + i);
> > @@ -571,6 +571,8 @@ static void __free_pages_ok(struct page *page, unsigned int order)
> >  	kernel_map_pages(page, 1 << order, 0);
> >  
> >  	local_irq_save(flags);
> > +	if (unlikely(clearMlocked))
> > +		free_page_mlock(page);
> 
> I wonder what the compiler does in the case
> CONFIG_HAVE_MLOCKED_PAGE_BIT=n.  If it is dumb, this patch would cause
> additional code generation.

if CONFIG_HAVE_MLOCKED_PAGE_BIT=n, PageMlocked() is {return 0;} then
gcc can remove following code, I think.
	if (0) 
		free_page_mlock(page)



