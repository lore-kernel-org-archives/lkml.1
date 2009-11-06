Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbZKFWGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbZKFWGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbZKFWGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:06:02 -0500
Received: from kroah.org ([198.145.64.141]:39796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955AbZKFWF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:52 2009
Message-Id: <20091106215952.861425234@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [22/30] NFSv4: Fix a bug when the server returns NFS4ERR_RESOURCE
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=nfsv4-fix-a-bug-when-the-server-returns-nfs4err_resource.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 52567b03ca38b6e556ced450d64dba8d66e23b0e upstream.

RFC 3530 states that when we recieve the error NFS4ERR_RESOURCE, we are not
supposed to bump the sequence number on OPEN, LOCK, LOCKU, CLOSE, etc
operations. The problem is that we map that error into EREMOTEIO in the XDR
layer, and so the NFSv4 middle-layer routines like seqid_mutating_err(),
and nfs_increment_seqid() don't recognise it.

The fix is to defer the mapping until after the middle layers have
processed the error.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4proc.c |   11 ++++++++---
 fs/nfs/nfs4xdr.c  |    1 -
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -71,12 +71,17 @@ static int _nfs4_proc_getattr(struct nfs
 /* Prevent leaks of NFSv4 errors into userland */
 int nfs4_map_errors(int err)
 {
-	if (err < -1000) {
+	if (err >= -1000)
+		return err;
+	switch (err) {
+	case -NFS4ERR_RESOURCE:
+		return -EREMOTEIO;
+	default:
 		dprintk("%s could not handle NFSv4 error %d\n",
 				__func__, -err);
-		return -EIO;
+		break;
 	}
-	return err;
+	return -EIO;
 }
 
 /*
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4671,7 +4671,6 @@ static struct {
 	{ NFS4ERR_SERVERFAULT,	-ESERVERFAULT	},
 	{ NFS4ERR_BADTYPE,	-EBADTYPE	},
 	{ NFS4ERR_LOCKED,	-EAGAIN		},
-	{ NFS4ERR_RESOURCE,	-EREMOTEIO	},
 	{ NFS4ERR_SYMLINK,	-ELOOP		},
 	{ NFS4ERR_OP_ILLEGAL,	-EOPNOTSUPP	},
 	{ NFS4ERR_DEADLOCK,	-EDEADLK	},


