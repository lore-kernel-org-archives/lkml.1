Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbYDOTmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbYDOTmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYDOTm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:42:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbYDOTmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:42:25 -0400
Date: Tue, 15 Apr 2008 21:41:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415194157.GA22274@elte.hu>
References: <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org> <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <20080415193540.GA22094@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415193540.GA22094@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> -#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
> +#if NODES_WIDTH <= 0 || NODES_SHIFT == 0
>  #define NODE_NOT_IN_PAGE_FLAGS
>  #endif

Peter "radar eye" Zijlstra noticed an ugly and annoying typo in mm.h:

-#ifdef NODE_NOT_IN_PAGEFLAGS
+#ifdef NODE_NOT_IN_PAGE_FLAGS

but even with the full fix (see below) the same crash remains.

i think getting NODE_NOT_IN_PAGEFLAGS wrong seems to result in 
non-optimal but still correct code - by virtue of NODES_MASK ending up 
zero.

	Ingo

----------------------->
Subject: nodes: shift fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 15 21:15:21 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
@@ -424,7 +424,7 @@ static inline void set_compound_order(st
  * We are going to use the flags for the page to node mapping if its in
  * there.  This includes the case where there is no node, so it is implicit.
  */
-#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#if NODES_WIDTH <= 0 || NODES_SHIFT == 0
 #define NODE_NOT_IN_PAGE_FLAGS
 #endif
 
@@ -442,7 +442,7 @@ static inline void set_compound_order(st
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
 
 /* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allcator */
-#ifdef NODE_NOT_IN_PAGEFLAGS
+#ifdef NODE_NOT_IN_PAGE_FLAGS
 #define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
 #define ZONEID_PGOFF		((SECTIONS_PGOFF < ZONES_PGOFF)? \
 						SECTIONS_PGOFF : ZONES_PGOFF)
