Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYGUThj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYGUThj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYGUThb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:37:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49781 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbYGUTha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:37:30 -0400
Date: Mon, 21 Jul 2008 22:37:29 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       adobriyan@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Subject: [GIT PULL] SLUB updates for 2.6.27
Message-ID: <Pine.LNX.4.64.0807212237020.29859@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The tree has one cleanup patch from Alexey and a small fix for SLUB debugging
by me.

I am heading off to OLS (as apprently is Christoph) so expect some downtime
from us SLUB folks this week. In case anyone is wondering, the SLUB defrag
patches have been postponed to 2.6.28 due to lack of time from Christoph.

                Pekka

Alexey Dobriyan (1):
      SLUB: simplify re on_each_cpu()

Pekka Enberg (1):
      slub: dump more data on slab corruption

 mm/slub.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 35ab38a..6d4a49c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -492,7 +492,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	if (p > addr + 16)
 		print_section("Bytes b4", p - 16, 16);
 
-	print_section("Object", p, min(s->objsize, 128));
+	print_section("Object", p, min_t(unsigned long, s->objsize, PAGE_SIZE));
 
 	if (s->flags & SLAB_RED_ZONE)
 		print_section("Redzone", p + s->objsize,
@@ -1495,15 +1495,7 @@ static void flush_cpu_slab(void *d)
 
 static void flush_all(struct kmem_cache *s)
 {
-#ifdef CONFIG_SMP
 	on_each_cpu(flush_cpu_slab, s, 1);
-#else
-	unsigned long flags;
-
-	local_irq_save(flags);
-	flush_cpu_slab(s);
-	local_irq_restore(flags);
-#endif
 }
 
 /*
