Return-Path: <linux-kernel-owner+w=401wt.eu-S1761692AbZFKIoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761692AbZFKIoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760828AbZFKIoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:44:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44894 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760635AbZFKIoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:44:23 -0400
Date: Thu, 11 Jun 2009 11:44:25 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: cl@linux-foundation.org, mel@csn.ul.ie, Larry.Finger@lwfinger.net
Subject: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum page
 order
Message-ID: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As CONFIG_SLUB_DEBUG is almost always enabled, we need to disable debugging on
per-cache basis if the added debug metadata increases minimum page order. This
is a problem for large caches such as kmalloc-4096 as seen in the following
bugzilla report:

  http://bugzilla.kernel.org/show_bug.cgi?id=13319

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2bbacfc..45080d3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2385,6 +2385,16 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 }
 
+#define MAX_DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
+
+static bool must_disable_debug(size_t size)
+{
+	/*
+	 * Disable debugging if it increases the minimum page order.
+	 */
+	return get_order(size + MAX_DEBUG_SIZE) > get_order(size);
+}
+
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -2397,6 +2407,9 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	s->align = align;
 	s->flags = kmem_cache_flags(size, flags, name, ctor);
 
+	if (must_disable_debug(size))
+		s->flags &= ~(SLAB_POISON|SLAB_RED_ZONE|SLAB_STORE_USER);
+
 	if (!calculate_sizes(s, -1))
 		goto error;
 
-- 
1.6.0.4

