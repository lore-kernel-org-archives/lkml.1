Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbYHSNxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbYHSNxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYHSNwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:52:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbYHSNwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:52:53 -0400
Message-ID: <48AACFDA.5090600@linux-foundation.org>
Date: Tue, 19 Aug 2008 08:51:22 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080818193143.60D7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48A98259.7030101@linux-foundation.org> <20080819192515.12C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080819192515.12C5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> IOW, My box didn't happend performance regression.
> but I think it isn't typical.

Well that is typical for small NUMA system. Maybe this patch will fix it for
now? Large systems can be tuned by setting the ratio lower.


Subject: slub/NUMA: Disable remote node defragmentation by default

Switch remote node defragmentation off by default. The current settings can
cause excessive node local allocations with hackbench. (Note that this feature
is not related to slab defragmentation).

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-08-19 06:45:54.732348449 -0700
+++ linux-2.6/mm/slub.c	2008-08-19 06:46:12.442348249 -0700
@@ -2312,7 +2312,7 @@ static int kmem_cache_open(struct kmem_c

 	s->refcount = 1;
 #ifdef CONFIG_NUMA
-	s->remote_node_defrag_ratio = 100;
+	s->remote_node_defrag_ratio = 1000;
 #endif
 	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
 		goto error;
@@ -4058,7 +4058,7 @@ static ssize_t remote_node_defrag_ratio_
 	if (err)
 		return err;

-	if (ratio < 100)
+	if (ratio <= 100)
 		s->remote_node_defrag_ratio = ratio * 10;

 	return length;
