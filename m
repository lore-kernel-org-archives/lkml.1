Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZDUJkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZDUJkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZDUJj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:39:56 -0400
Received: from cmpxchg.org ([85.214.51.133]:53484 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZDUJj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:39:56 -0400
Date: Tue, 21 Apr 2009 11:38:30 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-ID: <20090421093830.GA3639@cmpxchg.org>
References: <20090421095857.b989ce44.kamezawa.hiroyu@jp.fujitsu.com> <20090421085231.GB2527@cmpxchg.org> <20090421182427.F14D.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421182427.F14D.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 06:27:08PM +0900, KOSAKI Motohiro wrote:
> > > > -		cond_resched();
> > > > +		if (list_empty(&swap_pages))
> > > > +			cond_resched();
> > > >  
> > > Why this ?
> > 
> > It shouldn't schedule anymore when it's allocated the first swap slot.
> > Another reclaimer could e.g. sleep on the cond_resched() before the
> > loop and when we schedule while having swap slots allocated, we might
> > continue further allocations multiple slots ahead.
> 
> Oops, It seems regression. this cond_resched() intent to
> 
> cond_resched();
> pageout();
> cond_resched();
> pageout();
> cond_resched();
> pageout();

It still does that.  While it collects swap pages (swap_pages list is
non-empty), it doesn't page out.  And if it restarts for unmap and
page-out, the swap_pages list is empty and cond_resched() is called.
