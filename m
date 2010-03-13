Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab0CMAUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:09 -0500
Received: from kroah.org ([198.145.64.141]:60538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934817Ab0CMATl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:41 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.486908042@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wu Fengguang <fengguang.wu@intel.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Chuck Lever <chuck.lever@oracle.com>
Subject: [patch 015/123] vfs: take f_lock on modifying f_mode after open time
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 42e49608683ab25fbbbf9c40edb944601e543882 upstream.

We'll introduce FMODE_RANDOM which will be runtime modified.  So protect
all runtime modification to f_mode with f_lock to avoid races.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/file_table.c     |    2 ++
 fs/nfsd/nfs4state.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -393,7 +393,9 @@ retry:
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
+		spin_lock(&f->f_lock);
 		f->f_mode &= ~FMODE_WRITE;
+		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
 		file_release_write(f);
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1998,7 +1998,9 @@ nfs4_file_downgrade(struct file *filp, u
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
 		drop_file_write_access(filp);
+		spin_lock(&filp->f_lock);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
+		spin_unlock(&filp->f_lock);
 	}
 }
 


