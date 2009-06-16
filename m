Return-Path: <linux-kernel-owner+w=401wt.eu-S1764010AbZFPUpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764010AbZFPUpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbZFPUlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:41:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35501 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763399AbZFPUlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:41:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/17] KEYS: Export lookup_user_key() and the key permission
	request flags
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:47 +0100
Message-ID: <20090616203947.4526.55723.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export lookup_user_key() and the key permission request flags so that the token
handling pioctls of kAFS can make use of them.

This requires that the key permission request flags also be renamed from
KEY_xxx to WANT_KEY_xxx to avoid collision with keyboard-related symbols.

This allows AFS's VIOCSETTOK/PSetTokens and similar to access and manipulate
the calling process's session keyring.

The following text is added to Documentation/keys.txt:

(*) For code that manipulates keys and keyrings on behalf of userspace (such
    as keyctl functions), the following function is available:

	key_ref_t lookup_user_key(key_serial_t id,
				  int create,
				  int partial,
				  key_perm_t perm)

    This looks up a key or keyring by serial ID, or may take a KEY_SPEC_
    constant instead as the ID [see above].  It may be asked to create special
    keyrings if they're asked for, but don't already exist (such as the
    per-thread keyring), and may be asked to look up partially created keys for
    the purpose of instantiation.

    The key requested must have the specified permission available, where perm
    is one of:

	WANT_KEY_VIEW	 - Require permission to view attributes
	WANT_KEY_READ	 - Require permission to read content
	WANT_KEY_WRITE	 - Require permission to update / modify
	WANT_KEY_SEARCH	 - Require permission to search (keyring) or find (key)
	WANT_KEY_LINK	 - Require permission to link
	WANT_KEY_SETATTR - Require permission to change attributes


Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt       |   25 +++++++++++++++++++++++++
 include/linux/key.h          |   12 ++++++++++++
 security/keys/internal.h     |   12 ------------
 security/keys/key.c          |    6 +++---
 security/keys/keyctl.c       |   38 +++++++++++++++++++-------------------
 security/keys/keyring.c      |    8 ++++----
 security/keys/permission.c   |    2 +-
 security/keys/proc.c         |    2 +-
 security/keys/process_keys.c |    2 ++
 9 files changed, 67 insertions(+), 40 deletions(-)


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index b56aacc..35618d1 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -877,6 +877,31 @@ payload contents" for more information.
     case error ERESTARTSYS will be returned.
 
 
+(*) For code that manipulates keys and keyrings on behalf of userspace (such
+    as keyctl functions), the following function is available:
+
+	key_ref_t lookup_user_key(key_serial_t id,
+				  int create,
+				  int partial,
+				  key_perm_t perm)
+
+    This looks up a key or keyring by serial ID, or may take a KEY_SPEC_
+    constant instead as the ID [see above].  It may be asked to create special
+    keyrings if they're asked for, but don't already exist (such as the
+    per-thread keyring), and may be asked to look up partially created keys
+    for the purpose of instantiation.
+
+    The key requested must have the specified permission available, where perm
+    is one of:
+
+	WANT_KEY_VIEW	 - Require permission to view attributes
+	WANT_KEY_READ	 - Require permission to read content
+	WANT_KEY_WRITE	 - Require permission to update / modify
+	WANT_KEY_SEARCH	 - Require permission to search (keyring) or find (key)
+	WANT_KEY_LINK	 - Require permission to link
+	WANT_KEY_SETATTR - Require permission to change attributes
+
+
 (*) When it is no longer required, the key should be released using:
 
 	void key_put(struct key *key);
diff --git a/include/linux/key.h b/include/linux/key.h
index e544f46..4d8cc1e 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -71,6 +71,15 @@ struct key;
 
 #define KEY_PERM_UNDEF	0xffffffff
 
