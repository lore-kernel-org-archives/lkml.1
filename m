Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260Ab0AVFTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0AVFTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487Ab0AVFT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:19:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:25128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0AVFT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:19:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="533525969"
Message-Id: <20100122051517.549075734@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 12:59:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: <stable@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/4] vfs: take f_lock on modifying f_mode after open time
References: <20100122045914.993668874@intel.com>
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
 


