Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZFJHcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZFJHcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFJHby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:31:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39730 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZFJHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:31:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/4] Properly account for the number of page cache pages zone_reclaim() can reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090610011939.GA5603@localhost>
References: <1244566904-31470-2-git-send-email-mel@csn.ul.ie> <20090610011939.GA5603@localhost>
Message-Id: <20090610162926.DDC8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Jun 2009 16:31:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 10, 2009 at 01:01:41AM +0800, Mel Gorman wrote:
> > On NUMA machines, the administrator can configure zone_reclaim_mode that
> > is a more targetted form of direct reclaim. On machines with large NUMA
> > distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
> > unmapped pages will be reclaimed if the zone watermarks are not being met.
> > 
> > There is a heuristic that determines if the scan is worthwhile but the
> > problem is that the heuristic is not being properly applied and is basically
> > assuming zone_reclaim_mode is 1 if it is enabled.
> > 
> > Historically, once enabled it was depending on NR_FILE_PAGES which may
> > include swapcache pages that the reclaim_mode cannot deal with.  Patch
> > vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch by
> > Kosaki Motohiro noted that zone_page_state(zone, NR_FILE_PAGES) included
> > pages that were not file-backed such as swapcache and made a calculation
> > based on the inactive, active and mapped files. This is far superior
> > when zone_reclaim==1 but if RECLAIM_SWAP is set, then NR_FILE_PAGES is a
> > reasonable starting figure.
> > 
> > This patch alters how zone_reclaim() works out how many pages it might be
> > able to reclaim given the current reclaim_mode. If RECLAIM_SWAP is set
> > in the reclaim_mode it will either consider NR_FILE_PAGES as potential
> > candidates or else use NR_{IN}ACTIVE}_PAGES-NR_FILE_MAPPED to discount
> > swapcache and other non-file-backed pages.  If RECLAIM_WRITE is not set,
> > then NR_FILE_DIRTY number of pages are not candidates. If RECLAIM_SWAP is
> > not set, then NR_FILE_MAPPED are not.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Acked-by: Christoph Lameter <cl@linux-foundation.org>
> > ---
> >  mm/vmscan.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
> >  1 files changed, 38 insertions(+), 14 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 2ddcfc8..2bfc76e 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2333,6 +2333,41 @@ int sysctl_min_unmapped_ratio = 1;
> >   */
> >  int sysctl_min_slab_ratio = 5;
> >  
> > +static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
> > +{
> > +	return zone_page_state(zone, NR_INACTIVE_FILE) +
> > +		zone_page_state(zone, NR_ACTIVE_FILE) -
> > +		zone_page_state(zone, NR_FILE_MAPPED);
> 
> This may underflow if too many tmpfs pages are mapped.

sorry my fault.
I'm preparing updated patch.




