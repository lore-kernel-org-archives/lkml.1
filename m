Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbYHFPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbYHFPtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYHFPhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:37:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbYHFPhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:37:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/24] KEYS: Disperse linux/key_ui.h [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:24 +0100
Message-ID: <20080806153724.14351.13817.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disperse the bits of linux/key_ui.h as the reason they were put here (keyfs)
didn't get in.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

 include/keys/keyring-type.h |   31 ++++++++++++++++++++
 include/linux/key-ui.h      |   66 -------------------------------------------
 security/keys/internal.h    |   31 ++++++++++++++++++++
 security/keys/keyring.c     |    1 +
 security/keys/request_key.c |    2 +
 5 files changed, 64 insertions(+), 67 deletions(-)
 create mode 100644 include/keys/keyring-type.h
 delete mode 100644 include/linux/key-ui.h


diff --git a/include/keys/keyring-type.h b/include/keys/keyring-type.h
new file mode 100644
index 0000000..843f872
--- /dev/null
+++ b/include/keys/keyring-type.h
@@ -0,0 +1,31 @@
+/* Keyring key type
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _KEYS_KEYRING_TYPE_H
+#define _KEYS_KEYRING_TYPE_H
+
+#include <linux/key.h>
+#include <linux/rcupdate.h>
+
+/*
+ * the keyring payload contains a list of the keys to which the keyring is
+ * subscribed
+ */
+struct keyring_list {
+	struct rcu_head	rcu;		/* RCU deletion hook */
+	unsigned short	maxkeys;	/* max keys this list can hold */
+	unsigned short	nkeys;		/* number of keys currently held */
+	unsigned short	delkey;		/* key to be unlinked by RCU */
+	struct key	*keys[0];
+};
+
+
+#endif /* _KEYS_KEYRING_TYPE_H */
diff --git a/include/linux/key-ui.h b/include/linux/key-ui.h
deleted file mode 100644
index e8b8a7a..0000000
--- a/include/linux/key-ui.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/* key-ui.h: key userspace interface stuff
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _LINUX_KEY_UI_H
-#define _LINUX_KEY_UI_H
-
-#include <linux/key.h>
-
-/* the key tree */
-extern struct rb_root key_serial_tree;
-extern spinlock_t key_serial_lock;
-
-/* required permissions */
-#define	KEY_VIEW	0x01	/* require permission to view attributes */
-#define	KEY_READ	0x02	/* require permission to read content */
-#define	KEY_WRITE	0x04	/* require permission to update / modify */
-#define	KEY_SEARCH	0x08	/* require permission to search (keyring) or find (key) */
-#define	KEY_LINK	0x10	/* require permission to link */
-#define	KEY_SETATTR	0x20	/* require permission to change attributes */
-#define	KEY_ALL		0x3f	/* all the above permissions */
-
-/*
- * the keyring payload contains a list of the keys to which the keyring is
- * subscribed
- */
-struct keyring_list {
-	struct rcu_head	rcu;		/* RCU deletion hook */
-	unsigned short	maxkeys;	/* max keys this list can hold */
-	unsigned short	nkeys;		/* number of keys currently held */
-	unsigned short	delkey;		/* key to be unlinked by RCU */
-	struct key	*keys[0];
-};
-
-/*
- * check to see whether permission is granted to use a key in the desired way
- */
-extern int key_task_permission(const key_ref_t key_ref,
-			       struct task_struct *context,
-			       key_perm_t perm);
-
-static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
-{
-	return key_task_permission(key_ref, current, perm);
-}
-
-extern key_ref_t lookup_user_key(struct task_struct *context,
-				 key_serial_t id, int create, int partial,
-				 key_perm_t perm);
-
-extern long join_session_keyring(const char *name);
-
-extern struct key_type *key_type_lookup(const char *type);
-extern void key_type_put(struct key_type *ktype);
-
-#define key_negative_timeout	60	/* default timeout on a negative key's existence */
-
-
-#endif /* _LINUX_KEY_UI_H */
diff --git a/security/keys/internal.h b/security/keys/internal.h
index b39f5c2..a60c681 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -13,7 +13,6 @@
 #define _INTERNAL_H
 
 #include <linux/key-type.h>
-#include <linux/key-ui.h>
 
 static inline __attribute__((format(printf, 1, 2)))
 void no_printk(const char *fmt, ...)
@@ -82,6 +81,9 @@ extern struct mutex key_construction_mutex;
 extern wait_queue_head_t request_key_conswq;
 
 
+extern struct key_type *key_type_lookup(const char *type);
+extern void key_type_put(struct key_type *ktype);
+
 extern int __key_link(struct key *keyring, struct key *key);
 
 extern key_ref_t __keyring_search_one(key_ref_t keyring_ref,
@@ -118,6 +120,33 @@ extern struct key *request_key_and_link(struct key_type *type,
 					struct key *dest_keyring,
 					unsigned long flags);
 
+extern key_ref_t lookup_user_key(struct task_struct *context,
+				 key_serial_t id, int create, int partial,
+				 key_perm_t perm);
+
+extern long join_session_keyring(const char *name);
+
+/*
+ * check to see whether permission is granted to use a key in the desired way
+ */
+extern int key_task_permission(const key_ref_t key_ref,
+			       struct task_struct *context,
+			       key_perm_t perm);
+
+static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
+{
+	return key_task_permission(key_ref, current, perm);
+}
+
+/* required permissions */
+#define	KEY_VIEW	0x01	/* require permission to view attributes */
+#define	KEY_READ	0x02	/* require permission to read content */
+#define	KEY_WRITE	0x04	/* require permission to update / modify */
+#define	KEY_SEARCH	0x08	/* require permission to search (keyring) or find (key) */
+#define	KEY_LINK	0x10	/* require permission to link */
+#define	KEY_SETATTR	0x20	/* require permission to change attributes */
+#define	KEY_ALL		0x3f	/* all the above permissions */
+
 /*
  * request_key authorisation
  */
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index a9ab8af..fdf75f9 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -16,6 +16,7 @@
 #include <linux/security.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
+#include <keys/keyring-type.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index ba32ca6..b9e50a9 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -19,6 +19,8 @@
 #include <linux/slab.h>
 #include "internal.h"
 
+#define key_negative_timeout	60	/* default timeout on a negative key's existence */
+
 /*
  * wait_on_bit() sleep function for uninterruptible waiting
  */

