Return-Path: <linux-kernel-owner+w=401wt.eu-S941306AbXHJQQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941306AbXHJQQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936659AbXHJQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:07:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940405AbXHJQHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:07:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/16] NFS: Use local caching [try #3]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov
Date: Fri, 10 Aug 2007 17:06:08 +0100
Message-ID: <20070810160608.24698.72894.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
References: <20070810160455.24698.30983.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch makes it possible for the NFS filesystem to make use of the
network filesystem local caching service (FS-Cache).

To be able to use this, an updated mount program is required.  This can be
obtained from:

	http://people.redhat.com/steved/fscache/util-linux/

To mount an NFS filesystem to use caching, add an "fsc" option to the mount:

	mount warthog:/ /a -o fsc

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 fs/nfs/Makefile           |    1 
 fs/nfs/client.c           |    5 +
 fs/nfs/file.c             |   51 ++++++
 fs/nfs/fscache-def.c      |  288 +++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.c          |  374 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nfs/fscache.h          |  144 +++++++++++++++++
 fs/nfs/inode.c            |   48 +++++-
 fs/nfs/read.c             |   28 +++
 fs/nfs/sysctl.c           |   44 +++++
 include/linux/nfs_fs.h    |    8 +
 include/linux/nfs_fs_sb.h |    7 +
 11 files changed, 988 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/Makefile b/fs/nfs/Makefile
index b55cb23..07c9345 100644
--- a/fs/nfs/Makefile
+++ b/fs/nfs/Makefile
@@ -16,4 +16,5 @@ nfs-$(CONFIG_NFS_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4renewd.o \
 			   nfs4namespace.o
 nfs-$(CONFIG_NFS_DIRECTIO) += direct.o
 nfs-$(CONFIG_SYSCTL) += sysctl.o
+nfs-$(CONFIG_NFS_FSCACHE) += fscache.o fscache-def.o
 nfs-objs		:= $(nfs-y)
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index a49f9fe..f1783b2 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -41,6 +41,7 @@
 #include "delegation.h"
 #include "iostat.h"
 #include "internal.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_CLIENT
 
@@ -137,6 +138,8 @@ static struct nfs_client *nfs_alloc_client(const char *hostname,
 	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
 #endif
 
+	nfs_fscache_get_client_cookie(clp);
+
 	return clp;
 
 error_3:
@@ -168,6 +171,8 @@ static void nfs_free_client(struct nfs_client *clp)
 
 	nfs4_shutdown_client(clp);
 
+	nfs_fscache_release_client_cookie(clp);
+
 	/* -EIO all pending I/O */
 	if (!IS_ERR(clp->cl_rpcclient))
 		rpc_shutdown_client(clp->cl_rpcclient);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index c87dc71..d4d9c06 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -34,6 +34,8 @@
 
 #include "delegation.h"
 #include "iostat.h"
+#include "internal.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_FILE
 
@@ -54,6 +56,12 @@ static int nfs_check_flags(int flags);
 static int nfs_lock(struct file *filp, int cmd, struct file_lock *fl);
 static int nfs_flock(struct file *filp, int cmd, struct file_lock *fl);
 static int nfs_setlease(struct file *file, long arg, struct file_lock **fl);
+static int nfs_file_page_mkwrite(struct vm_area_struct *vma, struct page *page);
+
+struct vm_operations_struct nfs_fs_vm_operations = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= nfs_file_page_mkwrite,
+};
 
 const struct file_operations nfs_file_operations = {
 	.llseek		= nfs_file_llseek,
@@ -259,6 +267,9 @@ nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
 	status = nfs_revalidate_mapping(inode, file->f_mapping);
 	if (!status)
 		status = generic_file_mmap(file, vma);
+	if (!status)
+		vma->vm_ops = &nfs_fs_vm_operations;
+
 	return status;
 }
 
@@ -311,22 +322,48 @@ static int nfs_commit_write(struct file *file, struct page *page, unsigned offse
 	return status;
 }
 
+/*
+ * Partially or wholly invalidate a page
+ * - Release the private state associated with a page if undergoing complete
+ *   page invalidation
+ * - Called if either PG_private or PG_fscache set on the page
+ * - Caller holds page lock
+ */
 static void nfs_invalidate_page(struct page *page, unsigned long offset)
 {
 	if (offset != 0)
 		return;
 	/* Cancel any unstarted writes on this page */
 	nfs_wb_page_priority(page->mapping->host, page, FLUSH_INVALIDATE);
+
+	nfs_fscache_invalidate_page(page, page->mapping->host);
 }
 
+/*
+ * Release the private state associated with a page
+ * - Called if either PG_private or PG_fscache set on the page
+ * - Caller holds page lock
+ * - Return true (may release) or false (may not)
+ */
 static int nfs_release_page(struct page *page, gfp_t gfp)
 {
 	/* If PagePrivate() is set, then the page is not freeable */
-	return 0;
+	if (PagePrivate(page))
+		return 0;
+	return nfs_fscache_release_page(page, gfp);
 }
 
+/*
+ * Attempt to clear the private state associated with a page when an error
+ * occurs that requires the cached contents of an inode to be written back or
+ * destroyed
+ * - Called if either PG_private or PG_fscache set on the page
+ * - Caller holds page lock
+ * - Return 0 if successful, -error otherwise
+ */
 static int nfs_launder_page(struct page *page)
 {
+	wait_on_page_fscache_write(page);
 	return nfs_wb_page(page->mapping->host, page);
 }
 
@@ -572,3 +609,15 @@ static int nfs_setlease(struct file *file, long arg, struct file_lock **fl)
 	 */
 	return -EINVAL;
 }
+
+/*
+ * Notification that a PTE pointing to an NFS page is about to be made
+ * writable, implying that someone is about to modify the page through a
+ * shared-writable mapping
+ */
+static int nfs_file_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	/* make sure the cache has finished storing the page */
+	wait_on_page_fscache_write(page);
+	return 0;
+}
diff --git a/fs/nfs/fscache-def.c b/fs/nfs/fscache-def.c
new file mode 100644
index 0000000..4aa2bab
--- /dev/null
+++ b/fs/nfs/fscache-def.c
@@ -0,0 +1,288 @@
+/* NFS FS-Cache index structure definition
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
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
+
+#include "internal.h"
+#include "fscache.h"
+
+#define NFSDBG_FACILITY		NFSDBG_FSCACHE
+
+/*
+ * Definition of the auxiliary data attached to NFS inode storage objects.
+ * This is used for coherency management.
+ */
+struct nfs_fh_auxdata {
+	struct timespec	i_mtime;
+	struct timespec	i_ctime;
+	loff_t		i_size;
+};
+
+/*
+ * Definition of the key for an NFS server index object.  The server's IP
+ * address is stored as an IPv6 address, with IPv4 addresses being wrapped
+ * appropriately.
+ */
+struct nfs_server_key {
+	uint16_t nfsversion;
+	uint16_t port;
+	union {
+		struct {
+			uint8_t		ipv6wrapper[12];
+			struct in_addr	addr;
+		} ipv4_addr;
+		struct in6_addr ipv6_addr;
+	};
+};
+
+static const struct fscache_netfs_operations nfs_cache_ops = {
+};
+
+struct fscache_netfs nfs_cache_netfs = {
+	.name		= "nfs",
+	.version	= 0,
+	.ops		= &nfs_cache_ops,
+};
+
+static const uint8_t nfs_cache_ipv6_wrapper_for_ipv4[12] = {
+	[0 ... 9]	= 0x00,
+	[10 ... 11]	= 0xff
+};
+
+/*
+ * Generate a key to describe a server in the main NFS index
+ */
+static uint16_t nfs_server_get_key(const void *cookie_netfs_data,
+				   void *buffer, uint16_t bufmax)
+{
+	const struct nfs_client *clp = cookie_netfs_data;
+	struct nfs_server_key *key = buffer;
+	uint16_t len = 0;
+
+	key->nfsversion = clp->cl_nfsversion;
+
+	switch (clp->cl_addr.sin_family) {
+	case AF_INET:
+		key->port = clp->cl_addr.sin_port;
+
+		memcpy(&key->ipv4_addr.ipv6wrapper,
+		       &nfs_cache_ipv6_wrapper_for_ipv4,
+		       sizeof(key->ipv4_addr.ipv6wrapper));
+		memcpy(&key->ipv4_addr.addr,
+		       &clp->cl_addr.sin_addr,
+		       sizeof(key->ipv4_addr.addr));
+		len = sizeof(struct nfs_server_key);
+		break;
+
+	case AF_INET6:
+		key->port = clp->cl_addr.sin_port;
+
+		memcpy(&key->ipv6_addr,
+		       &clp->cl_addr.sin_addr,
+		       sizeof(key->ipv6_addr));
+		len = sizeof(struct nfs_server_key);
+		break;
+
+	default:
+		len = 0;
+		printk(KERN_WARNING "NFS: Unknown network family '%d'\n",
+			clp->cl_addr.sin_family);
+		break;
+	}
+
+	return len;
+}
+
+/*
+ * The root index for the filesystem is defined by nfsd IP address and ports
+ */
+const struct fscache_cookie_def nfs_cache_server_index_def = {
+	.name		= "NFS.servers",
+	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= nfs_server_get_key,
+};
+
+/*
+ * Generate a key to describe an NFS inode in an NFS server's index
+ */
+static uint16_t nfs_fh_get_key(const void *cookie_netfs_data,
+			       void *buffer, uint16_t bufmax)
+{
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+	uint16_t nsize;
+
+	/* use the inode's NFS filehandle as the key */
+	nsize = nfsi->fh.size;
+	memcpy(buffer, nfsi->fh.data, nsize);
+	return nsize;
+}
+
+/*
+ * Get an extra reference on a read context
+ * - This function can be absent if the completion function doesn't require a
+ *   context
+ */
+static void nfs_fh_get_context(void *cookie_netfs_data, void *context)
+{
+	get_nfs_open_context(context);
+}
+
+/*
+ * Release an extra reference on a read context
+ * - This function can be absent if the completion function doesn't require a
+ *   context
+ */
+static void nfs_fh_put_context(void *cookie_netfs_data, void *context)
+{
+	if (context)
+		put_nfs_open_context(context);
+}
+
+/*
+ * Indication the cookie is no longer uncached
+ * - This function is called when the backing store currently caching a cookie
+ *   is removed
+ * - The netfs should use this to clean up any markers indicating cached pages
+ * - This is mandatory for any object that may have data
+ */
+static void nfs_fh_now_uncached(void *cookie_netfs_data)
+{
+	struct nfs_inode *nfsi = cookie_netfs_data;
+	struct pagevec pvec;
+	pgoff_t first;
+	int loop, nr_pages;
+
+	pagevec_init(&pvec, 0);
+	first = 0;
+
+	dprintk("NFS: nfs_fh_now_uncached: nfs_inode 0x%p\n", nfsi);
+
+	for (;;) {
+		/* grab a bunch of pages to clean */
+		nr_pages = pagevec_lookup(&pvec,
+					  nfsi->vfs_inode.i_mapping,
+					  first,
+					  PAGEVEC_SIZE - pagevec_count(&pvec));
+		if (!nr_pages)
+			break;
+
+		for (loop = 0; loop < nr_pages; loop++)
+			ClearPageFsCache(pvec.pages[loop]);
+
+		first = pvec.pages[nr_pages - 1]->index + 1;
+
+		pvec.nr = nr_pages;
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+}
+
+/*
+ * Tet certain file attributes from the netfs data
+ * - This function can be absent for an index
+ * - Not permitted to return an error
+ * - The netfs data from the cookie being used as the source is
+ *   presented
+ */
+static void nfs_fh_get_attr(const void *cookie_netfs_data, uint64_t *size)
+{
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+
+	*size = nfsi->vfs_inode.i_size;
+}
+
+/*
+ * Get the auxiliary data from netfs data
+ * - This function can be absent if the index carries no state data
+ * - Should store the auxiliary data in the buffer
+ * - Should return the amount of amount stored
+ * - Not permitted to return an error
+ * - The netfs data from the cookie being used as the source is presented
+ */
+static uint16_t nfs_fh_get_aux(const void *cookie_netfs_data,
+			       void *buffer, uint16_t bufmax)
+{
+	struct nfs_fh_auxdata auxdata;
+	const struct nfs_inode *nfsi = cookie_netfs_data;
+
+	auxdata.i_size = nfsi->vfs_inode.i_size;
+	auxdata.i_mtime = nfsi->vfs_inode.i_mtime;
+	auxdata.i_ctime = nfsi->vfs_inode.i_ctime;
+
+	if (bufmax > sizeof(auxdata))
+		bufmax = sizeof(auxdata);
+
+	memcpy(buffer, &auxdata, bufmax);
+	return bufmax;
+}
+
+/*
+ * Consult the netfs about the state of an object
+ * - This function can be absent if the index carries no state data
+ * - The netfs data from the cookie being used as the target is
+ *   presented, as is the auxiliary data
+ */
+static fscache_checkaux_t nfs_fh_check_aux(void *cookie_netfs_data,
+					   const void *data, uint16_t datalen)
+{
+	struct nfs_fh_auxdata auxdata;
+	struct nfs_inode *nfsi = cookie_netfs_data;
+
+	if (datalen > sizeof(auxdata))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	auxdata.i_size = nfsi->vfs_inode.i_size;
+	auxdata.i_mtime = nfsi->vfs_inode.i_mtime;
+	auxdata.i_ctime = nfsi->vfs_inode.i_ctime;
+
+	if (memcmp(data, &auxdata, datalen) != 0)
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	return FSCACHE_CHECKAUX_OKAY;
+}
+
+/*
+ * The primary index for each server is simply made up of a series of NFS file
+ * handles
+ */
+const struct fscache_cookie_def nfs_cache_fh_index_def = {
+	.name		= "NFS.fh",
+	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
+	.get_key	= nfs_fh_get_key,
+	.get_attr	= nfs_fh_get_attr,
+	.get_aux	= nfs_fh_get_aux,
+	.check_aux	= nfs_fh_check_aux,
+	.get_context	= nfs_fh_get_context,
+	.put_context	= nfs_fh_put_context,
+	.now_uncached	= nfs_fh_now_uncached,
+};
+
+/*
+ * Register NFS for caching
+ */
+int nfs_fscache_register(void)
+{
+	return fscache_register_netfs(&nfs_cache_netfs);
+}
+
+/*
+ * Unregister NFS for caching
+ */
+void nfs_fscache_unregister(void)
+{
+	fscache_unregister_netfs(&nfs_cache_netfs);
+}
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
new file mode 100644
index 0000000..2bb9bbb
--- /dev/null
+++ b/fs/nfs/fscache.c
@@ -0,0 +1,374 @@
+/* NFS filesystem cache interface
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/nfs_fs.h>
+#include <linux/nfs_fs_sb.h>
+#include <linux/in6.h>
+
+#include "internal.h"
+#include "fscache.h"
+
+#define NFSDBG_FACILITY		NFSDBG_FSCACHE
+
+/*
+ * Sysctl variables
+ */
+atomic_t nfs_fscache_to_pages;
+atomic_t nfs_fscache_from_pages;
+atomic_t nfs_fscache_uncache_page;
+int nfs_fscache_from_error;
+int nfs_fscache_to_error;
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
+	clp->fscache = fscache_acquire_cookie(nfs_cache_netfs.primary_index,
+					      &nfs_cache_server_index_def,
+					      clp);
+	dfprintk(FSCACHE,"NFS: get client cookie (0x%p/0x%p)\n",
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
+
+/*
+ * Initialise the per-filehandle cookie for an NFS inode
+ */
+void nfs_fscache_init_fh_cookie(struct inode *inode)
+{
+	NFS_I(inode)->fscache = NULL;
+	if (S_ISREG(inode->i_mode))
+		set_bit(NFS_INO_FSCACHE, &NFS_I(inode)->flags);
+}
+
+/*
+ * Get the per-filehandle cookie for an NFS inode
+ */
+void nfs_fscache_enable_fh_cookie(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	if (nfsi->fscache || !NFS_FSCACHE(inode))
+		return;
+
+	if ((NFS_SB(sb)->options & NFS_OPTION_FSCACHE)) {
+		nfsi->fscache = fscache_acquire_cookie(
+			NFS_SB(sb)->nfs_client->fscache,
+			&nfs_cache_fh_index_def,
+			nfsi);
+
+		dfprintk(FSCACHE, "NFS: get FH cookie (0x%p/0x%p/0x%p)\n",
+			 sb, nfsi, nfsi->fscache);
+	}
+}
+
+/*
+ * Release a per-filehandle cookie
+ */
+void nfs_fscache_release_fh_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	dfprintk(FSCACHE, "NFS: clear cookie (0x%p/0x%p)\n",
+		 nfsi, nfsi->fscache);
+
+	fscache_relinquish_cookie(nfsi->fscache, 0);
+	nfsi->fscache = NULL;
+}
+
+/*
+ * Retire a per-filehandle cookie, destroying the data attached to it
+ */
+void nfs_fscache_zap_fh_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+
+	dfprintk(FSCACHE,"NFS: zapping cookie (0x%p/0x%p)\n",
+		nfsi, nfsi->fscache);
+
+	fscache_relinquish_cookie(nfsi->fscache, 1);
+	nfsi->fscache = NULL;
+}
+
+/*
+ * Turn off the cache with regard to a filehandle cookie if opened for writing,
+ * invalidating all the pages in the page cache relating to the associated
+ * inode to clear the per-page caching
+ */
+void nfs_fscache_disable_fh_cookie(struct inode *inode)
+{
+	clear_bit(NFS_INO_FSCACHE, &NFS_I(inode)->flags);
+
+	if (NFS_I(inode)->fscache) {
+		dfprintk(FSCACHE,
+			 "NFS: nfsi 0x%p turning cache off\n", NFS_I(inode));
+
+		/* Need to invalidate any mapped pages that were read in before
+		 * turning off the cache.
+		 */
+		if (inode->i_mapping && inode->i_mapping->nrpages)
+			invalidate_inode_pages2(inode->i_mapping);
+
+		nfs_fscache_zap_fh_cookie(inode);
+	}
+}
+
+/*
+ * Decide if we should enable or disable the FS cache for this inode
+ * - For now, only regular files that are open read-only will be able to use
+ *   the cache
+ */
+void nfs_fscache_set_fh_cookie(struct inode *inode, struct file *filp)
+{
+	if (NFS_FSCACHE(inode)) {
+		if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
+			nfs_fscache_disable_fh_cookie(inode);
+		else
+			nfs_fscache_enable_fh_cookie(inode);
+	}
+}
+
+/*
+ * Replace a per-filehandle cookie due to revalidation detecting a file having
+ * changed on the server
+ */
+void nfs_fscache_renew_fh_cookie(struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(inode);
+	struct nfs_server *server = NFS_SERVER(inode);
+	struct fscache_cookie *old = nfsi->fscache;
+
+	if (nfsi->fscache) {
+		/* retire the current fscache cache and get a new one */
+		fscache_relinquish_cookie(nfsi->fscache, 1);
+
+		nfsi->fscache = fscache_acquire_cookie(
+			server->nfs_client->fscache,
+			&nfs_cache_fh_index_def,
+			nfsi);
+
+		dfprintk(FSCACHE,
+			 "NFS: revalidation new cookie (0x%p/0x%p/0x%p/0x%p)\n",
+			 server, nfsi, old, nfsi->fscache);
+	}
+}
+
+/*
+ * change the filesize associated with a per-filehandle cookie
+ */
+void nfs_fscache_attr_changed(struct inode *inode)
+{
+	fscache_attr_changed(NFS_I(inode)->fscache);
+}
+
+/*
+ * Handle completion of a page being read from the cache
+ * - Called in process (keventd) context
+ */
+static void nfs_readpage_from_fscache_complete(struct page *page,
+					       void *context,
+					       int error)
+{
+	dfprintk(FSCACHE,
+		 "NFS: readpage_from_fscache_complete (0x%p/0x%p/%d)\n",
+		 page, context, error);
+
+	/* if the read completes with an error, we just unlock the page and let
+	 * the VM reissue the readpage */
+	if (!error) {
+		SetPageUptodate(page);
+		unlock_page(page);
+	} else {
+		error = nfs_readpage_async(context, page->mapping->host, page);
+		if (error)
+			unlock_page(page);
+	}
+}
+
+/*
+ * Store a newly fetched page in fscache
+ * - PG_fscache must be set on the page
+ */
+void __nfs_readpage_to_fscache(struct inode *inode, struct page *page, int sync)
+{
+	int ret;
+
+	dfprintk(FSCACHE,
+		 "NFS: readpage_to_fscache(fsc:%p/p:%p(i:%lx f:%lx)/%d)\n",
+		 NFS_I(inode)->fscache, page, page->index, page->flags, sync);
+
+	ret = fscache_write_page(NFS_I(inode)->fscache, page, GFP_KERNEL);
+	dfprintk(FSCACHE,
+		 "NFS:     readpage_to_fscache: p:%p(i:%lu f:%lx) ret %d\n",
+		 page, page->index, page->flags, ret);
+
+	if (ret != 0) {
+		fscache_uncache_page(NFS_I(inode)->fscache, page);
+		atomic_inc(&nfs_fscache_uncache_page);
+		nfs_fscache_to_error = ret;
+	} else {
+		atomic_inc(&nfs_fscache_to_pages);
+	}
+}
+
+/*
+ * Retrieve a page from fscache
+ */
+int __nfs_readpage_from_fscache(struct nfs_open_context *ctx,
+				struct inode *inode, struct page *page)
+{
+	int ret;
+
+	dfprintk(FSCACHE,
+		 "NFS: readpage_from_fscache(fsc:%p/p:%p(i:%lx f:%lx)/0x%p)\n",
+		 NFS_I(inode)->fscache, page, page->index, page->flags, inode);
+
+	ret = fscache_read_or_alloc_page(NFS_I(inode)->fscache,
+					 page,
+					 nfs_readpage_from_fscache_complete,
+					 ctx,
+					 GFP_KERNEL);
+
+	switch (ret) {
+	case 0: /* read BIO submitted (page in fscache) */
+		dfprintk(FSCACHE,
+			 "NFS:    readpage_from_fscache: BIO submitted\n");
+		atomic_inc(&nfs_fscache_from_pages);
+		return ret;
+
+	case -ENOBUFS: /* inode not in cache */
+	case -ENODATA: /* page not in cache */
+		dfprintk(FSCACHE,
+			 "NFS:    readpage_from_fscache error %d\n", ret);
+		return 1;
+
+	default:
+		dfprintk(FSCACHE, "NFS:    readpage_from_fscache %d\n", ret);
+		nfs_fscache_from_error = ret;
+	}
+	return ret;
+}
+
+/*
+ * Retrieve a set of pages from fscache
+ */
+int __nfs_readpages_from_fscache(struct nfs_open_context *ctx,
+				 struct inode *inode,
+				 struct address_space *mapping,
+				 struct list_head *pages,
+				 unsigned *nr_pages)
+{
+	int ret, npages = *nr_pages;
+
+	dfprintk(FSCACHE, "NFS: nfs_getpages_from_fscache (0x%p/%u/0x%p)\n",
+		 NFS_I(inode)->fscache, npages, inode);
+
+	ret = fscache_read_or_alloc_pages(NFS_I(inode)->fscache,
+					  mapping, pages, nr_pages,
+					  nfs_readpage_from_fscache_complete,
+					  ctx,
+					  mapping_gfp_mask(mapping));
+
+
+	switch (ret) {
+	case 0: /* read BIO submitted (page in fscache) */
+		BUG_ON(!list_empty(pages));
+		BUG_ON(*nr_pages != 0);
+		dfprintk(FSCACHE, "NFS: nfs_getpages_from_fscache: submitted\n");
+
+		atomic_add(npages, &nfs_fscache_from_pages);
+		return ret;
+
+	case -ENOBUFS: /* inode not in cache */
+	case -ENODATA: /* page not in cache */
+		dfprintk(FSCACHE,
+			 "NFS: nfs_getpages_from_fscache: no page: %d\n", ret);
+		return 1;
+
+	default:
+		dfprintk(FSCACHE,
+			 "NFS: nfs_getpages_from_fscache: ret  %d\n", ret);
+		nfs_fscache_from_error = ret;
+	}
+
+	return ret;
+}
+
+/*
+ * Release the caching state associated with a page, if the page isn't busy
+ * interacting with the cache
+ * - Returns true (can release page) or false (page busy)
+ */
+int nfs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	if (PageFsCacheWrite(page)) {
+		if (!(gfp & __GFP_WAIT))
+			return 0;
+		wait_on_page_fscache_write(page);
+	}
+
+	if (PageFsCache(page)) {
+		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+
+		BUG_ON(!nfsi->fscache);
+
+		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
+			 nfsi->fscache, page, nfsi);
+
+		fscache_uncache_page(nfsi->fscache, page);
+		atomic_inc(&nfs_fscache_uncache_page);
+	}
+
+	return 1;
+}
+
+/*
+ * Release the caching state associated with a page if undergoing complete page
+ * invalidation
+ */
+void __nfs_fscache_invalidate_page(struct page *page, struct inode *inode)
+{
+	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+
+	BUG_ON(!nfsi->fscache);
+
+	dfprintk(FSCACHE, "NFS: fscache invalidatepage (0x%p/0x%p/0x%p)\n",
+		 nfsi->fscache, page, nfsi);
+
+	wait_on_page_fscache_write(page);
+
+	BUG_ON(!PageLocked(page));
+	if (!PageWriteback(page)) {
+		fscache_uncache_page(nfsi->fscache, page);
+		atomic_inc(&nfs_fscache_uncache_page);
+	}
+}
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
new file mode 100644
index 0000000..44bb0d1
--- /dev/null
+++ b/fs/nfs/fscache.h
@@ -0,0 +1,144 @@
+/* NFS filesystem cache interface definitions
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _NFS_FSCACHE_H
+#define _NFS_FSCACHE_H
+
+#include <linux/nfs_fs.h>
+#include <linux/nfs_mount.h>
+#include <linux/nfs4_mount.h>
+
+#ifdef CONFIG_NFS_FSCACHE
+#include <linux/fscache.h>
+
+/*
+ * fscache-def.c
+ */
+extern struct fscache_netfs nfs_cache_netfs;
+extern const struct fscache_cookie_def nfs_cache_server_index_def;
+extern const struct fscache_cookie_def nfs_cache_fh_index_def;
+
+extern int nfs_fscache_register(void);
+extern void nfs_fscache_unregister(void);
+
+/*
+ * fscache.c
+ */
+extern atomic_t nfs_fscache_to_pages;
+extern atomic_t nfs_fscache_from_pages;
+extern atomic_t nfs_fscache_uncache_page;
+extern int nfs_fscache_from_error;
+extern int nfs_fscache_to_error;
+
+extern void nfs_fscache_get_client_cookie(struct nfs_client *);
+extern void nfs_fscache_release_client_cookie(struct nfs_client *);
+extern void nfs_fscache_init_fh_cookie(struct inode *);
+extern void nfs_fscache_enable_fh_cookie(struct inode *);
+extern void nfs_fscache_release_fh_cookie(struct inode *);
+extern void nfs_fscache_zap_fh_cookie(struct inode *);
+extern void nfs_fscache_disable_fh_cookie(struct inode *);
+extern void nfs_fscache_set_fh_cookie(struct inode *, struct file *);
+extern void nfs_fscache_renew_fh_cookie(struct inode *);
+extern void nfs_fscache_attr_changed(struct inode *);
+extern void __nfs_readpage_to_fscache(struct inode *, struct page *, int);
+extern int __nfs_readpage_from_fscache(struct nfs_open_context *, struct inode *, struct page *);
+extern int __nfs_readpages_from_fscache(struct nfs_open_context *, struct inode *,
+					struct address_space *, struct list_head *, unsigned *);
+extern void __nfs_fscache_invalidate_page(struct page *, struct inode *);
+extern int nfs_fscache_release_page(struct page *, gfp_t);
+
+/*
+ * release the caching state associated with a page if undergoing complete page
+ * invalidation
+ */
+static inline void nfs_fscache_invalidate_page(struct page *page,
+					       struct inode *inode)
+{
+	if (PageFsCache(page))
+		__nfs_fscache_invalidate_page(page, inode);
+}
+
+/*
+ * store a newly fetched page in fscache
+ */
+static inline void nfs_readpage_to_fscache(struct inode *inode,
+					   struct page *page,
+					   int sync)
+{
+	if (PageFsCache(page))
+		__nfs_readpage_to_fscache(inode, page, sync);
+}
+
+/*
+ * retrieve a page from fscache
+ */
+static inline int nfs_readpage_from_fscache(struct nfs_open_context *ctx,
+					    struct inode *inode,
+					    struct page *page)
+{
+	if (NFS_I(inode)->fscache)
+		return __nfs_readpage_from_fscache(ctx, inode, page);
+	return -ENOBUFS;
+}
+
+/*
+ * retrieve a set of pages from fscache
+ */
+static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
+					     struct inode *inode,
+					     struct address_space *mapping,
+					     struct list_head *pages,
+					     unsigned *nr_pages)
+{
+	if (NFS_I(inode)->fscache)
+		return __nfs_readpages_from_fscache(ctx, inode, mapping, pages,
+						    nr_pages);
+	return -ENOBUFS;
+}
+
+#else /* CONFIG_NFS_FSCACHE */
+static inline int nfs_fscache_register(void) { return 0; }
+static inline void nfs_fscache_unregister(void) {}
+static inline void nfs_fscache_get_client_cookie(struct nfs_client *clp) {}
+static inline void nfs4_fscache_get_client_cookie(struct nfs_client *clp) {}
+static inline void nfs_fscache_release_client_cookie(struct nfs_client *clp) {}
+
+static inline void nfs_fscache_init_fh_cookie(struct inode *inode) {}
+static inline void nfs_fscache_enable_fh_cookie(struct inode *inode) {}
+static inline void nfs_fscache_attr_changed(struct inode *inode) {}
+static inline void nfs_fscache_release_fh_cookie(struct inode *inode) {}
+static inline void nfs_fscache_zap_fh_cookie(struct inode *inode) {}
+static inline void nfs_fscache_renew_fh_cookie(struct inode *inode) {}
+static inline void nfs_fscache_disable_fh_cookie(struct inode *inode) {}
+static inline void nfs_fscache_set_fh_cookie(struct inode *inode, struct file *filp) {}
+static inline void nfs_fscache_install_vm_ops(struct inode *inode, struct vm_area_struct *vma) {}
+static inline int nfs_fscache_release_page(struct page *page, gfp_t gfp)
+{
+	return 1; /* True: may release page */
+}
+static inline void nfs_fscache_invalidate_page(struct page *page, struct inode *inode) {}
+static inline void nfs_readpage_to_fscache(struct inode *inode, struct page *page, int sync) {}
+static inline int nfs_readpage_from_fscache(struct nfs_open_context *ctx,
+					    struct inode *inode, struct page *page)
+{
+	return -ENOBUFS;
+}
+static inline int nfs_readpages_from_fscache(struct nfs_open_context *ctx,
+					     struct inode *inode,
+					     struct address_space *mapping,
+					     struct list_head *pages,
+					     unsigned *nr_pages)
+{
+	return -ENOBUFS;
+}
+
+#endif /* CONFIG_NFS_FSCACHE */
+#endif /* _NFS_FSCACHE_H */
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 71a49c3..db04114 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -46,6 +46,7 @@
 #include "delegation.h"
 #include "iostat.h"
 #include "internal.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
