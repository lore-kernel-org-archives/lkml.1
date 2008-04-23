Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYDWUpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYDWUpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYDWUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:45:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54715 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYDWUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:45:45 -0400
Date: Wed, 23 Apr 2008 23:45:17 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: clameter@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLUB debugging fixes for 2.6.25
Message-ID: <Pine.LNX.4.64.0804232343410.6858@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLUB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

It contains two minor fixes that improve SLUB debugging support.

                Pekka

Christoph Lameter (1):
      slub: fix parameters passed to slab_bug()

Pekka Enberg (1):
      slub: improve kmem_cache_destroy() error message

 mm/slub.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7f8aaa2..378d3f1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -521,7 +521,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 static void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
-	slab_bug(s, reason);
+	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
 }
 
@@ -533,7 +533,7 @@ static void slab_err(struct kmem_cache *s, struct page *page, char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	slab_bug(s, fmt);
+	slab_bug(s, "%s", buf);
 	print_page_info(page);
 	dump_stack();
 }
@@ -2426,8 +2426,11 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (!s->refcount) {
 		list_del(&s->list);
 		up_write(&slub_lock);
-		if (kmem_cache_close(s))
-			WARN_ON(1);
+		if (kmem_cache_close(s)) {
+			printk(KERN_ERR "SLUB %s: %s called for cache that "
+				"still has objects.\n", s->name, __func__);
+			dump_stack();
+		}
 		sysfs_slab_remove(s);
 	} else
 		up_write(&slub_lock);
