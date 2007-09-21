Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbXIUOtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbXIUOtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbXIUOtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641AbXIUOtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/22] NFS: Display local caching state
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:25 +0100
Message-ID: <20070921144825.8323.59284.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Display the local caching state in /proc/fs/nfsfs/volumes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/client.c  |    7 ++++---
 fs/nfs/fscache.h |   12 ++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 0de4db4..d350668 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1319,7 +1319,7 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 
 	/* display header on line 1 */
 	if (v == &nfs_volume_list) {
-		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
+		seq_puts(m, "NV SERVER   PORT DEV     FSID              FSC\n");
 		return 0;
 	}
 	/* display one transport per line on subsequent lines */
@@ -1333,12 +1333,13 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
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
index 44bb0d1..77f3450 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -56,6 +56,17 @@ extern void __nfs_fscache_invalidate_page(struct page *, struct inode *);
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
@@ -110,6 +121,7 @@ static inline void nfs_fscache_unregister(void) {}
 static inline void nfs_fscache_get_client_cookie(struct nfs_client *clp) {}
 static inline void nfs4_fscache_get_client_cookie(struct nfs_client *clp) {}
 static inline void nfs_fscache_release_client_cookie(struct nfs_client *clp) {}
+static inline const char *nfs_server_fscache_state(struct nfs_server *server) { return "no "; }
 
 static inline void nfs_fscache_init_fh_cookie(struct inode *inode) {}
 static inline void nfs_fscache_enable_fh_cookie(struct inode *inode) {}

