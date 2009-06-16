Return-Path: <linux-kernel-owner+w=401wt.eu-S1764560AbZFPUo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764560AbZFPUo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762983AbZFPUkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762995AbZFPUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/17] AFS: Implement the PGetTokens pioctl
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:40:13 +0100
Message-ID: <20090616204013.4526.32291.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the PGetTokens pioctl for AFS.  This will get the security tokens
cached for a user for security index 2 tokens.

This can be tested with the OpenAFS userspace tools by doing:

	tokens

which should return something like:

	[root@andromeda ~]# echo password | klog admin -pipe
	[root@andromeda ~]# keyctl show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	237984081 --alswrv      0    -1   \_ keyring: _uid.0
	978861311 --als--v      0     0   \_ rxrpc: cambridge.redhat.com
	[root@andromeda ~]# tokens

	Tokens held by the Cache Manager:

	User's (AFS ID 10143) tokens for afs@cambridge.redhat.com [Expires Jun 16 16:10]
	   --End of list--

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/pioctl.c         |  174 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/afscall.h |    1 
 include/linux/venus.h   |    1 
 3 files changed, 176 insertions(+), 0 deletions(-)


diff --git a/fs/afs/pioctl.c b/fs/afs/pioctl.c
index e6ea69f..d097745 100644
--- a/fs/afs/pioctl.c
+++ b/fs/afs/pioctl.c
@@ -392,6 +392,175 @@ invalid:
 }
 
 /*
+ * filter tickets by security index when enumerating
+ */
+bool afs_enum_filter(const struct key *key, void *data)
+{
+	unsigned long security_index = (unsigned long) data;
+
+	return key->type == &key_type_rxrpc &&
+		key->type_data.x[0] == security_index &&
+		memcmp(key->description, "afs@", 4) == 0;
+}
+
+/*
+ * Get a user's authentication rxkad tokens
+ */
+static long afs_PGetTokens(struct vice_ioctl *arg)
+{
+	struct rxrpc_key_payload *upayload;
+	struct clear_token details;
+	struct afs_cell *root_cell;
+	struct key *key;
+	key_ref_t keyring_r, key_r = NULL;
+	size_t out_size;
+	void *out, *out_next;
+	long ret;
+	int skip;
+	u32 tmp, ticket_len;
+
+	_enter("");
+
+	/* find out which key we're being asked for */
+	if (arg->in_size == 0) {
+		skip = -1;
+	} else if (arg->in_size == sizeof(skip)) {
+		memcpy(&skip, arg->in, sizeof(skip));
+		if (skip < 0) {
+			_leave(" = -EINVAL [inval iter]");
+			return -EINVAL;
+		}
+	} else {
+		_leave(" = -EINVAL [bad arg size]");
+		return -EINVAL;
+	}
+
+	_debug("iterator: %d", skip);
+
+	/* we're going to look through the session keyring */
+	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 1, 0,
+				    WANT_KEY_SEARCH);
+	if (IS_ERR(keyring_r)) {
+		_leave(" = %ld [keyring]", PTR_ERR(keyring_r));
+		return PTR_ERR(keyring_r);
+	}
+
+	root_cell = afs_get_root_cell();
+	ASSERT(root_cell != NULL);
+
+	/* if there's no input argument, then we return the tokens for the root
+	 * cell; if there is an argument, then we're being asked for the nth
+	 * key belonging to this session */
+	if (skip >= 0) {
+		key_r = keyring_enum(keyring_r, skip,
+				     afs_enum_filter,
+				     (void *) RXRPC_SECURITY_RXKAD,
+				     WANT_KEY_SEARCH);
+		if (key_r == ERR_PTR(-ENOKEY)) {
+			ret = -EDOM;
+			goto error_no_key;
+		}
+	} else {
+		/* find key for the root cell */
+		key_r = keyring_search(keyring_r, &key_type_rxrpc,
+				       root_cell->anonymous_key->description);
+		if (key_r == ERR_PTR(-ENOKEY)) {
+			ret = -ENOTCONN;
+			goto error_no_key;
+		}
+	}
+
+	key_ref_put(keyring_r);
+	keyring_r = NULL;
+
+	if (IS_ERR(key_r)) {
+		if (key_r == ERR_PTR(-EACCES))
+			ret = -EACCES;
+		else
+			ret = -EIO;
+		goto error_no_key;
+	}
+
+	key = key_ref_to_ptr(key_r);
+	upayload = key->payload.data;
+
+	_debug("key serial: %x", key->serial);
+
+	/* pass the contents of the key back to userspace */
+#define CHECK(n)				\
+	do {					\
+		if (out_size < (n)) {		\
+			ret = -EINVAL;		\
+			goto error;		\
+		}				\
+		out = out_next;			\
+		out_size -= (n);		\
+		out_next += (n);		\
+	} while(0)
+
+#define ENCODE(from)					\
+	do {						\
+		CHECK(sizeof(*(from)));			\
+		memcpy(out, from, sizeof(*(from)));	\
+	} while(0)
+
+	out_next = arg->out;
+	out_size = arg->out_size;
+
+	/* pass the ticket in at least 56 bytes of space */
+	ticket_len = upayload->k.ticket_len;
+	tmp = min(ticket_len, 56U);
+	ENCODE(&tmp);
+	CHECK(tmp);
+	memcpy(out, upayload->k.ticket, ticket_len);
+	if (ticket_len < tmp)
+		memset(out + ticket_len, 0, tmp - ticket_len);
+
+	tmp = sizeof(details);
+	ENCODE(&tmp);
+	details.vice_id		= upayload->k.vice_id;
+	details.begin_timestamp	= upayload->k.start;
+	details.end_timestamp	= upayload->k.expiry;
+	details.auth_handle	= upayload->k.kvno;
+	memcpy(details.session_key, upayload->k.session_key, 8);
+	ENCODE(&details);
+
+	/* if we were given an iterator, then there's more stuff we must
+	 * return */
+	if (arg->in_size > 0) {
+		struct afs_cell *cell;
+		size_t cellname_size;
+
+		cellname_size = strlen(key->description + 4);
+		cell = afs_cell_lookup(key->description + 4, cellname_size);
+		tmp = (cell == root_cell) ? 1 : 0;
+		if (!IS_ERR(cell))
+			afs_put_cell(cell);
+		ENCODE(&tmp);
+		CHECK(cellname_size + 1);
+		memcpy(out, key->description + 4, cellname_size + 1);
+	}
+
+#undef ENCODE
+#undef CHECK
+
+	arg->out_size = (char *) out_next - arg->out;
+
+	key_ref_put(key_r);
+	afs_put_cell(root_cell);
+	_leave(" = 0");
+	return 0;
+
+error:
+	key_ref_put(key_r);
+error_no_key:
+	key_ref_put(keyring_r);
+	afs_put_cell(root_cell);
+	_leave(" = %ld", ret);
+	return ret;
+}
+
+/*
  * The AFS pathless pioctl handler
  */
 long afs_pathless_pioctl(int cmd, struct vice_ioctl *arg)
