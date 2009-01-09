Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbZAIWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbZAIWwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZAIWwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:52:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:35728 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZAIWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:52:12 -0500
Date: Fri, 9 Jan 2009 16:52:08 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 1/4] keys: distinguish per-uid keys in different namespaces
Message-ID: <20090109225208.GA15252@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

per-uid keys were looked by uid only.  Use the user namespace
to distinguish the same uid in different namespaces.

This does not address key_permission.  So a task can for instance
try to join a keyring owned by the same uid in another namespace.
That will be handled by a separate patch.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/user.c                |    2 +-
 security/keys/internal.h     |    4 +++-
 security/keys/key.c          |   11 +++++++++--
 security/keys/keyctl.c       |    2 +-
 security/keys/process_keys.c |    2 ++
 security/keys/request_key.c  |    2 +-
 6 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 6608a3d..fe326a6 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -20,7 +20,7 @@
 
 struct user_namespace init_user_ns = {
 	.kref = {
-		.refcount	= ATOMIC_INIT(1),
+		.refcount	= ATOMIC_INIT(2),
 	},
 	.creator = &root_user,
 };
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 81932ab..9fb679c 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -53,6 +53,7 @@ struct key_user {
 	atomic_t		nkeys;		/* number of keys */
 	atomic_t		nikeys;		/* number of instantiated keys */
 	uid_t			uid;
+	struct user_namespace	*user_ns;
 	int			qnkeys;		/* number of keys allocated to this user */
 	int			qnbytes;	/* number of bytes allocated to this user */
 };
@@ -61,7 +62,8 @@ extern struct rb_root	key_user_tree;
 extern spinlock_t	key_user_lock;
 extern struct key_user	root_key_user;
 
-extern struct key_user *key_user_lookup(uid_t uid);
+extern struct key_user *key_user_lookup(uid_t uid,
+					struct user_namespace *user_ns);
 extern void key_user_put(struct key_user *user);
 
 /*
diff --git a/security/keys/key.c b/security/keys/key.c
index f76c8a5..4a1297d 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -18,6 +18,7 @@
 #include <linux/workqueue.h>
 #include <linux/random.h>
 #include <linux/err.h>
+#include <linux/user_namespace.h>
 #include "internal.h"
 
 static struct kmem_cache	*key_jar;
@@ -60,7 +61,7 @@ void __key_check(const struct key *key)
  * get the key quota record for a user, allocating a new record if one doesn't
  * already exist
  */
-struct key_user *key_user_lookup(uid_t uid)
+struct key_user *key_user_lookup(uid_t uid, struct user_namespace *user_ns)
 {
 	struct key_user *candidate = NULL, *user;
 	struct rb_node *parent = NULL;
@@ -79,6 +80,10 @@ struct key_user *key_user_lookup(uid_t uid)
 			p = &(*p)->rb_left;
 		else if (uid > user->uid)
 			p = &(*p)->rb_right;
+		else if (user_ns < user->user_ns)
+			p = &(*p)->rb_left;
+		else if (user_ns > user->user_ns)
+			p = &(*p)->rb_right;
 		else
 			goto found;
 	}
@@ -106,6 +111,7 @@ struct key_user *key_user_lookup(uid_t uid)
 	atomic_set(&candidate->nkeys, 0);
 	atomic_set(&candidate->nikeys, 0);
 	candidate->uid = uid;
+	candidate->user_ns = get_user_ns(user_ns);
 	candidate->qnkeys = 0;
 	candidate->qnbytes = 0;
 	spin_lock_init(&candidate->lock);
@@ -136,6 +142,7 @@ void key_user_put(struct key_user *user)
 	if (atomic_dec_and_lock(&user->usage, &key_user_lock)) {
 		rb_erase(&user->node, &key_user_tree);
 		spin_unlock(&key_user_lock);
+		put_user_ns(user->user_ns);
 
 		kfree(user);
 	}
@@ -234,7 +241,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	quotalen = desclen + type->def_datalen;
 
 	/* get hold of the key tracking for this user */
-	user = key_user_lookup(uid);
+	user = key_user_lookup(uid, cred->user->user_ns);
 	if (!user)
 		goto no_memory_1;
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 7c72baa..db4c029 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -725,7 +725,7 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 	/* change the UID */
 	if (uid != (uid_t) -1 && uid != key->uid) {
 		ret = -ENOMEM;
-		newowner = key_user_lookup(uid);
+		newowner = key_user_lookup(uid, current_user_ns());
 		if (!newowner)
 			goto error_put;
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 2f5d89e..276d278 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -34,6 +35,7 @@ struct key_user root_key_user = {
 	.nkeys		= ATOMIC_INIT(2),
 	.nikeys		= ATOMIC_INIT(2),
 	.uid		= 0,
+	.user_ns	= &init_user_ns,
 };
 
 /*****************************************************************************/
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 0e04f72..22a3158 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -365,7 +365,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 
 	kenter("");
 
-	user = key_user_lookup(current_fsuid());
+	user = key_user_lookup(current_fsuid(), current_user_ns());
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.5.4.3

