Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYKGJN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYKGJN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKGJNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:13:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49156 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYKGJNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:13:42 -0500
Date: Fri, 7 Nov 2008 18:13:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 2/6] memcg: handle swap cache
Message-Id: <20081107181303.7dd232fd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081107175303.1d5c8a29.nishimura@mxp.nes.nec.co.jp>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
	<20081105172009.d9541e27.kamezawa.hiroyu@jp.fujitsu.com>
	<20081107175303.1d5c8a29.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 17:53:03 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Wed, 5 Nov 2008 17:20:09 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > SwapCache support for memory resource controller (memcg)
> > 
> > Before mem+swap controller, memcg itself should handle SwapCache in proper way.
> > 
> > In current memcg, SwapCache is just leaked and the user can create tons of
> > SwapCache. This is a leak of account and should be handled.
> > 
> > SwapCache accounting is done as following.
> > 
> >   charge (anon)
> > 	- charged when it's mapped.
> > 	  (because of readahead, charge at add_to_swap_cache() is not sane)
> >   uncharge (anon)
> > 	- uncharged when it's dropped from swapcache and fully unmapped.
> > 	  means it's not uncharged at unmap.
> > 	  Note: delete from swap cache at swap-in is done after rmap information
> > 	        is established.
> >   charge (shmem)
> > 	- charged at swap-in. this prevents charge at add_to_page_cache().
> > 
> >   uncharge (shmem)
> > 	- uncharged when it's dropped from swapcache and not on shmem's
> > 	  radix-tree.
> > 
> >   at migration, check against 'old page' is modified to handle shmem.
> > 
> > Comparing to the old version discussed (and caused troubles), we have
> > advantages of
> >   - PCG_USED bit.
> >   - simple migrating handling.
> > 
> > So, situation is much easier than several months ago, maybe.
> > 
> > Changelog (v1) -> (v2)
> >   - use lock_page() when we handle unlocked SwapCache.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> I tested this version under swap in/out activity with page migration/rmdir,
> and it worked w/o errors for more than 24 hours.
> 
> 	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 	Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
Thank you!

-Kame

