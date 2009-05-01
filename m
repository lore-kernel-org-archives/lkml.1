Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZEAAlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZEAAlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZEAAlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:41:11 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57004 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336AbZEAAlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:41:10 -0400
Date: Thu, 30 Apr 2009 19:41:06 -0500
From: Jack Steiner <steiner@sgi.com>
To: akpm@linux-foundation.org, piggin@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Fix memory corruption in slbq
Message-ID: <20090501004105.GA16409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory corruption caused by slqb overrunning the end
of the page allocated in kmem_cache_dyn_array_alloc() for
initial caches.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 mm/slqb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/mm/slqb.c
===================================================================
--- linux.orig/mm/slqb.c	2009-04-30 15:47:16.000000000 -0500
+++ linux/mm/slqb.c	2009-04-30 19:08:33.000000000 -0500
@@ -2194,15 +2194,14 @@ static void *kmem_cache_dyn_array_alloc(
 		 * never get freed by definition so we can do it rather
 		 * simply.
 		 */
-		if (!nextmem) {
+		if (!nextmem || offset_in_page(nextmem) + size > PAGE_SIZE) {
 			nextmem = alloc_pages_exact(size, GFP_KERNEL);
 			if (!nextmem)
 				return NULL;
 		}
 		ret = nextmem;
 		nextmem = (void *)((unsigned long)ret + size);
-		if ((unsigned long)ret >> PAGE_SHIFT !=
-				(unsigned long)nextmem >> PAGE_SHIFT)
+		if (offset_in_page(ret) + size >= PAGE_SIZE)
 			nextmem = NULL;
 		memset(ret, 0, size);
 		return ret;
