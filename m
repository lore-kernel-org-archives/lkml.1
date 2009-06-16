Return-Path: <linux-kernel-owner+w=401wt.eu-S1764010AbZFPUmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764010AbZFPUmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762914AbZFPUkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762348AbZFPUkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/17] AFS: Implement the PSetTokens pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:40:02 +0100
Message-ID: <20090616204002.4526.22111.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the PSetTokens pioctl for AFS.  This will submit a security token for
caching.

This can be tested with the OpenAFS userspace tools using the klog program,
which should add a key to the session keyring with something like:

	[root@andromeda ~]# echo password | klog -pipe admin
	[root@andromeda ~]# keyctl show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	147139749 --alswrv      0    -1   \_ keyring: _uid.0
	457362442 --als--v      0     0   \_ rxrpc: cambridge.redhat.com

Note that 'klog -setpag' is not supported by this patch as there's currently
no way for a process to replace its parent process's session keyring.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/cell.c           |   15 ++++
 fs/afs/internal.h       |    1 
 fs/afs/pioctl.c         |  177 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/afscall.h |   14 ++++
 include/linux/venus.h   |    1 
 5 files changed, 208 insertions(+), 0 deletions(-)


diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index e19c13f..b900fc7 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -227,6 +227,21 @@ int afs_cell_init(char *rootcell)
 }
 
 /*
+ * get a reference to the root cell
+ */
+struct afs_cell *afs_get_root_cell(void)
+{
+	struct afs_cell *cell;
+
+	read_lock(&afs_cells_lock);
+	cell = afs_cell_root;
+	afs_get_cell(cell);
+	read_unlock(&afs_cells_lock);
+
+	return cell;
+}
+
+/*
  * lookup a cell record
  */
 struct afs_cell *afs_cell_lookup(const char *name, unsigned namesz)
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 9a8e8a2..cf08782 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -467,6 +467,7 @@ extern struct list_head afs_proc_cells;
 
 #define afs_get_cell(C) do { atomic_inc(&(C)->usage); } while(0)
 extern int afs_cell_init(char *);
+extern struct afs_cell *afs_get_root_cell(void);
 extern struct afs_cell *afs_cell_create(const char *, char *);
 extern struct afs_cell *afs_cell_lookup(const char *, unsigned);
 extern struct afs_cell *afs_grab_cell(struct afs_cell *);
diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index ffbec0c..e6ea69f 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -2,6 +2,8 @@
  *
  * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
  *
+ * Modified by David Howells <dhowells@redhat.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -12,6 +14,10 @@
 #include <linux/pioctl.h>
 #include <linux/venus.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/key.h>
