Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbXFBMkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbXFBMkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 08:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbXFBMkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 08:40:40 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:7445 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbXFBMki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 08:40:38 -0400
Message-ID: <4661652D.9040404@sw.ru>
Date: Sat, 02 Jun 2007 16:40:13 +0400
From: Vasily Averin <vvs@sw.ru>
Organization: SW-soft
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.8_seamonkey_1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
       linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
       adilger@clusterfs.com
Subject: [PATCH ext3/ext4] lost brelse in ext3_read_inode
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Kirill Korotaev <dev@openvz.org>

One of error path in ext3_read_inode() leaks bh since brelse is forgoten.

Signed-Off-By:	Kirill Korotaev <dev@openvz.org>
Acked-by:	Vasily Averin <vvs@sw.ru>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index a6cb617..2a85dde 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2677,8 +2677,10 @@ void ext3_read_inode(struct inode * inode)
 		 */
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT3_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT3_INODE_SIZE(inode->i_sb))
+		    EXT3_INODE_SIZE(inode->i_sb)) {
+			brelse (bh);
 			goto bad_inode;
+		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext3_inode) -
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b34182b..0cd7bc4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2673,8 +2673,10 @@ void ext4_read_inode(struct inode * inode)
 		 */
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT4_INODE_SIZE(inode->i_sb))
+		    EXT4_INODE_SIZE(inode->i_sb)) {
+			brelse (bh);
 			goto bad_inode;
+		}
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext4_inode) -

