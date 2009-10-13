Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZJMAmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZJMAmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZJMAmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:42:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZJMAmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:42:19 -0400
Message-ID: <4AD3CCC1.9020102@suse.com>
Date: Mon, 12 Oct 2009 20:41:37 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel andr <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] hfs: fix oops on mount with corrupted btree extent records
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 A particular fsfuzzer run caused an hfs file system to crash on mount. This
 is due to a corrupted MDB extent record causing a miscalculation of
 HFS_I(inode)->first_blocks for the extent tree. If the extent records
 are zereod out, it won't trigger the first_blocks special case. Instead
 it falls through to the extent code which we're still in the middle
 of initializing.

 This patch catches the 0 size extent records, reports the corruption,
 and fails the mount.

Reported-by: Ramon de Carvalho Valle <rcvalle@linux.vnet.ibm.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/hfs/btree.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -58,6 +58,11 @@ struct hfs_btree *hfs_btree_open(struct
 	}
 	unlock_new_inode(tree->inode);
 
+	if (!HFS_I(tree->inode)->first_blocks) {
+		printk(KERN_ERR "hfs: invalid btree extent records (0 size).\n");
+		goto free_inode;
+	}
+
 	mapping = tree->inode->i_mapping;
 	page = read_mapping_page(mapping, 0, NULL);
 	if (IS_ERR(page))
-- 
Jeff Mahoney
SUSE Labs
