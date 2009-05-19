Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZESBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZESBLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZESBLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:11:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38526 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZESBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:11:31 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/4] vmscan: change the number of the unmapped files in zone reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090518035319.GA7940@localhost>
References: <2f11576a0905172035k3f26b8d6r84af555a94b1d70e@mail.gmail.com> <20090518035319.GA7940@localhost>
Message-Id: <20090519094141.4EA2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 May 2009 10:11:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, May 18, 2009 at 11:35:31AM +0800, KOSAKI Motohiro wrote:
> > >> --- a/mm/vmscan.c
> > >> +++ b/mm/vmscan.c
> > >> @@ -2397,6 +2397,7 @@ static int __zone_reclaim(struct zone *z
> > >> ? ? ? ? ? ? ? .isolate_pages = isolate_pages_global,
> > >> ? ? ? };
> > >> ? ? ? unsigned long slab_reclaimable;
> > >> + ? ? long nr_unmapped_file_pages;
> > >>
> > >> ? ? ? disable_swap_token();
> > >> ? ? ? cond_resched();
> > >> @@ -2409,9 +2410,11 @@ static int __zone_reclaim(struct zone *z
> > >> ? ? ? reclaim_state.reclaimed_slab = 0;
> > >> ? ? ? p->reclaim_state = &reclaim_state;
> > >>
> > >> - ? ? if (zone_page_state(zone, NR_FILE_PAGES) -
> > >> - ? ? ? ? ? ? zone_page_state(zone, NR_FILE_MAPPED) >
> > >> - ? ? ? ? ? ? zone->min_unmapped_pages) {
> > >> + ? ? nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
> > >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?zone_page_state(zone, NR_ACTIVE_FILE) -
> > >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?zone_page_state(zone, NR_FILE_MAPPED);
> > >
> > > This can possibly go negative.
> > 
> > Is this a problem?
> > negative value mean almost pages are mapped. Thus
> > 
> >   (nr_unmapped_file_pages > zone->min_unmapped_pages)  => 0
> > 
> > is ok, I think.
> 
> I wonder why you didn't get a gcc warning, because zone->min_unmapped_pages
> is a "unsigned long".
> 
> Anyway, add a simple note to the code if it works *implicitly*?

hm, My gcc is wrong version? (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14))
Anyway, you are right. thanks for good catch :)

incremental fixing patch is here.

Patch name: vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim-fix.patch
Applied after: vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch
---
 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2397,7 +2397,9 @@ static int __zone_reclaim(struct zone *z
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
-	long nr_unmapped_file_pages;
+	unsigned long nr_file_pages;
+	unsigned long nr_mapped;
+	unsigned long nr_unmapped_file_pages = 0;
 
 	disable_swap_token();
 	cond_resched();
@@ -2410,9 +2412,11 @@ static int __zone_reclaim(struct zone *z
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
+	nr_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
+			zone_page_state(zone, NR_ACTIVE_FILE);
+	nr_mapped = zone_page_state(zone, NR_FILE_MAPPED);
+	if (likely(nr_file_pages >= nr_mapped))
+		nr_unmapped_file_pages = nr_file_pages - nr_mapped;
 
 	if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
 		/*



