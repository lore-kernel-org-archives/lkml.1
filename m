Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbYHDVj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbYHDVj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765382AbYHDVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:37:58 -0400
Received: from mail.suse.de ([195.135.220.2]:54834 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbYHDVhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:37:55 -0400
Date: Mon, 4 Aug 2008 14:30:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 12/25] NFS: Ensure we zap only the access and acl caches
	when setting new acls
Message-ID: <20080804213022.GL8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-ensure-we-zap-only-the-access-and-acl-caches-when-setting-new-acls.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit f41f741838480aeaa3a189cff6e210503cf9c42d upstream

...and ensure that we obey the NFS_INO_INVALID_ACL flag when retrieving the
acls.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/inode.c    |    4 +---
 fs/nfs/internal.h |    1 +
 fs/nfs/nfs3acl.c  |    9 ++++++---
 fs/nfs/nfs4proc.c |    5 ++++-
 4 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -57,8 +57,6 @@ static int enable_ino64 = NFS_64_BIT_INO
 static void nfs_invalidate_inode(struct inode *);
 static int nfs_update_inode(struct inode *, struct nfs_fattr *);
 
-static void nfs_zap_acl_cache(struct inode *);
-
 static struct kmem_cache * nfs_inode_cachep;
 
 static inline unsigned long
@@ -167,7 +165,7 @@ void nfs_zap_mapping(struct inode *inode
 	}
 }
 
-static void nfs_zap_acl_cache(struct inode *inode)
+void nfs_zap_acl_cache(struct inode *inode)
 {
 	void (*clear_acl_cache)(struct inode *);
 
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -150,6 +150,7 @@ extern void nfs_clear_inode(struct inode
 #ifdef CONFIG_NFS_V4
 extern void nfs4_clear_inode(struct inode *);
 #endif
+void nfs_zap_acl_cache(struct inode *inode);
 
 /* super.c */
 extern struct file_system_type nfs_xdev_fs_type;
--- a/fs/nfs/nfs3acl.c
+++ b/fs/nfs/nfs3acl.c
@@ -5,6 +5,8 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/nfsacl.h>
 
+#include "internal.h"
+
 #define NFSDBG_FACILITY	NFSDBG_PROC
 
 ssize_t nfs3_listxattr(struct dentry *dentry, char *buffer, size_t size)
@@ -205,6 +207,8 @@ struct posix_acl *nfs3_proc_getacl(struc
 	status = nfs_revalidate_inode(server, inode);
 	if (status < 0)
 		return ERR_PTR(status);
+	if (NFS_I(inode)->cache_validity & NFS_INO_INVALID_ACL)
+		nfs_zap_acl_cache(inode);
 	acl = nfs3_get_cached_acl(inode, type);
 	if (acl != ERR_PTR(-EAGAIN))
 		return acl;
@@ -319,9 +323,8 @@ static int nfs3_proc_setacls(struct inod
 	dprintk("NFS call setacl\n");
 	msg.rpc_proc = &server->client_acl->cl_procinfo[ACLPROC3_SETACL];
 	status = rpc_call_sync(server->client_acl, &msg, 0);
-	spin_lock(&inode->i_lock);
-	NFS_I(inode)->cache_validity |= NFS_INO_INVALID_ACCESS;
-	spin_unlock(&inode->i_lock);
+	nfs_access_zap_cache(inode);
+	nfs_zap_acl_cache(inode);
 	dprintk("NFS reply setacl: %d\n", status);
 
 	/* pages may have been allocated at the xdr layer. */
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2706,6 +2706,8 @@ static ssize_t nfs4_proc_get_acl(struct 
 	ret = nfs_revalidate_inode(server, inode);
 	if (ret < 0)
 		return ret;
+	if (NFS_I(inode)->cache_validity & NFS_INO_INVALID_ACL)
+		nfs_zap_acl_cache(inode);
 	ret = nfs4_read_cached_acl(inode, buf, buflen);
 	if (ret != -ENOENT)
 		return ret;
@@ -2733,7 +2735,8 @@ static int __nfs4_proc_set_acl(struct in
 	nfs_inode_return_delegation(inode);
 	buf_to_pages(buf, buflen, arg.acl_pages, &arg.acl_pgbase);
 	ret = rpc_call_sync(NFS_CLIENT(inode), &msg, 0);
-	nfs_zap_caches(inode);
+	nfs_access_zap_cache(inode);
+	nfs_zap_acl_cache(inode);
 	return ret;
 }
 

-- 
