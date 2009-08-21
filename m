Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZHUK5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZHUK5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZHUK5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:57:24 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:47754 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbZHUK5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=I/fbJVZtOVmC7YMro+65561XnRJtPVLT0ivFkW6NmBiYdJCnktKkKc8kMF1EdQp4Z8
         6ZsWmCbogAcohgOaUB991/vgOnNjXju1zT61hO6L2Y85ZJ3iOvIt8mQrAAfwLLWGPOAY
         WdLVCuGDkY/vsCFXyTn6IOpYSJhhuuiSsD510=
MIME-Version: 1.0
In-Reply-To: <20090821072743.GA1808@localhost>
References: <20090820024929.GA19793@localhost>
	 <20090820121347.8a886e4b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090820040533.GA27540@localhost>
	 <28c262360908202055u2744879cic989e007867d0599@mail.gmail.com>
	 <20090821072743.GA1808@localhost>
Date: Fri, 21 Aug 2009 19:57:24 +0900
X-Google-Sender-Auth: 4a0d3f62022bea25
Message-ID: <2f11576a0908210357j72a0c5b4v16997dff137bd738@mail.gmail.com>
Subject: Re: [PATCH -v2 changelog updated] mm: do batched scans for mem_cgroup
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/21 Wu Fengguang <fengguang.wu@intel.com>:
> For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
> in which case shrink_list() _still_ calls isolate_pages() with the much
> larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
> scan rate by up to 32 times.
>
> For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
> So when shrink_zone() expects to scan 4 pages in the active/inactive
> list, the active list will be scanned 4 pages, while the inactive list
> will be (over) scanned SWAP_CLUSTER_MAX=32 pages in effect. And that
> could break the balance between the two lists.
>
> It can further impact the scan of anon active list, due to the anon
> active/inactive ratio rebalance logic in balance_pgdat()/shrink_zone():
>
> inactive anon list over scanned => inactive_anon_is_low() == TRUE
>                                => shrink_active_list()
>                                => active anon list over scanned
>
> So the end result may be
>
> - anon inactive  => over scanned
> - anon active    => over scanned (maybe not as much)
> - file inactive  => over scanned
> - file active    => under scanned (relatively)
>
> The accesses to nr_saved_scan are not lock protected and so not 100%
> accurate, however we can tolerate small errors and the resulted small
> imbalanced scan rates between zones.
>

Looks good to me.
  Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