@@ -408,6 +577,11 @@ long afs_pathless_pioctl(int cmd, struct vice_ioctl *arg)
 		ret = afs_PSetTokens(arg);
 		break;
 
+
+	case VIOC_COMMAND(PGetTokens):
+		ret = afs_PGetTokens(arg);
+		break;
+
 	default:
 		printk(KERN_DEBUG "AFS: Unsupported pioctl command %x\n", cmd);
 		ret = -EOPNOTSUPP;
diff --git a/include/linux/afscall.h b/include/linux/afscall.h
index 7635aab..bdff9a0 100644
--- a/include/linux/afscall.h
+++ b/include/linux/afscall.h
@@ -18,6 +18,7 @@
 /* pioctl commands */
 #define PSetTokens	3		/* get authentication tokens for user */
 #define PGetVolStat	4		/* get volume status */
+#define PGetTokens	8		/* get authentication tokens for user */
 #define PWhereIs	14		/* find out where a volume is located */
 #define PGetFID		22		/* get file ID */
 #define PFlushCB	25		/* flush callback only */
diff --git a/include/linux/venus.h b/include/linux/venus.h
index b90e5f2..7a3ae08 100644
--- a/include/linux/venus.h
+++ b/include/linux/venus.h
@@ -19,6 +19,7 @@
  */
 #define VIOCSETTOK		_VICEIOCTL(PSetTokens)
 #define VIOCGETVOLSTAT		_VICEIOCTL(PGetVolStat)
+#define VIOCGETTOK		_VICEIOCTL(PGetTokens)
 #define VIOCWHEREIS		_VICEIOCTL(PWhereIs)
 #define VIOCGETFID		_VICEIOCTL(PGetFID)
 #define VIOCFLUSHCB		_VICEIOCTL(PFlushCB)

