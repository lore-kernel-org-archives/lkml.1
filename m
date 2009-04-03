Return-Path: <linux-kernel-owner+w=401wt.eu-S935983AbZDCQHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935983AbZDCQHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933557AbZDCP5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56625 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934921AbZDCP4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:56:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/41] FS-Cache: Make kAFS use FS-Cache [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:56:39 +0100
Message-ID: <20090403155639.28714.87664.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch makes the kAFS filesystem in fs/afs/ use FS-Cache, and
through it any attached caches.  The kAFS filesystem will use caching
automatically if it's available.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/afs/Kconfig     |    8 +
 fs/afs/Makefile    |    3 
 fs/afs/cache.c     |  503 ++++++++++++++++++++++++++++++++++------------------
 fs/afs/cache.h     |   15 --
 fs/afs/cell.c      |   16 +-
 fs/afs/file.c      |  220 +++++++++++++++--------
 fs/afs/inode.c     |   31 ++-
 fs/afs/internal.h  |   53 +++--
 fs/afs/main.c      |   27 +--
 fs/afs/mntpt.c     |    4 
 fs/afs/vlocation.c |   25 +--
 fs/afs/volume.c    |   14 +
 fs/afs/write.c     |   21 ++
 13 files changed, 582 insertions(+), 358 deletions(-)


diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index e7b522f..5c4e61d 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -19,3 +19,11 @@ config AFS_DEBUG
 	  See <file:Documentation/filesystems/afs.txt> for more information.
 
 	  If unsure, say N.
+
+config AFS_FSCACHE
+	bool "Provide AFS client caching support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on AFS_FS=m && FSCACHE || AFS_FS=y && FSCACHE=y
+	help
+	  Say Y here if you want AFS data to be cached locally on disk through
+	  the generic filesystem cache manager
diff --git a/fs/afs/Makefile b/fs/afs/Makefile
index a666710..4f64b95 100644
--- a/fs/afs/Makefile
+++ b/fs/afs/Makefile
@@ -2,7 +2,10 @@
 # Makefile for Red Hat Linux AFS client.
 #
 
+afs-cache-$(CONFIG_AFS_FSCACHE) := cache.o
+
 kafs-objs := \
+	$(afs-cache-y) \
 	callback.o \
 	cell.o \
 	cmservice.o \
diff --git a/fs/afs/cache.c b/fs/afs/cache.c
index de0d7de..e2b1d3f 100644
--- a/fs/afs/cache.c
+++ b/fs/afs/cache.c
@@ -1,6 +1,6 @@
 /* AFS caching stuff
  *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -9,248 +9,395 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_cell_cache_match(void *target,
-						const void *entry);
-static void afs_cell_cache_update(void *source, void *entry);
-
-struct cachefs_index_def afs_cache_cell_index_def = {
-	.name			= "cell_ix",
-	.data_size		= sizeof(struct afs_cache_cell),
-	.keys[0]		= { CACHEFS_INDEX_KEYS_ASCIIZ, 64 },
-	.match			= afs_cell_cache_match,
-	.update			= afs_cell_cache_update,
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include "internal.h"
+
+static uint16_t afs_cell_cache_get_key(const void *cookie_netfs_data,
+				       void *buffer, uint16_t buflen);
+static uint16_t afs_cell_cache_get_aux(const void *cookie_netfs_data,
+				       void *buffer, uint16_t buflen);
+static enum fscache_checkaux afs_cell_cache_check_aux(void *cookie_netfs_data,
+						      const void *buffer,
+						      uint16_t buflen);
+
+static uint16_t afs_vlocation_cache_get_key(const void *cookie_netfs_data,
+					    void *buffer, uint16_t buflen);
+static uint16_t afs_vlocation_cache_get_aux(const void *cookie_netfs_data,
+					    void *buffer, uint16_t buflen);
+static enum fscache_checkaux afs_vlocation_cache_check_aux(
+	void *cookie_netfs_data, const void *buffer, uint16_t buflen);
+
+static uint16_t afs_volume_cache_get_key(const void *cookie_netfs_data,
+					 void *buffer, uint16_t buflen);
+
+static uint16_t afs_vnode_cache_get_key(const void *cookie_netfs_data,
+					void *buffer, uint16_t buflen);
+static void afs_vnode_cache_get_attr(const void *cookie_netfs_data,
+				     uint64_t *size);
+static uint16_t afs_vnode_cache_get_aux(const void *cookie_netfs_data,
+					void *buffer, uint16_t buflen);
+static enum fscache_checkaux afs_vnode_cache_check_aux(void *cookie_netfs_data,
+						       const void *buffer,
+						       uint16_t buflen);
+static void afs_vnode_cache_now_uncached(void *cookie_netfs_data);
+
+struct fscache_netfs afs_cache_netfs = {
+	.name			= "afs",
+	.version		= 0,
+};
+
+struct fscache_cookie_def afs_cell_cache_index_def = {
+	.name		= "AFS.cell",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= afs_cell_cache_get_key,
+	.get_aux	= afs_cell_cache_get_aux,
+	.check_aux	= afs_cell_cache_check_aux,
+};
+
+struct fscache_cookie_def afs_vlocation_cache_index_def = {
+	.name			= "AFS.vldb",
+	.type			= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key		= afs_vlocation_cache_get_key,
+	.get_aux		= afs_vlocation_cache_get_aux,
+	.check_aux		= afs_vlocation_cache_check_aux,
+};
+
+struct fscache_cookie_def afs_volume_cache_index_def = {
+	.name		= "AFS.volume",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= afs_volume_cache_get_key,
+};
+
+struct fscache_cookie_def afs_vnode_cache_index_def = {
+	.name			= "AFS.vnode",
+	.type			= FSCACHE_COOKIE_TYPE_DATAFILE,
+	.get_key		= afs_vnode_cache_get_key,
+	.get_attr		= afs_vnode_cache_get_attr,
+	.get_aux		= afs_vnode_cache_get_aux,
+	.check_aux		= afs_vnode_cache_check_aux,
+	.now_uncached		= afs_vnode_cache_now_uncached,
 };
-#endif
 
 /*
- * match a cell record obtained from the cache
+ * set the key for the index entry
  */
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_cell_cache_match(void *target,
-						const void *entry)
+static uint16_t afs_cell_cache_get_key(const void *cookie_netfs_data,
+				       void *buffer, uint16_t bufmax)
 {
-	const struct afs_cache_cell *ccell = entry;
-	struct afs_cell *cell = target;
+	const struct afs_cell *cell = cookie_netfs_data;
+	uint16_t klen;
 
-	_enter("{%s},{%s}", ccell->name, cell->name);
+	_enter("%p,%p,%u", cell, buffer, bufmax);
 
-	if (strncmp(ccell->name, cell->name, sizeof(ccell->name)) == 0) {
-		_leave(" = SUCCESS");
-		return CACHEFS_MATCH_SUCCESS;
-	}
+	klen = strlen(cell->name);
+	if (klen > bufmax)
+		return 0;
 
-	_leave(" = FAILED");
-	return CACHEFS_MATCH_FAILED;
+	memcpy(buffer, cell->name, klen);
+	return klen;
 }
-#endif
 
 /*
- * update a cell record in the cache
+ * provide new auxilliary cache data
  */
-#ifdef AFS_CACHING_SUPPORT
-static void afs_cell_cache_update(void *source, void *entry)
+static uint16_t afs_cell_cache_get_aux(const void *cookie_netfs_data,
+				       void *buffer, uint16_t bufmax)
 {
-	struct afs_cache_cell *ccell = entry;
-	struct afs_cell *cell = source;
+	const struct afs_cell *cell = cookie_netfs_data;
+	uint16_t dlen;
 
-	_enter("%p,%p", source, entry);
+	_enter("%p,%p,%u", cell, buffer, bufmax);
 
-	strncpy(ccell->name, cell->name, sizeof(ccell->name));
+	dlen = cell->vl_naddrs * sizeof(cell->vl_addrs[0]);
+	dlen = min(dlen, bufmax);
+	dlen &= ~(sizeof(cell->vl_addrs[0]) - 1);
 
-	memcpy(ccell->vl_servers,
-	       cell->vl_addrs,
-	       min(sizeof(ccell->vl_servers), sizeof(cell->vl_addrs)));
+	memcpy(buffer, cell->vl_addrs, dlen);
+	return dlen;
+}
 
+/*
+ * check that the auxilliary data indicates that the entry is still valid
+ */
+static enum fscache_checkaux afs_cell_cache_check_aux(void *cookie_netfs_data,
+						      const void *buffer,
+						      uint16_t buflen)
+{
+	_leave(" = OKAY");
+	return FSCACHE_CHECKAUX_OKAY;
 }
-#endif
-
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_vlocation_cache_match(void *target,
-						     const void *entry);
-static void afs_vlocation_cache_update(void *source, void *entry);
-
-struct cachefs_index_def afs_vlocation_cache_index_def = {
-	.name		= "vldb",
-	.data_size	= sizeof(struct afs_cache_vlocation),
-	.keys[0]	= { CACHEFS_INDEX_KEYS_ASCIIZ, 64 },
-	.match		= afs_vlocation_cache_match,
-	.update		= afs_vlocation_cache_update,
-};
-#endif
 
+/*****************************************************************************/
 /*
- * match a VLDB record stored in the cache
- * - may also load target from entry
+ * set the key for the index entry
  */
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_vlocation_cache_match(void *target,
-						     const void *entry)
+static uint16_t afs_vlocation_cache_get_key(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax)
 {
-	const struct afs_cache_vlocation *vldb = entry;
-	struct afs_vlocation *vlocation = target;
+	const struct afs_vlocation *vlocation = cookie_netfs_data;
+	uint16_t klen;
+
+	_enter("{%s},%p,%u", vlocation->vldb.name, buffer, bufmax);
+
+	klen = strnlen(vlocation->vldb.name, sizeof(vlocation->vldb.name));
+	if (klen > bufmax)
+		return 0;
 
-	_enter("{%s},{%s}", vlocation->vldb.name, vldb->name);
+	memcpy(buffer, vlocation->vldb.name, klen);
 
-	if (strncmp(vlocation->vldb.name, vldb->name, sizeof(vldb->name)) == 0
-	    ) {
-		if (!vlocation->valid ||
-		    vlocation->vldb.rtime == vldb->rtime
+	_leave(" = %u", klen);
+	return klen;
+}
+
+/*
+ * provide new auxilliary cache data
+ */
+static uint16_t afs_vlocation_cache_get_aux(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax)
+{
+	const struct afs_vlocation *vlocation = cookie_netfs_data;
+	uint16_t dlen;
+
+	_enter("{%s},%p,%u", vlocation->vldb.name, buffer, bufmax);
+
+	dlen = sizeof(struct afs_cache_vlocation);
+	dlen -= offsetof(struct afs_cache_vlocation, nservers);
+	if (dlen > bufmax)
+		return 0;
+
+	memcpy(buffer, (uint8_t *)&vlocation->vldb.nservers, dlen);
+
+	_leave(" = %u", dlen);
+	return dlen;
+}
+
+/*
+ * check that the auxilliary data indicates that the entry is still valid
+ */
+static
+enum fscache_checkaux afs_vlocation_cache_check_aux(void *cookie_netfs_data,
+						    const void *buffer,
+						    uint16_t buflen)
+{
+	const struct afs_cache_vlocation *cvldb;
+	struct afs_vlocation *vlocation = cookie_netfs_data;
+	uint16_t dlen;
+
+	_enter("{%s},%p,%u", vlocation->vldb.name, buffer, buflen);
+
+	/* check the size of the data is what we're expecting */
+	dlen = sizeof(struct afs_cache_vlocation);
+	dlen -= offsetof(struct afs_cache_vlocation, nservers);
+	if (dlen != buflen)
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	cvldb = container_of(buffer, struct afs_cache_vlocation, nservers);
+
+	/* if what's on disk is more valid than what's in memory, then use the
+	 * VL record from the cache */
+	if (!vlocation->valid || vlocation->vldb.rtime == cvldb->rtime) {
+		memcpy((uint8_t *)&vlocation->vldb.nservers, buffer, dlen);
+		vlocation->valid = 1;
+		_leave(" = SUCCESS [c->m]");
+		return FSCACHE_CHECKAUX_OKAY;
+	}
+
+	/* need to update the cache if the cached info differs */
+	if (memcmp(&vlocation->vldb, buffer, dlen) != 0) {
+		/* delete if the volume IDs for this name differ */
+		if (memcmp(&vlocation->vldb.vid, &cvldb->vid,
+			   sizeof(cvldb->vid)) != 0
 		    ) {
-			vlocation->vldb = *vldb;
-			vlocation->valid = 1;
-			_leave(" = SUCCESS [c->m]");
-			return CACHEFS_MATCH_SUCCESS;
-		} else if (memcmp(&vlocation->vldb, vldb, sizeof(*vldb)) != 0) {
-			/* delete if VIDs for this name differ */
-			if (memcmp(&vlocation->vldb.vid,
-				   &vldb->vid,
-				   sizeof(vldb->vid)) != 0) {
-				_leave(" = DELETE");
-				return CACHEFS_MATCH_SUCCESS_DELETE;
-			}
-
-			_leave(" = UPDATE");
-			return CACHEFS_MATCH_SUCCESS_UPDATE;
-		} else {
-			_leave(" = SUCCESS");
-			return CACHEFS_MATCH_SUCCESS;
+			_leave(" = OBSOLETE");
+			return FSCACHE_CHECKAUX_OBSOLETE;
 		}
+
+		_leave(" = UPDATE");
+		return FSCACHE_CHECKAUX_NEEDS_UPDATE;
 	}
 
-	_leave(" = FAILED");
-	return CACHEFS_MATCH_FAILED;
+	_leave(" = OKAY");
+	return FSCACHE_CHECKAUX_OKAY;
 }
-#endif
 
+/*****************************************************************************/
 /*
- * update a VLDB record stored in the cache
+ * set the key for the volume index entry
  */
-#ifdef AFS_CACHING_SUPPORT
-static void afs_vlocation_cache_update(void *source, void *entry)
+static uint16_t afs_volume_cache_get_key(const void *cookie_netfs_data,
+					void *buffer, uint16_t bufmax)
 {
-	struct afs_cache_vlocation *vldb = entry;
-	struct afs_vlocation *vlocation = source;
+	const struct afs_volume *volume = cookie_netfs_data;
+	uint16_t klen;
+
+	_enter("{%u},%p,%u", volume->type, buffer, bufmax);
+
+	klen = sizeof(volume->type);
+	if (klen > bufmax)
+		return 0;
 
-	_enter("");
+	memcpy(buffer, &volume->type, sizeof(volume->type));
+
+	_leave(" = %u", klen);
+	return klen;
 
-	*vldb = vlocation->vldb;
 }
-#endif
-
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_volume_cache_match(void *target,
-						  const void *entry);
-static void afs_volume_cache_update(void *source, void *entry);
-
-struct cachefs_index_def afs_volume_cache_index_def = {
-	.name		= "volume",
-	.data_size	= sizeof(struct afs_cache_vhash),
-	.keys[0]	= { CACHEFS_INDEX_KEYS_BIN, 1 },
-	.keys[1]	= { CACHEFS_INDEX_KEYS_BIN, 1 },
-	.match		= afs_volume_cache_match,
-	.update		= afs_volume_cache_update,
-};
-#endif
 
+/*****************************************************************************/
 /*
- * match a volume hash record stored in the cache
+ * set the key for the index entry
  */
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_volume_cache_match(void *target,
-						  const void *entry)
+static uint16_t afs_vnode_cache_get_key(const void *cookie_netfs_data,
+					void *buffer, uint16_t bufmax)
 {
-	const struct afs_cache_vhash *vhash = entry;
-	struct afs_volume *volume = target;
+	const struct afs_vnode *vnode = cookie_netfs_data;
+	uint16_t klen;
 
-	_enter("{%u},{%u}", volume->type, vhash->vtype);
+	_enter("{%x,%x,%llx},%p,%u",
+	       vnode->fid.vnode, vnode->fid.unique, vnode->status.data_version,
+	       buffer, bufmax);
 
-	if (volume->type == vhash->vtype) {
-		_leave(" = SUCCESS");
-		return CACHEFS_MATCH_SUCCESS;
-	}
+	klen = sizeof(vnode->fid.vnode);
+	if (klen > bufmax)
+		return 0;
+
+	memcpy(buffer, &vnode->fid.vnode, sizeof(vnode->fid.vnode));
 
-	_leave(" = FAILED");
-	return CACHEFS_MATCH_FAILED;
+	_leave(" = %u", klen);
+	return klen;
 }
-#endif
 
 /*
- * update a volume hash record stored in the cache
+ * provide updated file attributes
  */
-#ifdef AFS_CACHING_SUPPORT
-static void afs_volume_cache_update(void *source, void *entry)
+static void afs_vnode_cache_get_attr(const void *cookie_netfs_data,
+				     uint64_t *size)
 {
-	struct afs_cache_vhash *vhash = entry;
-	struct afs_volume *volume = source;
+	const struct afs_vnode *vnode = cookie_netfs_data;
 
-	_enter("");
+	_enter("{%x,%x,%llx},",
+	       vnode->fid.vnode, vnode->fid.unique,
+	       vnode->status.data_version);
 
-	vhash->vtype = volume->type;
+	*size = vnode->status.size;
 }
-#endif
-
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_vnode_cache_match(void *target,
-						 const void *entry);
-static void afs_vnode_cache_update(void *source, void *entry);
-
-struct cachefs_index_def afs_vnode_cache_index_def = {
-	.name		= "vnode",
-	.data_size	= sizeof(struct afs_cache_vnode),
-	.keys[0]	= { CACHEFS_INDEX_KEYS_BIN, 4 },
-	.match		= afs_vnode_cache_match,
-	.update		= afs_vnode_cache_update,
-};
-#endif
 
 /*
- * match a vnode record stored in the cache
+ * provide new auxilliary cache data
+ */
+static uint16_t afs_vnode_cache_get_aux(const void *cookie_netfs_data,
+					void *buffer, uint16_t bufmax)
+{
+	const struct afs_vnode *vnode = cookie_netfs_data;
+	uint16_t dlen;
+
+	_enter("{%x,%x,%Lx},%p,%u",
+	       vnode->fid.vnode, vnode->fid.unique, vnode->status.data_version,
+	       buffer, bufmax);
+
+	dlen = sizeof(vnode->fid.unique) + sizeof(vnode->status.data_version);
+	if (dlen > bufmax)
+		return 0;
+
+	memcpy(buffer, &vnode->fid.unique, sizeof(vnode->fid.unique));
+	buffer += sizeof(vnode->fid.unique);
+	memcpy(buffer, &vnode->status.data_version,
+	       sizeof(vnode->status.data_version));
+
+	_leave(" = %u", dlen);
+	return dlen;
+}
+
+/*
+ * check that the auxilliary data indicates that the entry is still valid
  */
-#ifdef AFS_CACHING_SUPPORT
-static cachefs_match_val_t afs_vnode_cache_match(void *target,
-						 const void *entry)
+static enum fscache_checkaux afs_vnode_cache_check_aux(void *cookie_netfs_data,
+						       const void *buffer,
+						       uint16_t buflen)
 {
-	const struct afs_cache_vnode *cvnode = entry;
-	struct afs_vnode *vnode = target;
-
-	_enter("{%x,%x,%Lx},{%x,%x,%Lx}",
-	       vnode->fid.vnode,
-	       vnode->fid.unique,
-	       vnode->status.version,
-	       cvnode->vnode_id,
-	       cvnode->vnode_unique,
-	       cvnode->data_version);
-
-	if (vnode->fid.vnode != cvnode->vnode_id) {
-		_leave(" = FAILED");
-		return CACHEFS_MATCH_FAILED;
+	struct afs_vnode *vnode = cookie_netfs_data;
+	uint16_t dlen;
+
+	_enter("{%x,%x,%llx},%p,%u",
+	       vnode->fid.vnode, vnode->fid.unique, vnode->status.data_version,
+	       buffer, buflen);
+
+	/* check the size of the data is what we're expecting */
+	dlen = sizeof(vnode->fid.unique) + sizeof(vnode->status.data_version);
+	if (dlen != buflen) {
+		_leave(" = OBSOLETE [len %hx != %hx]", dlen, buflen);
+		return FSCACHE_CHECKAUX_OBSOLETE;
 	}
 
-	if (vnode->fid.unique != cvnode->vnode_unique ||
-	    vnode->status.version != cvnode->data_version) {
-		_leave(" = DELETE");
-		return CACHEFS_MATCH_SUCCESS_DELETE;
+	if (memcmp(buffer,
+		   &vnode->fid.unique,
+		   sizeof(vnode->fid.unique)
+		   ) != 0) {
+		unsigned unique;
+
+		memcpy(&unique, buffer, sizeof(unique));
+
+		_leave(" = OBSOLETE [uniq %x != %x]",
+		       unique, vnode->fid.unique);
+		return FSCACHE_CHECKAUX_OBSOLETE;
+	}
+
+	if (memcmp(buffer + sizeof(vnode->fid.unique),
+		   &vnode->status.data_version,
+		   sizeof(vnode->status.data_version)
+		   ) != 0) {
+		afs_dataversion_t version;
+
+		memcpy(&version, buffer + sizeof(vnode->fid.unique),
+		       sizeof(version));
+
+		_leave(" = OBSOLETE [vers %llx != %llx]",
+		       version, vnode->status.data_version);
+		return FSCACHE_CHECKAUX_OBSOLETE;
 	}
 
 	_leave(" = SUCCESS");
-	return CACHEFS_MATCH_SUCCESS;
+	return FSCACHE_CHECKAUX_OKAY;
 }
-#endif
 
 /*
- * update a vnode record stored in the cache
+ * indication the cookie is no longer uncached
+ * - this function is called when the backing store currently caching a cookie
+ *   is removed
+ * - the netfs should use this to clean up any markers indicating cached pages
+ * - this is mandatory for any object that may have data
  */
-#ifdef AFS_CACHING_SUPPORT
-static void afs_vnode_cache_update(void *source, void *entry)
+static void afs_vnode_cache_now_uncached(void *cookie_netfs_data)
 {
-	struct afs_cache_vnode *cvnode = entry;
-	struct afs_vnode *vnode = source;
+	struct afs_vnode *vnode = cookie_netfs_data;
+	struct pagevec pvec;
+	pgoff_t first;
+	int loop, nr_pages;
+
+	_enter("{%x,%x,%Lx}",
+	       vnode->fid.vnode, vnode->fid.unique, vnode->status.data_version);
+
+	pagevec_init(&pvec, 0);
+	first = 0;
+
+	for (;;) {
+		/* grab a bunch of pages to clean */
+		nr_pages = pagevec_lookup(&pvec, vnode->vfs_inode.i_mapping,
+					  first,
+					  PAGEVEC_SIZE - pagevec_count(&pvec));
+		if (!nr_pages)
+			break;
 
-	_enter("");
+		for (loop = 0; loop < nr_pages; loop++)
+			ClearPageFsCache(pvec.pages[loop]);
+
+		first = pvec.pages[nr_pages - 1]->index + 1;
+
+		pvec.nr = nr_pages;
+		pagevec_release(&pvec);
+		cond_resched();
+	}
 
-	cvnode->vnode_id	= vnode->fid.vnode;
-	cvnode->vnode_unique	= vnode->fid.unique;
-	cvnode->data_version	= vnode->status.version;
+	_leave("");
 }
-#endif
diff --git a/fs/afs/cache.h b/fs/afs/cache.h
index 36a3642..5c4f6b4 100644
--- a/fs/afs/cache.h
+++ b/fs/afs/cache.h
@@ -1,6 +1,6 @@
 /* AFS local cache management interface
  *
- * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -9,15 +9,4 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifndef AFS_CACHE_H
-#define AFS_CACHE_H
-
-#undef AFS_CACHING_SUPPORT
-
-#include <linux/mm.h>
-#ifdef AFS_CACHING_SUPPORT
-#include <linux/cachefs.h>
-#endif
-#include "types.h"
-
-#endif /* AFS_CACHE_H */
+#include <linux/fscache.h>
diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 5e1df14..e19c13f 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -147,12 +147,11 @@ struct afs_cell *afs_cell_create(const char *name, char *vllist)
 	if (ret < 0)
 		goto error;
 
-#ifdef AFS_CACHING_SUPPORT
-	/* put it up for caching */
-	cachefs_acquire_cookie(afs_cache_netfs.primary_index,
-			       &afs_vlocation_cache_index_def,
-			       cell,
-			       &cell->cache);
+#ifdef CONFIG_AFS_FSCACHE
+	/* put it up for caching (this never returns an error) */
+	cell->cache = fscache_acquire_cookie(afs_cache_netfs.primary_index,
+					     &afs_cell_cache_index_def,
+					     cell);
 #endif
 
 	/* add to the cell lists */
@@ -362,10 +361,9 @@ static void afs_cell_destroy(struct afs_cell *cell)
 	list_del_init(&cell->proc_link);
 	up_write(&afs_proc_cells_sem);
 
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_relinquish_cookie(cell->cache, 0);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_relinquish_cookie(cell->cache, 0);
 #endif
-
 	key_put(cell->anonymous_key);
 	kfree(cell);
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index a390176..7a1d942 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -23,6 +23,9 @@ static void afs_invalidatepage(struct page *page, unsigned long offset);
 static int afs_releasepage(struct page *page, gfp_t gfp_flags);
 static int afs_launder_page(struct page *page);
 
+static int afs_readpages(struct file *filp, struct address_space *mapping,
+			 struct list_head *pages, unsigned nr_pages);
+
 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
 	.release	= afs_release,
@@ -46,6 +49,7 @@ const struct inode_operations afs_file_inode_operations = {
 
 const struct address_space_operations afs_fs_aops = {
 	.readpage	= afs_readpage,
+	.readpages	= afs_readpages,
 	.set_page_dirty	= afs_set_page_dirty,
 	.launder_page	= afs_launder_page,
 	.releasepage	= afs_releasepage,
@@ -101,37 +105,18 @@ int afs_release(struct inode *inode, struct file *file)
 /*
  * deal with notification that a page was read from the cache
  */
-#ifdef AFS_CACHING_SUPPORT
-static void afs_readpage_read_complete(void *cookie_data,
-				       struct page *page,
-				       void *data,
-				       int error)
+static void afs_file_readpage_read_complete(struct page *page,
+					    void *data,
+					    int error)
 {
-	_enter("%p,%p,%p,%d", cookie_data, page, data, error);
+	_enter("%p,%p,%d", page, data, error);
 
-	if (error)
-		SetPageError(page);
-	else
+	/* if the read completes with an error, we just unlock the page and let
+	 * the VM reissue the readpage */
+	if (!error)
 		SetPageUptodate(page);
 	unlock_page(page);
-
 }
-#endif
-
-/*
- * deal with notification that a page was written to the cache
- */
-#ifdef AFS_CACHING_SUPPORT
-static void afs_readpage_write_complete(void *cookie_data,
-					struct page *page,
-					void *data,
-					int error)
-{
-	_enter("%p,%p,%p,%d", cookie_data, page, data, error);
-
-	unlock_page(page);
-}
-#endif
 
 /*
  * AFS read page from file, directory or symlink
@@ -161,9 +146,9 @@ static int afs_readpage(struct file *file, struct page *page)
 	if (test_bit(AFS_VNODE_DELETED, &vnode->flags))
 		goto error;
 
-#ifdef AFS_CACHING_SUPPORT
 	/* is it cached? */
-	ret = cachefs_read_or_alloc_page(vnode->cache,
+#ifdef CONFIG_AFS_FSCACHE
+	ret = fscache_read_or_alloc_page(vnode->cache,
 					 page,
 					 afs_file_readpage_read_complete,
 					 NULL,
@@ -171,20 +156,21 @@ static int afs_readpage(struct file *file, struct page *page)
 #else
 	ret = -ENOBUFS;
 #endif
-
 	switch (ret) {
-		/* read BIO submitted and wb-journal entry found */
-	case 1:
-		BUG(); // TODO - handle wb-journal match
-
 		/* read BIO submitted (page in cache) */
 	case 0:
 		break;
 
-		/* no page available in cache */
-	case -ENOBUFS:
+		/* page not yet cached */
 	case -ENODATA:
+		_debug("cache said ENODATA");
+		goto go_on;
+
+		/* page will not be cached */
+	case -ENOBUFS:
+		_debug("cache said ENOBUFS");
 	default:
+	go_on:
 		offset = page->index << PAGE_CACHE_SHIFT;
 		len = min_t(size_t, i_size_read(inode) - offset, PAGE_SIZE);
 
@@ -198,27 +184,25 @@ static int afs_readpage(struct file *file, struct page *page)
 				set_bit(AFS_VNODE_DELETED, &vnode->flags);
 				ret = -ESTALE;
 			}
-#ifdef AFS_CACHING_SUPPORT
-			cachefs_uncache_page(vnode->cache, page);
+
+#ifdef CONFIG_AFS_FSCACHE
+			fscache_uncache_page(vnode->cache, page);
 #endif
+			BUG_ON(PageFsCache(page));
 			goto error;
 		}
 
 		SetPageUptodate(page);
 
-#ifdef AFS_CACHING_SUPPORT
-		if (cachefs_write_page(vnode->cache,
-				       page,
-				       afs_file_readpage_write_complete,
-				       NULL,
-				       GFP_KERNEL) != 0
-		    ) {
-			cachefs_uncache_page(vnode->cache, page);
-			unlock_page(page);
+		/* send the page to the cache */
+#ifdef CONFIG_AFS_FSCACHE
+		if (PageFsCache(page) &&
+		    fscache_write_page(vnode->cache, page, GFP_KERNEL) != 0) {
+			fscache_uncache_page(vnode->cache, page);
+			BUG_ON(PageFsCache(page));
 		}
-#else
-		unlock_page(page);
 #endif
+		unlock_page(page);
 	}
 
 	_leave(" = 0");
@@ -232,34 +216,59 @@ error:
 }
 
 /*
- * invalidate part or all of a page
+ * read a set of pages
  */
-static void afs_invalidatepage(struct page *page, unsigned long offset)
+static int afs_readpages(struct file *file, struct address_space *mapping,
+			 struct list_head *pages, unsigned nr_pages)
 {
-	int ret = 1;
+	struct afs_vnode *vnode;
+	int ret = 0;
 
-	_enter("{%lu},%lu", page->index, offset);
+	_enter(",{%lu},,%d", mapping->host->i_ino, nr_pages);
 
-	BUG_ON(!PageLocked(page));
+	vnode = AFS_FS_I(mapping->host);
+	if (vnode->flags & AFS_VNODE_DELETED) {
+		_leave(" = -ESTALE");
+		return -ESTALE;
+	}
 
-	if (PagePrivate(page)) {
-		/* We release buffers only if the entire page is being
-		 * invalidated.
-		 * The get_block cached value has been unconditionally
-		 * invalidated, so real IO is not possible anymore.
-		 */
-		if (offset == 0) {
-			BUG_ON(!PageLocked(page));
-
-			ret = 0;
-			if (!PageWriteback(page))
-				ret = page->mapping->a_ops->releasepage(page,
-									0);
-			/* possibly should BUG_ON(!ret); - neilb */
-		}
+	/* attempt to read as many of the pages as possible */
+#ifdef CONFIG_AFS_FSCACHE
+	ret = fscache_read_or_alloc_pages(vnode->cache,
+					  mapping,
+					  pages,
+					  &nr_pages,
+					  afs_file_readpage_read_complete,
+					  NULL,
+					  mapping_gfp_mask(mapping));
+#else
+	ret = -ENOBUFS;
+#endif
+
+	switch (ret) {
+		/* all pages are being read from the cache */
+	case 0:
+		BUG_ON(!list_empty(pages));
+		BUG_ON(nr_pages != 0);
+		_leave(" = 0 [reading all]");
+		return 0;
+
+		/* there were pages that couldn't be read from the cache */
+	case -ENODATA:
+	case -ENOBUFS:
+		break;
+
+		/* other error */
+	default:
+		_leave(" = %d", ret);
+		return ret;
 	}
 
-	_leave(" = %d", ret);
+	/* load the missing pages from the network */
+	ret = read_cache_pages(mapping, pages, (void *) afs_readpage, file);
+
+	_leave(" = %d [netting]", ret);
+	return ret;
 }
 
 /*
@@ -273,25 +282,82 @@ static int afs_launder_page(struct page *page)
 }
 
 /*
- * release a page and cleanup its private data
+ * invalidate part or all of a page
+ * - release a page and clean up its private data if offset is 0 (indicating
+ *   the entire page)
+ */
+static void afs_invalidatepage(struct page *page, unsigned long offset)
+{
+	struct afs_writeback *wb = (struct afs_writeback *) page_private(page);
+
+	_enter("{%lu},%lu", page->index, offset);
+
+	BUG_ON(!PageLocked(page));
+
+	/* we clean up only if the entire page is being invalidated */
+	if (offset == 0) {
+#ifdef CONFIG_AFS_FSCACHE
+		if (PageFsCache(page)) {
+			struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
+			fscache_wait_on_page_write(vnode->cache, page);
+			fscache_uncache_page(vnode->cache, page);
+			ClearPageFsCache(page);
+		}
+#endif
+
+		if (PagePrivate(page)) {
+			if (wb && !PageWriteback(page)) {
+				set_page_private(page, 0);
+				afs_put_writeback(wb);
+			}
+
+			if (!page_private(page))
+				ClearPagePrivate(page);
+		}
+	}
+
+	_leave("");
+}
+
+/*
+ * release a page and clean up its private state if it's not busy
+ * - return true if the page can now be released, false if not
  */
 static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 {
+	struct afs_writeback *wb = (struct afs_writeback *) page_private(page);
 	struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
-	struct afs_writeback *wb;
 
 	_enter("{{%x:%u}[%lu],%lx},%x",
 	       vnode->fid.vid, vnode->fid.vnode, page->index, page->flags,
 	       gfp_flags);
 
+	/* deny if page is being written to the cache and the caller hasn't
+	 * elected to wait */
+#ifdef CONFIG_AFS_FSCACHE
+	if (PageFsCache(page)) {
+		if (fscache_check_page_write(vnode->cache, page)) {
+			if (!(gfp_flags & __GFP_WAIT)) {
+				_leave(" = F [cache busy]");
+				return 0;
+			}
+			fscache_wait_on_page_write(vnode->cache, page);
+		}
+
+		fscache_uncache_page(vnode->cache, page);
+		ClearPageFsCache(page);
+	}
+#endif
+
 	if (PagePrivate(page)) {
-		wb = (struct afs_writeback *) page_private(page);
-		ASSERT(wb != NULL);
-		set_page_private(page, 0);
+		if (wb) {
+			set_page_private(page, 0);
+			afs_put_writeback(wb);
+		}
 		ClearPagePrivate(page);
-		afs_put_writeback(wb);
 	}
 
-	_leave(" = 0");
-	return 0;
+	/* indicate that the page can be released */
+	_leave(" = T");
+	return 1;
 }
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index bb47217..c048f06 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -61,6 +61,11 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 		return -EBADMSG;
 	}
 
+#ifdef CONFIG_AFS_FSCACHE
+	if (vnode->status.size != inode->i_size)
+		fscache_attr_changed(vnode->cache);
+#endif
+
 	inode->i_nlink		= vnode->status.nlink;
 	inode->i_uid		= vnode->status.owner;
 	inode->i_gid		= 0;
@@ -149,15 +154,6 @@ struct inode *afs_iget(struct super_block *sb, struct key *key,
 		return inode;
 	}
 
-#ifdef AFS_CACHING_SUPPORT
-	/* set up caching before reading the status, as fetch-status reads the
-	 * first page of symlinks to see if they're really mntpts */
-	cachefs_acquire_cookie(vnode->volume->cache,
-			       NULL,
-			       vnode,
-			       &vnode->cache);
-#endif
-
 	if (!status) {
 		/* it's a remotely extant inode */
 		set_bit(AFS_VNODE_CB_BROKEN, &vnode->flags);
@@ -183,6 +179,15 @@ struct inode *afs_iget(struct super_block *sb, struct key *key,
 		}
 	}
 
+	/* set up caching before mapping the status, as map-status reads the
+	 * first page of symlinks to see if they're really mountpoints */
+	inode->i_size = vnode->status.size;
+#ifdef CONFIG_AFS_FSCACHE
+	vnode->cache = fscache_acquire_cookie(vnode->volume->cache,
+					      &afs_vnode_cache_index_def,
+					      vnode);
+#endif
+
 	ret = afs_inode_map_status(vnode, key);
 	if (ret < 0)
 		goto bad_inode;
@@ -196,6 +201,10 @@ struct inode *afs_iget(struct super_block *sb, struct key *key,
 
 	/* failure */
 bad_inode:
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_relinquish_cookie(vnode->cache, 0);
+	vnode->cache = NULL;
+#endif
 	iget_failed(inode);
 	_leave(" = %d [bad]", ret);
 	return ERR_PTR(ret);
@@ -340,8 +349,8 @@ void afs_clear_inode(struct inode *inode)
 	ASSERT(list_empty(&vnode->writebacks));
 	ASSERT(!vnode->cb_promised);
 
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_relinquish_cookie(vnode->cache, 0);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_relinquish_cookie(vnode->cache, 0);
 	vnode->cache = NULL;
 #endif
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 67f259d..106be66 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -21,6 +21,7 @@
 
 #include "afs.h"
 #include "afs_vl.h"
+#include "cache.h"
 
 #define AFS_CELL_MAX_ADDRS 15
 
@@ -193,8 +194,8 @@ struct afs_cell {
 	struct key		*anonymous_key;	/* anonymous user key for this cell */
 	struct list_head	proc_link;	/* /proc cell list link */
 	struct proc_dir_entry	*proc_dir;	/* /proc dir for this cell */
-#ifdef AFS_CACHING_SUPPORT
-	struct cachefs_cookie	*cache;		/* caching cookie */
+#ifdef CONFIG_AFS_FSCACHE
+	struct fscache_cookie	*cache;		/* caching cookie */
 #endif
 
 	/* server record management */
@@ -249,8 +250,8 @@ struct afs_vlocation {
 	struct list_head	grave;		/* link in master graveyard list */
 	struct list_head	update;		/* link in master update list */
 	struct afs_cell		*cell;		/* cell to which volume belongs */
-#ifdef AFS_CACHING_SUPPORT
-	struct cachefs_cookie	*cache;		/* caching cookie */
+#ifdef CONFIG_AFS_FSCACHE
+	struct fscache_cookie	*cache;		/* caching cookie */
 #endif
 	struct afs_cache_vlocation vldb;	/* volume information DB record */
 	struct afs_volume	*vols[3];	/* volume access record pointer (index by type) */
@@ -302,8 +303,8 @@ struct afs_volume {
 	atomic_t		usage;
 	struct afs_cell		*cell;		/* cell to which belongs (unrefd ptr) */
 	struct afs_vlocation	*vlocation;	/* volume location */
-#ifdef AFS_CACHING_SUPPORT
-	struct cachefs_cookie	*cache;		/* caching cookie */
+#ifdef CONFIG_AFS_FSCACHE
+	struct fscache_cookie	*cache;		/* caching cookie */
 #endif
 	afs_volid_t		vid;		/* volume ID */
 	afs_voltype_t		type;		/* type of volume */
@@ -333,8 +334,8 @@ struct afs_vnode {
 	struct afs_server	*server;	/* server currently supplying this file */
 	struct afs_fid		fid;		/* the file identifier for this inode */
 	struct afs_file_status	status;		/* AFS status info for this file */
-#ifdef AFS_CACHING_SUPPORT
-	struct cachefs_cookie	*cache;		/* caching cookie */
+#ifdef CONFIG_AFS_FSCACHE
+	struct fscache_cookie	*cache;		/* caching cookie */
 #endif
 	struct afs_permits	*permits;	/* cache of permits so far obtained */
 	struct mutex		permits_lock;	/* lock for altering permits list */
@@ -428,6 +429,22 @@ struct afs_uuid {
 
 /*****************************************************************************/
 /*
+ * cache.c
+ */
+#ifdef CONFIG_AFS_FSCACHE
+extern struct fscache_netfs afs_cache_netfs;
+extern struct fscache_cookie_def afs_cell_cache_index_def;
+extern struct fscache_cookie_def afs_vlocation_cache_index_def;
+extern struct fscache_cookie_def afs_volume_cache_index_def;
+extern struct fscache_cookie_def afs_vnode_cache_index_def;
+#else
+#define afs_cell_cache_index_def	(*(struct fscache_cookie_def *) NULL)
+#define afs_vlocation_cache_index_def	(*(struct fscache_cookie_def *) NULL)
+#define afs_volume_cache_index_def	(*(struct fscache_cookie_def *) NULL)
+#define afs_vnode_cache_index_def	(*(struct fscache_cookie_def *) NULL)
+#endif
+
+/*
  * callback.c
  */
 extern void afs_init_callback_state(struct afs_server *);
@@ -446,9 +463,6 @@ extern void afs_callback_update_kill(void);
  */
 extern struct rw_semaphore afs_proc_cells_sem;
 extern struct list_head afs_proc_cells;
-#ifdef AFS_CACHING_SUPPORT
-extern struct cachefs_index_def afs_cache_cell_index_def;
-#endif
 
 #define afs_get_cell(C) do { atomic_inc(&(C)->usage); } while(0)
 extern int afs_cell_init(char *);
@@ -554,9 +568,6 @@ extern void afs_clear_inode(struct inode *);
  * main.c
  */
 extern struct afs_uuid afs_uuid;
-#ifdef AFS_CACHING_SUPPORT
-extern struct cachefs_netfs afs_cache_netfs;
-#endif
 
 /*
  * misc.c
@@ -637,10 +648,6 @@ extern int afs_get_MAC_address(u8 *, size_t);
 /*
  * vlclient.c
  */
-#ifdef AFS_CACHING_SUPPORT
-extern struct cachefs_index_def afs_vlocation_cache_index_def;
-#endif
-
 extern int afs_vl_get_entry_by_name(struct in_addr *, struct key *,
 				    const char *, struct afs_cache_vlocation *,
 				    const struct afs_wait_mode *);
@@ -664,12 +671,6 @@ extern void afs_vlocation_purge(void);
 /*
  * vnode.c
  */
-#ifdef AFS_CACHING_SUPPORT
-extern struct cachefs_index_def afs_vnode_cache_index_def;
-#endif
-
-extern struct afs_timer_ops afs_vnode_cb_timed_out_ops;
-
 static inline struct afs_vnode *AFS_FS_I(struct inode *inode)
 {
 	return container_of(inode, struct afs_vnode, vfs_inode);
@@ -711,10 +712,6 @@ extern int afs_vnode_release_lock(struct afs_vnode *, struct key *);
 /*
  * volume.c
  */
-#ifdef AFS_CACHING_SUPPORT
-extern struct cachefs_index_def afs_volume_cache_index_def;
-#endif
-
 #define afs_get_volume(V) do { atomic_inc(&(V)->usage); } while(0)
 
 extern void afs_put_volume(struct afs_volume *);
diff --git a/fs/afs/main.c b/fs/afs/main.c
index 2d3e5d4..66d54d3 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -1,6 +1,6 @@
 /* AFS client file system
  *
- * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2002,5 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -29,18 +29,6 @@ static char *rootcell;
 module_param(rootcell, charp, 0);
 MODULE_PARM_DESC(rootcell, "root AFS cell name and VL server IP addr list");
 
-#ifdef AFS_CACHING_SUPPORT
-static struct cachefs_netfs_operations afs_cache_ops = {
-	.get_page_cookie	= afs_cache_get_page_cookie,
-};
-
-struct cachefs_netfs afs_cache_netfs = {
-	.name			= "afs",
-	.version		= 0,
-	.ops			= &afs_cache_ops,
-};
-#endif
-
 struct afs_uuid afs_uuid;
 
 /*
@@ -104,10 +92,9 @@ static int __init afs_init(void)
 	if (ret < 0)
 		return ret;
 
-#ifdef AFS_CACHING_SUPPORT
+#ifdef CONFIG_AFS_FSCACHE
 	/* we want to be able to cache */
-	ret = cachefs_register_netfs(&afs_cache_netfs,
-				     &afs_cache_cell_index_def);
+	ret = fscache_register_netfs(&afs_cache_netfs);
 	if (ret < 0)
 		goto error_cache;
 #endif
@@ -142,8 +129,8 @@ error_fs:
 error_open_socket:
 error_vl_update_init:
 error_cell_init:
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_unregister_netfs(&afs_cache_netfs);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_unregister_netfs(&afs_cache_netfs);
 error_cache:
 #endif
 	afs_callback_update_kill();
@@ -175,8 +162,8 @@ static void __exit afs_exit(void)
 	afs_vlocation_purge();
 	flush_scheduled_work();
 	afs_cell_purge();
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_unregister_netfs(&afs_cache_netfs);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_unregister_netfs(&afs_cache_netfs);
 #endif
 	afs_proc_cleanup();
 	rcu_barrier();
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 78db495..2b9e2d0 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -173,9 +173,9 @@ static struct vfsmount *afs_mntpt_do_automount(struct dentry *mntpt)
 	if (PageError(page))
 		goto error;
 
-	buf = kmap(page);
+	buf = kmap_atomic(page, KM_USER0);
 	memcpy(devname, buf, size);
-	kunmap(page);
+	kunmap_atomic(buf, KM_USER0);
 	page_cache_release(page);
 	page = NULL;
 
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index 849fc31..ec2a743 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -281,9 +281,8 @@ static void afs_vlocation_apply_update(struct afs_vlocation *vl,
 
 	vl->vldb = *vldb;
 
-#ifdef AFS_CACHING_SUPPORT
-	/* update volume entry in local cache */
-	cachefs_update_cookie(vl->cache);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_update_cookie(vl->cache);
 #endif
 }
 
@@ -304,11 +303,9 @@ static int afs_vlocation_fill_in_record(struct afs_vlocation *vl,
 	memset(&vldb, 0, sizeof(vldb));
 
 	/* see if we have an in-cache copy (will set vl->valid if there is) */
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_acquire_cookie(cell->cache,
-			       &afs_volume_cache_index_def,
-			       vlocation,
-			       &vl->cache);
+#ifdef CONFIG_AFS_FSCACHE
+	vl->cache = fscache_acquire_cookie(vl->cell->cache,
+					   &afs_vlocation_cache_index_def, vl);
 #endif
 
 	if (vl->valid) {
@@ -420,6 +417,11 @@ fill_in_record:
 	spin_unlock(&vl->lock);
 	wake_up(&vl->waitq);
 
+	/* update volume entry in local cache */
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_update_cookie(vl->cache);
+#endif
+
 	/* schedule for regular updates */
 	afs_vlocation_queue_for_updates(vl);
 	goto success;
@@ -465,7 +467,7 @@ found_in_memory:
 	spin_unlock(&vl->lock);
 
 success:
-	_leave(" = %p",vl);
+	_leave(" = %p", vl);
 	return vl;
 
 error_abandon:
@@ -523,10 +525,9 @@ static void afs_vlocation_destroy(struct afs_vlocation *vl)
 {
 	_enter("%p", vl);
 
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_relinquish_cookie(vl->cache, 0);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_relinquish_cookie(vl->cache, 0);
 #endif
-
 	afs_put_cell(vl->cell);
 	kfree(vl);
 }
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 8bab0e3..a353e69 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -124,13 +124,11 @@ struct afs_volume *afs_volume_lookup(struct afs_mount_params *params)
 	}
 
 	/* attach the cache and volume location */
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_acquire_cookie(vlocation->cache,
-			       &afs_vnode_cache_index_def,
-			       volume,
-			       &volume->cache);
+#ifdef CONFIG_AFS_FSCACHE
+	volume->cache = fscache_acquire_cookie(vlocation->cache,
+					       &afs_volume_cache_index_def,
+					       volume);
 #endif
-
 	afs_get_vlocation(vlocation);
 	volume->vlocation = vlocation;
 
@@ -194,8 +192,8 @@ void afs_put_volume(struct afs_volume *volume)
 	up_write(&vlocation->cell->vl_sem);
 
 	/* finish cleaning up the volume */
-#ifdef AFS_CACHING_SUPPORT
-	cachefs_relinquish_cookie(volume->cache, 0);
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_relinquish_cookie(volume->cache, 0);
 #endif
 	afs_put_vlocation(vlocation);
 
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 3fb36d4..c2e7a7f 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -780,3 +780,24 @@ int afs_fsync(struct file *file, struct dentry *dentry, int datasync)
 	_leave(" = %d", ret);
 	return ret;
 }
+
+/*
+ * notification that a previously read-only page is about to become writable
+ * - if it returns an error, the caller will deliver a bus error signal
+ */
+int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
+{
+	struct afs_vnode *vnode = AFS_FS_I(vma->vm_file->f_mapping->host);
+
+	_enter("{{%x:%u}},{%lx}",
+	       vnode->fid.vid, vnode->fid.vnode, page->index);
+
+	/* wait for the page to be written to the cache before we allow it to
+	 * be modified */
+#ifdef CONFIG_AFS_FSCACHE
+	fscache_wait_on_page_write(vnode->cache, page);
+#endif
+
+	_leave(" = 0");
+	return 0;
+}

