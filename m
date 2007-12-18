Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbXLRWNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbXLRWNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbXLRWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:13:27 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60825 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbXLRWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:13:26 -0500
Date: Tue, 18 Dec 2007 22:12:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] unionfs: remove cap_writeback_dirty test
In-Reply-To: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182210440.28390@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182207400.28390@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove !mapping_cap_writeback_dirty shortcircuit from unionfs_writepages.

It was introduced to avoid the stray AOP_WRITEPAGE_ACTIVATE coming from
shmem_writepage; but that has since been fixed in shmem_writepage and in
write_cache_pages.  It stayed because it looked like a good optimization,
not to waste time calling down to tmpfs when that would serve no purpose.

But in fact this optimization causes hangs when running LTP with unionfs
over tmpfs.  The problem is that the test comes at the wrong level: unionfs
has already declared in its default_backing_dev_info that it's playing by
cap_writeback_dirty rules.  If it does nothing here in its writepages, its
dirty pages accumulate and choke the system.  What's needed is to carry on
down and let its pages be cleaned while in turn they dirty the lower level.

And this now has an additional benefit for tmpfs, that a sync or pdflush
pushes these pages down to shmem_writepage, letting it match the filepage
coming from unionfs with the swap which may have been allocated earlier,
so it can free the duplication sooner than waiting for further pressure.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/unionfs/mmap.c |    3 ---
 1 file changed, 3 deletions(-)

--- 2.6.24-rc5-mm1/fs/unionfs/mmap.c	2007-12-05 10:38:38.000000000 +0000
+++ unionfs1/fs/unionfs/mmap.c	2007-12-05 16:50:15.000000000 +0000
@@ -130,9 +130,6 @@ static int unionfs_writepages(struct add
 	if (!lower_inode)
 		goto out;
 
-	if (!mapping_cap_writeback_dirty(lower_inode->i_mapping))
-		goto out;
-
 	err = generic_writepages(mapping, wbc);
 	if (!err)
 		unionfs_copy_attr_times(inode);
