Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbXBEGpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbXBEGpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXBEGpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:45:42 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:34919 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbXBEGpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:45:40 -0500
Date: Sun, 4 Feb 2007 22:45:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <1170576977.3073.1100.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702042236250.6748@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> 
 <20070203005316.eb0b4042.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com> 
 <1170525860.3073.1054.camel@laptopd505.fenrus.org> 
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com> 
 <20070203172242.e5bf2534.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Arjan van de Ven wrote:

> 
> > Exclusion or inclusion of NR_MLOCK number is straightforward for the dirty 
> > ratio calcuations. global_page_state(NR_MLOCK) f.e. would get us totals on 
> > mlocked pages per zone. node_page_state(NR_MLOCK) gives a node specific 
> > number of mlocked pages. The nice thing about ZVCs is that it allows
> > easy access to counts on different levels.
> 
> however... mlocked pages still can be dirty, and want to be written back
> at some point ;)

Yes that is why we need to add them to the count of total pages.
 
> I can see the point of doing dirty ratio as percentage of the LRU size,
> but in that case you don't need to track NR_MLOCK, only the total LRU
> size. (And yes it'll be sometimes optimistic because not all mlock'd
> pages are moved off the lru yet, but I doubt you'll have that as a
> problem in practice)

The dirty ratio with the ZVCS would be

NR_DIRTY + NR_UNSTABLE_NFS
	/ 
NR_FREE_PAGES + NR_INACTIVE + NR_ACTIVE + NR_MLOCK


I think we need a PageMlocked after all for the delayed NR_MLOCK 
approach but it needs to have different semantics in order to make
it work. With the patch that I posted earlier we could actually return
a page to the LRU in zap_pte_range while something else is keeping
a page off the LRU (i.e. Page migration is occurring and suddenly the 
page is reclaimed since zap_pte_range put it back). So PageMlocked needs 
to be set in shrink_list() in order to clarify that the page was taken 
off the LRU lists due to it being mlocked and not for other reasons. 
zap_pte_range then needs to check for PageMlocked before putting the 
page onto the LRU.

If we do that then we can observer the state transitions and have an 
accurate count. The delayed accounting problem can probably be 
somewhat remedied by putting new mlocked pages not on the LRU and 
counting them directly. Page migration can simply clear the PageMlocked 
bit and then treat the page as if it was taken off the LRU.

