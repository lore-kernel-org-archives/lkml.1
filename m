Return-Path: <linux-kernel-owner+w=401wt.eu-S1763147AbYEOR4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763147AbYEOR4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYEORzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:55:52 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26139 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYEORzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:55:51 -0400
Subject: Re: [PATCH] take pageout refcount into account for
	remove_exclusive_swap_page
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <482B9CCA.9060203@mxp.nes.nec.co.jp>
References: <20080428181835.502876582@redhat.com>
	 <20080428181852.620969450@redhat.com> <4828283C.4000803@mxp.nes.nec.co.jp>
	 <20080512093307.2ace3096@bree.surriel.com>
	 <482990FC.3020303@mxp.nes.nec.co.jp>
	 <20080513120417.0833cec1@cuia.bos.redhat.com>
	 <1210700635.6208.40.camel@lts-notebook>
	 <20080513140902.1030afaa@cuia.bos.redhat.com>
	 <1210705370.6208.47.camel@lts-notebook>
	 <482B9CCA.9060203@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=UTF-8
Organization: HP/OSLO
Date: Thu, 15 May 2008 13:55:24 -0400
Message-Id: <1210874124.7389.51.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 11:15 +0900, Daisuke Nishimura wrote:
> On 2008/05/14 4:02 +0900, Lee Schermerhorn wrote:
> > On Tue, 2008-05-13 at 14:09 -0400, Rik van Riel wrote:
> >> On Tue, 13 May 2008 13:43:55 -0400
> >> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> >>
> >>> Or, more generally, 2 + N, for an anon page that is mapped [must be
> >>> read-only, right?] by N processes.  This can happen after, e.g., fork().
> >>> Looks like this patch handles the condition just fine, but you might
> >>> want to reflect this in the comment.
> >> No, this patch only removes a page from the swap cache that is mapped
> >> by one process.  The function page_mapped() returns either 1 or 0, not
> >> the same as page_mapcount().
> > 
> > Duh!  I was reading "page_mapcount()", 'cause that's what I've been
> > considering using for this purpose.
> > 
> >>  
> >> I am not sure if trying to handle swap cache pages that are mapped by
> >> multiple processes could get us into other corner cases and think that
> >> we should probably try to stick to the safe thing for now.
> 
> I think it would be better to add a comment of
> remove_exclusive_swap_page_ref() that it doesn't handle
> swap caches that are mapped by multiple processes for safty.
> 
> > 
> > OK.  I can test the more general case down the road.
> > 
> >> Besides, shouldn't anonymous shared pages be COW and relatively rare?
> > 
> > Well, all anon pages are shared right after fork(), right?  They only
> > become private once they've been written to.  I don't have a feel for
> > the relative numbers of shared anon vs COWed anon--either in general or
> > in the swap cache.
> > 
> >>> Now, I think I can use this to try to remove anon pages from the swap
> >>> cache when they're mlocked.
> > 
> > ﻿I suppose I can just go ahead and use this version with my stress load
> > and count the times when I could have freed the swap cache entry, but
> > didn't because it's mapped in multiple address spaces.  Later ... :)
> > 
> 
> Lee, Rik's version looks good to me except mlocked case, but
> do you have any plan to handle these cases?

Well, it's really just an optimization--freeing swap cache entry, if
possible, when mlocking a page.  I'll patch Rik's version to use
page_mapcount() and test heavily before proposing to do this.  I suppose
we can also discuss whether we want a separate version that frees swap
mapped by multiple tasks for the mlock case, and keep Rik's version for
vmscan.  However, I think that if it's safe in the mlock case, it should
be safe for vmscan.  We'll see.

Lee

> 
> 
> >>>> + */
> >>>> +int remove_exclusive_swap_page_ref(struct page *page)
> >>>> +{
> >>>> +	return remove_exclusive_swap_page_count(page, 2 + page_mapped(page));
> >>>> +}
> >>>> +
> >>>> +/*
> >>>>   * Free the swap entry like above, but also try to
> >>>>   * free the page cache entry if it is the last user.
> >>>>   */
> >>>>
> >>>> All Rights Reversed
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 

