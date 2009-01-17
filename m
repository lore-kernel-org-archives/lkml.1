Return-Path: <linux-kernel-owner+w=401wt.eu-S937337AbZAQCdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937337AbZAQCdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935028AbZAQCaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:30:14 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459AbZAQCaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:30:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=V7KcN4dXQhXM4b8yFeuhKqfAXQ62R03Q8fm1jaWai7QFbNf9uWS3bKbgQOKGJ2iiN
	tG8QSPaM3PBGSmtnmJfzw==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 6/8] hugetlbfs drop_inode update
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:30:07 -0800
Message-ID: <20090117023007.20425.67727.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update hugetlbfs to compile with the new drop_inode callback mechanism that
works with phases.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/hugetlbfs/inode.c |   72 +++++++++++++++++++++++++++++---------------------
 1 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6903d37..986fed4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -388,46 +388,58 @@ static void hugetlbfs_delete_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
-static void hugetlbfs_forget_inode(struct inode *inode) __releases(inode_lock)
+static int hugetlbfs_forget_inode(struct inode *inode,
+				  enum drop_inode_phase phase)
 {
 	struct super_block *sb = inode->i_sb;
 
-	if (!hlist_unhashed(&inode->i_hash)) {
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			list_move(&inode->i_list, &inode_unused);
-		inodes_stat.nr_unused++;
-		if (!sb || (sb->s_flags & MS_ACTIVE)) {
-			spin_unlock(&inode_lock);
-			return;
+	switch (phase) {
+	case DIP_START_FREEING:
+		if (!hlist_unhashed(&inode->i_hash)) {
+			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
+				list_move(&inode->i_list, &inode_unused);
+			inodes_stat.nr_unused++;
+			if (!sb || (sb->s_flags & MS_ACTIVE))
+				return 1;
+			inode->i_state |= I_WILL_FREE;
 		}
-		inode->i_state |= I_WILL_FREE;
-		spin_unlock(&inode_lock);
-		/*
-		 * write_inode_now is a noop as we set BDI_CAP_NO_WRITEBACK
-		 * in our backing_dev_info.
-		 */
-		write_inode_now(inode, 1);
-		spin_lock(&inode_lock);
-		inode->i_state &= ~I_WILL_FREE;
-		inodes_stat.nr_unused--;
-		hlist_del_init(&inode->i_hash);
+		break;
+	case DIP_DELETING:
+		if (!hlist_unhashed(&inode->i_hash)) {
+			/*
+			 * write_inode_now is a noop as we set
+			 * BDI_CAP_NO_WRITEBACK in our backing_dev_info.
+			 */
+			write_inode_now(inode, 1);
+		}
+		break;
+	case DIP_UNHASHING:
+		if (!hlist_unhashed(&inode->i_hash)) {
+			inode->i_state &= ~I_WILL_FREE;
+			inodes_stat.nr_unused--;
+			hlist_del_init(&inode->i_hash);
+		}
+		list_del_init(&inode->i_list);
+		list_del_init(&inode->i_sb_list);
+		inode->i_state |= I_FREEING;
+		inodes_stat.nr_inodes--;
+		break;
+	case DIP_DESTROYING:
+		truncate_hugepages(inode, 0);
+		clear_inode(inode);
+		destroy_inode(inode);
+		break;
 	}
-	list_del_init(&inode->i_list);
-	list_del_init(&inode->i_sb_list);
-	inode->i_state |= I_FREEING;
-	inodes_stat.nr_inodes--;
-	spin_unlock(&inode_lock);
-	truncate_hugepages(inode, 0);
-	clear_inode(inode);
-	destroy_inode(inode);
+	return 0;
 }
 
-static void hugetlbfs_drop_inode(struct inode *inode)
+static int hugetlbfs_drop_inode(struct inode *inode,
+				enum drop_inode_phase phase)
 {
 	if (!inode->i_nlink)
-		generic_delete_inode(inode);
+		return generic_delete_inode(inode, phase);
 	else
-		hugetlbfs_forget_inode(inode);
+		return hugetlbfs_forget_inode(inode, phase);
 }
 
 static inline void

