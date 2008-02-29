Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbYB2BEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbYB2BEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763576AbYB2AsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:48:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763549AbYB2Arz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:47:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/37] NFS: Display local caching state [ver #34]
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 29 Feb 2008 00:46:46 +0000
Message-ID: <20080229004646.4142.51656.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
References: <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display the local caching state in /proc/fs/nfsfs/volumes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/client.c  |    7 ++++---
 fs/nfs/fscache.h |   15 +++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)


diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 51e9346..d67d52f 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1451,7 +1451,7 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 
 	/* display header on line 1 */
 	if (v == &nfs_volume_list) {
-		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
+		seq_puts(m, "NV SERVER   PORT DEV     FSID              FSC\n");
 		return 0;
 	}
 	/* display one transport per line on subsequent lines */
@@ -1465,12 +1465,13 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 		 (unsigned long long) server->fsid.major,
 		 (unsigned long long) server->fsid.minor);
 
-	seq_printf(m, "v%u %s %s %-7s %-17s\n",
+	seq_printf(m, "v%u %s %s %-7s %-17s %s\n",
 		   clp->rpc_ops->version,
 		   rpc_peeraddr2str(clp->cl_rpcclient, RPC_DISPLAY_HEX_ADDR),
 		   rpc_peeraddr2str(clp->cl_rpcclient, RPC_DISPLAY_HEX_PORT),
 		   dev,
-		   fsid);
+		   fsid,
+		   nfs_server_fscache_state(server));
 
 	return 0;
 }
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 2dc94e9..c9ed169 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -144,6 +144,16 @@ static inline void nfs_readpage_to_fscache(struct inode *inode,
 		__nfs_readpage_to_fscache(inode, page, sync);
 }
 
+/*
+ * indicate the client caching state as readable text
+ */
+static inline const char *nfs_server_fscache_state(struct nfs_server *server)
+{
+	if (server->fscache && (server->options & NFS_OPTION_FSCACHE))
+		return "yes";
+	return "no ";
+}
+
 
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
@@ -191,5 +201,10 @@ static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
 static inline void nfs_readpage_to_fscache(struct inode *inode,
 					   struct page *page, int sync) {}
 
+static inline const char *nfs_server_fscache_state(struct nfs_server *server)
+{
+	return "no ";
+}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */

