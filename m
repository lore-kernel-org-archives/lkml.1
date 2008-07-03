Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYGCRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYGCRjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYGCRjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:39:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58094 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbYGCRjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:39:05 -0400
Date: Thu, 3 Jul 2008 18:39:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #10961] 2.6.26-rc: nfsd hangs for a few sec
Message-ID: <20080703173903.GH18055@csn.ul.ie>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik> <X8mbwW6K81I.A.PjD.169ZIB@albercik> <20080630210142.GB20245@csn.ul.ie> <a4423d670807010704g6cc8513fxfdb258e0b1f873ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <a4423d670807010704g6cc8513fxfdb258e0b1f873ac@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/07/08 18:04), Alexander Beregalov didst pronounce:
> 2008/7/1 Mel Gorman <mel@csn.ul.ie>:
> > I still have no useful reaction to this. According to Christoph Hellwig,
> > this lockup has been appearing since lockdep was introduced but for some
> > reason is easier to trigger now. It bisected to the two-zonelist changes
> > but it still looks like a red herring as I cannot see how reclaim has
> > changed significantly as a result of that patch.
> 
> Do you wait reaction from me? Can I help?
> As I mentioned, the lockup does not happen when lockdep is disabled.
> 

Sorry for the slow response Alexander.

This bug is likely fixed by commit 494de90098784b8e2797598cefdd34188884ec2e
which will be visible publicly later when maintenance on master.kernel.org
finishes. I included it below for convenience.

The lockdep warning still exists but it is a false positive and should be
relatively hard to trigger again. It would be nice to have confirmation
of this.

commit 494de90098784b8e2797598cefdd34188884ec2e
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Thu Jul 3 05:27:51 2008 +0100

    Do not overwrite nr_zones on !NUMA when initialising zlcache_ptr
    
    The non-NUMA case of build_zonelist_cache() would initialize the
    zlcache_ptr for both node_zonelists[] to NULL.
    
    Which is problematic, since non-NUMA only has a single node_zonelists[]
    entry, and trying to zero the non-existent second one just overwrote the
    nr_zones field instead.
    
    As kswapd uses this value to determine what reclaim work is necessary,
    the result is that kswapd never reclaims.  This causes processes to
    stall frequently in low-memory situations as they always direct reclaim.
    This patch initialises zlcache_ptr correctly.
    
    Signed-off-by: Mel Gorman <mel@csn.ul.ie>
    Tested-by: Dan Williams <dan.j.williams@intel.com>
    [ Simplified patch a bit ]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_alloc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2f55295..f32fae3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2328,7 +2328,6 @@ static void build_zonelists(pg_data_t *pgdat)
 static void build_zonelist_cache(pg_data_t *pgdat)
 {
 	pgdat->node_zonelists[0].zlcache_ptr = NULL;
-	pgdat->node_zonelists[1].zlcache_ptr = NULL;
 }
 
 #endif	/* CONFIG_NUMA */

