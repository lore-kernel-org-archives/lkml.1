Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZLAVpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZLAVpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZLAVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:45:28 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36986 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZLAVp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:45:27 -0500
Date: Tue, 1 Dec 2009 21:45:29 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
Message-ID: <20091201214529.GA1457@csn.ul.ie>
References: <4B1575AC.6080904@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B1575AC.6080904@tuffmail.co.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 07:59:40PM +0000, Alan Jenkins wrote:
> Hi
>
> Suspend to disk is (sometimes) hanging for me in 2.6.32-rc.  I finally  
> got around to bisecting it, which blamed the following commit by Mel:
>
> 5f8dcc2 "page-allocator: split per-cpu list into one-list-per-migrate-type"
>
> I was able to confirm this by reverting the commit, which fixed the  
> hang.  I had to revert one other commit first to avoid a conflict:
>
> a6f9edd "page-allocator: maintain rolling count of pages to free from  
> the PCP"
>

Which RC kernel? Specifically, are the commits

cc4a6851466039a8a688c843962a05689059ff3b always wake kswapd when restarting an allocation attempt
9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 Do not allow interrupts to use ALLOC_HARDER

applied?

The latter one in particular might make a difference if s2disk is
pushing the system far below the watermarks. I don't suppose you know
where it's hanging? i.e. is it hanging in the allocator itself?

If those patches are applied, then one difference that 5f8dcc2 makes is
that pages on the PCP lists but not of the right migratetype are not
used. Prior to that commit, an allocation might succeed even if the
buddy lists were empty because one of the other PCP page types would be
used.

> -- detail --
>
> When I suspend my EeePc 701 to disk, it sometimes hangs after writing  
> out the hibernation image.  The system is still able to resume from this  
> image (after working around the hang by pressing the power button). 
>
> This is specific to s2disk from the uswsusp package (which is now  
> installed by default on debian unstable).  It doesn't happen if I  
> uninstall uswsusp and use the in-kernel suspend instead.
>

This leads me to believe that uswsusp is able to push available pages
far below what is expected. It's a total guess though, I have no idea
how uswsusp is implemented or how it differs from what is in kernel.

> The hang doesn't happen if I boot with "init=/bin/bash" and run s2disk.   
> Nor does it happen if I boot normally, then switch to single user mode  
> ("telinit 12").
>
> It only happens if I've logged in to KDE.  In the past, this has  
> indicated a problem in a network driver, since NetworkManager only made  
> a connection once I logged in.  But it still hangs if I remove both  
> ath5k and atl2 before I log into KDE.  (I actually tried removing as  
> many modules as possible: atl2, ath5k, usbcore, snd-hda-intel, psmouse,  
> pcspkr, battery, ac, themal, fan, and eeepc-laptop).  Perhaps it's  
> something to do with the size of the hibernation image.
>

I believe you are correct in that it's something to do with the size of
the hibernation image and how close to the edge the kernel gets pushed
as a result.

Please confirm first that the two commits I mentioned above are in your
kernel. If not, would you mind trying the following patch?
Unfortunately, it's totally untested. The intention of the patch is to
use other PCP lists if the desired one cannot be refilled.

Thanks.

==== CUT HERE ====
page allocator: Allow use of other pcp lists if the buddy lists are depleted

Commit [5f8dcc2 page-allocator: split per-cpu list into
one-list-per-migrate-type] has been identified as a cause of lockups with
the uswsusp package. One possibility is that something in uswsusp allows
watermarks to be pushed far below expectations. Prior to this commit, a
failure to get new pages for the PCP lists could result in pages of another
migratetype being used instead. This patch attempts to restore that behaviour
in case it was required for uswsusp. It's untested.

Experimental-patch-by: Mel Gorman <mel@csn.ul.ie>
--- 
 page_alloc.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bc2ac6..a485963 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1171,6 +1171,35 @@ void split_page(struct page *page, unsigned int order)
 }
 
 /*
+ * If the PCP lists for the desired migrate type are empty but the buddy
+ * allocator cannot allocate more pages, then this function is used to
+ * allocate a page of another migratetype. This impacts anti-fragmentation
+ * but in the event the system has totally locked itself up, it saves
+ * itself from deadlock
+ */
+static noinline struct list_head *find_next_pcplist(struct per_cpu_pages *pcp,
+					int start_migratetype)
+{
+	int i, migratetype;
+	struct list_head *list;
+
+	for (i = 0; i < MIGRATE_TYPES - 1; i++) {
+		migratetype = fallbacks[start_migratetype][i];
+		if (migratetype >= MIGRATE_PCPTYPES) {
+			list = NULL;
+			break;
+		}
+
+		list = &pcp->lists[migratetype];
+
+		if (!list_empty(list))
+			break;
+	}
+
+	return list;
+}
+
+/*
  * Really, prep_compound_page() should be called from __rmqueue_bulk().  But
  * we cheat by calling it from here, in the order > 0 path.  Saves a branch
  * or two.
@@ -1198,8 +1227,11 @@ again:
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, list,
 					migratetype, cold);
-			if (unlikely(list_empty(list)))
-				goto failed;
+			if (unlikely(list_empty(list))) {
+				list = find_next_pcplist(pcp, migratetype);
+				if (!list)
+					goto failed;
+			}
 		}
 
 		if (cold)
