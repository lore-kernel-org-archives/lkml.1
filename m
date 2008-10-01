Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYJASlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYJASlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYJASk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:40:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:19474 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYJASk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:40:56 -0400
Subject: [PATCH] Improve buffered streaming write ordering
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Oct 2008 14:40:51 -0400
Message-Id: <1222886451.9158.34.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

write_cache_pages can use the address space writeback_index field to
try and pick up where it left off between calls.  pdflush and
balance_dirty_pages both enable this mode in hopes of having writeback
evenly walk down the file instead of just servicing pages at the
start of the address space.

But, there is no locking around this field, and concurrent callers of
write_cache_pages on the same inode can get some very strange results.
pdflush uses writeback_acquire function to make sure that only one
pdflush process is servicing a given backing device, but
balance_dirty_pages does not.

When there are a small number of dirty inodes in the system,
balance_dirty_pages is likely to run in parallel with pdflush on one or
two of them, leading to somewhat random updates of the writeback_index
field in struct address space.

The end result is very seeky writeback during streaming IO.  A 4 drive
hardware raid0 array here can do 317MB/s streaming O_DIRECT writes on
ext4.  This is creating a new file, so O_DIRECT is really just a way to
bypass write_cache_pages.

If I do buffered writes instead, XFS does 205MB/s, and ext4 clocks in at
81.7MB/s.  Looking at the buffered IO traces for each one, we can see a
lot of seeks.

http://oss.oracle.com/~mason/bugs/writeback_ordering/ext4-nopatch.png

http://oss.oracle.com/~mason/bugs/writeback_ordering/xfs-nopatch.png

The patch below changes write_cache_pages to only use writeback_index
when current_is_pdflush().  The basic idea is that pdflush is the only
one who has concurrency control against the bdi, so it is the only one
who can safely use and update writeback_index.

The performance changes quite a bit:

        patched        unpatched
XFS     247MB/s        205MB/s
Ext4    246MB/s        81.7MB/s

The graphs after the patch:

http://oss.oracle.com/~mason/bugs/writeback_ordering/ext4-patched.png

http://oss.oracle.com/~mason/bugs/writeback_ordering/xfs-patched.png

The ext4 graph really does look strange.  What's happening there is the
lazy inode table init has dirtied a whole bunch of pages on the block
device inode.  I don't have much of an answer for why my patch makes all
of this writeback happen up front, other then writeback_index is no
longer bouncing all over the address space.

It is also worth noting that before the patch, filefrag shows ext4 using
about 4000 extents on the file.  After the patch it is around 400.  XFS
uses 2 extents both patched and unpatched.

This is just one benchmark, and I'm not convinced this patch is right.
The ordering of pdflush vs balance_dirty pages is very tricky so I
definitely think we need more thought on this one.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 24de8b6..d799f03 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -884,7 +884,11 @@ int write_cache_pages(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
+		/* start from previous offset done by pdflush */
+		if (current_is_pdflush())
+			index = mapping->writeback_index;
+		else
+			index = 0;
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
@@ -958,7 +962,8 @@ retry:
 		index = 0;
 		goto retry;
 	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+	if (current_is_pdflush() &&
+	    (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0)))
 		mapping->writeback_index = index;
 
 	if (wbc->range_cont)


