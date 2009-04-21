Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZDUKNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZDUKNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZDUKND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:13:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34738 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZDUKNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:13:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 10/25] Calculate the alloc_flags for allocation only once
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421100530.GN12713@csn.ul.ie>
References: <20090421165022.F13F.A69D9226@jp.fujitsu.com> <20090421100530.GN12713@csn.ul.ie>
Message-Id: <20090421190921.F15F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 19:12:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	/* Avoid recursion of direct reclaim */
> > > +	if (p->flags & PF_MEMALLOC)
> > > +		goto nopage;
> > > +
> > 
> > Again. old code doesn't only check PF_MEMALLOC, but also check TIF_MEMDIE.
> > 
> 
> But a direct reclaim will have PF_MEMALLOC set and doesn't care about
> the value of TIF_MEMDIE with respect to recursion.
> 
> There is still a check made for TIF_MEMDIE for setting ALLOC_NO_WATERMARKS
> in gfp_to_alloc_flags() so that flag is still being taken care of.

Do you mean this is intentional change?
I only said there is changelog-less behavior change.

old code is here.
PF_MEMALLOC and TIF_MEMDIE makes goto nopage. it avoid reclaim.
-------------------------------------------------------------------------
rebalance:
        if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
                        && !in_interrupt()) {
                if (!(gfp_mask & __GFP_NOMEMALLOC)) {
nofail_alloc:
                        /* go through the zonelist yet again, ignoring mins */
                        page = get_page_from_freelist(gfp_mask, nodemask, order,
                                zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
                        if (page)
                                goto got_pg;
                        if (gfp_mask & __GFP_NOFAIL) {
                                congestion_wait(WRITE, HZ/50);
                                goto nofail_alloc;
                        }
                }
                goto nopage;
        }
-------------------------------------------------------------------------


but I don't oppose this change if it is your intentional.




