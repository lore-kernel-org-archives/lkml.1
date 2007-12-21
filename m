Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXLUWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXLUWhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbXLUWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:37:39 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52852 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754174AbXLUWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:37:38 -0500
Date: Fri, 21 Dec 2007 14:37:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain> 
 <20071211143336.GA17866@elte.hu>  <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> 
 <20071221120908.GA15926@elte.hu> <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
 <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually thanks for pointing that out Pekka.... Here is a patch that takes 
the regression almost completely away (Too much jetlag combined with flu 
seems to have impaired my thinking I should have seen this earlier). I 
still need to run my slab performance tests on this. But hackbench 
improves.


SLUB: Improve hackbench speed

Increase the mininum number of partial slabs to keep around and put
partial slabs to the end of the partial queue so that they can add
more objects.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-12-21 14:30:11.096324462 -0800
+++ linux-2.6/mm/slub.c	2007-12-21 14:30:33.656441994 -0800
@@ -172,7 +172,7 @@ static inline void ClearSlabDebug(struct
  * Mininum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
  */
-#define MIN_PARTIAL 2
+#define MIN_PARTIAL 5
 
 /*
  * Maximum number of desirable partial slabs.
@@ -1616,7 +1616,7 @@ checks_ok:
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial(get_node(s, page_to_nid(page)), page);
+		add_partial_tail(get_node(s, page_to_nid(page)), page);
 
 out_unlock:
 	slab_unlock(page);
