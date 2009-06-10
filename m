Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZFJFX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZFJFX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZFJFXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:23:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbZFJFXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:23:51 -0400
Date: Tue, 9 Jun 2009 22:23:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       yanmin.zhang@intel.com, Wu Fengguang <fengguang.wu@intel.com>,
       linuxram@us.ibm.com, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when
 zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Message-Id: <20090609222301.8da002ae.akpm@linux-foundation.org>
In-Reply-To: <20090608151151.GI15070@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie>
	<1244466090-10711-2-git-send-email-mel@csn.ul.ie>
	<4A2D129D.3020309@redhat.com>
	<20090608135433.GD15070@csn.ul.ie>
	<alpine.DEB.1.10.0906081033060.21954@gentwo.org>
	<20090608143857.GG15070@csn.ul.ie>
	<alpine.DEB.1.10.0906081055170.21954@gentwo.org>
	<20090608151151.GI15070@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 16:11:51 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> On Mon, Jun 08, 2009 at 10:55:55AM -0400, Christoph Lameter wrote:
> > On Mon, 8 Jun 2009, Mel Gorman wrote:
> > 
> > > > The tmpfs pages are unreclaimable and therefore should not be on the anon
> > > > lru.
> > > >
> > >
> > > tmpfs pages can be swap-backed so can be reclaimable. Regardless of what
> > > list they are on, we still need to know how many of them there are if
> > > this patch is to be avoided.
> > 
> > If they are reclaimable then why does it matter? They can be pushed out if
> > you configure zone reclaim to be that aggressive.
> > 
> 
> Because they are reclaimable by kswapd or normal direct reclaim but *not*
> reclaimable by zone_reclaim() if the zone_reclaim_mode is not configured
> appropriately.

Ah.  (zone_reclaim_mode & RECLAIM_SWAP) == 0.  That was important info.

Couldn't the lack of RECLAIM_WRITE cause a similar problem?

> I briefly considered setting zone_reclaim_mode to 7 instead of
> 1 by default for large NUMA distances but that has other serious consequences
> such as paging in preference to going off-node as a default out-of-box
> behaviour.

Maybe we should consider that a bit harder.  At what stage does
zone_reclaim decide to give up and try a different node?  Perhaps it's
presently too reluctant to do that?

> The point of the patch is that the heuristics that avoid the scan are not
> perfect. In the event they are wrong and a useless scan occurs, the response
> of the kernel after a useless scan should not be to uselessly scan a load
> more times around the LRU lists making no progress.

It would be sad to bring back a jiffies-based thing into page reclaim. 
Wall time has little correlation with the rate of page allocation and
reclaim activity.

