Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbZLGAbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbZLGAbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbZLGAbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:31:18 -0500
Received: from kroah.org ([198.145.64.141]:34333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758401AbZLGAM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:46 2009
Message-Id: <20091207000646.342613889@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>
Subject: [037/119] page allocator: Do not allow interrupts to use ALLOC_HARDER
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mel Gorman <mel@csn.ul.ie>

commit 9d0ed60fe9cd1fbf57f755cd27a23ae9114d7210 upstream.

Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 ("page allocator:
calculate the alloc_flags for allocation only once") altered watermark
logic slightly by allowing rt_tasks that are handling an interrupt to set
ALLOC_HARDER.  This patch brings the watermark logic more in line with
2.6.30.

This change results in a reduction of the number high-order GFP_ATOMIC
allocation failures reported.  See
http://www.gossamer-threads.com/lists/linux/kernel/1144153

[rientjes@google.com: Spotted the problem]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1715,7 +1715,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)))
+	} else if (unlikely(rt_task(p)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {


