Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0AOBuw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213Ab0AOBtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:49:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:59358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab0AOBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232971457"
Message-Id: <20100115014422.683631340@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:39:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: David Howells <dhowells@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/6] vfs: take f_lock on modifying f_mode after open time
References: <20100115013954.311049665@intel.com>
Content-Disposition: inline; filename=fmode-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll introduce FMODE_RANDOM which will be runtime modified.
So protect all runtime modification to f_mode with f_lock to
avoid races.

CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/file_table.c     |    2 ++
 fs/nfsd/nfs4state.c |    2 ++
 2 files changed, 4 insertions(+)

--- linux.orig/fs/file_table.c	2010-01-15 09:11:07.000000000 +0800
+++ linux/fs/file_table.c	2010-01-15 09:11:15.000000000 +0800
@@ -392,7 +392,9 @@ retry:
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
+		spin_lock(&f->f_lock);
 		f->f_mode &= ~FMODE_WRITE;
+		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
 		file_release_write(f);
--- linux.orig/fs/nfsd/nfs4state.c	2010-01-15 09:08:22.000000000 +0800
+++ linux/fs/nfsd/nfs4state.c	2010-01-15 09:11:15.000000000 +0800
@@ -1998,7 +1998,9 @@ nfs4_file_downgrade(struct file *filp, u
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
 		drop_file_write_access(filp);
+		spin_lock(&filp->f_lock);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
+		spin_unlock(&filp->f_lock);
 	}
 }
 


