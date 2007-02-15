Return-Path: <linux-kernel-owner+w=401wt.eu-S1030225AbXBORAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225AbXBORAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030217AbXBORAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:00:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54761 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030218AbXBOQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:59:26 -0500
Date: Thu, 15 Feb 2007 08:55:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, tony.luck@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
Message-Id: <20070215085500.30e57866.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
	<20070212150802.f240e94f.akpm@linux-foundation.org>
	<45D12715.4070408@yahoo.com.au>
	<20070213121217.0f4e9f3a.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com>
	<20070213144909.70943de2.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 00:19:06 +0000 (GMT) Hugh Dickins wrote:

> On Tue, 13 Feb 2007, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Don't check for pte swap entries when CONFIG_SWAP=n.
> > And save 'present' in the vec array.
> > 
> > mm/built-in.o: In function `sys_mincore':
> > (.text+0xe584): undefined reference to `swapper_space'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> What you've done there is fine, Randy, thank you.
> 
> But I just got out of bed to take another look, and indeed:
> what is it doing in the none_mapped !vma->vm_file case?
> passing back an uninitialized vector.
> 
> Easy enough to fix, but I'd say Nick's patch has by now exceeded
> its embarrassment quota, and should be reverted from Linus' tree
> for now: clearly none of us have been paying enough attention,
> and other eyes are liable to find further errors lurking in it.
> 
> Hugh


so, are we going to get a revert of 42da9cbd3eedde33a42acc2cb06f454814cf5de0 ?
Has that been requested?  or are there other plans?

Thanks.

> > ---
> >  mm/mincore.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- linux-2.6.20-git9.orig/mm/mincore.c
> > +++ linux-2.6.20-git9/mm/mincore.c
> > @@ -111,6 +111,7 @@ static long do_mincore(unsigned long add
> >  			present = mincore_page(vma->vm_file->f_mapping, pgoff);
> >  
> >  		} else { /* pte is a swap entry */
> > +#ifdef CONFIG_SWAP
> >  			swp_entry_t entry = pte_to_swp_entry(pte);
> >  			if (is_migration_entry(entry)) {
> >  				/* migration entries are always uptodate */
> > @@ -119,7 +120,11 @@ static long do_mincore(unsigned long add
> >  				pgoff = entry.val;
> >  				present = mincore_page(&swapper_space, pgoff);
> >  			}
> > +#else
> > +			present = 1;
> > +#endif
> >  		}
> > +		vec[i] = present;
> >  	}
> >  	pte_unmap_unlock(ptep-1, ptl);
> 
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
