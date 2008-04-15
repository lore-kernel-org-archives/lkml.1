Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYDOG0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYDOG0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYDOG0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:26:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYDOG0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:26:43 -0400
Date: Tue, 15 Apr 2008 08:25:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415062534.GA9172@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
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


you asked me to run with the debug patch attached below. I just tried 
vanilla -rc9 (head 120dd64cacd4fb7) and it still crashes with this 
config:

  http://redhat.com/~mingo/misc/config-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9

debug output is:

  http://redhat.com/~mingo/misc/log-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9

so it's probably the first few page allocations (setup_cpu_cache()) 
going wrong already - suggesting a some fundamental borkage in SLAB?

note, when i change SLAB to SLUB (and keep the config unchanged 
otherwise), i get a similar early crash:

  http://redhat.com/~mingo/misc/log-Tue_Apr_15_07_24_59_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Tue_Apr_15_07_24_59_CEST_2008.bad

i've also uploaded a bzImage (SLUB, debug patch not applied) that you 
can pick up and run on any 32-bit test-system:

  http://redhat.com/~mingo/misc/bzImage-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9

it's a relatively generic bzImage that should boot on most whitebox PCs 
on most distros as long as you use a pure ext3 setup and might even give 
you networking (no modules or initrd is needed). It boots fine on two 
other 32-bit PCs i have (an Intel laptop and an AMD desktop).

	Ingo

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -1485,6 +1485,7 @@ restart:
 		 * Happens if we have an empty zonelist as a result of
 		 * GFP_THISNODE being used on a memoryless node
 		 */
+		WARN_ON(1);
 		return NULL;
 	}
 
Index: linux/mm/slab.c
===================================================================
--- linux.orig/mm/slab.c
+++ linux/mm/slab.c
@@ -1682,6 +1682,7 @@ static void *kmem_getpages(struct kmem_c
 		flags |= __GFP_RECLAIMABLE;
 
 	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
+	WARN_ON(!page);
 	if (!page)
 		return NULL;
 
@@ -2620,6 +2621,7 @@ static struct slab *alloc_slabmgmt(struc
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags & ~GFP_THISNODE, nodeid);
+		WARN_ON(!slabp);
 		if (!slabp)
 			return NULL;
 	} else {
