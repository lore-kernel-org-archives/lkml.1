Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZKBPgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZKBPgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZKBPg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:36:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36571 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbZKBPg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:36:28 -0500
Date: Tue, 3 Nov 2009 00:35:31 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCHv2 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4AEE0536.6020605@crca.org.au>
References: <20091102000855.F404.A69D9226@jp.fujitsu.com> <4AEE0536.6020605@crca.org.au>
Message-Id: <20091103002520.886C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for the reviewing :)

> > 2) shrink_all_zone() try to shrink all pages at a time. but it doesn't works
> >   fine on numa system.
> >   example)
> >     System has 4GB memory and each node have 2GB. and hibernate need 1GB.
> > 
> >     optimal)
> >        steal 500MB from each node.
> >     shrink_all_zones)
> >        steal 1GB from node-0.
> 
> I haven't given much thought to numa awareness in hibernate code, but I
> can say that the shrink_all_memory interface is woefully inadequate as
> far as zone awareness goes. Since lowmem needs to be atomically restored
> before we can restore highmem, we really need to be able to ask for a
> particular number of pages of a particular zone type to be freed.

Honestly, I am not suspend/hibernation expert. Can I ask why caller need to know
per-zone number of freed pages information? if hibernation don't need highmem.
following incremental patch prevent highmem reclaim perfectly. Is it enough?


---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e6ea011..7fb3435 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2265,7 +2265,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 {
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
-		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+		.gfp_mask = GFP_KERNEL,
 		.may_swap = 1,
 		.may_unmap = 1,
 		.may_writepage = 1,
-- 
1.6.2.5



