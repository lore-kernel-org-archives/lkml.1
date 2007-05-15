Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbXEOOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbXEOOhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 10:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbXEOOh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 10:37:29 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:46451 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbXEOOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 10:37:29 -0400
Date: Tue, 15 May 2007 16:37:26 +0200
From: Johann Lombardi <johann@clusterfs.com>
To: linux-kernel@vger.kernel.org
Subject: Clear PG_error before reading a page
Message-ID: <20070515143726.GC2160@chiva>
Mail-Followup-To: Johann Lombardi <johann@clusterfs.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've observed that transient disk errors can result in persistent I/O issues
at the filesystem level. I can at least put forward the problem with ext2/ext3
and scsci_debug.

Here are the steps to reproduce:
* format an ext3 fs on a SCSI disk simulated by scsci_debug
* mount the fs and create a 10MB file
* unmount/remount the fs
* enable the medium error flag in scsi_debug (please note that I've slightly
  modified scsi_debug to return a medium error indication when any sector >=
  0x1234 is read)
* try to read the file (as expected, got -EIO)
* disable medium error injection in scsi_debug
* try to read the file (keep getting -EIO)

In fact, when the underlying device experiences errors, block_read_full_page()
calls ext3_get_block() which correctly returns an I/O error.
Consequently, block_read_full_page() set the PG_error flag.
However, the problem is that afterwards, when the device no longer returns
any errors, PG_error is never cleared and, as a consequence, we are still
getting -EIO at the filesystem level.

Granted that block_read_full_page() always tries to fill a full page,
I think it should first clear the PG_error flag and set it back if a call
to get_block() fails. Besides, we should handle this in block_read_full_page
but also in other places that do full page reads. Any comments?
I am not able to reproduce the problem with the patch below.

Johann

Signed-off-by: Johann Lombardi <johann@clusterfs.com>
--

--- linux-2.6.12.6.orig/fs/buffer.c	2005-08-29 18:55:27.000000000 +0200
+++ linux-2.6.12.6/fs/buffer.c	2007-05-11 15:51:03.000000000 +0200
@@ -2078,6 +2078,7 @@ int block_read_full_page(struct page *pa
 	int fully_mapped = 1;
 
 	BUG_ON(!PageLocked(page));
+	ClearPageError(page);
 	blocksize = 1 << inode->i_blkbits;
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, blocksize, 0);
