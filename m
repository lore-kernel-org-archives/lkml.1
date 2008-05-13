Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYEMTHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYEMTHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYEMTGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:06:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:13521 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbYEMTGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:06:54 -0400
Subject: Re: [PATCH] take pageout refcount into account for
	remove_exclusive_swap_page
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080513140902.1030afaa@cuia.bos.redhat.com>
References: <20080428181835.502876582@redhat.com>
	 <20080428181852.620969450@redhat.com> <4828283C.4000803@mxp.nes.nec.co.jp>
	 <20080512093307.2ace3096@bree.surriel.com>
	 <482990FC.3020303@mxp.nes.nec.co.jp>
	 <20080513120417.0833cec1@cuia.bos.redhat.com>
	 <1210700635.6208.40.camel@lts-notebook>
	 <20080513140902.1030afaa@cuia.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Organization: HP/OSLO
Date: Tue, 13 May 2008 15:02:50 -0400
Message-Id: <1210705370.6208.47.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 14:09 -0400, Rik van Riel wrote:
> On Tue, 13 May 2008 13:43:55 -0400
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > Or, more generally, 2 + N, for an anon page that is mapped [must be
> > read-only, right?] by N processes.  This can happen after, e.g., fork().
> > Looks like this patch handles the condition just fine, but you might
> > want to reflect this in the comment.
> 
> No, this patch only removes a page from the swap cache that is mapped
> by one process.  The function page_mapped() returns either 1 or 0, not
> the same as page_mapcount().

Duh!  I was reading "page_mapcount()", 'cause that's what I've been
considering using for this purpose.

>  
> I am not sure if trying to handle swap cache pages that are mapped by
> multiple processes could get us into other corner cases and think that
> we should probably try to stick to the safe thing for now.

OK.  I can test the more general case down the road.

> 
> Besides, shouldn't anonymous shared pages be COW and relatively rare?

Well, all anon pages are shared right after fork(), right?  They only
become private once they've been written to.  I don't have a feel for
the relative numbers of shared anon vs COWed anon--either in general or
in the swap cache.

> 
> > Now, I think I can use this to try to remove anon pages from the swap
> > cache when they're mlocked.

﻿I suppose I can just go ahead and use this version with my stress load
and count the times when I could have freed the swap cache entry, but
didn't because it's mapped in multiple address spaces.  Later ... :)

> > 
> > > + */
> > > +int remove_exclusive_swap_page_ref(struct page *page)
> > > +{
> > > +	return remove_exclusive_swap_page_count(page, 2 + page_mapped(page));
> > > +}
> > > +
> > > +/*
> > >   * Free the swap entry like above, but also try to
> > >   * free the page cache entry if it is the last user.
> > >   */
> > > 
> > > All Rights Reversed
> 
> 

