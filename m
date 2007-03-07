Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbXCGKN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbXCGKN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbXCGKN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:13:28 -0500
Received: from verein.lst.de ([213.95.11.210]:60840 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbXCGKNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:13:23 -0500
Date: Wed, 7 Mar 2007 11:13:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] xfs: use xfs_get_buf_noaddr for iclogs
Message-ID: <20070307101314.GB30587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently xlog_alloc allocates memory for the iclogs first, then
allocates a buffer using xfs_buf_get_empty and finally assigns
the memory to the buffer.  We don't really want to do this, but
rather allocate a buffer with memory attached to it using
xfs_buf_get_noaddr.  There's a subtile change because
xfs_buf_get_empty returns the buffer locked, but xfs_buf_get_noaddr
returns it unlocked.  From my auditing and testing nothing in the
log I/O code cares about this distincition, but I'd be happy if
someone could try to prove this independently.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log.c	2007-03-06 17:26:40.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_log.c	2007-03-06 17:28:03.000000000 +0100
@@ -1199,11 +1199,16 @@
 		*iclogp = (xlog_in_core_t *)
 			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
 		iclog = *iclogp;
-		iclog->hic_data = (xlog_in_core_2_t *)
-			  kmem_zalloc(iclogsize, KM_SLEEP | KM_LARGE);
-
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
+
+		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
+		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
+		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
+		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
+		iclog->ic_bp = bp;
+		iclog->hic_data = bp->b_addr;
+
 		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
 
 		head = &iclog->ic_header;
@@ -1216,11 +1221,6 @@
 		INT_SET(head->h_fmt, ARCH_CONVERT, XLOG_FMT);
 		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
 
-		bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
-		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
-		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
-		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
-		iclog->ic_bp = bp;
 
 		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
@@ -1229,7 +1229,6 @@
 		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
-		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
 		sv_init(&iclog->ic_forcesema, SV_DEFAULT, "iclog-force");
 		sv_init(&iclog->ic_writesema, SV_DEFAULT, "iclog-write");
 
@@ -1528,7 +1527,6 @@
 		}
 #endif
 		next_iclog = iclog->ic_next;
-		kmem_free(iclog->hic_data, log->l_iclog_size);
 		kmem_free(iclog, sizeof(xlog_in_core_t));
 		iclog = next_iclog;
 	}
