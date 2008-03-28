Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYC1Onc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYC1Onc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYC1Ofz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:35:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbYC1Oey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:34:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/45] KEYS: Make the keyring quotas controllable through
	/proc/sys [ver #35]
To: torvalds@osdl.org, akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       chuck.lever@oracle.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 28 Mar 2008 14:30:41 +0000
Message-ID: <20080328143041.3483.46359.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
References: <20080328143010.3483.99079.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the keyring quotas controllable through /proc/sys files:

 (*) /proc/sys/kernel/keys/root_maxkeys
     /proc/sys/kernel/keys/root_maxbytes

     Maximum number of keys that root may have and the maximum total number of
     bytes of data that root may have stored in those keys.

 (*) /proc/sys/kernel/keys/maxkeys
     /proc/sys/kernel/keys/maxbytes

     Maximum number of keys that each non-root user may have and the maximum
     total number of bytes of data that each of those users may have stored in
     their keys.

Also increase the quotas as a number of people have been complaining that it's
not big enough.  I'm not sure that it's big enough now either, but on the
other hand, it can now be set in /etc/sysctl.conf.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt   |   24 +++++++++++++++++++++-
 include/linux/key.h      |    5 +++++
 kernel/sysctl.c          |    9 ++++++++
 security/keys/Makefile   |    1 +
 security/keys/internal.h |   14 +++++++++----
 security/keys/key.c      |   23 +++++++++++++++++----
 security/keys/keyctl.c   |   12 ++++++++---
 security/keys/proc.c     |    9 ++++++--
 security/keys/sysctl.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 131 insertions(+), 16 deletions(-)
 create mode 100644 security/keys/sysctl.c


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index b82d38d..38a90d9 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -170,7 +170,8 @@ The key service provides a number of features besides keys:
      amount of description and payload space that can be consumed.
 
      The user can view information on this and other statistics through procfs
-     files.
+     files.  The root user may also alter the quota limits through sysctl files
+     (see the section "New procfs files").
 
      Process-specific and thread-specific keyrings are not counted towards a
      user's quota.
@@ -329,6 +330,27 @@ about the status of the key service:
 	<bytes>/<max>		Key size quota
 
 
+Four new sysctl files have been added also for the purpose of controlling the
+quota limits on keys:
+
+ (*) /proc/sys/kernel/keys/root_maxkeys
+     /proc/sys/kernel/keys/root_maxbytes
+
+     These files hold the maximum number of keys that root may have and the
+     maximum total number of bytes of data that root may have stored in those
+     keys.
+
+ (*) /proc/sys/kernel/keys/maxkeys
+     /proc/sys/kernel/keys/maxbytes
+
+     These files hold the maximum number of keys that each non-root user may
+     have and the maximum total number of bytes of data that each of those
+     users may have stored in their keys.
+
+Root may alter these by writing each new limit as a decimal number string to
+the appropriate file.
+
+
 ===============================
 USERSPACE SYSTEM CALL INTERFACE
 ===============================
diff --git a/include/linux/key.h b/include/linux/key.h
index 2effd03..ad02d9c 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -19,6 +19,7 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/rcupdate.h>
+#include <linux/sysctl.h>
 #include <asm/atomic.h>
 
 #ifdef __KERNEL__
@@ -265,6 +266,10 @@ extern struct key *key_lookup(key_serial_t id);
 
 #define key_serial(key) ((key) ? (key)->serial : 0)
 
+#ifdef CONFIG_SYSCTL
+extern ctl_table key_sysctls[];
+#endif
+
 /*
  * the userspace interface
  */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2a2d68..1e89295 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -45,6 +45,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/key.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -820,6 +821,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_KEYS
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "keys",
+		.mode		= 0555,
+		.child		= key_sysctls,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 5145adf..747a464 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -14,3 +14,4 @@ obj-y := \
 
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
+obj-$(CONFIG_SYSCTL) += sysctl.o
diff --git a/security/keys/internal.h b/security/keys/internal.h
index b84f04a..e385066 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -57,10 +57,6 @@ struct key_user {
 	int			qnbytes;	/* number of bytes allocated to this user */
 };
 
-#define KEYQUOTA_MAX_KEYS	100
-#define KEYQUOTA_MAX_BYTES	10000
-#define KEYQUOTA_LINK_BYTES	4		/* a link in a keyring is worth 4 bytes */
-
 extern struct rb_root	key_user_tree;
 extern spinlock_t	key_user_lock;
 extern struct key_user	root_key_user;
@@ -68,6 +64,16 @@ extern struct key_user	root_key_user;
 extern struct key_user *key_user_lookup(uid_t uid);
 extern void key_user_put(struct key_user *user);
 
+/*
+ * key quota limits
+ * - root has its own separate limits to everyone else
+ */
+extern unsigned key_quota_root_maxkeys;
+extern unsigned key_quota_root_maxbytes;
+extern unsigned key_quota_maxkeys;
+extern unsigned key_quota_maxbytes;
+
+#define KEYQUOTA_LINK_BYTES	4		/* a link in a keyring is worth 4 bytes */
 
 
 extern struct rb_root key_serial_tree;
diff --git a/security/keys/key.c b/security/keys/key.c
index 46f125a..14948cf 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -27,6 +27,11 @@ DEFINE_SPINLOCK(key_serial_lock);
 struct rb_root	key_user_tree; /* tree of quota records indexed by UID */
 DEFINE_SPINLOCK(key_user_lock);
 
+unsigned int key_quota_root_maxkeys = 200;	/* root's key count quota */
+unsigned int key_quota_root_maxbytes = 20000;	/* root's key space quota */
+unsigned int key_quota_maxkeys = 200;		/* general key count quota */
+unsigned int key_quota_maxbytes = 20000;	/* general key space quota */
+
 static LIST_HEAD(key_types_list);
 static DECLARE_RWSEM(key_types_sem);
 
@@ -236,11 +241,16 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	/* check that the user's quota permits allocation of another key and
 	 * its description */
 	if (!(flags & KEY_ALLOC_NOT_IN_QUOTA)) {
+		unsigned maxkeys = (uid == 0) ?
+			key_quota_root_maxkeys : key_quota_maxkeys;
+		unsigned maxbytes = (uid == 0) ?
+			key_quota_root_maxbytes : key_quota_maxbytes;
+
 		spin_lock(&user->lock);
 		if (!(flags & KEY_ALLOC_QUOTA_OVERRUN)) {
-			if (user->qnkeys + 1 >= KEYQUOTA_MAX_KEYS ||
-			    user->qnbytes + quotalen >= KEYQUOTA_MAX_BYTES
-			    )
+			if (user->qnkeys + 1 >= maxkeys ||
+			    user->qnbytes + quotalen >= maxbytes ||
+			    user->qnbytes + quotalen < user->qnbytes)
 				goto no_quota;
 		}
 
@@ -345,11 +355,14 @@ int key_payload_reserve(struct key *key, size_t datalen)
 
 	/* contemplate the quota adjustment */
 	if (delta != 0 && test_bit(KEY_FLAG_IN_QUOTA, &key->flags)) {
+		unsigned maxbytes = (key->user->uid == 0) ?
+			key_quota_root_maxbytes : key_quota_maxbytes;
+
 		spin_lock(&key->user->lock);
 
 		if (delta > 0 &&
-		    key->user->qnbytes + delta > KEYQUOTA_MAX_BYTES
-		    ) {
+		    (key->user->qnbytes + delta >= maxbytes ||
+		     key->user->qnbytes + delta < key->user->qnbytes)) {
 			ret = -EDQUOT;
 		}
 		else {
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 5f0d85b..c32f5c6 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -730,10 +730,16 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 
 		/* transfer the quota burden to the new user */
 		if (test_bit(KEY_FLAG_IN_QUOTA, &key->flags)) {
+			unsigned maxkeys = (uid == 0) ?
+				key_quota_root_maxkeys : key_quota_maxkeys;
+			unsigned maxbytes = (uid == 0) ?
+				key_quota_root_maxbytes : key_quota_maxbytes;
+
 			spin_lock(&newowner->lock);
-			if (newowner->qnkeys + 1 >= KEYQUOTA_MAX_KEYS ||
-			    newowner->qnbytes + key->quotalen >=
-			    KEYQUOTA_MAX_BYTES)
+			if (newowner->qnkeys + 1 >= maxkeys ||
+			    newowner->qnbytes + key->quotalen >= maxbytes ||
+			    newowner->qnbytes + key->quotalen <
+			    newowner->qnbytes)
 				goto quota_overrun;
 
 			newowner->qnkeys++;
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 6941260..b49ad38 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -246,6 +246,10 @@ static int proc_key_users_show(struct seq_file *m, void *v)
 {
 	struct rb_node *_p = v;
 	struct key_user *user = rb_entry(_p, struct key_user, node);
+	unsigned maxkeys = (user->uid == 0) ?
+		key_quota_root_maxkeys : key_quota_maxkeys;
+	unsigned maxbytes = (user->uid == 0) ?
+		key_quota_root_maxbytes : key_quota_maxbytes;
 
 	seq_printf(m, "%5u: %5d %d/%d %d/%d %d/%d\n",
 		   user->uid,
@@ -253,10 +257,9 @@ static int proc_key_users_show(struct seq_file *m, void *v)
 		   atomic_read(&user->nkeys),
 		   atomic_read(&user->nikeys),
 		   user->qnkeys,
-		   KEYQUOTA_MAX_KEYS,
+		   maxkeys,
 		   user->qnbytes,
-		   KEYQUOTA_MAX_BYTES
-		   );
+		   maxbytes);
 
 	return 0;
 
diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
new file mode 100644
index 0000000..b611d49
--- /dev/null
+++ b/security/keys/sysctl.c
@@ -0,0 +1,50 @@
+/* Key management controls
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/key.h>
+#include <linux/sysctl.h>
+#include "internal.h"
+
+ctl_table key_sysctls[] = {
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "maxkeys",
+		.data = &key_quota_maxkeys,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "maxbytes",
+		.data = &key_quota_maxbytes,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "root_maxkeys",
+		.data = &key_quota_root_maxkeys,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "root_maxbytes",
+		.data = &key_quota_root_maxbytes,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};

