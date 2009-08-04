Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbZHDO5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbZHDO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932733AbZHDO5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:57:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52386 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571AbZHDO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:57:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/6] KEYS: Add garbage collection for dead,
	revoked and expired keys.
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 04 Aug 2009 15:55:46 +0100
Message-ID: <20090804145546.17676.98776.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
References: <20090804145530.17676.24656.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add garbage collection for dead, revoked and expired keys.  This involved
erasing all links to such keys from keyrings that point to them.  At that
point, the key will be deleted in the normal manner.

Keyrings from which garbage collection occurs are shrunk and their quota
consumption reduced as appropriate.

Dead keys (for which the key type has been removed) will be garbage collected
immediately.

Revoked and expired keys will hang around for a number of seconds, as set in
/proc/sys/kernel/keys/gc_delay before being automatically removed.  The default
is 5 minutes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt   |   19 +++++++++++
 include/linux/key.h      |    5 ++-
 security/keys/Makefile   |    1 +
 security/keys/internal.h |    4 ++
 security/keys/key.c      |   14 ++++++++
 security/keys/keyctl.c   |    1 +
 security/keys/keyring.c  |   78 ++++++++++++++++++++++++++++++++++++++++++++++
 security/keys/sysctl.c   |   28 ++++++++++++++---
 8 files changed, 144 insertions(+), 6 deletions(-)


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index b56aacc..203487e 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -26,7 +26,7 @@ This document has the following sections:
 	- Notes on accessing payload contents
 	- Defining a key type
 	- Request-key callback service
-	- Key access filesystem
+	- Garbage collection
 
 
 ============
@@ -113,6 +113,9 @@ Each key has a number of attributes:
 
      (*) Dead. The key's type was unregistered, and so the key is now useless.
 
+Keys in the last three states are subject to garbage collection.  See the
+section on "Garbage collection".
+
 
 ====================
 KEY SERVICE OVERVIEW
@@ -1231,3 +1234,17 @@ by executing:
 
 In this case, the program isn't required to actually attach the key to a ring;
 the rings are provided for reference.
+
+
+==================
+GARBAGE COLLECTION
+==================
+
+Dead keys (for which the type has been removed) will be automatically unlinked
+from those keyrings that point to them and deleted as soon as possible by a
+background garbage collector.
+
+Similarly, revoked and expired keys will be garbage collected, but only after a
+certain amount of time has passed.  This time is set as a number of seconds in:
+
+	/proc/sys/kernel/keys/gc_delay
diff --git a/include/linux/key.h b/include/linux/key.h
index e544f46..33e0165 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -129,7 +129,10 @@ struct key {
 	struct rw_semaphore	sem;		/* change vs change sem */
 	struct key_user		*user;		/* owner of this key */
 	void			*security;	/* security data for this key */
-	time_t			expiry;		/* time at which key expires (or 0) */
+	union {
+		time_t		expiry;		/* time at which key expires (or 0) */
+		time_t		revoked_at;	/* time at which key was revoked */
+	};
 	uid_t			uid;
 	gid_t			gid;
 	key_perm_t		perm;		/* access permissions */
diff --git a/security/keys/Makefile b/security/keys/Makefile
index 747a464..74d5447 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-y := \
+	gc.o \
 	key.o \
 	keyring.o \
 	keyctl.o \
diff --git a/security/keys/internal.h b/security/keys/internal.h
index a7252e7..fb83051 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -132,6 +132,10 @@ extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
 
 extern long join_session_keyring(const char *name);
 
+extern unsigned key_gc_delay;
+extern void keyring_gc(struct key *keyring, time_t limit);
+extern void key_schedule_gc(time_t expiry_at);
+
 /*
  * check to see whether permission is granted to use a key in the desired way
  */
diff --git a/security/keys/key.c b/security/keys/key.c
index bd9d267..08531ad 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -500,6 +500,7 @@ int key_negate_and_link(struct key *key,
 		set_bit(KEY_FLAG_INSTANTIATED, &key->flags);
 		now = current_kernel_time();
 		key->expiry = now.tv_sec + timeout;
+		key_schedule_gc(key->expiry);
 
 		if (test_and_clear_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags))
 			awaken = 1;
@@ -888,6 +889,9 @@ EXPORT_SYMBOL(key_update);
  */
 void key_revoke(struct key *key)
 {
+	struct timespec now;
+	time_t time;
+
 	key_check(key);
 
 	/* make sure no one's trying to change or use the key when we mark it
@@ -900,6 +904,14 @@ void key_revoke(struct key *key)
 	    key->type->revoke)
 		key->type->revoke(key);
 
+	/* set the death time to no more than the expiry time */
+	now = current_kernel_time();
+	time = now.tv_sec;
+	if (key->revoked_at == 0 || key->revoked_at > time) {
+		key->revoked_at = time;
+		key_schedule_gc(key->revoked_at);
+	}
+
 	up_write(&key->sem);
 
 } /* end key_revoke() */
@@ -984,6 +996,8 @@ void unregister_key_type(struct key_type *ktype)
 	spin_unlock(&key_serial_lock);
 	up_write(&key_types_sem);
 
+	key_schedule_gc(0);
+
 } /* end unregister_key_type() */
 
 EXPORT_SYMBOL(unregister_key_type);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 1160b64..736d780 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1115,6 +1115,7 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 	}
 
 	key->expiry = expiry;
