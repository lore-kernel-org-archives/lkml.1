Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZG1BtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZG1BtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZG1BtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:49:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:58620 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbZG1BtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:49:04 -0400
Subject: [PATCH] mm: Make it easier to catch NULL cache names
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 11:48:55 +1000
Message-Id: <1248745735.30993.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, if you inadvertently pass NULL to kmem_cache_create() at boot
time, it crashes much later after boot somewhere deep inside sysfs which
makes it very non obvious to figure out what's going on.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Yes, I did hit that :-) Something in ppc land using an array of caches
and got the names array out of sync with changes to the list of indices.

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..b5b5653 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3292,6 +3292,8 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 {
 	struct kmem_cache *s;
 
+	BUG_ON(name == NULL);
+
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
-- 
1.6.1.2.14.gf26b5



