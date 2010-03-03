Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab0CCAuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:50:35 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54211 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab0CCAqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:49 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 16/26] ceph: authentication interface
Date: Tue,  2 Mar 2010 16:46:47 -0800
Message-Id: <1267577217-31923-17-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267577217-31923-1-git-send-email-sage@newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the authentication interface and abstract interface for
authentication protocols.  This allows us to implement different
authentication schemes, including a trivial scheme that performs
no actual authentication.  A proper implementation allows us to
authenticate ourselves once with the monitor, and use a ticket to
access services (MDS, OSD) with mutual authentication.

When the client initially connects to the monitor, it lists
supported authentication protocols and the monitor indicates
which will be used for the session.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/auth.c |  257 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/auth.h |   84 ++++++++++++++++++
 2 files changed, 341 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/auth.c
 create mode 100644 fs/ceph/auth.h

diff --git a/fs/ceph/auth.c b/fs/ceph/auth.c
new file mode 100644
index 0000000..abb204f
--- /dev/null
+++ b/fs/ceph/auth.c
@@ -0,0 +1,257 @@
+#include "ceph_debug.h"
+
+#include <linux/module.h>
+#include <linux/err.h>
+
+#include "types.h"
+#include "auth_none.h"
+#include "auth_x.h"
+#include "decode.h"
+#include "super.h"
+
+#include "messenger.h"
+
+/*
+ * get protocol handler
+ */
+static u32 supported_protocols[] = {
+	CEPH_AUTH_NONE,
+	CEPH_AUTH_CEPHX
+};
+
+int ceph_auth_init_protocol(struct ceph_auth_client *ac, int protocol)
+{
+	switch (protocol) {
+	case CEPH_AUTH_NONE:
+		return ceph_auth_none_init(ac);
+	case CEPH_AUTH_CEPHX:
+		return ceph_x_init(ac);
+	default:
+		return -ENOENT;
+	}
+}
+
+/*
+ * setup, teardown.
+ */
+struct ceph_auth_client *ceph_auth_init(const char *name, const char *secret)
+{
+	struct ceph_auth_client *ac;
+	int ret;
+
+	dout("auth_init name '%s' secret '%s'\n", name, secret);
+
+	ret = -ENOMEM;
+	ac = kzalloc(sizeof(*ac), GFP_NOFS);
+	if (!ac)
+		goto out;
+
+	ac->negotiating = true;
+	if (name)
+		ac->name = name;
+	else
+		ac->name = CEPH_AUTH_NAME_DEFAULT;
+	dout("auth_init name %s secret %s\n", ac->name, secret);
+	ac->secret = secret;
+	return ac;
+
+out:
+	return ERR_PTR(ret);
+}
+
+void ceph_auth_destroy(struct ceph_auth_client *ac)
+{
+	dout("auth_destroy %p\n", ac);
+	if (ac->ops)
+		ac->ops->destroy(ac);
+	kfree(ac);
+}
+
+/*
+ * Reset occurs when reconnecting to the monitor.
+ */
+void ceph_auth_reset(struct ceph_auth_client *ac)
+{
+	dout("auth_reset %p\n", ac);
+	if (ac->ops && !ac->negotiating)
+		ac->ops->reset(ac);
+	ac->negotiating = true;
+}
+
+int ceph_entity_name_encode(const char *name, void **p, void *end)
+{
+	int len = strlen(name);
+
+	if (*p + 2*sizeof(u32) + len > end)
+		return -ERANGE;
+	ceph_encode_32(p, CEPH_ENTITY_TYPE_CLIENT);
+	ceph_encode_32(p, len);
+	ceph_encode_copy(p, name, len);
+	return 0;
+}
+
+/*
+ * Initiate protocol negotiation with monitor.  Include entity name
+ * and list supported protocols.
+ */
+int ceph_auth_build_hello(struct ceph_auth_client *ac, void *buf, size_t len)
+{
+	struct ceph_mon_request_header *monhdr = buf;
+	void *p = monhdr + 1, *end = buf + len, *lenp;
+	int i, num;
+	int ret;
+
+	dout("auth_build_hello\n");
+	monhdr->have_version = 0;
+	monhdr->session_mon = cpu_to_le16(-1);
+	monhdr->session_mon_tid = 0;
+
+	ceph_encode_32(&p, 0);  /* no protocol, yet */
+
+	lenp = p;
+	p += sizeof(u32);
+
+	ceph_decode_need(&p, end, 1 + sizeof(u32), bad);
+	ceph_encode_8(&p, 1);
+	num = ARRAY_SIZE(supported_protocols);
+	ceph_encode_32(&p, num);
+	ceph_decode_need(&p, end, num * sizeof(u32), bad);
+	for (i = 0; i < num; i++)
+		ceph_encode_32(&p, supported_protocols[i]);
+
+	ret = ceph_entity_name_encode(ac->name, &p, end);
+	if (ret < 0)
+		return ret;
+	ceph_decode_need(&p, end, sizeof(u64), bad);
+	ceph_encode_64(&p, ac->global_id);
+
+	ceph_encode_32(&lenp, p - lenp - sizeof(u32));
+	return p - buf;
+
+bad:
+	return -ERANGE;
+}
+
+int ceph_build_auth_request(struct ceph_auth_client *ac,
+			   void *msg_buf, size_t msg_len)
+{
+	struct ceph_mon_request_header *monhdr = msg_buf;
+	void *p = monhdr + 1;
+	void *end = msg_buf + msg_len;
+	int ret;
+
+	monhdr->have_version = 0;
+	monhdr->session_mon = cpu_to_le16(-1);
+	monhdr->session_mon_tid = 0;
+
+	ceph_encode_32(&p, ac->protocol);
+
+	ret = ac->ops->build_request(ac, p + sizeof(u32), end);
+	if (ret < 0) {
+		pr_err("error %d building request\n", ret);
+		return ret;
+	}
+	dout(" built request %d bytes\n", ret);
+	ceph_encode_32(&p, ret);
+	return p + ret - msg_buf;
+}
+
+/*
+ * Handle auth message from monitor.
+ */
+int ceph_handle_auth_reply(struct ceph_auth_client *ac,
+			   void *buf, size_t len,
+			   void *reply_buf, size_t reply_len)
+{
+	void *p = buf;
+	void *end = buf + len;
+	int protocol;
+	s32 result;
+	u64 global_id;
+	void *payload, *payload_end;
+	int payload_len;
+	char *result_msg;
+	int result_msg_len;
+	int ret = -EINVAL;
+
+	dout("handle_auth_reply %p %p\n", p, end);
+	ceph_decode_need(&p, end, sizeof(u32) * 3 + sizeof(u64), bad);
+	protocol = ceph_decode_32(&p);
+	result = ceph_decode_32(&p);
+	global_id = ceph_decode_64(&p);
+	payload_len = ceph_decode_32(&p);
+	payload = p;
+	p += payload_len;
+	ceph_decode_need(&p, end, sizeof(u32), bad);
+	result_msg_len = ceph_decode_32(&p);
+	result_msg = p;
+	p += result_msg_len;
+	if (p != end)
+		goto bad;
+
+	dout(" result %d '%.*s' gid %llu len %d\n", result, result_msg_len,
+	     result_msg, global_id, payload_len);
+
+	payload_end = payload + payload_len;
+
+	if (global_id && ac->global_id != global_id) {
+		dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
+		ac->global_id = global_id;
+	}
+
+	if (ac->negotiating) {
+		/* server does not support our protocols? */
+		if (!protocol && result < 0) {
+			ret = result;
+			goto out;
+		}
+		/* set up (new) protocol handler? */
+		if (ac->protocol && ac->protocol != protocol) {
+			ac->ops->destroy(ac);
+			ac->protocol = 0;
+			ac->ops = NULL;
+		}
+		if (ac->protocol != protocol) {
+			ret = ceph_auth_init_protocol(ac, protocol);
+			if (ret) {
+				pr_err("error %d on auth protocol %d init\n",
+				       ret, protocol);
+				goto out;
+			}
+		}
+
+		ac->negotiating = false;
+	}
+
+	ret = ac->ops->handle_reply(ac, result, payload, payload_end);
+	if (ret == -EAGAIN) {
+		return ceph_build_auth_request(ac, reply_buf, reply_len);
+	} else if (ret) {
+		pr_err("authentication error %d\n", ret);
+		return ret;
+	}
+	return 0;
+
+bad:
+	pr_err("failed to decode auth msg\n");
+out:
+	return ret;
+}
+
+int ceph_build_auth(struct ceph_auth_client *ac,
+		    void *msg_buf, size_t msg_len)
+{
+	if (!ac->protocol)
+		return ceph_auth_build_hello(ac, msg_buf, msg_len);
+	BUG_ON(!ac->ops);
+	if (!ac->ops->is_authenticated(ac))
+		return ceph_build_auth_request(ac, msg_buf, msg_len);
+	return 0;
+}
+
+int ceph_auth_is_authenticated(struct ceph_auth_client *ac)
+{
+	if (!ac->ops)
+		return 0;
+	return ac->ops->is_authenticated(ac);
+}
diff --git a/fs/ceph/auth.h b/fs/ceph/auth.h
new file mode 100644
index 0000000..ca4f57c
--- /dev/null
+++ b/fs/ceph/auth.h
@@ -0,0 +1,84 @@
+#ifndef _FS_CEPH_AUTH_H
+#define _FS_CEPH_AUTH_H
+
+#include "types.h"
+#include "buffer.h"
+
+/*
+ * Abstract interface for communicating with the authenticate module.
+ * There is some handshake that takes place between us and the monitor
+ * to acquire the necessary keys.  These are used to generate an
+ * 'authorizer' that we use when connecting to a service (mds, osd).
+ */
+
+struct ceph_auth_client;
+struct ceph_authorizer;
+
+struct ceph_auth_client_ops {
+	/*
+	 * true if we are authenticated and can connect to
+	 * services.
+	 */
+	int (*is_authenticated)(struct ceph_auth_client *ac);
+
+	/*
+	 * build requests and process replies during monitor
+	 * handshake.  if handle_reply returns -EAGAIN, we build
+	 * another request.
+	 */
+	int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
+	int (*handle_reply)(struct ceph_auth_client *ac, int result,
+			    void *buf, void *end);
+
+	/*
+	 * Create authorizer for connecting to a service, and verify
+	 * the response to authenticate the service.
+	 */
+	int (*create_authorizer)(struct ceph_auth_client *ac, int peer_type,
+				 struct ceph_authorizer **a,
+				 void **buf, size_t *len,
+				 void **reply_buf, size_t *reply_len);
+	int (*verify_authorizer_reply)(struct ceph_auth_client *ac,
+				       struct ceph_authorizer *a, size_t len);
+	void (*destroy_authorizer)(struct ceph_auth_client *ac,
+				   struct ceph_authorizer *a);
+	void (*invalidate_authorizer)(struct ceph_auth_client *ac,
+				      int peer_type);
+
+	/* reset when we (re)connect to a monitor */
+	void (*reset)(struct ceph_auth_client *ac);
+
+	void (*destroy)(struct ceph_auth_client *ac);
+};
+
+struct ceph_auth_client {
+	u32 protocol;           /* CEPH_AUTH_* */
+	void *private;          /* for use by protocol implementation */
+	const struct ceph_auth_client_ops *ops;  /* null iff protocol==0 */
+
+	bool negotiating;       /* true if negotiating protocol */
+	const char *name;       /* entity name */
+	u64 global_id;          /* our unique id in system */
+	const char *secret;     /* our secret key */
+	unsigned want_keys;     /* which services we want */
+};
+
+extern struct ceph_auth_client *ceph_auth_init(const char *name,
+					       const char *secret);
+extern void ceph_auth_destroy(struct ceph_auth_client *ac);
+
+extern void ceph_auth_reset(struct ceph_auth_client *ac);
+
+extern int ceph_auth_build_hello(struct ceph_auth_client *ac,
+				 void *buf, size_t len);
+extern int ceph_handle_auth_reply(struct ceph_auth_client *ac,
+				  void *buf, size_t len,
+				  void *reply_buf, size_t reply_len);
+extern int ceph_entity_name_encode(const char *name, void **p, void *end);
+
+extern int ceph_build_auth(struct ceph_auth_client *ac,
+		    void *msg_buf, size_t msg_len);
+
+extern int ceph_auth_is_authenticated(struct ceph_auth_client *ac);
+
+#endif
-- 
1.7.0

