Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYKTO4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYKTO4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbYKTOop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:44:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41153 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbYKTOog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:44:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 33/45] NFS: Define and create server-level objects [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:44:29 +0000
Message-ID: <20081120144429.10667.69038.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and create server-level cache index objects (as managed by nfs_client
structs).

Each server object is created in the NFS top-level index object and is itself
an index into which superblock-level objects are inserted.

Ideally there would be one superblock-level object per server, and the former
would be folded into the latter; however, since the "nosharecache" option
exists this isn't possible.

The server object key is a sequence consisting of:

 (1) NFS version

 (2) Server address family (eg: AF_INET or AF_INET6)

 (3) Server port.

 (4) Server IP address.

The key blob is of variable length, depending on the length of (4).

The server object is given no coherency data to carry in the auxiliary data
permitted by the cache.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/Makefile           |    2 +
 fs/nfs/client.c           |    5 +++
 fs/nfs/fscache-index.c    |   65 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.c          |   52 ++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h          |   10 +++++++
 include/linux/nfs_fs_sb.h |    4 +++
 6 files changed, 137 insertions(+), 1 deletions(-)
 create mode 100644 fs/nfs/fscache.c


diff --git a/fs/nfs/Makefile b/fs/nfs/Makefile
index 0e0bb6c..8451598 100644
--- a/fs/nfs/Makefile
+++ b/fs/nfs/Makefile
@@ -15,4 +15,4 @@ nfs-$(CONFIG_NFS_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4renewd.o \
 			   callback.o callback_xdr.o callback_proc.o \
 			   nfs4namespace.o
 nfs-$(CONFIG_SYSCTL) += sysctl.o
-nfs-$(CONFIG_NFS_FSCACHE) += fscache-index.o
+nfs-$(CONFIG_NFS_FSCACHE) += fscache.o fscache-index.o
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 7547600..f3ffd55 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -45,6 +45,7 @@
 #include "delegation.h"
 #include "iostat.h"
 #include "internal.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_CLIENT
 
@@ -155,6 +156,8 @@ static struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_
 	if (!IS_ERR(cred))
 		clp->cl_machine_cred = cred;
 
+	nfs_fscache_get_client_cookie(clp);
+
 	return clp;
 
 error_3:
@@ -188,6 +191,8 @@ static void nfs_free_client(struct nfs_client *clp)
 
 	nfs4_shutdown_client(clp);
 
+	nfs_fscache_release_client_cookie(clp);
+
 	/* -EIO all pending I/O */
 	if (!IS_ERR(clp->cl_rpcclient))
 		rpc_shutdown_client(clp->cl_rpcclient);
diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index 6d5bb5c..ff14b03 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -47,3 +47,68 @@ void nfs_fscache_unregister(void)
 {
 	fscache_unregister_netfs(&nfs_fscache_netfs);
 }
+
+/*
+ * Layout of the key for an NFS server cache object.
+ */
+struct nfs_server_key {
+	uint16_t	nfsversion;		/* NFS protocol version */
+	uint16_t	family;			/* address family */
+	uint16_t	port;			/* IP port */
+	union {
+		struct in_addr	ipv4_addr;	/* IPv4 address */
+		struct in6_addr ipv6_addr;	/* IPv6 address */
+	} addr[0];
+};
+
+/*
+ * Generate a key to describe a server in the main NFS index
+ * - We return the length of the key, or 0 if we can't generate one
+ */
+static uint16_t nfs_server_get_key(const void *cookie_netfs_data,
+				   void *buffer, uint16_t bufmax)
+{
+	const struct nfs_client *clp = cookie_netfs_data;
+	const struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *) &clp->cl_addr;
+	const struct sockaddr_in *sin = (struct sockaddr_in *) &clp->cl_addr;
+	struct nfs_server_key *key = buffer;
+	uint16_t len = sizeof(struct nfs_server_key);
+
+	key->nfsversion = clp->rpc_ops->version;
+	key->family = clp->cl_addr.ss_family;
+
+	memset(key, 0, len);
+
+	switch (clp->cl_addr.ss_family) {
+	case AF_INET:
+		key->port = sin->sin_port;
+		key->addr[0].ipv4_addr = sin->sin_addr;
+		len += sizeof(key->addr[0].ipv4_addr);
+		break;
+
+	case AF_INET6:
+		key->port = sin6->sin6_port;
+		key->addr[0].ipv6_addr = sin6->sin6_addr;
+		len += sizeof(key->addr[0].ipv6_addr);
+		break;
+
+	default:
+		printk(KERN_WARNING "NFS: Unknown network family '%d'\n",
+		       clp->cl_addr.ss_family);
+		len = 0;
+		break;
+	}
+
+	return len;
+}
+
+/*
+ * Define the server object for FS-Cache.  This is used to describe a server
+ * object to fscache_acquire_cookie().  It is keyed by the NFS protocol and
+ * server address parameters.
+ */
+const struct fscache_cookie_def nfs_fscache_server_index_def = {
+	.name		= "NFS.server",
+	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= nfs_server_get_key,
+};
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
new file mode 100644
index 0000000..c3f056f
--- /dev/null
+++ b/fs/nfs/fscache.c
@@ -0,0 +1,52 @@
+/* NFS filesystem cache interface
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/nfs_fs.h>
+#include <linux/nfs_fs_sb.h>
+#include <linux/in6.h>
+#include <linux/seq_file.h>
+
+#include "internal.h"
+#include "fscache.h"
+
+#define NFSDBG_FACILITY		NFSDBG_FSCACHE
+
+/*
+ * Get the per-client index cookie for an NFS client if the appropriate mount
+ * flag was set
+ * - We always try and get an index cookie for the client, but get filehandle
+ *   cookies on a per-superblock basis, depending on the mount flags
+ */
+void nfs_fscache_get_client_cookie(struct nfs_client *clp)
+{
+	/* create a cache index for looking up filehandles */
+	clp->fscache = fscache_acquire_cookie(nfs_fscache_netfs.primary_index,
+					      &nfs_fscache_server_index_def,
+					      clp);
+	dfprintk(FSCACHE, "NFS: get client cookie (0x%p/0x%p)\n",
+		 clp, clp->fscache);
+}
+
+/*
+ * Dispose of a per-client cookie
+ */
+void nfs_fscache_release_client_cookie(struct nfs_client *clp)
+{
+	dfprintk(FSCACHE, "NFS: releasing client cookie (0x%p/0x%p)\n",
+		 clp, clp->fscache);
+
+	fscache_relinquish_cookie(clp->fscache, 0);
+	clp->fscache = NULL;
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index ccfcdc5..1d864be 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -23,13 +23,23 @@
  * fscache-index.c
  */
 extern struct fscache_netfs nfs_fscache_netfs;
+extern const struct fscache_cookie_def nfs_fscache_server_index_def;
 
 extern int nfs_fscache_register(void);
 extern void nfs_fscache_unregister(void);
 
+/*
+ * fscache.c
+ */
+extern void nfs_fscache_get_client_cookie(struct nfs_client *);
+extern void nfs_fscache_release_client_cookie(struct nfs_client *);
+
 #else /* CONFIG_NFS_FSCACHE */
 static inline int nfs_fscache_register(void) { return 0; }
 static inline void nfs_fscache_unregister(void) {}
 
+static inline void nfs_fscache_get_client_cookie(struct nfs_client *clp) {}
+static inline void nfs_fscache_release_client_cookie(struct nfs_client *clp) {}
+
 #endif /* CONFIG_NFS_FSCACHE */
 #endif /* _NFS_FSCACHE_H */
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 6fd68d5..614bc16 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -70,6 +70,10 @@ struct nfs_client {
 	char			cl_ipaddr[48];
 	unsigned char		cl_id_uniquifier;
 #endif
+
+#ifdef CONFIG_NFS_FSCACHE
+	struct fscache_cookie	*fscache;	/* client index cache cookie */
+#endif
 };
 
 /*

