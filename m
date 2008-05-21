Return-Path: <linux-kernel-owner+w=401wt.eu-S936399AbYEUSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936399AbYEUSZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbYEUSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:25:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44138 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbYEUSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:25:28 -0400
Date: Wed, 21 May 2008 21:25:26 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
Message-ID: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The ksize() function is meant for objects allocated from the slab caches, not
for arbitrary objects. Add a BUG_ON() to enforce that.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 06236e4..b98bb7c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4472,10 +4472,14 @@ const struct seq_operations slabstats_op = {
  */
 size_t ksize(const void *objp)
 {
+	struct page *page;
+
 	BUG_ON(!objp);
 	if (unlikely(objp == ZERO_SIZE_PTR))
 		return 0;
 
-	return obj_size(virt_to_cache(objp));
+	page = virt_to_page(objp);
+	BUG_ON(!PageSlab(page));
+	return obj_size(page_get_cache(page));
 }
 EXPORT_SYMBOL(ksize);
-- 
1.5.2.5

