Return-Path: <linux-kernel-owner+w=401wt.eu-S935411AbZDCQB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935411AbZDCQB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934229AbZDCPzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbZDCPzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/41] FS-Cache: Root index definition [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:33 +0100
Message-ID: <20090403155533.28714.78451.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a description of the root index of the cache for later patches to make use
of.

The root index is owned by FS-Cache itself.  When a netfs requests caching
facilities, FS-Cache will, if one doesn't already exist, create an entry in
the root index with the key being the name of the netfs ("AFS" for example),
and the auxiliary data holding the index structure version supplied by the
netfs:

				     FSDEF
				       |
				 +-----------+
				 |           |
				NFS         AFS
			       [v=1]       [v=1]

If an entry with the appropriate name does already exist, the version is
compared.  If the version is different, the entire subtree from that entry
will be discarded and a new entry created.

The new entry will be an index, and a cookie referring to it will be passed to
the netfs.  This is then the root handle by which the netfs accesses the
cache.  It can create whatever objects it likes in that index, including
further indices.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/Makefile   |    1 
 fs/fscache/fsdef.c    |  144 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/internal.h |    6 ++
 3 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 fs/fscache/fsdef.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 1384823..bc1f3b9 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -3,6 +3,7 @@
 #
 
 fscache-y := \
+	fsdef.o \
 	main.o
 
 fscache-$(CONFIG_PROC_FS) += proc.o
diff --git a/fs/fscache/fsdef.c b/fs/fscache/fsdef.c
new file mode 100644
index 0000000..f5b4bae
--- /dev/null
+++ b/fs/fscache/fsdef.c
@@ -0,0 +1,144 @@
+/* Filesystem index definition
+ *
+ * Copyright (C) 2004-2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL CACHE
+#include <linux/module.h>
+#include "internal.h"
+
+static uint16_t fscache_fsdef_netfs_get_key(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax);
+
+static uint16_t fscache_fsdef_netfs_get_aux(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax);
+
+static
+enum fscache_checkaux fscache_fsdef_netfs_check_aux(void *cookie_netfs_data,
+						    const void *data,
+						    uint16_t datalen);
+
+/*
+ * The root index is owned by FS-Cache itself.
+ *
+ * When a netfs requests caching facilities, FS-Cache will, if one doesn't
+ * already exist, create an entry in the root index with the key being the name
+ * of the netfs ("AFS" for example), and the auxiliary data holding the index
+ * structure version supplied by the netfs:
+ *
+ *				     FSDEF
+ *				       |
+ *				 +-----------+
+ *				 |           |
+ *				NFS         AFS
+ *			       [v=1]       [v=1]
+ *
+ * If an entry with the appropriate name does already exist, the version is
+ * compared.  If the version is different, the entire subtree from that entry
+ * will be discarded and a new entry created.
+ *
+ * The new entry will be an index, and a cookie referring to it will be passed
+ * to the netfs.  This is then the root handle by which the netfs accesses the
+ * cache.  It can create whatever objects it likes in that index, including
+ * further indices.
+ */
+static struct fscache_cookie_def fscache_fsdef_index_def = {
+	.name		= ".FS-Cache",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+};
+
+struct fscache_cookie fscache_fsdef_index = {
+	.usage		= ATOMIC_INIT(1),
+	.lock		= __SPIN_LOCK_UNLOCKED(fscache_fsdef_index.lock),
+	.backing_objects = HLIST_HEAD_INIT,
+	.def		= &fscache_fsdef_index_def,
+};
+EXPORT_SYMBOL(fscache_fsdef_index);
+
+/*
+ * Definition of an entry in the root index.  Each entry is an index, keyed to
+ * a specific netfs and only applicable to a particular version of the index
+ * structure used by that netfs.
+ */
+struct fscache_cookie_def fscache_fsdef_netfs_def = {
+	.name		= "FSDEF.netfs",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= fscache_fsdef_netfs_get_key,
+	.get_aux	= fscache_fsdef_netfs_get_aux,
+	.check_aux	= fscache_fsdef_netfs_check_aux,
+};
+
+/*
+ * get the key data for an FSDEF index record - this is the name of the netfs
+ * for which this entry is created
+ */
+static uint16_t fscache_fsdef_netfs_get_key(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax)
+{
+	const struct fscache_netfs *netfs = cookie_netfs_data;
+	unsigned klen;
+
+	_enter("{%s.%u},", netfs->name, netfs->version);
+
+	klen = strlen(netfs->name);
+	if (klen > bufmax)
+		return 0;
+
+	memcpy(buffer, netfs->name, klen);
+	return klen;
+}
+
+/*
+ * get the auxiliary data for an FSDEF index record - this is the index
+ * structure version number of the netfs for which this version is created
+ */
+static uint16_t fscache_fsdef_netfs_get_aux(const void *cookie_netfs_data,
+					    void *buffer, uint16_t bufmax)
+{
+	const struct fscache_netfs *netfs = cookie_netfs_data;
+	unsigned dlen;
+
+	_enter("{%s.%u},", netfs->name, netfs->version);
+
+	dlen = sizeof(uint32_t);
+	if (dlen > bufmax)
+		return 0;
+
+	memcpy(buffer, &netfs->version, dlen);
+	return dlen;
+}
+
+/*
+ * check that the index structure version number stored in the auxiliary data
+ * matches the one the netfs gave us
+ */
+static enum fscache_checkaux fscache_fsdef_netfs_check_aux(
+	void *cookie_netfs_data,
+	const void *data,
+	uint16_t datalen)
+{
+	struct fscache_netfs *netfs = cookie_netfs_data;
+	uint32_t version;
+
+	_enter("{%s},,%hu", netfs->name, datalen);
+
+	if (datalen != sizeof(version)) {
+		_leave(" = OBSOLETE [dl=%d v=%zu]", datalen, sizeof(version));
+		return FSCACHE_CHECKAUX_OBSOLETE;
+	}
+
+	memcpy(&version, data, sizeof(version));
+	if (version != netfs->version) {
+		_leave(" = OBSOLETE [ver=%x net=%x]", version, netfs->version);
+		return FSCACHE_CHECKAUX_OBSOLETE;
+	}
+
+	_leave(" = OKAY");
+	return FSCACHE_CHECKAUX_OKAY;
+}
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 16f9f1f..4113af8 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -28,6 +28,12 @@
 #define FSCACHE_MAX_THREADS	32
 
 /*
+ * fsc-fsdef.c
+ */
+extern struct fscache_cookie fscache_fsdef_index;
+extern struct fscache_cookie_def fscache_fsdef_netfs_def;
+
+/*
  * fsc-histogram.c
  */
 #ifdef CONFIG_FSCACHE_HISTOGRAM

