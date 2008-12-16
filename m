Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYLPEyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYLPEyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 23:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYLPEyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 23:54:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50568 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYLPEyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 23:54:11 -0500
Date: Tue, 16 Dec 2008 13:53:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH mmotm] memcg: fix for documentation (Re: [BUGFIX][PATCH
 mmotm] memcg fix swap accounting leak (v3))
Message-Id: <20081216135310.9bef1c2d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081216130230.2978b8fc.nishimura@mxp.nes.nec.co.jp>
References: <20081212172930.282caa38.kamezawa.hiroyu@jp.fujitsu.com>
	<20081212184341.b62903a7.nishimura@mxp.nes.nec.co.jp>
	<46730.10.75.179.61.1229080565.squirrel@webmail-b.css.fujitsu.com>
	<20081213160310.e9501cd9.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0812130935220.3611@blonde.anvils>
	<4409.10.75.179.62.1229164064.squirrel@webmail-b.css.fujitsu.com>
	<20081215160751.b6a944be.kamezawa.hiroyu@jp.fujitsu.com>
	<20081216130230.2978b8fc.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 13:02:30 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Sorry for late reply.
> 
> > @@ -111,9 +111,40 @@ Under below explanation, we assume CONFI
> >  	(b) If the SwapCache has been mapped by processes, it has been
> >  	    charged already.
> >  
> > -	In case (a), we charge it. In case (b), we don't charge it.
> > -	(But racy state between (a) and (b) exists. We do check it.)
> > -	At charging, a charge recorded in swap_cgroup is moved to page_cgroup.
> > +	This swap-in is one of the most complicated work. In do_swap_page(),
> > +	following events occur when pte is unchanged.
> > +
> > +	(1) the page (SwapCache) is looked up.
> > +	(2) lock_page()
> > +	(3) try_charge_swapin()
> > +	(4) reuse_swap_page() (may call delete_swap_cache())
> > +	(5) commit_charge_swapin()
> > +	(6) swap_free().
> > +
> > +	Considering following situation for example.
> > +
> > +	(A) The page has not been charged before (2) and reuse_swap_page()
> > +	    doesn't call delete_from_swap_cache().
> > +	(B) The page has not been charged before (2) and reuse_swap_page()
> > +	    calls delete_from_swap_cache().
> > +	(C) The page has been charged before (2) and reuse_swap_page() doesn't
> > +	    call delete_from_swap_cache().
> > +	(D) The page has been charged before (2) and reuse_swap_page() calls
> > +	    delete_from_swap_cache().
> > +
> > +	    memory.usage/memsw.usage changes to this page/swp_entry will be
> > +	 Case          (A)      (B)       (C)     (D)
> > +         Event
> > +       Before (2)     0/ 1     0/ 1      1/ 1    1/ 1
> > +          ===========================================
> > +          (3)        +1/+1    +1/+1     +1/+1   +1/+1
> > +          (4)          -       0/ 0       -     -1/ 0
> > +          (5)         0/ 1     0/-1     -1/-1    0/ 0
> > +          (6)          -        -         -      0/-1
> > +          ===========================================
> > +       Result         1/ 1     1/1       1/ 1    1/ 1
> > +
> > +       In any cases, charges to this page should be 1/ 1.
> >  
> I've verified that charges will result in valid values by tracing source code
> in all of these cases, but in case of (B) I don't think commit_charge_swapin
> does memsw-- because PageSwapCache has been cleared already. swap_free does
> memsw-- in this case.
> 
> I attached a fix patch.
> 
you're right. it comes from this version's new change....sorry.

Acked-by; KAMEZAWA Hiroyuki <kamezaw.hiroyu@jp.fujitsu.com>


> Thanks,
> Daisuke Nishimura.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> fix for documentation.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  Documentation/controllers/memcg_test.txt |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/controllers/memcg_test.txt b/Documentation/controllers/memcg_test.txt
> index 3c1458a..08d4d3e 100644
> --- a/Documentation/controllers/memcg_test.txt
> +++ b/Documentation/controllers/memcg_test.txt
> @@ -139,10 +139,10 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
>            ===========================================
>            (3)        +1/+1    +1/+1     +1/+1   +1/+1
>            (4)          -       0/ 0       -     -1/ 0
> -          (5)         0/ 1     0/-1     -1/-1    0/ 0
> -          (6)          -        -         -      0/-1
> +          (5)         0/-1     0/ 0     -1/-1    0/ 0
> +          (6)          -       0/-1       -      0/-1
>            ===========================================
> -       Result         1/ 1     1/1       1/ 1    1/ 1
> +       Result         1/ 1     1/ 1      1/ 1    1/ 1
>  
>         In any cases, charges to this page should be 1/ 1.
>  
> 

