Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab0CCAui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:50:38 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54189 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0CCAqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:49 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 17/26] ceph: trivial 'auth_none' authentication scheme
Date: Tue,  2 Mar 2010 16:46:48 -0800
Message-Id: <1267577217-31923-18-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267577217-31923-1-git-send-email-sage@newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a trivial authentication scheme that provides
no actual authentication.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/auth_none.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/auth_none.h |   28 ++++++++++++
 2 files changed, 149 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/auth_none.c
 create mode 100644 fs/ceph/auth_none.h

diff --git a/fs/ceph/auth_none.c b/fs/ceph/auth_none.c
new file mode 100644
index 0000000..b4ef6f0
--- /dev/null
+++ b/fs/ceph/auth_none.c
@@ -0,0 +1,121 @@
+
+#include "ceph_debug.h"
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include "auth_none.h"
+#include "auth.h"
+#include "decode.h"
+
+static void reset(struct ceph_auth_client *ac)
+{
+	struct ceph_auth_none_info *xi = ac->private;
+
+	xi->starting = true;
+	xi->built_authorizer = false;
+}
+
+static void destroy(struct ceph_auth_client *ac)
+{
+	kfree(ac->private);
+	ac->private = NULL;
+}
+
+static int is_authenticated(struct ceph_auth_client *ac)
+{
+	struct ceph_auth_none_info *xi = ac->private;
+
+	return !xi->starting;
+}
+
+/*
+ * the generic auth code decode the global_id, and we carry no actual
+ * authenticate state, so nothing happens here.
+ */
+static int handle_reply(struct ceph_auth_client *ac, int result,
+			void *buf, void *end)
+{
+	struct ceph_auth_none_info *xi = ac->private;
+
+	xi->starting = false;
+	return result;
+}
+
+/*
+ * build an 'authorizer' with our entity_name and global_id.  we can
+ * reuse a single static copy since it is identical for all services
+ * we connect to.
+ */
+static int ceph_auth_none_create_authorizer(
+	struct ceph_auth_client *ac, int peer_type,
+	struct ceph_authorizer **a,
+	void **buf, size_t *len,
+	void **reply_buf, size_t *reply_len)
+{
+	struct ceph_auth_none_info *ai = ac->private;
+	struct ceph_none_authorizer *au = &ai->au;
+	void *p, *end;
+	int ret;
+
+	if (!ai->built_authorizer) {
+		p = au->buf;
+		end = p + sizeof(au->buf);
+		ceph_encode_8(&p, 1);
+		ret = ceph_entity_name_encode(ac->name, &p, end - 8);
+		if (ret < 0)
+			goto bad;
+		ceph_decode_need(&p, end, sizeof(u64), bad2);
+		ceph_encode_64(&p, ac->global_id);
+		au->buf_len = p - (void *)au->buf;
+		ai->built_authorizer = true;
+		dout("built authorizer len %d\n", au->buf_len);
+	}
+
+	*a = (struct ceph_authorizer *)au;
+	*buf = au->buf;
+	*len = au->buf_len;
+	*reply_buf = au->reply_buf;
+	*reply_len = sizeof(au->reply_buf);
+	return 0;
+
+bad2:
+	ret = -ERANGE;
+bad:
+	return ret;
+}
+
+static void ceph_auth_none_destroy_authorizer(struct ceph_auth_client *ac,
+				      struct ceph_authorizer *a)
+{
+	/* nothing to do */
+}
+
+static const struct ceph_auth_client_ops ceph_auth_none_ops = {
+	.reset = reset,
+	.destroy = destroy,
+	.is_authenticated = is_authenticated,
+	.handle_reply = handle_reply,
+	.create_authorizer = ceph_auth_none_create_authorizer,
+	.destroy_authorizer = ceph_auth_none_destroy_authorizer,
+};
+
+int ceph_auth_none_init(struct ceph_auth_client *ac)
+{
+	struct ceph_auth_none_info *xi;
+
+	dout("ceph_auth_none_init %p\n", ac);
+	xi = kzalloc(sizeof(*xi), GFP_NOFS);
+	if (!xi)
+		return -ENOMEM;
+
+	xi->starting = true;
+	xi->built_authorizer = false;
+
+	ac->protocol = CEPH_AUTH_NONE;
+	ac->private = xi;
+	ac->ops = &ceph_auth_none_ops;
+	return 0;
+}
+
diff --git a/fs/ceph/auth_none.h b/fs/ceph/auth_none.h
new file mode 100644
index 0000000..56c0553
--- /dev/null
+++ b/fs/ceph/auth_none.h
@@ -0,0 +1,28 @@
+#ifndef _FS_CEPH_AUTH_NONE_H
+#define _FS_CEPH_AUTH_NONE_H
+
+#include "auth.h"
+
+/*
+ * null security mode.
+ *
+ * we use a single static authorizer that simply encodes our entity name
+ * and global id.
+ */
+
+struct ceph_none_authorizer {
+	char buf[128];
+	int buf_len;
+	char reply_buf[0];
+};
+
+struct ceph_auth_none_info {
+	bool starting;
+	bool built_authorizer;
+	struct ceph_none_authorizer au;   /* we only need one; it's static */
+};
+
+extern int ceph_auth_none_init(struct ceph_auth_client *ac);
+
+#endif
+
-- 
1.7.0

