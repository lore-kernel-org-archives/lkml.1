Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYDBTUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYDBTUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYDBTUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:20:34 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:53840 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbYDBTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:20:34 -0400
Date: Wed, 2 Apr 2008 21:20:33 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: torvalds@linux-foundation.org
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
Message-ID: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It looks like someone overoptimized mark_buffer_dirty(). 

mark_buffer_dirty() is
void mark_buffer_dirty(struct buffer_head *bh)
{
        WARN_ON_ONCE(!buffer_uptodate(bh));
        if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
                __set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
}

That buffer_dirty() test is not atomic, it may be reordered with whatever 
else.

So suppose this race

CPU1:

write to buffer data
call mark_buffer_dirty()
test for !buffer_dirty(bh)

--- there is no synchronizing operation, so inside CPU it may get 
reordered to:

test for !buffer_dirty(bh)
write to buffer data

CPU2:
clear_buffer_dirty(bh);
submit_bh(WRITE, bh);

The resulting operations may end up in this order:
CPU1: test for !buffer_dirty(bh) --- sees that the bit is set
CPU2: clear_buffer_dirty(bh);
CPU2: submit_bh(WRITE, bh);
CPU1: write to buffer data

So we have a clean buffer with modified data and this modification is 
going to be lost.

Mikulas


Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

--- linux-2.6.25-rc8/fs/buffer.c_	2008-04-02 21:08:36.000000000 +0200
+++ linux-2.6.25-rc8/fs/buffer.c	2008-04-02 21:10:25.000000000 +0200
@@ -1180,6 +1180,12 @@
  */
 void mark_buffer_dirty(struct buffer_head *bh)
 {
+	/*
+	 * Make sure that the test for buffer_dirty(bh) is not reordered with
+	 * previous modifications to the buffer data.
+	 * -- mikulas
+	 */
+	smp_mb();
 	WARN_ON_ONCE(!buffer_uptodate(bh));
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
 		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