+/* required permissions */
+#define	WANT_KEY_VIEW	0x01	/* require permission to view attributes */
+#define	WANT_KEY_READ	0x02	/* require permission to read content */
+#define	WANT_KEY_WRITE	0x04	/* require permission to update / modify */
+#define	WANT_KEY_SEARCH	0x08	/* require permission to search (keyring) or find (key) */
+#define	WANT_KEY_LINK	0x10	/* require permission to link */
+#define	WANT_KEY_SETATTR 0x20	/* require permission to change attributes */
+#define	WANT_KEY_ALL	0x3f	/* all the above permissions */
+
 struct seq_file;
 struct user_struct;
 struct signal_struct;
@@ -275,6 +284,9 @@ static inline key_serial_t key_serial(struct key *key)
 extern ctl_table key_sysctls[];
 #endif
 
+extern key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
+				 key_perm_t perm);
+
 /*
  * the userspace interface
  */
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 9fb679c..7baf655 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -124,9 +124,6 @@ extern struct key *request_key_and_link(struct key_type *type,
 					struct key *dest_keyring,
 					unsigned long flags);
 
-extern key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
-				 key_perm_t perm);
-
 extern long join_session_keyring(const char *name);
 
 /*
@@ -141,15 +138,6 @@ static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
 	return key_task_permission(key_ref, current_cred(), perm);
 }
 
-/* required permissions */
-#define	KEY_VIEW	0x01	/* require permission to view attributes */
-#define	KEY_READ	0x02	/* require permission to read content */
-#define	KEY_WRITE	0x04	/* require permission to update / modify */
-#define	KEY_SEARCH	0x08	/* require permission to search (keyring) or find (key) */
-#define	KEY_LINK	0x10	/* require permission to link */
-#define	KEY_SETATTR	0x20	/* require permission to change attributes */
-#define	KEY_ALL		0x3f	/* all the above permissions */
-
 /*
  * request_key authorisation
  */
