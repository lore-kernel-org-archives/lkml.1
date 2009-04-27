Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZD0Iva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZD0Iva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZD0IvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:51:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37606 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZD0IvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:51:20 -0400
Date: Mon, 27 Apr 2009 17:49:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
 for memg v3.
Message-Id: <20090427174944.86dbb94c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090427084347.GJ4454@balbir.in.ibm.com>
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
	<20090424133306.0d9fb2ce.kamezawa.hiroyu@jp.fujitsu.com>
	<20090424152103.a5ee8d13.nishimura@mxp.nes.nec.co.jp>
	<20090424162840.2ad06d8a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427081206.GI4454@balbir.in.ibm.com>
	<20090427172119.d84aaa68.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427084347.GJ4454@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 14:13:47 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > I like to. But there is no space to record it as stale. And "race" makes
> > that difficult even if we have enough space. If you read the whole thread,
> > you know there are many patterns of race.
> 
> There have been several iterations of this discussion, summarizing it
> would be nice, let me find the thread.
> 
At first, it's obious that there are no free space in swap entry array and
swap_cgroup array. (And this can be trouble even if MEM_RES_CONTROLLER_SWAP_EXT
is not used.)

I tried to record "stale" information to page_cgroup with flag, but there is
following sequence and I can't do it.

==
     CPU0(zap_pte)                 CPU1 (read swap)
                                  swap_duplicate()
     free_swapentry()
                                  add_to_swap_cache().
==
In this case, we can't know swap_entry is stale or not at zap_pte().



> > 
> > > 2. Can't we reclaim stale entries during memcg LRU reclaim? Why write
> > > a GC for it?
> > > 
> > Because they are not on memcg LRU. we can't reclaim it by memcg LRU.
> > (See the first mail from Nishimura of this thread. It explains well.)
> >
> 
> Hmm.. I don't find it, let me do a more exhaustive search on the web.
> If the entry is stale and not on memcg LRU, it is still accounted to
> the memcg?
yes. accoutned to memcg.memsw.usage_in_bytes.


>  
> > One easy case is here.
> > 
> >   - CPU0 call zap_pte()->free_swap_and_cache()
> >   - CPU1 tries to swap-in it.
> >   In this case, free_swap_and_cache() doesn't free swp_entry and swp_entry
> >   is read into the memory. But it will never be added memcg's LRU until
> >   it's mapped.
> 
> That is strange.. not even added to the LRU as a cached page?
> 
added to "global" LRU but not to "memcg's LRU" because "USED" bit is not set.


> >   (What we have to consider here is swapin-readahead. It can swap-in memory
> >    even if it's not accessed. Then, this race window is larger than expected.)
> > 
> > We can't use memcg's LRU then...what we can do is.
> > 
> >  - scanning global LRU all
> >  or
> >  - use some trick to reclaim them in lazy way.
> >
> 
> Thanks for being patient, some of these questions have been discussed
> before I suppose. Let me dig out the thread. 
> 

Sorry for lack of explanation. I'll add more text to v4. patch.

Thanks,
-kame