+#include <linux/keyctl.h>
+#include <keys/rxrpc-type.h>
 #include "internal.h"
 
 /*
@@ -219,6 +225,173 @@ long afs_pioctl(struct dentry *dentry, int cmd, struct vice_ioctl *arg)
 }
 
 /*
+ * Set a user's rxkad authentication tokens
+ */
+static long afs_PSetTokens(struct vice_ioctl *arg)
+{
+	struct rxrpc_key_data_v2 *payload;
+	struct clear_token details;
+	struct afs_cell *cell;
+	const char *cp;
+	key_ref_t keyring_r, key_r;
+	size_t in_size, loop;
+	void *in, *in_next, *ticket;
+	char *cellname, *keyname, *dp;
+	long ret;
+	u32 tktlen, tmp, flag;
+
+	_enter("");
+
+	/* decode the argument block */
+	in_next = arg->in;
+	in_size = arg->in_size;
+
+#define CHECK(n)				\
+	do {					\
+		if (in_size < (n))		\
+			goto underflow;		\
+		in = in_next;			\
+		in_size -= (n);			\
+		in_next += (n);			\
+	} while(0)
+
+#define DECODE(to)				\
+	do {					\
+		CHECK(sizeof(*(to)));		\
+		memcpy(to, in, sizeof(*(to)));	\
+	} while(0)
+
+	DECODE(&tktlen);
+	_debug("tktlen: %u", tktlen);
+	if (tktlen > INT_MAX)
+		goto invalid;
+	CHECK(tktlen);
+	ticket = in;
+	DECODE(&tmp);
+	_debug("clear token %u", tmp);
+	if (tmp != sizeof(struct clear_token))
+		goto invalid;
+	DECODE(&details);
+	_debug("ah:%x vi:%x bts:%x ets:%x (e-b:%u) (CT:%lx)",
+	       details.auth_handle, details.vice_id,
+	       details.begin_timestamp, details.end_timestamp,
+	       details.end_timestamp - details.begin_timestamp,
+	       CURRENT_TIME.tv_sec);
+	if (details.vice_id == UINT_MAX)
+		goto invalid;
+	if (details.auth_handle == UINT_MAX)
+		details.auth_handle = 999;
+
+	/* flags and cellname are optional, defaulting to the root cell */
+	_debug("in_size: %zu", in_size);
+	if (in_size != 0) {
+		DECODE(&flag);
+		_debug("flag: %x", flag);
+
+		if (flag & 0x8000) {
+			/* the caller wants us to give our parent a new PAG
+			 * - we don't support this currently
+			 */
+			_leave(" = -EACCES");
+			return -EACCES;
+		}
+
+		/* remainder is cell name */
+		CHECK(sizeof(char));
+		cellname = in;
+		for (loop = 0; loop < in_size; loop++)
+			if (!isprint(cellname[loop]))
+				goto invalid;
+
+		if (cellname[loop] != '\0')
+			goto invalid;
+		cell = NULL;
+
+		_debug("cellname: %s", cellname);
+	} else {
+		cell = afs_get_root_cell();
+		cellname = cell->name;
+		flag = 1;
+	}
+
+#undef DECODE
+#undef CHECK
+
+	/* construct the key name */
+	ret = -ENOMEM;
+	keyname = kmalloc(4 + strlen(cellname) + 1, GFP_KERNEL);
+	if (!keyname)
+		goto error_nokeyname;
+
+	memcpy(keyname, "afs@", 4);
+	dp = keyname + 4;
+	cp = cellname;
+	while (*cp)
+		*dp++ = toupper(*cp++);
+	*dp = 0;
+
+	/* we install the authentication token as a key */
+	payload = kmalloc(sizeof(*payload) + tktlen, GFP_KERNEL);
+	if (!payload)
+		goto error_nopayload;
+
+	payload->kif_version	= 2;
+	payload->security_index	= RXRPC_SECURITY_RXKAD;
+	payload->ticket_length	= tktlen;
+	payload->vice_id	= details.vice_id;
+	payload->start		= details.begin_timestamp;
+	payload->expiry		= details.end_timestamp;
+	payload->kvno		= details.auth_handle;
+	memcpy(payload->session_key, details.session_key, 8);
+	memcpy(payload->ticket, ticket, tktlen);
+
+	/* add the key to the session keyring */
+	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 1, 0,
+				    WANT_KEY_WRITE);
+	if (IS_ERR(keyring_r)) {
+		_debug("keyring lookup failed");
+		ret = PTR_ERR(keyring_r);
+		goto error;
+	}
+
+	/* create or update the requested key and add it to the target
+	 * keyring */
+	key_r = key_create_or_update(keyring_r, "rxrpc", keyname,
+				     payload, sizeof(*payload) + tktlen,
+				     KEY_PERM_UNDEF, KEY_ALLOC_IN_QUOTA);
+	key_ref_put(keyring_r);
+
+	if (IS_ERR(key_r)) {
+		_debug("key create failed");
+		ret = PTR_ERR(key_r);
+		goto error;
+	}
+
+	_debug("key serial: %x", key_ref_to_ptr(key_r)->serial);
+
+	key_ref_put(key_r);
+	arg->out_size = 0;
+	ret = 0;
+
+error:
+	kfree(payload);
+error_nopayload:
+	kfree(keyname);
+error_nokeyname:
+	afs_put_cell(cell);
+	_leave(" = %ld", ret);
+	return ret;
+
+underflow:
+	_leave(" = -EINVAL [short arg]");
+	return -EINVAL;
+
+invalid:
+	_leave(" = -EINVAL [invalid arg]");
+	return -EINVAL;
+}
+
+/*
  * The AFS pathless pioctl handler
  */
 long afs_pathless_pioctl(int cmd, struct vice_ioctl *arg)
@@ -231,6 +404,10 @@ long afs_pathless_pioctl(int cmd, struct vice_ioctl *arg)
 #define VIOC_COMMAND(nr) (_VICEIOCTL(nr) & ~IOCSIZE_MASK)
 
 	switch (cmd & ~IOCSIZE_MASK) {
+	case VIOC_COMMAND(PSetTokens):
+		ret = afs_PSetTokens(arg);
+		break;
+
 	default:
 		printk(KERN_DEBUG "AFS: Unsupported pioctl command %x\n", cmd);
 		ret = -EOPNOTSUPP;
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index 00054f0..7635aab 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -2,6 +2,8 @@
  *
  * Copyright (C) 2008 Jacob Thebault-Spieker <summatusmentis@gmail.com>
  *
+ * Modified by David Howells <dhowells@redhat.com>
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
@@ -14,6 +16,7 @@
 #define AFSCALL_PIOCTL 0x14
 
 /* pioctl commands */
+#define PSetTokens	3		/* get authentication tokens for user */
 #define PGetVolStat	4		/* get volume status */
 #define PWhereIs	14		/* find out where a volume is located */
 #define PGetFID		22		/* get file ID */
@@ -40,4 +43,15 @@ struct VolumeStatus {
 	int	PartMaxBlocks;	/* size of volume's partition */
 };
 
+/*
+ * User details when getting or submitting a token
+ */
+struct clear_token {
+	u32	auth_handle;		/* key version number */
+	u8	session_key[8];		/* session encryption key */
+	u32	vice_id;		/* client/user ID */
+	u32	begin_timestamp;	/* time_t at which ticket starts */
+	u32	end_timestamp;		/* time_t at which ticket expires */
+};
+
 #endif /* _LINUX_AFSCALL_H */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index ea8e468..b90e5f2 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -17,6 +17,7 @@
 /*
  * pioctl commands (not usable as ioctls)
  */
+#define VIOCSETTOK		_VICEIOCTL(PSetTokens)
 #define VIOCGETVOLSTAT		_VICEIOCTL(PGetVolStat)
 #define VIOCWHEREIS		_VICEIOCTL(PWhereIs)
 #define VIOCGETFID		_VICEIOCTL(PGetFID)

