Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXLETsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXLETsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXLETlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:41:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbXLETk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:40:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/28] NFS: Display local caching state [try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:40:05 +0000
Message-ID: <20071205194005.24617.55345.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
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
index be38c3c..91ecea3 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1335,7 +1335,7 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 
 	/* display header on line 1 */
 	if (v == &nfs_volume_list) {
-		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
+		seq_puts(m, "NV SERVER   PORT DEV     FSID              FSC\n");
 		return 0;
 	}
 	/* display one transport per line on subsequent lines */
@@ -1349,12 +1349,13 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 		 (unsigned long long) server->fsid.major,
 		 (unsigned long long) server->fsid.minor);
 
-	seq_printf(m, "v%d %02x%02x%02x%02x %4hx %-7s %-17s\n",
+	seq_printf(m, "v%d %02x%02x%02x%02x %4hx %-7s %-17s %s\n",
 		   clp->cl_nfsversion,
 		   NIPQUAD(clp->cl_addr.sin_addr),
 		   ntohs(clp->cl_addr.sin_port),
 		   dev,
-		   fsid);
+		   fsid,
+		   nfs_server_fscache_state(server));
 
 	return 0;
 }
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 144fb58..9a735fc 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -53,6 +53,17 @@ extern void __nfs_fscache_invalidate_page(struct page *, struct inode *);
 extern int nfs_fscache_release_page(struct page *, gfp_t);
 
 /*
+ * indicate the client caching state as readable text
+ */
+static inline const char *nfs_server_fscache_state(struct nfs_server *server)
+{
+	if (server->nfs_client->fscache &&
+	    (server->options & NFS_OPTION_FSCACHE))
+		return "yes";
+	return "no ";
+}
+
+/*
  * release the caching state associated with a page if undergoing complete page
  * invalidation
  */
@@ -109,6 +120,10 @@ static inline void nfs4_fscache_get_client_cookie(struct nfs_client *clp) {}
 static inline void nfs_fscache_release_client_cookie(struct nfs_client *clp) {}
 static inline void nfs_fscache_show_stats(struct seq_file *m,
 					  struct nfs_server *nfss) {}
+static inline const char *nfs_server_fscache_state(struct nfs_server *server)
+{
+	return "no ";
+}
 
 static inline void nfs_fscache_init_fh_cookie(struct inode *inode) {}
 static inline void nfs_fscache_enable_fh_cookie(struct inode *inode) {}

