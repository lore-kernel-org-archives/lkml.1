Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZBKMDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZBKMDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZBKMDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:03:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60495 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZBKMDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:03:46 -0500
Date: Wed, 11 Feb 2009 12:03:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, wli@movementarian.org
Subject: Re: [PATCH] Do not account for the address space used by hugetlbfs
	using VM_ACCOUNT V2 (Was Linus 2.6.29-rc4)
Message-ID: <20090211120317.GB25898@shadowen.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <20090210140227.GC4023@csn.ul.ie> <20090211094329.GE26746@shadowen.org> <20090211103000.GA2416@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211103000.GA2416@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 10:30:01AM +0000, Mel Gorman wrote:

> > >  	/*
> > >  	 * Shared mappings base their reservation on the number of pages that
> > >  	 * are already allocated on behalf of the file. Private mappings need
> > > @@ -2285,22 +2283,25 @@ int hugetlb_reserve_pages(struct inode *inode,
> > >  	 */
> > >  	if (!vma || vma->vm_flags & VM_SHARED)
> > >  		chg = region_chg(&inode->i_mapping->private_list, from, to);
> > 
> > I thought the region map for a VM_SHARED mapping is meant to contain
> > those pages for which we already have a reservation allocated.  So that
> > if we have overlapping VM_RESERVE and VM_NORESERVE mappings we know that
> > we did have a page reserved at fault time and know whether we can take
> > it from the reserve portion of the pool.  By letting this get executed
> > for VM_NORESERVE mappings that would seem to be getting out of sync,
> > which doesn't sound right. 
> 
> This part doesn't get executed for NORESERVE so while region_chg() took
> place to calculate a reservation, region_add() did not get called to
> commit it.

Bah I wrote those damn routines and even I get confused.  As you say
they are a prepare/commit pair and this is only the prepare phase you
are executing, no persistant change is made; so its safe.

> > > +	if (acctflag & VM_NORESERVE) {
> > > +		reset_vma_resv_huge_pages(vma);
> > 
> > Why do we now need to do this in the non-reserve case?  We didn't need
> > to do it before.
> > 
> 
> True, it was largely defensive against anything being in page_private
> that would make it think it had reserves. 

Defensive is good.

> > > +		return 0;
> > > +	}
> > > +
> > 
> > This also seems like a semantic change.  Previously NO_RESERVE did not
> > take quota, now it does.  NO_RESERVE used to mean that we took our
> > chances on there being pages available at fault time both for quota and
> > in the pools. Now it means that we only risk there being no pages.
> > Does that not significantly change semantics. 
> 
> Yes, and this was a mistake. For noreserve mappings, we may now be taking
> twice the amount of quota and probably leaking it. This is wrong and I need
> to move the check for quota below the check for VM_NORESERVE. Good spot.

Thanks.

-apw
