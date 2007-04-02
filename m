Return-Path: <linux-kernel-owner+w=401wt.eu-S965819AbXDBUSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965819AbXDBUSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965822AbXDBUSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:18:20 -0400
Received: from verein.lst.de ([213.95.11.210]:59344 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965819AbXDBUSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:18:17 -0400
Date: Mon, 2 Apr 2007 22:12:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steve French <smfrench@austin.rr.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org
Subject: Re: + cifs-remove-unneeded-checks.patch added to -mm tree
Message-ID: <20070402201257.GA8705@lst.de>
References: <OFD0781213.454F562D-ON872572B1.0067861B-862572B1.00679895@us.ibm.com> <1175546161.4306.9.camel@smf-t60p.smfdom>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175546161.4306.9.camel@smf-t60p.smfdom>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 03:36:01PM -0500, Steve French wrote:
> I merged most of Christoph's cifs-remove-unneeded-checks patch into the
> cifs-2.6 development tree. The part I did not merge was a little harder
> to verify and vaguely reminded me of the old bug report.  The part I
> left out is attached (I don't mind leaving that part in mm a little
> longer to make sure it is safe).


diff -Nau /home/stevef/linux-2.6/fs/cifs/file.c /home/stevef/virtfs-2.6/fs/cifs/file.c
--- /home/stevef/linux-2.6/fs/cifs/file.c	2007-04-02 13:55:36.000000000 -0500
+++ /home/stevef/virtfs-2.6/fs/cifs/file.c	2007-04-02 13:48:29.000000000 -0500
@@ -352,8 +352,6 @@
 	int disposition = FILE_OPEN;
 	__u16 netfid;
 
-	if (inode == NULL)
-		return -EBADF;

This is cifs_reopen_file.  One of the callers (find_writable_file) calls
this with the &cifs_inode->vfs_inode as inode argument, which can't be
NULL per definition.  All other callers pass
file->f_path.dentry->d_inode as inode argument, which per definition is
not never zero, because there are not file structs arount that don't
point to an inode.

Note that you could nicely simplify the find_writable_file calling
conventions by not passing the inode argument explicitly at all, but
rather always deriving it from file->f_path.dentry->d_inode inside
the function body.

 	if (file->private_data) {
 		pCifsFile = (struct cifsFileInfo *)file->private_data;
 	} else
@@ -367,12 +365,6 @@
 		return 0;
 	}
 
-	if (file->f_path.dentry == NULL) {
-		up(&pCifsFile->fh_sem);
-		cFYI(1, ("failed file reopen, no valid name if dentry freed"));
-		FreeXid(xid);
-		return -EBADF;
-	}

@@ -784,6 +776,7 @@
 ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	size_t write_size, loff_t *poffset)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
@@ -831,11 +824,6 @@
 					return -EBADF;
 			}
 			if (open_file->invalidHandle) {
-				if ((file->f_path.dentry == NULL) ||
-				    (file->f_path.dentry->d_inode == NULL)) {
-					FreeXid(xid);
-					return total_written;
-				}

Same again here, there's no fscking chance read/write could ever work
without a dentry or inode.
