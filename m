Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXDZRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXDZRGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXDZRBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbXDZRAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:16 -0400
Date: Thu, 26 Apr 2007 09:56:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 19/33] NFS: Fix an Oops in nfs_setattr()
Message-ID: <20070426165627.GT1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-fix-an-oops-in-nfs_setattr.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

NFS: Fix an Oops in nfs_setattr()

It looks like nfs_setattr() and nfs_rename() also need to test whether the
target is a regular file before calling nfs_wb_all()...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c   |    3 ++-
 fs/nfs/inode.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1659,7 +1659,8 @@ go_ahead:
 	 * ... prune child dentries and writebacks if needed.
 	 */
 	if (atomic_read(&old_dentry->d_count) > 1) {
-		nfs_wb_all(old_inode);
+		if (S_ISREG(old_inode->i_mode))
+			nfs_wb_all(old_inode);
 		shrink_dcache_parent(old_dentry);
 	}
 	nfs_inode_return_delegation(old_inode);
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -334,8 +334,10 @@ nfs_setattr(struct dentry *dentry, struc
 	lock_kernel();
 	nfs_begin_data_update(inode);
 	/* Write all dirty data */
-	filemap_write_and_wait(inode->i_mapping);
-	nfs_wb_all(inode);
+	if (S_ISREG(inode->i_mode)) {
+		filemap_write_and_wait(inode->i_mapping);
+		nfs_wb_all(inode);
+	}
 	/*
 	 * Return any delegations if we're going to change ACLs
 	 */

-- 