diff --git a/security/keys/key.c b/security/keys/key.c
index 4a1297d..68d7d6b 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -708,7 +708,7 @@ static inline key_ref_t __key_update(key_ref_t key_ref,
 	int ret;
 
 	/* need write permission on the key to update it */
-	ret = key_permission(key_ref, KEY_WRITE);
+	ret = key_permission(key_ref, WANT_KEY_WRITE);
 	if (ret < 0)
 		goto error;
 
@@ -780,7 +780,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 
 	/* if we're going to allocate a new key, we're going to have
 	 * to modify the keyring */
-	ret = key_permission(keyring_ref, KEY_WRITE);
+	ret = key_permission(keyring_ref, WANT_KEY_WRITE);
 	if (ret < 0) {
 		key_ref = ERR_PTR(ret);
 		goto error_3;
@@ -860,7 +860,7 @@ int key_update(key_ref_t key_ref, const void *payload, size_t plen)
 	key_check(key);
 
 	/* the key must be writable */
-	ret = key_permission(key_ref, KEY_WRITE);
+	ret = key_permission(key_ref, WANT_KEY_WRITE);
 	if (ret < 0)
 		goto error;
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 7f09fb8..ec0cd69 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -103,7 +103,7 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 	}
 
 	/* find the target keyring (which must be writable) */
-	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 1, 0, WANT_KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error3;
@@ -185,7 +185,7 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
 	/* get the destination keyring if specified */
 	dest_ref = NULL;
 	if (destringid) {
-		dest_ref = lookup_user_key(destringid, 1, 0, KEY_WRITE);
+		dest_ref = lookup_user_key(destringid, 1, 0, WANT_KEY_WRITE);
 		if (IS_ERR(dest_ref)) {
 			ret = PTR_ERR(dest_ref);
 			goto error3;
@@ -235,7 +235,7 @@ long keyctl_get_keyring_ID(key_serial_t id, int create)
 	key_ref_t key_ref;
 	long ret;
 
-	key_ref = lookup_user_key(id, create, 0, KEY_SEARCH);
+	key_ref = lookup_user_key(id, create, 0, WANT_KEY_SEARCH);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -309,7 +309,7 @@ long keyctl_update_key(key_serial_t id,
 	}
 
 	/* find the target key (which must be writable) */
-	key_ref = lookup_user_key(id, 0, 0, KEY_WRITE);
+	key_ref = lookup_user_key(id, 0, 0, WANT_KEY_WRITE);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error2;
@@ -337,7 +337,7 @@ long keyctl_revoke_key(key_serial_t id)
 	key_ref_t key_ref;
 	long ret;
 
-	key_ref = lookup_user_key(id, 0, 0, KEY_WRITE);
+	key_ref = lookup_user_key(id, 0, 0, WANT_KEY_WRITE);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -363,7 +363,7 @@ long keyctl_keyring_clear(key_serial_t ringid)
 	key_ref_t keyring_ref;
 	long ret;
 
-	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 1, 0, WANT_KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error;
@@ -389,13 +389,13 @@ long keyctl_keyring_link(key_serial_t id, key_serial_t ringid)
 	key_ref_t keyring_ref, key_ref;
 	long ret;
 
-	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 1, 0, WANT_KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error;
 	}
 
-	key_ref = lookup_user_key(id, 1, 0, KEY_LINK);
+	key_ref = lookup_user_key(id, 1, 0, WANT_KEY_LINK);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error2;
@@ -423,7 +423,7 @@ long keyctl_keyring_unlink(key_serial_t id, key_serial_t ringid)
 	key_ref_t keyring_ref, key_ref;
 	long ret;
 
-	keyring_ref = lookup_user_key(ringid, 0, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 0, 0, WANT_KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error;
@@ -465,7 +465,7 @@ long keyctl_describe_key(key_serial_t keyid,
 	char *tmpbuf;
 	long ret;
 
-	key_ref = lookup_user_key(keyid, 0, 1, KEY_VIEW);
+	key_ref = lookup_user_key(keyid, 0, 1, WANT_KEY_VIEW);
 	if (IS_ERR(key_ref)) {
 		/* viewing a key under construction is permitted if we have the
 		 * authorisation token handy */
@@ -558,7 +558,7 @@ long keyctl_keyring_search(key_serial_t ringid,
 	}
 
 	/* get the keyring at which to begin the search */
-	keyring_ref = lookup_user_key(ringid, 0, 0, KEY_SEARCH);
+	keyring_ref = lookup_user_key(ringid, 0, 0, WANT_KEY_SEARCH);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error2;
@@ -567,7 +567,7 @@ long keyctl_keyring_search(key_serial_t ringid,
 	/* get the destination keyring if specified */
 	dest_ref = NULL;
 	if (destringid) {
-		dest_ref = lookup_user_key(destringid, 1, 0, KEY_WRITE);
+		dest_ref = lookup_user_key(destringid, 1, 0, WANT_KEY_WRITE);
 		if (IS_ERR(dest_ref)) {
 			ret = PTR_ERR(dest_ref);
 			goto error3;
@@ -594,7 +594,7 @@ long keyctl_keyring_search(key_serial_t ringid,
 
 	/* link the resulting key to the destination keyring if we can */
 	if (dest_ref) {
-		ret = key_permission(key_ref, KEY_LINK);
+		ret = key_permission(key_ref, WANT_KEY_LINK);
 		if (ret < 0)
 			goto error6;
 
@@ -646,7 +646,7 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 	key = key_ref_to_ptr(key_ref);
 
 	/* see if we can read it directly */
-	ret = key_permission(key_ref, KEY_READ);
+	ret = key_permission(key_ref, WANT_KEY_READ);
 	if (ret == 0)
 		goto can_read_key;
 	if (ret != -EACCES)
@@ -700,7 +700,7 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 	if (uid == (uid_t) -1 && gid == (gid_t) -1)
 		goto error;
 
-	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
+	key_ref = lookup_user_key(id, 1, 1, WANT_KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -805,7 +805,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	if (perm & ~(KEY_POS_ALL | KEY_USR_ALL | KEY_GRP_ALL | KEY_OTH_ALL))
 		goto error;
 
-	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
+	key_ref = lookup_user_key(id, 1, 1, WANT_KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -847,7 +847,7 @@ static long get_instantiation_keyring(key_serial_t ringid,
 
 	/* if a specific keyring is nominated by ID, then use that */
 	if (ringid > 0) {
-		dkref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
+		dkref = lookup_user_key(ringid, 1, 0, WANT_KEY_WRITE);
 		if (IS_ERR(dkref))
 			return PTR_ERR(dkref);
 		*_dest_keyring = key_ref_to_ptr(dkref);
@@ -1083,7 +1083,7 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 	time_t expiry;
 	long ret;
 
-	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
+	key_ref = lookup_user_key(id, 1, 1, WANT_KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -1170,7 +1170,7 @@ long keyctl_get_security(key_serial_t keyid,
 	char *context;
 	long ret;
 
-	key_ref = lookup_user_key(keyid, 0, 1, KEY_VIEW);
+	key_ref = lookup_user_key(keyid, 0, 1, WANT_KEY_VIEW);
 	if (IS_ERR(key_ref)) {
 		if (PTR_ERR(key_ref) != -EACCES)
 			return PTR_ERR(key_ref);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 3dba81c..97529ab 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -304,7 +304,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	key_check(keyring);
 
 	/* top keyring must have search permission to begin the search */
-        err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
+        err = key_task_permission(keyring_ref, cred, WANT_KEY_SEARCH);
 	if (err < 0) {
 		key_ref = ERR_PTR(err);
 		goto error;
@@ -377,7 +377,7 @@ descend:
 
 		/* key must have search permissions */
 		if (key_task_permission(make_key_ref(key, possessed),
-					cred, KEY_SEARCH) < 0)
+					cred, WANT_KEY_SEARCH) < 0)
 			continue;
 
 		/* we set a different error code if we pass a negative key */
@@ -404,7 +404,7 @@ ascend:
 			continue;
 
 		if (key_task_permission(make_key_ref(key, possessed),
-					cred, KEY_SEARCH) < 0)
+					cred, WANT_KEY_SEARCH) < 0)
 			continue;
 
 		/* stack the current position */
@@ -550,7 +550,7 @@ struct key *find_keyring_by_name(const char *name, bool skip_perm_check)
 
 			if (!skip_perm_check &&
 			    key_permission(make_key_ref(keyring, 0),
-					   KEY_SEARCH) < 0)
+					   WANT_KEY_SEARCH) < 0)
 				continue;
 
 			/* we've got a match */
diff --git a/security/keys/permission.c b/security/keys/permission.c
index 0ed802c..a3a2bbe 100644
--- a/security/keys/permission.c
+++ b/security/keys/permission.c
@@ -72,7 +72,7 @@ use_these_perms:
 	if (is_key_possessed(key_ref))
 		kperm |= key->perm >> 24;
 
-	kperm = kperm & perm & KEY_ALL;
+	kperm = kperm & perm & WANT_KEY_ALL;
 
 	if (kperm != perm)
 		return -EACCES;
diff --git a/security/keys/proc.c b/security/keys/proc.c
index 6132629..cfab6f7 100644
--- a/security/keys/proc.c
+++ b/security/keys/proc.c
@@ -182,7 +182,7 @@ static int proc_keys_show(struct seq_file *m, void *v)
 	 *   access to __current_cred() safe
 	 */
 	rc = key_task_permission(make_key_ref(key, 0), current_cred(),
-				 KEY_VIEW);
+				 WANT_KEY_VIEW);
 	if (rc < 0)
 		return 0;
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 276d278..5b3b7a0 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -685,6 +685,8 @@ reget_creds:
 
 } /* end lookup_user_key() */
 
+EXPORT_SYMBOL(lookup_user_key);
+
 /*****************************************************************************/
 /*
  * join the named keyring as the session keyring if possible, or attempt to

