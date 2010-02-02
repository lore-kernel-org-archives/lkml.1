Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0BBE0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:26:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34426 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0BBE0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:26:09 -0500
Date: Tue, 2 Feb 2010 15:26:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100202152605.656c26b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
kernel/audit_tree.c between commit
1a527a2c261ad15dd15d5ee7763d3afcd8c084e9 ("new helper: iterate_mounts()")
from the vfs tree and commits 0bb4b47eebb9d06546c9beae77dc283fbb43ea35
("audit: reimplement audit_trees using fsnotify rather than inotify")
and 98d4301cc7c8828ea41432a62a3216212ffda250 ("fsnotify: put inode
specific fields in an fsnotify_mark in a union") from the fsnotify tree.

I think I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/audit_tree.c
index 028e856,a9167f9..0000000
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@@ -581,12 -594,20 +598,13 @@@ void audit_trim_trees(void
  		if (!root_mnt)
  			goto skip_it;
  
 -		list_add_tail(&list, &root_mnt->mnt_list);
  		spin_lock(&hash_lock);
  		list_for_each_entry(node, &tree->chunks, list) {
- 			struct inode *inode = find_chunk(node)->watch.inode;
 -			struct audit_chunk *chunk = find_chunk(node);
+ 			/* this could be NULL if the watch is dieing else where... */
 -			struct inode *inode = chunk->mark.i.inode;
 -			struct vfsmount *mnt;
++			struct inode *inode = find_chunk(node)->mark.i.inode;
  			node->index |= 1U<<31;
 -			list_for_each_entry(mnt, &list, mnt_list) {
 -				if (mnt->mnt_root->d_inode == inode) {
 -					node->index &= ~(1U<<31);
 -					break;
 -				}
 -			}
 +			if (iterate_mounts(compare_root, inode, root_mnt))
 +				node->index &= ~(1U<<31);
  		}
  		spin_unlock(&hash_lock);
  		trim_marked(tree);
