Return-Path: <linux-kernel-owner+w=401wt.eu-S933422AbZFOSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbZFOSDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932422AbZFOSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:00:56 -0400
Received: from moodiegate.xandros.com ([142.46.212.62]:51985 "EHLO
	dactyl.ottawa.xandros.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932835AbZFOSAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:00:55 -0400
X-Greylist: delayed 2956 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 14:00:55 EDT
From: Zygo Blaxell <zygo.blaxell@xandros.com>
Date: Fri, 12 Jun 2009 13:37:50 -0400
Subject: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-Id: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mismatch between calls to write_lock() and write_unlock() in
gen_pool_destroy by removing the write_lock().

Signed-off-by: Zygo Blaxell <zygo.blaxell@xandros.com>
---
There is a call to write_lock() in gen_pool_destroy which is not balanced
by any corresponding write_unlock().  This causes problems with preemption
because the preemption-disable counter is incremented in the write_lock()
call, but never decremented by any call to write_unlock().  This bug is
difficult to observe in the field because only two in-tree drivers call
gen_pool_destroy, and one of them is non-x86 arch-specific code.

To fix this, I have chosen removing the write_lock() over adding a
write_unlock() because the lock in question is inside a structure which
is being freed.  Any other thread that waited to acquire such a lock
while gen_pool_destroy was running would find itself holding a lock
in recently-freed or about-to-be-freed memory.  This would result in
memory corruption or a crash whether &pool->lock is held or not.

Using a pool while it is in the process of being destroyed is a bug that
must be resolved outside of the gen_pool_destroy function.

 lib/genalloc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index f6d276d..eed2bdb 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -85,7 +85,6 @@ void gen_pool_destroy(struct gen_pool *pool)
 	int bit, end_bit;
 
 
-	write_lock(&pool->lock);
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
-- 
1.5.6.5

