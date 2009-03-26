Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbZCZU1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbZCZU1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbZCZU1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:27:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZCZU1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:27:10 -0400
Message-ID: <49CBE513.80205@redhat.com>
Date: Thu, 26 Mar 2009 16:26:59 -0400
From: Dave Anderson <anderson@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: zippel@linux-m68k.org, Dave Anderson <anderson@redhat.com>
Subject: [PATCH] HFS: fix memory leak when unmounting
Content-Type: multipart/mixed;
 boundary="------------000300040206010107030404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000300040206010107030404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


When an HFS filesystem is unmounted, it leaks a 2-page
bitmap.  Also, under extreme memory pressure, it's possible
that hfs_releasepage() may use a tree pointer that has not
been initialized, and if so, the release request should
just be rejected.

Signed-off-by: Dave Anderson <anderson@redhat.com>







--------------000300040206010107030404
Content-Type: text/x-patch;
 name="hfs-git.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hfs-git.patch"

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 9435dda..a1cbff2 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -70,6 +70,10 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 		BUG();
 		return 0;
 	}
+
+	if (!tree)
+		return 0;
+
 	if (tree->node_size >= PAGE_CACHE_SIZE) {
 		nidx = page->index >> (tree->node_size_shift - PAGE_CACHE_SHIFT);
 		spin_lock(&tree->hash_lock);
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 36ca2e1..369f2af 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -349,6 +349,10 @@ void hfs_mdb_put(struct super_block *sb)
 	if (HFS_SB(sb)->nls_disk)
 		unload_nls(HFS_SB(sb)->nls_disk);
 
+	/* free the bitmap page(s) */
+	if (HFS_SB(sb)->bitmap)
+		free_pages((unsigned long)HFS_SB(sb)->bitmap, PAGE_SIZE < 8192 ? 1 : 0);
+
 	kfree(HFS_SB(sb));
 	sb->s_fs_info = NULL;
 }

--------------000300040206010107030404--
