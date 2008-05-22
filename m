Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYEVQYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYEVQYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYEVQYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:24:03 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58015 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYEVQYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:24:01 -0400
Date: Thu, 22 May 2008 19:24:00 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: clameter@sgi.com
cc: mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: [PATCH] SLUB: ksize() abuse checks
Message-ID: <Pine.LNX.4.64.0805221923360.4177@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add a WARN_ON for pages that don't have PageSlab nor PageCompound set to catch
the worst abusers of ksize() in the kernel.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a505a82..0987d1c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2726,9 +2726,10 @@ size_t ksize(const void *object)
 
 	page = virt_to_head_page(object);
 
-	if (unlikely(!PageSlab(page)))
+	if (unlikely(!PageSlab(page))) {
+		WARN_ON(!PageCompound(page));
 		return PAGE_SIZE << compound_order(page);
-
+	}
 	s = page->slab;
 
 #ifdef CONFIG_SLUB_DEBUG
-- 
1.5.2.5

