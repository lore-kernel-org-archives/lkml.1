Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZG2ADn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZG2ADn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZG1Xtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:35 -0400
Received: from kroah.org ([198.145.64.141]:35616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbZG1Xtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:51 2009
Message-Id: <20090728234151.596651226@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Howells <dhowells@redhat.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 02/71] NFSD: Dont hold unrefcounted creds over call to nfsd_setuser()
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=nfsd-don-t-hold-unrefcounted-creds-over-call-to-nfsd_setuser.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 033a666ccb842ab4134fcd0c861d5ba9f5d6bf3a upstream.

nfsd_open() gets an unrefcounted pointer to the current process's effective
credentials at the top of the function, then calls nfsd_setuser() via
fh_verify() - which may replace and destroy the current process's effective
credentials - and then passes the unrefcounted pointer to dentry_open() - but
the credentials may have been destroyed by this point.

Instead, the value from current_cred() should be passed directly to
dentry_open() as one of its arguments, rather than being cached in a variable.

Possibly fh_verify() should return the creds to use.

This is a regression introduced by
745ca2475a6ac596e3d8d37c2759c0fbe2586227 "CRED: Pass credentials through
dentry_open()".

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-and-Verified-By: Steve Dickson <steved@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -677,7 +677,6 @@ __be32
 nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 			int access, struct file **filp)
 {
-	const struct cred *cred = current_cred();
 	struct dentry	*dentry;
 	struct inode	*inode;
 	int		flags = O_RDONLY|O_LARGEFILE;
@@ -732,7 +731,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 		vfs_dq_init(inode);
 	}
 	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt),
-			    flags, cred);
+			    flags, current_cred());
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
 out_nfserr:


