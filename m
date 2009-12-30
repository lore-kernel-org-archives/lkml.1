Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZL3Bgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZL3Bgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZL3Bgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:36:35 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:46239 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZL3Bgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=GTFqdtif2zGPOLZQFAGmdOzkiry3oKPI2StXdgpUpp8fvGuCCzJJL96iMhdqDdZTfv
         gvDA5QV428z+TDzaITlwpVCXUImKVd076QJJjTrl5/B0vWKG1g6q75K43NgH29Bwawmw
         kMu4hPY5FAc4EFAyTAkTMPykitY4jLtYzPoPs=
Date: Wed, 30 Dec 2009 10:33:49 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH -mmotm-2009-12-10-17-19] Fix wrong rss count of smaps
Message-Id: <20091230103349.1ec71aac.minchan.kim@barrios-desktop>
In-Reply-To: <1262117339.3000.2023.camel@calx>
References: <20091228134619.92ba28f6.minchan.kim@barrios-desktop>
	<1262117339.3000.2023.camel@calx>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt. 

On Tue, 29 Dec 2009 14:08:59 -0600
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, 2009-12-28 at 13:46 +0900, Minchan Kim wrote:
> > I am not sure we have to account zero page with file_rss. 
> > Hugh and Kame's new zero page doesn't do it. 
> > As side effect of this, we can prevent innocent process which have a lot
> > of zero page when OOM happens. 
> > (But I am not sure there is a process like this :)
> > So I think not file_rss counting is not bad. 
> > 
> > RSS counting zero page with file_rss helps any program using smaps?
> > If we have to keep the old behavior, I have to remake this patch. 
> > 
> > == CUT_HERE ==
> > 
> > Long time ago, We regards zero page as file_rss and
> > vm_normal_page doesn't return NULL.
> > 
> > But now, we reinstated ZERO_PAGE and vm_normal_page's implementation
> > can return NULL in case of zero page. Also we don't count it with
> > file_rss any more.
> > 
> > Then, RSS and PSS can't be matched.
> > For consistency, Let's ignore zero page in smaps_pte_range.
> > 
> 
> Not counting the zero page in RSS is fine with me. But will this patch
> make the total from smaps agree with get_mm_rss()?

Yes. Anon page fault handler also don't count zero page any more, now. 
Nonetheless, smaps counts it with resident. 

It's point of this patch. 

But I reposted both anon fault handler and here counts it as file_rss
as compatibility with old zero page counting.
Pz, Look at that. :)

> 
> Regarding OOM handling: arguably RSS should play no role in OOM as it's
> practically meaningless in a shared memory system. If we were instead

It's very arguable issue for us that OOM depens on RSS.

> used per-process unshared pages as the metric (aka USS), we'd have a
> much better notion of how much memory an OOM kill would recover.
> Unfortunately, that's not trivial to track as the accounting on COW
> operations is not lightweight.

I think we can approximate it with the size of VM_SHARED vma of process
when VM calculate badness. 
What do you think about it?

Thanks for good idea, Matt. 

> 
> > CC: Matt Mackall <mpm@selenic.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > ---
> >  fs/proc/task_mmu.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 47c03f4..f277c4a 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -361,12 +361,11 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  		if (!pte_present(ptent))
> >  			continue;
> >  
> > -		mss->resident += PAGE_SIZE;
> > -
> >  		page = vm_normal_page(vma, addr, ptent);
> >  		if (!page)
> >  			continue;
> >  
> > +		mss->resident += PAGE_SIZE;
> >  		/* Accumulate the size in pages that have been accessed. */
> >  		if (pte_young(ptent) || PageReferenced(page))
> >  			mss->referenced += PAGE_SIZE;
> > -- 
> > 1.5.6.3
> > 
> > 
> > 
> 
> 
> 
> -- 
> http://selenic.com : development and support for Mercurial and Linux
> 
> 


-- 
Kind regards,
Minchan Kim
