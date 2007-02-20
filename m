Return-Path: <linux-kernel-owner+w=401wt.eu-S964866AbXBTH56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866AbXBTH56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964886AbXBTH56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:57:58 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:43096 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964866AbXBTH55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:57:57 -0500
To: linux-kernel@vger.kernel.org
CC: reiserfs-list@namesys.com
Subject: [patch] reiserfs: possible null pointer dereference during resize
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Tue, 20 Feb 2007 10:58:21 +0300
Message-ID: <87ps85z2ea.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

sb_read may return NULL, let's explicitly check it.
If so free new bitmap blocks array, after this we may safely exit as it done
above during bitmap allocation.
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
-------------

--=-=-=
Content-Disposition: inline;
 filename=diff-mm-reiserfs-resize-sb_read-errh-fix

diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 3156847..976cc78 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -131,6 +131,10 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 			/* don't use read_bitmap_block since it will cache
 			 * the uninitialized bitmap */
 			bh = sb_bread(s, i * s->s_blocksize * 8);
+			if (!bh) {
+				vfree(bitmap);
+				return -EIO;
+			}
 			memset(bh->b_data, 0, sb_blocksize(sb));
 			reiserfs_test_and_set_le_bit(0, bh->b_data);
 			reiserfs_cache_bitmap_metadata(s, bh, bitmap + i);

--=-=-=--

