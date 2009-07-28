Return-Path: <linux-kernel-owner+w=401wt.eu-S1750941AbZG1ELk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941AbZG1ELk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZG1ELj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:11:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:59116 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZG1ELj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:11:39 -0400
Subject: [PATCH] mm: Make it easier to catch NULL cache names
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 14:11:29 +1000
Message-Id: <1248754289.30993.45.camel@pasglop>
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

 mm/slub.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..e31fbe6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3292,6 +3292,9 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 {
 	struct kmem_cache *s;
 
+	if (WARN_ON(!name))
+		return NULL;
+
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {




