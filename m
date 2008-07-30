Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYGaA1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYGaA1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbYGaAZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:25:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760212AbYGaAZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:25:24 -0400
Date: Wed, 30 Jul 2008 16:59:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>
Subject: [patch 56/62] tmpfs: fix kernel BUG in shmem_delete_inode
Message-ID: <20080730235957.GD12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Hugh Dickins <hugh@veritas.com>

commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1 upstream

SuSE's insserve initscript ordering program hits kernel BUG at mm/shmem.c:814
on 2.6.26.  It's using posix_fadvise on directories, and the shmem_readpage
method added in 2.6.23 is letting POSIX_FADV_WILLNEED allocate useless pages
to a tmpfs directory, incrementing i_blocks count but never decrementing it.

Fix this by assigning shmem_aops (pointing to readpage and writepage and
set_page_dirty) only when it's needed, on a regular file or a long symlink.

Many thanks to Kel for outstanding bugreport and steps to reproduce it.

Reported-by: Kel Modderman <kel@otaku42.de>
Tested-by: Kel Modderman <kel@otaku42.de>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1503,7 +1503,6 @@ shmem_get_inode(struct super_block *sb, 
 		inode->i_uid = current->fsuid;
 		inode->i_gid = current->fsgid;
 		inode->i_blocks = 0;
-		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_mapping->backing_dev_info = &shmem_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_generation = get_seconds();
@@ -1518,6 +1517,7 @@ shmem_get_inode(struct super_block *sb, 
 			init_special_inode(inode, mode, dev);
 			break;
 		case S_IFREG:
+			inode->i_mapping->a_ops = &shmem_aops;
 			inode->i_op = &shmem_inode_operations;
 			inode->i_fop = &shmem_file_operations;
 			mpol_shared_policy_init(&info->policy,
@@ -1907,6 +1907,7 @@ static int shmem_symlink(struct inode *d
 			return error;
 		}
 		unlock_page(page);
+		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);

-- 
