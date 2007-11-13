Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXKMBUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXKMBUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbXKMBUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:20:07 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46000 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbXKMBUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:20:05 -0500
Date: Mon, 12 Nov 2007 20:15:11 -0500
Message-Id: <200711130115.lAD1FBfG015626@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bfields@fieldses.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: [PATCH] NFSD: fix wrong mnt_writer count in rename (MMOTM 2007-11-10-19-05)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NFSD forgets to call mnt_drop_write after a successful rename.  Here's a
fix.  (Ah, the curse of a stackable file system developer: you have to debug
everyone else's too. :-)

One thing I wasn't sure is whether I could move the mnt_drop_write line a
little above, just after the call to vfs_rename.  If we can drop the ref
earlier, it could improve scalability/performance just a bit, no? (i.e.,
what are the ramifications of holding on to this mnt writer ref longer than
needed?)

Cheers,
Erez.



Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7dfde65..47aec49 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1693,6 +1693,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 		if (!host_err)
 			host_err = nfsd_sync_dir(fdentry);
 	}
+	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
 
  out_dput_new:
 	dput(ndentry);
