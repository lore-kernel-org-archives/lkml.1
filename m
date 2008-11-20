Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYKTOr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYKTOr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYKTOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:42:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbYKTOms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:42:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/45] FS-Cache: Root index definition [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:42:41 +0000
Message-ID: <20081120144241.10667.24102.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
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
---

 fs/fscache/Makefile       |    1 
 fs/fscache/fsc-fsdef.c    |  144 +++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/fsc-internal.h |    6 ++
 3 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 fs/fscache/fsc-fsdef.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index ba55ab1..8fb7bcc 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -3,6 +3,7 @@
 #
 
 fscache-y := \
+	fsc-fsdef.o \
 	fsc-main.o \
 	fsc-proc.o \
 	fsc-stats.o
diff --git a/fs/fscache/fsc-fsdef.c b/fs/fscache/fsc-fsdef.c
new file mode 100644
index 0000000..f408684
--- /dev/null
+++ b/fs/fscache/fsc-fsdef.c
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
+#include "fsc-internal.h"
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
diff --git a/fs/fscache/fsc-internal.h b/fs/fscache/fsc-internal.h
index 4ada505..5ff611a 100644
--- a/fs/fscache/fsc-internal.h
+++ b/fs/fscache/fsc-internal.h
@@ -28,6 +28,12 @@
 #define FSCACHE_MAX_THREADS	32
 
 /*
+ * fsc-fsdef.c
+ */
+extern struct fscache_cookie fscache_fsdef_index;
+extern struct fscache_cookie_def fscache_fsdef_netfs_def;
+
+/*
  * fsc-main.c
  */
 extern unsigned fscache_defer_lookup;