@@ -88,6 +89,7 @@ void nfs_clear_inode(struct inode *inode)
 	BUG_ON(atomic_read(&NFS_I(inode)->data_updates) != 0);
 	nfs_zap_acl_cache(inode);
 	nfs_access_zap_cache(inode);
+	nfs_fscache_release_fh_cookie(inode);
 }
 
 /**
@@ -300,6 +302,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 		nfsi->access_cache = RB_ROOT;
 
+		nfs_fscache_init_fh_cookie(inode);
+
 		unlock_new_inode(inode);
 	} else
 		nfs_refresh_inode(inode, fattr);
@@ -565,6 +569,7 @@ int nfs_open(struct inode *inode, struct file *filp)
 	ctx->mode = filp->f_mode;
 	nfs_file_set_open_context(filp, ctx);
 	put_nfs_open_context(ctx);
+	nfs_fscache_set_fh_cookie(inode, filp);
 	return 0;
 }
 
@@ -631,7 +636,13 @@ __nfs_revalidate_inode(struct nfs_server *server, struct inode *inode)
 			 (long long)NFS_FILEID(inode), status);
 		goto out;
 	}
-	spin_unlock(&inode->i_lock);
+	if (nfsi->cache_validity & NFS_INO_INVALID_FSCACHE_ATTR) {
+		nfsi->cache_validity &= ~NFS_INO_INVALID_FSCACHE_ATTR;
+		spin_unlock(&inode->i_lock);
+		nfs_fscache_attr_changed(inode);
+	} else {
+		spin_unlock(&inode->i_lock);
+	}
 
 	if (nfsi->cache_validity & NFS_INO_INVALID_ACL)
 		nfs_zap_acl_cache(inode);
@@ -690,6 +701,7 @@ static int nfs_invalidate_mapping_nolock(struct inode *inode, struct address_spa
 	}
 	spin_unlock(&inode->i_lock);
 	nfs_inc_stats(inode, NFSIOS_DATAINVALIDATE);
+	nfs_fscache_renew_fh_cookie(inode);
 	dfprintk(PAGECACHE, "NFS: (%s/%Ld) data cache invalidated\n",
 			inode->i_sb->s_id, (long long)NFS_FILEID(inode));
 	return 0;
@@ -890,7 +902,13 @@ int nfs_refresh_inode(struct inode *inode, struct nfs_fattr *fattr)
 	else
 		status = nfs_check_inode_attributes(inode, fattr);
 
-	spin_unlock(&inode->i_lock);
+	if (nfsi->cache_validity & NFS_INO_INVALID_FSCACHE_ATTR) {
+		nfsi->cache_validity &= ~NFS_INO_INVALID_FSCACHE_ATTR;
+		spin_unlock(&inode->i_lock);
+		nfs_fscache_attr_changed(inode);
+	} else {
+		spin_unlock(&inode->i_lock);
+	}
 	return status;
 }
 
@@ -920,7 +938,13 @@ int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	}
 	status = nfs_update_inode(inode, fattr);
 out:
-	spin_unlock(&inode->i_lock);
+	if (nfsi->cache_validity & NFS_INO_INVALID_FSCACHE_ATTR) {
+		nfsi->cache_validity &= ~NFS_INO_INVALID_FSCACHE_ATTR;
+		spin_unlock(&inode->i_lock);
+		nfs_fscache_attr_changed(inode);
+	} else {
+		spin_unlock(&inode->i_lock);
+	}
 	return status;
 }
 
@@ -991,12 +1015,14 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 			/* No, but did we race with nfs_end_data_update()? */
 			if (data_stable) {
 				inode->i_size = new_isize;
-				invalid |= NFS_INO_INVALID_DATA;
+				invalid |= NFS_INO_INVALID_DATA |
+					NFS_INO_INVALID_FSCACHE_ATTR;
 			}
 			invalid |= NFS_INO_INVALID_ATTR;
 		} else if (new_isize > cur_isize) {
 			inode->i_size = new_isize;
-			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
+			invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA |
+				NFS_INO_INVALID_FSCACHE_ATTR;
 		}
 		nfsi->cache_change_attribute = now;
 		dprintk("NFS: isize change on server for file %s/%ld\n",
@@ -1008,7 +1034,8 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 		memcpy(&inode->i_mtime, &fattr->mtime, sizeof(inode->i_mtime));
 		dprintk("NFS: mtime change on server for file %s/%ld\n",
 				inode->i_sb->s_id, inode->i_ino);
-		invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA;
+		invalid |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA |
+			NFS_INO_INVALID_FSCACHE_ATTR;
 		nfsi->cache_change_attribute = now;
 	}
 