+	key_schedule_gc(key->expiry);
 
 	up_write(&key->sem);
 	key_put(key);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 3dba81c..acbe0d5 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1000,3 +1000,81 @@ static void keyring_revoke(struct key *keyring)
 	}
 
 } /* end keyring_revoke() */
+
+/*
+ * Collect garbage from the contents of a keyring
+ */
+void keyring_gc(struct key *keyring, time_t limit)
+{
+	struct keyring_list *klist, *new;
+	struct key *key;
+	int loop, keep, max;
+
+	kenter("%x", key_serial(keyring));
+
+	down_write(&keyring->sem);
+
+	klist = keyring->payload.subscriptions;
+	if (!klist)
+		goto just_return;
+
+	/* work out how many subscriptions we're keeping */
+	keep = 0;
+	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
+		key = klist->keys[loop];
+		if (!test_bit(KEY_FLAG_DEAD, &key->flags) &&
+		    !(key->expiry > 0 && key->expiry <= limit))
+			keep++;
+	}
+
+	if (keep == klist->nkeys)
+		goto just_return;
+
+	/* allocate a new keyring payload */
+	max = roundup(keep, 4);
+	new = kmalloc(sizeof(struct keyring_list) + max * sizeof(struct key *),
+		      GFP_KERNEL);
+	if (!new)
+		goto just_return;
+	new->maxkeys = max;
+	new->nkeys = 0;
+	new->delkey = 0;
+
+	/* install the live keys */
+	keep = 0;
+	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
+		key = klist->keys[loop];
+		if (!test_bit(KEY_FLAG_DEAD, &key->flags) &&
+		    !(key->expiry > 0 && key->expiry <= limit)) {
+			if (keep >= max)
+				goto discard_new;
+			new->keys[keep++] = key_get(key);
+		}
+	}
+	new->nkeys = keep;
+
+	/* adjust the quota */
+	key_payload_reserve(keyring,
+			    sizeof(struct keyring_list) +
+			    KEYQUOTA_LINK_BYTES * keep);
+
+	if (keep == 0) {
+		rcu_assign_pointer(keyring->payload.subscriptions, NULL);
+		kfree(new);
+	} else {
+		rcu_assign_pointer(keyring->payload.subscriptions, new);
+	}
+
+	up_write(&keyring->sem);
+
+	call_rcu(&klist->rcu, keyring_clear_rcu_disposal);
+	kleave(" [yes]");
+	return;
+
+discard_new:
+	new->nkeys = keep;
+	keyring_clear_rcu_disposal(&new->rcu);
+just_return:
+	up_write(&keyring->sem);
+	kleave(" [no]");
+}
diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index b611d49..5e05dc0 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -13,6 +13,8 @@
 #include <linux/sysctl.h>
 #include "internal.h"
 
+static const int zero, one = 1, max = INT_MAX;
+
 ctl_table key_sysctls[] = {
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -20,7 +22,9 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_maxkeys,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = &proc_dointvec_minmax,
+		.extra1 = (void *) &one,
+		.extra2 = (void *) &max,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -28,7 +32,9 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_maxbytes,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = &proc_dointvec_minmax,
+		.extra1 = (void *) &one,
+		.extra2 = (void *) &max,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -36,7 +42,9 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_root_maxkeys,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = &proc_dointvec_minmax,
+		.extra1 = (void *) &one,
+		.extra2 = (void *) &max,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -44,7 +52,19 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_root_maxbytes,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = &proc_dointvec_minmax,
+		.extra1 = (void *) &one,
+		.extra2 = (void *) &max,
+	},
+	{
+		.ctl_name = CTL_UNNUMBERED,
+		.procname = "gc_delay",
+		.data = &key_gc_delay,
+		.maxlen = sizeof(unsigned),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec_minmax,
+		.extra1 = (void *) &zero,
+		.extra2 = (void *) &max,
 	},
 	{ .ctl_name = 0 }
 };

