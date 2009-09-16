Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZIPWTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZIPWTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZIPWSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:18:47 -0400
Received: from kroah.org ([198.145.64.141]:49819 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbZIPWSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:18:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:15:07 2009
Message-Id: <20090916221507.102426758@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:13:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 10/10] nfsd: fix hung up of nfs client while sync write data to nfs server
References: <20090916221320.283781925@mini.kroah.org>
Content-Disposition: inline; filename=nfsd-fix-hung-up-of-nfs-client-while-sync-write-data-to-nfs-server.patch
In-Reply-To: <20090916221529.GA28162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wei Yongjun <yjwei@cn.fujitsu.com>

commit a0d24b295aed7a9daf4ca36bd4784e4d40f82303 upstream.

nfsd: fix hung up of nfs client while sync write data to nfs server

Commit 'Short write in nfsd becomes a full write to the client'
(31dec2538e45e9fff2007ea1f4c6bae9f78db724) broken the sync write.
With the following commands to reproduce:

  $ mount -t nfs -o sync 192.168.0.21:/nfsroot /mnt
  $ cd /mnt
  $ echo aaaa > temp.txt

Then nfs client is hung up.

In SYNC mode the server alaways return the write count 0 to the
client. This is because the value of host_err in nfsd_vfs_write()
will be overwrite in SYNC mode by 'host_err=nfsd_sync(file);',
and then we return host_err(which is now 0) as write count.

This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1003,6 +1003,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &offset);
 	set_fs(oldfs);
 	if (host_err >= 0) {
+		*cnt = host_err;
 		nfsdstats.io_write += host_err;
 		fsnotify_modify(file->f_path.dentry);
 	}
@@ -1048,10 +1049,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	}
 
 	dprintk("nfsd: write complete host_err=%d\n", host_err);
-	if (host_err >= 0) {
+	if (host_err >= 0)
 		err = 0;
-		*cnt = host_err;
-	} else
+	else
 		err = nfserrno(host_err);
 out:
 	return err;


