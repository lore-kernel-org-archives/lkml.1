Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZGMFlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZGMFlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 01:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZGMFlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 01:41:01 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40587 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZGMFlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 01:41:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jul 2009 14:38:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] switch free memory back to MIGRATE_MOVABLE
Message-Id: <20090713143857.07e81cb1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090713031801.GA4778@sli10-desk.sh.intel.com>
References: <20090713115803.b78a4f4f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090713030444.GA2582@sli10-desk.sh.intel.com>
	<20090713120549.6252.A69D9226@jp.fujitsu.com>
	<20090713031801.GA4778@sli10-desk.sh.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 11:18:01 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> On Mon, Jul 13, 2009 at 11:08:14AM +0800, KOSAKI Motohiro wrote:
> > > On Mon, Jul 13, 2009 at 10:58:03AM +0800, KAMEZAWA Hiroyuki wrote:
> > > > On Mon, 13 Jul 2009 11:47:46 +0900 (JST)
> > > > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > 
> > > > > > When page is back to buddy and its order is bigger than pageblock_order, we can
> > > > > > switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
> > > > > > has obvious effect when read a block device and then drop caches.
> > > > > > 
> > > > > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > > > 
> > > > > This patch change hot path, but there is no performance mesurement description.
> > > > > Also, I don't like modification buddy core for only drop caches.
> > > > > 
> > > > Li, does this patch imply fallback of migration type doesn't work well ?
> > > > What is the bad case ?
> > > The page is initialized as migrate_movable, and then switch to reclaimable or
> > > something else when fallback occurs, but its type remains even the page gets
> > > freed. When the page gets freed, its type actually can be switch back to movable,
> > > this is what the patch does.
> > 
> > This answer is not actual answer.
> > Why do you think __rmqueue_fallback() doesn't works well? Do you have
> > any test-case or found a bug by review?
> I never said __rmqueue_fallback() doesn't work well. The page is already freed, switching
> back the pageblock to movable might make next page allocation (non-movable) skip this
> pageblock. So this could potentially reduce fragmentation and improve memory offline.
> But your guys are right, I have no number if this will impact performance.
> 
If this is for memory offlining, plz mention that at first ;)
IIUC, if this can be a problem, fixing memory offline itself is better. No ?
At implementing memory unplug, I had no problems because I assumes ZONE_MOVABLE.
But ok, I welcome enhances to memory unplug.

If this part is bad for you.
4714         /*
4715          * In future, more migrate types will be able to be isolation target.
4716          */
4717         if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE)
4718                 goto out;

plz fix this to do more precise work for zid != ZONE_MOVABLE zones.
As I wrote in comments. My codes assumes ZONE_MOVABLE in many parts because I want
100%-success memory offline. 

Thanks,
-Kame