@@ -1061,7 +1088,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	/* Don't invalidate the data if we were to blame */
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)
 				|| S_ISLNK(inode->i_mode)))
-		invalid &= ~NFS_INO_INVALID_DATA;
+		invalid &= ~(NFS_INO_INVALID_DATA | NFS_INO_INVALID_FSCACHE_ATTR);
 	if (data_stable)
 		invalid &= ~(NFS_INO_INVALID_ATTR|NFS_INO_INVALID_ATIME|NFS_INO_REVAL_PAGECACHE);
 	if (!nfs_have_delegation(inode, FMODE_READ) ||
@@ -1183,6 +1210,10 @@ static int __init init_nfs_fs(void)
 {
 	int err;
 
+	err = nfs_fscache_register();
+	if (err < 0)
+		goto out6;
+
 	err = nfs_fs_proc_init();
 	if (err)
 		goto out5;
@@ -1229,6 +1260,8 @@ out3:
 out4:
 	nfs_fs_proc_exit();
 out5:
+	nfs_fscache_unregister();
+out6:
 	return err;
 }
 
@@ -1239,6 +1272,7 @@ static void __exit exit_nfs_fs(void)
 	nfs_destroy_readpagecache();
 	nfs_destroy_inodecache();
 	nfs_destroy_nfspagecache();
+	nfs_fscache_unregister();
 #ifdef CONFIG_PROC_FS
 	rpc_proc_unregister("nfs");
 #endif
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 19e0563..4dfd6dc 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -18,12 +18,14 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
+#include <linux/nfs_mount.h>
 #include <linux/smp_lock.h>
 
 #include <asm/system.h>
 
 #include "internal.h"
 #include "iostat.h"
+#include "fscache.h"
 
 #define NFSDBG_FACILITY		NFSDBG_PAGECACHE
 
@@ -114,8 +116,8 @@ static void nfs_readpage_truncate_uninitialised_page(struct nfs_read_data *data)
 	}
 }
 
