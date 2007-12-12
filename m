Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbXLLH2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbXLLH2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 02:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXLLH1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 02:27:54 -0500
Received: from ext-ch1gw-5.online-age.net ([64.37.194.13]:60753 "EHLO
	ext-ch1gw-5.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbXLLH1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 02:27:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH 1/1] replace 2.6.24-rc1 nfs_file_mmap by generic_file_mmap for nommu systems
Date: Wed, 12 Dec 2007 08:27:32 +0100
Message-ID: <050A770C1DB41144817F02E395E493105257D1@FLRMLVEM02.e2k.ad.ge.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] replace 2.6.24-rc1 nfs_file_mmap by generic_file_mmap for nommu systems
Thread-Index: Acg8kHWh5SeFgTW1R8e5iQAveS2odg==
From: "Berkhan, Enrik (GE Infra, Oil & Gas)" <enrik.berkhan@ge.com>
To: <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Dec 2007 07:27:47.0697 (UTC) FILETIME=[7E98F610:01C83C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic_file_mmap (which is noop in this case) instead of nfs_file_mmap
for nommu systems as suggested by Trond Myklebust.

Signed-Off-By: Enrik Berkhan <Enrik.Berkhan@ge.com>

---
 fs/nfs/file.c |    8 ++++++++
 1 files changed, 8 insertions(+)

Index: fs/nfs/file.c
===================================================================
--- fs/nfs/file.c.orig	2007-12-04 05:26:10.000000000 +0100
+++ fs/nfs/file.c	2007-12-12 08:15:16.000000000 +0100
@@ -41,7 +41,9 @@
 static int nfs_file_open(struct inode *, struct file *);
 static int nfs_file_release(struct inode *, struct file *);
 static loff_t nfs_file_llseek(struct file *file, loff_t offset, int origin);
+#ifdef CONFIG_MMU
 static int  nfs_file_mmap(struct file *, struct vm_area_struct *);
+#endif
 static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
 					struct pipe_inode_info *pipe,
 					size_t count, unsigned int flags);
@@ -64,7 +66,11 @@ const struct file_operations nfs_file_op
 	.write		= do_sync_write,
 	.aio_read	= nfs_file_read,
 	.aio_write	= nfs_file_write,
+#ifdef CONFIG_MMU
 	.mmap		= nfs_file_mmap,
+#else
+	.mmap		= generic_file_mmap,
+#endif
 	.open		= nfs_file_open,
 	.flush		= nfs_file_flush,
 	.release	= nfs_file_release,
@@ -269,6 +275,7 @@ nfs_file_splice_read(struct file *filp, 
 	return res;
 }
 
+#ifdef CONFIG_MMU
 static int
 nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
 {
@@ -287,6 +294,7 @@ nfs_file_mmap(struct file * file, struct
 	}
 	return status;
 }
+#endif
 
 /*
  * Flush any dirty pages for this process, and check for write errors.
