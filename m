Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYF3Cth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYF3Cth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYF3Ct2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:49:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36412 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYF3Ct1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:49:27 -0400
Date: Mon, 30 Jun 2008 11:53:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splitlru: BDI_CAP_SWAP_BACKED
Message-Id: <20080630115354.3a75edd3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site>
	<Pine.LNX.4.64.0806290122330.21758@blonde.site>
	<20080629173841.37CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 17:48:59 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > The split-lru patches put file and swap-backed pages on different lrus.
> > shmem/tmpfs pages are awkward because they are swap-backed file pages.
> > Since it's difficult to change lru midstream, they are treated as swap-
> > backed throughout, with SetPageSwapBacked on allocation in shmem_getpage.
> > 
> > However, splice read (used by loop and sendfile) and readahead* allocate
> > pages first, add_to_page_cache_lru, and then call into the filesystem
> > through ->readpage.  Under memory pressure, the shmem pages arrive at
> > add_to_swap_cache and hit its BUG_ON(!PageSwapBacked(page)).
> > 
> > I've not yet found a better way to handle this than a "capability"
> > flag in shmem_backing_dev_info, tested by add_to_page_cache_lru.
> > And solely because it would look suspicious without it, set that
> > BDI_CAP_SWAP_BACKED in swap_backing_dev_info also.
> > 
> > * readahead on shmem/tmpfs?  I'd always thought ra_pages 0 prevented
> > that; but in fact readahead(2), fadvise(POSIX_FADV_WILLNEED) and
> > madvise(MADV_WILLNEED) all force_page_cache_readahead and get there.
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> great.
> 
> I'm not sure about this patch is perfect.
> but it seems makes sense and very good code.
> 
> So, I'll testing this patch for a while.
> 

Hmm, how about adding LRU only for shmem/tmpfs ? nonsense ? ;)
It's just a file if not mapped but it's swap backed.


Thanks,
-Kame

