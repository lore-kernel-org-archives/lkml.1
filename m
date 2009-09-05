Return-Path: <linux-kernel-owner+w=401wt.eu-S1750877AbZIEE0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750877AbZIEE0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 00:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZIEEZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 00:25:58 -0400
Received: from relais.videotron.ca ([24.201.245.36]:21158 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZIEEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 00:25:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 05 Sep 2009 00:25:37 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext2: fix unbalanced kmap()/kunmap()
Message-id: <alpine.LFD.2.00.0909042343540.6044@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ext2_rename(), dir_page is acquired through ext2_dotdot().  It is 
then released through ext2_set_link() but only if old_dir != new_dir. 
Failing that, the pkmap reference count is never decremented and the 
page remains pinned forever.  Repeat that a couple times with highmem 
pages and all pkmap slots get exhausted, and every further kmap() calls 
end up stalling on the pkmap_map_wait queue at which point the whole 
system comes to a halt.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
---

I ran into this issue while testing highmem on ARM by running the git 
test suite in a loop with 3 parallel instances.  Using the right mv 
sequence in a script would constitute a pretty simple recipe for a 
local DoS on systems running ext2 and highmem.  No idea if ext3 or ext4 
have the same issue.

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index e1dedb0..78d9b92 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -362,6 +362,10 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	if (dir_de) {
 		if (old_dir != new_dir)
 			ext2_set_link(old_inode, dir_de, dir_page, new_dir, 0);
+		else {
+			kunmap(dir_page);
+			page_cache_release(dir_page);
+		}
 		inode_dec_link_count(old_dir);
 	}
 	return 0;