-static int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
-		struct page *page)
+int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
+		       struct page *page)
 {
 	LIST_HEAD(one_request);
 	struct nfs_page	*new;
@@ -142,6 +144,11 @@ static int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 
 static void nfs_readpage_release(struct nfs_page *req)
 {
+	struct inode *d_inode = req->wb_context->path.dentry->d_inode;
+
+	if (PageUptodate(req->wb_page))
+		nfs_readpage_to_fscache(d_inode, req->wb_page, 0);
+
 	unlock_page(req->wb_page);
 
 	dprintk("NFS: read done (%s/%Ld %d@%Ld)\n",
@@ -500,8 +507,15 @@ int nfs_readpage(struct file *file, struct page *page)
 		ctx = get_nfs_open_context((struct nfs_open_context *)
 				file->private_data);
 
+	if (!IS_SYNC(inode)) {
+		error = nfs_readpage_from_fscache(ctx, inode, page);
+		if (error == 0)
+			goto out;
+	}
+
 	error = nfs_readpage_async(ctx, inode, page);
 
+out:
 	put_nfs_open_context(ctx);
 	return error;
 out_unlock:
@@ -578,6 +592,15 @@ int nfs_readpages(struct file *filp, struct address_space *mapping,
 	} else
 		desc.ctx = get_nfs_open_context((struct nfs_open_context *)
 				filp->private_data);
+
+	/* attempt to read as many of the pages as possible from the cache
+	 * - this returns -ENOBUFS immediately if the cookie is negative
+	 */
+	ret = nfs_readpages_from_fscache(desc.ctx, inode, mapping,
+					 pages, &nr_pages);
+	if (ret == 0)
+		goto read_complete; /* all pages were read */
+
 	if (rsize < PAGE_CACHE_SIZE)
 		nfs_pageio_init(&pgio, inode, nfs_pagein_multi, rsize, 0);
 	else
@@ -588,6 +611,7 @@ int nfs_readpages(struct file *filp, struct address_space *mapping,
 	nfs_pageio_complete(&pgio);
 	npages = (pgio.pg_bytes_written + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	nfs_add_stats(inode, NFSIOS_READPAGES, npages);
+read_complete:
 	put_nfs_open_context(desc.ctx);
 out:
 	return ret;
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index b62481d..9eaf5a9 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -14,6 +14,8 @@
 #include <linux/nfs_fs.h>
 
 #include "callback.h"
+#include "internal.h"
+#include "fscache.h"
 
 static const int nfs_set_port_min = 0;
 static const int nfs_set_port_max = 65535;
@@ -58,6 +60,48 @@ static ctl_table nfs_cb_sysctls[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_NFS_FSCACHE
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "fscache_from_error",
+		.data = &nfs_fscache_from_error,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "fscache_to_error",
+		.data = &nfs_fscache_to_error,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "fscache_uncache_page",
+		.data = &nfs_fscache_uncache_page,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "fscache_to_pages",
+		.data = &nfs_fscache_to_pages,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec_minmax,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "fscache_from_pages",
+		.data = &nfs_fscache_from_pages,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 157dcb0..e335076 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -172,6 +172,9 @@ struct nfs_inode {
 	int			 delegation_state;
 	struct rw_semaphore	rwsem;
 #endif /* CONFIG_NFS_V4*/
+#ifdef CONFIG_NFS_FSCACHE
+	struct fscache_cookie	*fscache;
+#endif
 	struct inode		vfs_inode;
 };
 
@@ -185,6 +188,7 @@ struct nfs_inode {
 #define NFS_INO_INVALID_ACL	0x0010		/* cached acls are invalid */
 #define NFS_INO_REVAL_PAGECACHE	0x0020		/* must revalidate pagecache */
 #define NFS_INO_REVAL_FORCED	0x0040		/* force revalidation ignoring a delegation */
+#define NFS_INO_INVALID_FSCACHE_ATTR	0x0080	/* local cache attributes are invalid */
 
 /*
  * Bit offsets in flags field
@@ -193,6 +197,7 @@ struct nfs_inode {
 #define NFS_INO_ADVISE_RDPLUS	(1)		/* advise readdirplus */
 #define NFS_INO_STALE		(2)		/* possible stale inode */
 #define NFS_INO_ACL_LRU_SET	(3)		/* Inode is on the LRU list */
+#define NFS_INO_FSCACHE		(4)		/* inode can be cached by FS-Cache */
 
 static inline struct nfs_inode *NFS_I(struct inode *inode)
 {
@@ -218,6 +223,7 @@ static inline struct nfs_inode *NFS_I(struct inode *inode)
 
 #define NFS_FLAGS(inode)		(NFS_I(inode)->flags)
 #define NFS_STALE(inode)		(test_bit(NFS_INO_STALE, &NFS_FLAGS(inode)))
+#define NFS_FSCACHE(inode)		(test_bit(NFS_INO_FSCACHE, &NFS_FLAGS(inode)))
 
 #define NFS_FILEID(inode)		(NFS_I(inode)->fileid)
 
@@ -463,6 +469,7 @@ extern int  nfs_readpages(struct file *, struct address_space *,
 		struct list_head *, unsigned);
 extern int  nfs_readpage_result(struct rpc_task *, struct nfs_read_data *);
 extern void nfs_readdata_release(void *data);
+extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *, struct page *);
 
 /*
  * Allocate nfs_read_data structures
@@ -553,6 +560,7 @@ extern void * nfs_root_data(void);
 #define NFSDBG_CALLBACK		0x0100
 #define NFSDBG_CLIENT		0x0200
 #define NFSDBG_MOUNT		0x0400
+#define NFSDBG_FSCACHE		0x0800
 #define NFSDBG_ALL		0xFFFF
 
 #ifdef __KERNEL__
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 0cac49b..95d0617 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/backing-dev.h>
+#include <linux/fscache.h>
 
 struct nfs_iostats;
 
@@ -65,6 +66,10 @@ struct nfs_client {
 	char			cl_ipaddr[16];
 	unsigned char		cl_id_uniquifier;
 #endif
+
+#ifdef CONFIG_NFS_FSCACHE
+	struct fscache_cookie	*fscache;	/* client index cache cookie */
+#endif
 };
 
 /*
@@ -95,6 +100,8 @@ struct nfs_server {
 	unsigned int		acdirmin;
 	unsigned int		acdirmax;
 	unsigned int		namelen;
+	unsigned int		options;	/* extra options enabled by mount */
+#define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */
 
 	struct nfs_fsid		fsid;
 	__u64			maxfilesize;	/* maximum file size */

