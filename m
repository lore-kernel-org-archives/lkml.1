Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbYHFQI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbYHFQI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYHFQIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:08:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbYHFQIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:08:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/24] KEYS: Alter use of key instantiation link-to-keyring
	argument [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:37:29 +0100
Message-ID: <20080806153729.14351.48141.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alter the use of the key instantiation and negation functions' link-to-keyring
arguments.  Currently this specifies a keyring in the target process to link
the key into, creating the keyring if it doesn't exist.  This, however, can be
a problem for copy-on-write credentials as it means that the instantiating
process can alter the credentials of the requesting process.

This patch alters the behaviour such that:

 (1) If keyctl_instantiate_key() or keyctl_negate_key() are given a specific
     keyring by ID (ringid >= 0), then that keyring will be used.

 (2) If keyctl_instantiate_key() or keyctl_negate_key() are given one of the
     special constants that refer to the requesting process's keyrings
     (KEY_SPEC_*_KEYRING, all <= 0), then:

     (a) If sys_request_key() was given a keyring to use (destringid) then the
     	 key will be attached to that keyring.

     (b) If sys_request_key() was given a NULL keyring, then the key being
     	 instantiated will be attached to the default keyring as set by
     	 keyctl_set_reqkey_keyring().

 (3) No extra link will be made.

Decision point (1) follows current behaviour, and allows those instantiators
who've searched for a specifically named keyring in the requestor's keyring so
as to partition the keys by type to still have their named keyrings.

Decision point (2) allows the requestor to make sure that the key or keys that
get produced by request_key() go where they want, whilst allowing the
instantiator to request that the key is retained.  This is mainly useful for
situations where the instantiator makes a secondary request, the key for which
should be retained by the initial requestor:

	+-----------+        +--------------+        +--------------+
	|           |        |              |        |              |
	| Requestor |------->| Instantiator |------->| Instantiator |
	|           |        |              |        |              |
	+-----------+        +--------------+        +--------------+
	           request_key()           request_key()

This might be useful, for example, in Kerberos, where the requestor requests a
ticket, and then the ticket instantiator requests the TGT, which someone else
then has to go and fetch.  The TGT, however, should be retained in the
keyrings of the requestor, not the first instantiator.  To make this explict
an extra special keyring constant is also added.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

 include/linux/key.h              |   18 +++---
 include/linux/keyctl.h           |    4 +
 kernel/kmod.c                    |    2 -
 security/keys/internal.h         |   11 ++--
 security/keys/keyctl.c           |  118 +++++++++++++++++++++++---------------
 security/keys/process_keys.c     |   88 +++++++++++++++++-----------
 security/keys/request_key.c      |   71 +++++++++++++++--------
 security/keys/request_key_auth.c |    5 +-
 8 files changed, 195 insertions(+), 122 deletions(-)


diff --git a/include/linux/key.h b/include/linux/key.h
index c45c962..599a37c 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -287,25 +287,25 @@ extern void key_fsuid_changed(struct task_struct *tsk);
 extern void key_fsgid_changed(struct task_struct *tsk);
 extern void key_init(void);
 
-#define __install_session_keyring(tsk, keyring)			\
-({								\
-	struct key *old_session = tsk->signal->session_keyring;	\
-	tsk->signal->session_keyring = keyring;			\
-	old_session;						\
+#define __install_session_keyring(keyring)				\
+({									\
+	struct key *old_session = current->signal->session_keyring;	\
+	current->signal->session_keyring = keyring;			\
+	old_session;							\
 })
 
 #else /* CONFIG_KEYS */
 
 #define key_validate(k)			0
 #define key_serial(k)			0
-#define key_get(k) 			({ NULL; })
+#define key_get(k) 			NULL
 #define key_put(k)			do { } while(0)
 #define key_ref_put(k)			do { } while(0)
-#define make_key_ref(k, p)			({ NULL; })
-#define key_ref_to_ptr(k)		({ NULL; })
+#define make_key_ref(k, p)		NULL
+#define key_ref_to_ptr(k)		NULL
 #define is_key_possessed(k)		0
 #define switch_uid_keyring(u)		do { } while(0)
-#define __install_session_keyring(t, k)	({ NULL; })
+#define __install_session_keyring(k)	NULL
 #define copy_keys(f,t)			0
 #define copy_thread_group_keys(t)	0
 #define exit_keys(t)			do { } while(0)
diff --git a/include/linux/keyctl.h b/include/linux/keyctl.h
index 656ee6b..c0688eb 100644
--- a/include/linux/keyctl.h
+++ b/include/linux/keyctl.h
@@ -1,6 +1,6 @@
 /* keyctl.h: keyctl command IDs
  *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2004, 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -20,6 +20,7 @@
 #define KEY_SPEC_USER_SESSION_KEYRING	-5	/* - key ID for UID-session keyring */
 #define KEY_SPEC_GROUP_KEYRING		-6	/* - key ID for GID-specific keyring */
 #define KEY_SPEC_REQKEY_AUTH_KEY	-7	/* - key ID for assumed request_key auth key */
+#define KEY_SPEC_REQUESTOR_KEYRING	-8	/* - key ID for request_key() dest keyring */
 
 /* request-key default keyrings */
 #define KEY_REQKEY_DEFL_NO_CHANGE		-1
@@ -30,6 +31,7 @@
 #define KEY_REQKEY_DEFL_USER_KEYRING		4
 #define KEY_REQKEY_DEFL_USER_SESSION_KEYRING	5
 #define KEY_REQKEY_DEFL_GROUP_KEYRING		6
+#define KEY_REQKEY_DEFL_REQUESTOR_KEYRING	7
 
 /* keyctl commands */
 #define KEYCTL_GET_KEYRING_ID		0	/* ask for a keyring's ID */
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2456d1a..27e02e6 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -140,7 +140,7 @@ static int ____call_usermodehelper(void *data)
 	/* Unblock all signals and set the session keyring. */
 	new_session = key_get(sub_info->ring);
 	spin_lock_irq(&current->sighand->siglock);
-	old_session = __install_session_keyring(current, new_session);
+	old_session = __install_session_keyring(new_session);
 	flush_signal_handlers(current, 1);
 	sigemptyset(&current->blocked);
 	recalc_sigpending();
diff --git a/security/keys/internal.h b/security/keys/internal.h
index a60c681..cb8c678 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -109,8 +109,8 @@ extern key_ref_t search_process_keyrings(struct key_type *type,
 
 extern struct key *find_keyring_by_name(const char *name, bool skip_perm_check);
 
-extern int install_thread_keyring(struct task_struct *tsk);
-extern int install_process_keyring(struct task_struct *tsk);
+extern int install_thread_keyring(void);
+extern int install_process_keyring(void);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
@@ -120,8 +120,7 @@ extern struct key *request_key_and_link(struct key_type *type,
 					struct key *dest_keyring,
 					unsigned long flags);
 
-extern key_ref_t lookup_user_key(struct task_struct *context,
-				 key_serial_t id, int create, int partial,
+extern key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 				 key_perm_t perm);
 
 extern long join_session_keyring(const char *name);
@@ -152,6 +151,7 @@ static inline int key_permission(const key_ref_t key_ref, key_perm_t perm)
  */
 struct request_key_auth {
 	struct key		*target_key;
+	struct key		*dest_keyring;
 	struct task_struct	*context;
 	void			*callout_info;
 	size_t			callout_len;
@@ -161,7 +161,8 @@ struct request_key_auth {
 extern struct key_type key_type_request_key_auth;
 extern struct key *request_key_auth_new(struct key *target,
 					const void *callout_info,
-					size_t callout_len);
+					size_t callout_len,
+					struct key *dest_keyring);
 
 extern struct key *key_get_instantiation_authkey(key_serial_t target_id);
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index acc9c89..a738114 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -103,7 +103,7 @@ asmlinkage long sys_add_key(const char __user *_type,
 	}
 
 	/* find the target keyring (which must be writable) */
-	keyring_ref = lookup_user_key(NULL, ringid, 1, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error3;
@@ -185,7 +185,7 @@ asmlinkage long sys_request_key(const char __user *_type,
 	/* get the destination keyring if specified */
 	dest_ref = NULL;
 	if (destringid) {
-		dest_ref = lookup_user_key(NULL, destringid, 1, 0, KEY_WRITE);
+		dest_ref = lookup_user_key(destringid, 1, 0, KEY_WRITE);
 		if (IS_ERR(dest_ref)) {
 			ret = PTR_ERR(dest_ref);
 			goto error3;
@@ -235,7 +235,7 @@ long keyctl_get_keyring_ID(key_serial_t id, int create)
 	key_ref_t key_ref;
 	long ret;
 
-	key_ref = lookup_user_key(NULL, id, create, 0, KEY_SEARCH);
+	key_ref = lookup_user_key(id, create, 0, KEY_SEARCH);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -308,7 +308,7 @@ long keyctl_update_key(key_serial_t id,
 	}
 
 	/* find the target key (which must be writable) */
-	key_ref = lookup_user_key(NULL, id, 0, 0, KEY_WRITE);
+	key_ref = lookup_user_key(id, 0, 0, KEY_WRITE);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error2;
@@ -336,7 +336,7 @@ long keyctl_revoke_key(key_serial_t id)
 	key_ref_t key_ref;
 	long ret;
 
-	key_ref = lookup_user_key(NULL, id, 0, 0, KEY_WRITE);
+	key_ref = lookup_user_key(id, 0, 0, KEY_WRITE);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -362,7 +362,7 @@ long keyctl_keyring_clear(key_serial_t ringid)
 	key_ref_t keyring_ref;
 	long ret;
 
-	keyring_ref = lookup_user_key(NULL, ringid, 1, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error;
@@ -388,13 +388,13 @@ long keyctl_keyring_link(key_serial_t id, key_serial_t ringid)
 	key_ref_t keyring_ref, key_ref;
 	long ret;
 
-	keyring_ref = lookup_user_key(NULL, ringid, 1, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error;
 	}
 
-	key_ref = lookup_user_key(NULL, id, 1, 0, KEY_LINK);
+	key_ref = lookup_user_key(id, 1, 0, KEY_LINK);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error2;
@@ -422,13 +422,13 @@ long keyctl_keyring_unlink(key_serial_t id, key_serial_t ringid)
 	key_ref_t keyring_ref, key_ref;
 	long ret;
 
-	keyring_ref = lookup_user_key(NULL, ringid, 0, 0, KEY_WRITE);
+	keyring_ref = lookup_user_key(ringid, 0, 0, KEY_WRITE);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error;
 	}
 
-	key_ref = lookup_user_key(NULL, id, 0, 0, 0);
+	key_ref = lookup_user_key(id, 0, 0, 0);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error2;
@@ -464,7 +464,7 @@ long keyctl_describe_key(key_serial_t keyid,
 	char *tmpbuf;
 	long ret;
 
-	key_ref = lookup_user_key(NULL, keyid, 0, 1, KEY_VIEW);
+	key_ref = lookup_user_key(keyid, 0, 1, KEY_VIEW);
 	if (IS_ERR(key_ref)) {
 		/* viewing a key under construction is permitted if we have the
 		 * authorisation token handy */
@@ -472,7 +472,7 @@ long keyctl_describe_key(key_serial_t keyid,
 			instkey = key_get_instantiation_authkey(keyid);
 			if (!IS_ERR(instkey)) {
 				key_put(instkey);
-				key_ref = lookup_user_key(NULL, keyid,
+				key_ref = lookup_user_key(keyid,
 							  0, 1, 0);
 				if (!IS_ERR(key_ref))
 					goto okay;
@@ -557,7 +557,7 @@ long keyctl_keyring_search(key_serial_t ringid,
 	}
 
 	/* get the keyring at which to begin the search */
-	keyring_ref = lookup_user_key(NULL, ringid, 0, 0, KEY_SEARCH);
+	keyring_ref = lookup_user_key(ringid, 0, 0, KEY_SEARCH);
 	if (IS_ERR(keyring_ref)) {
 		ret = PTR_ERR(keyring_ref);
 		goto error2;
@@ -566,7 +566,7 @@ long keyctl_keyring_search(key_serial_t ringid,
 	/* get the destination keyring if specified */
 	dest_ref = NULL;
 	if (destringid) {
-		dest_ref = lookup_user_key(NULL, destringid, 1, 0, KEY_WRITE);
+		dest_ref = lookup_user_key(destringid, 1, 0, KEY_WRITE);
 		if (IS_ERR(dest_ref)) {
 			ret = PTR_ERR(dest_ref);
 			goto error3;
@@ -636,7 +636,7 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 	long ret;
 
 	/* find the key first */
-	key_ref = lookup_user_key(NULL, keyid, 0, 0, 0);
+	key_ref = lookup_user_key(keyid, 0, 0, 0);
 	if (IS_ERR(key_ref)) {
 		ret = -ENOKEY;
 		goto error;
@@ -699,7 +699,7 @@ long keyctl_chown_key(key_serial_t id, uid_t uid, gid_t gid)
 	if (uid == (uid_t) -1 && gid == (gid_t) -1)
 		goto error;
 
-	key_ref = lookup_user_key(NULL, id, 1, 1, KEY_SETATTR);
+	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -804,7 +804,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	if (perm & ~(KEY_POS_ALL | KEY_USR_ALL | KEY_GRP_ALL | KEY_OTH_ALL))
 		goto error;
 
-	key_ref = lookup_user_key(NULL, id, 1, 1, KEY_SETATTR);
+	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -829,6 +829,43 @@ error:
 
 } /* end keyctl_setperm_key() */
 
+/*
+ * get the destination keyring for instantiation
+ */
+static long get_instantiation_keyring(key_serial_t ringid,
+				      struct request_key_auth *rka,
+				      struct key **_dest_keyring)
+{
+	key_ref_t dkref;
+
+	/* just return a NULL pointer if we weren't asked to make a link */
+	if (ringid == 0) {
+		*_dest_keyring = NULL;
+		return 0;
+	}
+
+	/* if a specific keyring is nominated by ID, then use that */
+	if (ringid > 0) {
+		dkref = lookup_user_key(ringid, 1, 0, KEY_WRITE);
+		if (IS_ERR(dkref))
+			return PTR_ERR(dkref);
+		*_dest_keyring = key_ref_to_ptr(dkref);
+		return 0;
+	}
+
+	if (ringid == KEY_SPEC_REQKEY_AUTH_KEY)
+		return -EINVAL;
+
+	/* otherwise specify the destination keyring recorded in the
+	 * authorisation key (any KEY_SPEC_*_KEYRING) */
+	if (ringid >= KEY_SPEC_REQUESTOR_KEYRING) {
+		*_dest_keyring = rka->dest_keyring;
+		return 0;
+	}
+
+	return -ENOKEY;
+}
+
 /*****************************************************************************/
 /*
  * instantiate the key with the specified payload, and, if one is given, link
@@ -840,8 +877,7 @@ long keyctl_instantiate_key(key_serial_t id,
 			    key_serial_t ringid)
 {
 	struct request_key_auth *rka;
-	struct key *instkey;
-	key_ref_t keyring_ref;
+	struct key *instkey, *dest_keyring;
 	void *payload;
 	long ret;
 	bool vm = false;
@@ -883,21 +919,15 @@ long keyctl_instantiate_key(key_serial_t id,
 
 	/* find the destination keyring amongst those belonging to the
 	 * requesting task */
-	keyring_ref = NULL;
-	if (ringid) {
-		keyring_ref = lookup_user_key(rka->context, ringid, 1, 0,
-					      KEY_WRITE);
-		if (IS_ERR(keyring_ref)) {
-			ret = PTR_ERR(keyring_ref);
-			goto error2;
-		}
-	}
+	ret = get_instantiation_keyring(ringid, rka, &dest_keyring);
+	if (ret < 0)
+		goto error2;
 
 	/* instantiate the key and link it into a keyring */
 	ret = key_instantiate_and_link(rka->target_key, payload, plen,
-				       key_ref_to_ptr(keyring_ref), instkey);
+				       dest_keyring, instkey);
 
-	key_ref_put(keyring_ref);
+	key_put(dest_keyring);
 
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
@@ -924,8 +954,7 @@ error:
 long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 {
 	struct request_key_auth *rka;
-	struct key *instkey;
-	key_ref_t keyring_ref;
+	struct key *instkey, *dest_keyring;
 	long ret;
 
 	/* the appropriate instantiation authorisation key must have been
@@ -941,20 +970,15 @@ long keyctl_negate_key(key_serial_t id, unsigned timeout, key_serial_t ringid)
 
 	/* find the destination keyring if present (which must also be
 	 * writable) */
-	keyring_ref = NULL;
-	if (ringid) {
-		keyring_ref = lookup_user_key(NULL, ringid, 1, 0, KEY_WRITE);
-		if (IS_ERR(keyring_ref)) {
-			ret = PTR_ERR(keyring_ref);
-			goto error;
-		}
-	}
+	ret = get_instantiation_keyring(ringid, rka, &dest_keyring);
+	if (ret < 0)
+		goto error;
 
 	/* instantiate the key and link it into a keyring */
 	ret = key_negate_and_link(rka->target_key, timeout,
-				  key_ref_to_ptr(keyring_ref), instkey);
+				  dest_keyring, instkey);
 
-	key_ref_put(keyring_ref);
+	key_put(dest_keyring);
 
 	/* discard the assumed authority if it's just been disabled by
 	 * instantiation of the key */
@@ -979,13 +1003,13 @@ long keyctl_set_reqkey_keyring(int reqkey_defl)
 
 	switch (reqkey_defl) {
 	case KEY_REQKEY_DEFL_THREAD_KEYRING:
-		ret = install_thread_keyring(current);
+		ret = install_thread_keyring();
 		if (ret < 0)
 			return ret;
 		goto set;
 
 	case KEY_REQKEY_DEFL_PROCESS_KEYRING:
-		ret = install_process_keyring(current);
+		ret = install_process_keyring();
 		if (ret < 0)
 			return ret;
 
@@ -1018,7 +1042,7 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 	time_t expiry;
 	long ret;
 
-	key_ref = lookup_user_key(NULL, id, 1, 1, KEY_SETATTR);
+	key_ref = lookup_user_key(id, 1, 1, KEY_SETATTR);
 	if (IS_ERR(key_ref)) {
 		ret = PTR_ERR(key_ref);
 		goto error;
@@ -1105,7 +1129,7 @@ long keyctl_get_security(key_serial_t keyid,
 	char *context;
 	long ret;
 
-	key_ref = lookup_user_key(NULL, keyid, 0, 1, KEY_VIEW);
+	key_ref = lookup_user_key(keyid, 0, 1, KEY_VIEW);
 	if (IS_ERR(key_ref)) {
 		if (PTR_ERR(key_ref) != -EACCES)
 			return PTR_ERR(key_ref);
@@ -1117,7 +1141,7 @@ long keyctl_get_security(key_serial_t keyid,
 			return PTR_ERR(key_ref);
 		key_put(instkey);
 
-		key_ref = lookup_user_key(NULL, keyid, 0, 1, 0);
+		key_ref = lookup_user_key(keyid, 0, 1, 0);
 		if (IS_ERR(key_ref))
 			return PTR_ERR(key_ref);
 	}
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 5be6d01..324093d 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -40,9 +40,9 @@ struct key_user root_key_user = {
 /*
  * install user and user session keyrings for a particular UID
  */
-static int install_user_keyrings(struct task_struct *tsk)
+static int install_user_keyrings(void)
 {
-	struct user_struct *user = tsk->user;
+	struct user_struct *user = current->user;
 	struct key *uid_keyring, *session_keyring;
 	char buf[20];
 	int ret;
@@ -67,7 +67,7 @@ static int install_user_keyrings(struct task_struct *tsk)
 		uid_keyring = find_keyring_by_name(buf, true);
 		if (IS_ERR(uid_keyring)) {
 			uid_keyring = keyring_alloc(buf, user->uid, (gid_t) -1,
-						    tsk, KEY_ALLOC_IN_QUOTA,
+						    current, KEY_ALLOC_IN_QUOTA,
 						    NULL);
 			if (IS_ERR(uid_keyring)) {
 				ret = PTR_ERR(uid_keyring);
@@ -83,7 +83,8 @@ static int install_user_keyrings(struct task_struct *tsk)
 		if (IS_ERR(session_keyring)) {
 			session_keyring =
 				keyring_alloc(buf, user->uid, (gid_t) -1,
-					      tsk, KEY_ALLOC_IN_QUOTA, NULL);
+					      current, KEY_ALLOC_IN_QUOTA,
+					      NULL);
 			if (IS_ERR(session_keyring)) {
 				ret = PTR_ERR(session_keyring);
 				goto error_release;
@@ -146,8 +147,9 @@ void switch_uid_keyring(struct user_struct *new_user)
 /*
  * install a fresh thread keyring, discarding the old one
  */
-int install_thread_keyring(struct task_struct *tsk)
+int install_thread_keyring(void)
 {
+	struct task_struct *tsk = current;
 	struct key *keyring, *old;
 	char buf[20];
 	int ret;
@@ -178,8 +180,9 @@ error:
 /*
  * make sure a process keyring is installed
  */
-int install_process_keyring(struct task_struct *tsk)
+int install_process_keyring(void)
 {
+	struct task_struct *tsk = current;
 	struct key *keyring;
 	char buf[20];
 	int ret;
@@ -218,9 +221,9 @@ error:
  * install a session keyring, discarding the old one
  * - if a keyring is not supplied, an empty one is invented
  */
-static int install_session_keyring(struct task_struct *tsk,
-				   struct key *keyring)
+static int install_session_keyring(struct key *keyring)
 {
+	struct task_struct *tsk = current;
 	unsigned long flags;
 	struct key *old;
 	char buf[20];
@@ -572,93 +575,91 @@ static int lookup_user_key_possessed(const struct key *key, const void *target)
  * - don't create special keyrings unless so requested
  * - partially constructed keys aren't found unless requested
  */
-key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
-			  int create, int partial, key_perm_t perm)
+key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
+			  key_perm_t perm)
 {
+	struct request_key_auth *rka;
+	struct task_struct *t = current;
 	key_ref_t key_ref, skey_ref;
 	struct key *key;
 	int ret;
 
-	if (!context)
-		context = current;
-
 	key_ref = ERR_PTR(-ENOKEY);
 
 	switch (id) {
 	case KEY_SPEC_THREAD_KEYRING:
-		if (!context->thread_keyring) {
+		if (!t->thread_keyring) {
 			if (!create)
 				goto error;
 
-			ret = install_thread_keyring(context);
+			ret = install_thread_keyring();
 			if (ret < 0) {
 				key = ERR_PTR(ret);
 				goto error;
 			}
 		}
 
-		key = context->thread_keyring;
+		key = t->thread_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_PROCESS_KEYRING:
-		if (!context->signal->process_keyring) {
+		if (!t->signal->process_keyring) {
 			if (!create)
 				goto error;
 
-			ret = install_process_keyring(context);
+			ret = install_process_keyring();
 			if (ret < 0) {
 				key = ERR_PTR(ret);
 				goto error;
 			}
 		}
 
-		key = context->signal->process_keyring;
+		key = t->signal->process_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_SESSION_KEYRING:
-		if (!context->signal->session_keyring) {
+		if (!t->signal->session_keyring) {
 			/* always install a session keyring upon access if one
 			 * doesn't exist yet */
-			ret = install_user_keyrings(context);
+			ret = install_user_keyrings();
 			if (ret < 0)
 				goto error;
-			ret = install_session_keyring(
-				context, context->user->session_keyring);
+			ret = install_session_keyring(t->user->session_keyring);
 			if (ret < 0)
 				goto error;
 		}
 
 		rcu_read_lock();
-		key = rcu_dereference(context->signal->session_keyring);
+		key = rcu_dereference(t->signal->session_keyring);
 		atomic_inc(&key->usage);
 		rcu_read_unlock();
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
-		if (!context->user->uid_keyring) {
-			ret = install_user_keyrings(context);
+		if (!t->user->uid_keyring) {
+			ret = install_user_keyrings();
 			if (ret < 0)
 				goto error;
 		}
 
-		key = context->user->uid_keyring;
+		key = t->user->uid_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
-		if (!context->user->session_keyring) {
-			ret = install_user_keyrings(context);
+		if (!t->user->session_keyring) {
+			ret = install_user_keyrings();
 			if (ret < 0)
 				goto error;
 		}
 
-		key = context->user->session_keyring;
+		key = t->user->session_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
@@ -669,7 +670,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		goto error;
 
 	case KEY_SPEC_REQKEY_AUTH_KEY:
-		key = context->request_key_auth;
+		key = t->request_key_auth;
 		if (!key)
 			goto error;
 
@@ -677,6 +678,25 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		key_ref = make_key_ref(key, 1);
 		break;
 
+	case KEY_SPEC_REQUESTOR_KEYRING:
+		if (!t->request_key_auth)
+			goto error;
+
+		down_read(&t->request_key_auth->sem);
+		if (t->request_key_auth->flags & KEY_FLAG_REVOKED) {
+			key_ref = ERR_PTR(-EKEYREVOKED);
+			key = NULL;
+		} else {
+			rka = t->request_key_auth->payload.data;
+			key = rka->dest_keyring;
+			atomic_inc(&key->usage);
+		}
+		up_read(&t->request_key_auth->sem);
+		if (!key)
+			goto error;
+		key_ref = make_key_ref(key, 1);
+		break;
+
 	default:
 		key_ref = ERR_PTR(-EINVAL);
 		if (id < 1)
@@ -725,7 +745,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		goto invalid_key;
 
 	/* check the permissions */
-	ret = key_task_permission(key_ref, context, perm);
+	ret = key_task_permission(key_ref, t, perm);
 	if (ret < 0)
 		goto invalid_key;
 
@@ -754,7 +774,7 @@ long join_session_keyring(const char *name)
 
 	/* if no name is provided, install an anonymous keyring */
 	if (!name) {
-		ret = install_session_keyring(tsk, NULL);
+		ret = install_session_keyring(NULL);
 		if (ret < 0)
 			goto error;
 
@@ -784,7 +804,7 @@ long join_session_keyring(const char *name)
 	}
 
 	/* we've got a keyring - now to install it */
-	ret = install_session_keyring(tsk, keyring);
+	ret = install_session_keyring(keyring);
 	if (ret < 0)
 		goto error2;
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index b9e50a9..123edce 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -165,7 +165,8 @@ error_alloc:
  * - we ignore program failure and go on key status instead
  */
 static int construct_key(struct key *key, const void *callout_info,
-			 size_t callout_len, void *aux)
+			 size_t callout_len, void *aux,
+			 struct key *dest_keyring)
 {
 	struct key_construction *cons;
 	request_key_actor_t actor;
@@ -179,7 +180,8 @@ static int construct_key(struct key *key, const void *callout_info,
 		return -ENOMEM;
 
 	/* allocate an authorisation key */
-	authkey = request_key_auth_new(key, callout_info, callout_len);
+	authkey = request_key_auth_new(key, callout_info, callout_len,
+				       dest_keyring);
 	if (IS_ERR(authkey)) {
 		kfree(cons);
 		ret = PTR_ERR(authkey);
@@ -207,27 +209,48 @@ static int construct_key(struct key *key, const void *callout_info,
 }
 
 /*
- * link a key to the appropriate destination keyring
- * - the caller must hold a write lock on the destination keyring
+ * get the appropriate destination keyring for the request
+ * - we return whatever keyring we select with an extra reference upon it which
+ *   the caller must release
  */
-static void construct_key_make_link(struct key *key, struct key *dest_keyring)
+static void construct_get_dest_keyring(struct key **_dest_keyring)
 {
+	struct request_key_auth *rka;
 	struct task_struct *tsk = current;
-	struct key *drop = NULL;
+	struct key *dest_keyring = *_dest_keyring, *authkey;
 
-	kenter("{%d},%p", key->serial, dest_keyring);
+	kenter("%p", dest_keyring);
 
 	/* find the appropriate keyring */
-	if (!dest_keyring) {
+	if (dest_keyring) {
+		/* the caller supplied one */
+		key_get(dest_keyring);
+	} else {
+		/* use a default keyring; falling through the cases until we
+		 * find one that we actually have */
 		switch (tsk->jit_keyring) {
 		case KEY_REQKEY_DEFL_DEFAULT:
+		case KEY_REQKEY_DEFL_REQUESTOR_KEYRING:
+			if (tsk->request_key_auth) {
+				authkey = tsk->request_key_auth;
+				down_read(&authkey->sem);
+				rka = authkey->payload.data;
+				if (!test_bit(KEY_FLAG_REVOKED,
+					      &authkey->flags))
+					dest_keyring =
+						key_get(rka->dest_keyring);
+				up_read(&authkey->sem);
+				if (dest_keyring)
+					break;
+			}
+
 		case KEY_REQKEY_DEFL_THREAD_KEYRING:
-			dest_keyring = tsk->thread_keyring;
+			dest_keyring = key_get(tsk->thread_keyring);
 			if (dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_PROCESS_KEYRING:
-			dest_keyring = tsk->signal->process_keyring;
+			dest_keyring = key_get(tsk->signal->process_keyring);
 			if (dest_keyring)
 				break;
 
@@ -236,17 +259,16 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 			dest_keyring = key_get(
 				rcu_dereference(tsk->signal->session_keyring));
 			rcu_read_unlock();
-			drop = dest_keyring;
 
 			if (dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-			dest_keyring = tsk->user->session_keyring;
+			dest_keyring = key_get(tsk->user->session_keyring);
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring = tsk->user->uid_keyring;
+			dest_keyring = key_get(tsk->user->uid_keyring);
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:
@@ -255,10 +277,9 @@ static void construct_key_make_link(struct key *key, struct key *dest_keyring)
 		}
 	}
 
-	/* and attach the key to it */
-	__key_link(dest_keyring, key);
-	key_put(drop);
-	kleave("");
+	*_dest_keyring = dest_keyring;
+	kleave(" [dk %d]", key_serial(dest_keyring));
+	return;
 }
 
 /*
@@ -288,8 +309,7 @@ static int construct_alloc_key(struct key_type *type,
 
 	set_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags);
 
-	if (dest_keyring)
-		down_write(&dest_keyring->sem);
+	down_write(&dest_keyring->sem);
 
 	/* attach the key to the destination keyring under lock, but we do need
 	 * to do another check just in case someone beat us to it whilst we
@@ -301,12 +321,10 @@ static int construct_alloc_key(struct key_type *type,
 	if (!IS_ERR(key_ref))
 		goto key_already_present;
 
-	if (dest_keyring)
-		construct_key_make_link(key, dest_keyring);
+	__key_link(dest_keyring, key);
 
 	mutex_unlock(&key_construction_mutex);
-	if (dest_keyring)
-		up_write(&dest_keyring->sem);
+	up_write(&dest_keyring->sem);
 	mutex_unlock(&user->cons_lock);
 	*_key = key;
 	kleave(" = 0 [%d]", key_serial(key));
@@ -348,21 +366,26 @@ static struct key *construct_key_and_link(struct key_type *type,
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
+	construct_get_dest_keyring(&dest_keyring);
+
 	ret = construct_alloc_key(type, description, dest_keyring, flags, user,
 				  &key);
 	key_user_put(user);
 
 	if (ret == 0) {
-		ret = construct_key(key, callout_info, callout_len, aux);
+		ret = construct_key(key, callout_info, callout_len, aux,
+				    dest_keyring);
 		if (ret < 0)
 			goto construction_failed;
 	}
 
+	key_put(dest_keyring);
 	return key;
 
 construction_failed:
 	key_negate_and_link(key, key_negative_timeout, NULL, NULL);
 	key_put(key);
+	key_put(dest_keyring);
 	return ERR_PTR(ret);
 }
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index bd237b0..eccd2f2 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -128,6 +128,7 @@ static void request_key_auth_destroy(struct key *key)
 	}
 
 	key_put(rka->target_key);
+	key_put(rka->dest_keyring);
 	kfree(rka->callout_info);
 	kfree(rka);
 
@@ -139,7 +140,7 @@ static void request_key_auth_destroy(struct key *key)
  * access to the caller's security data
  */
 struct key *request_key_auth_new(struct key *target, const void *callout_info,
-				 size_t callout_len)
+				 size_t callout_len, struct key *dest_keyring)
 {
 	struct request_key_auth *rka, *irka;
 	struct key *authkey = NULL;
@@ -188,6 +189,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	}
 
 	rka->target_key = key_get(target);
+	rka->dest_keyring = key_get(dest_keyring);
 	memcpy(rka->callout_info, callout_info, callout_len);
 	rka->callout_len = callout_len;
 
@@ -223,6 +225,7 @@ error_inst:
 	key_put(authkey);
 error_alloc:
 	key_put(rka->target_key);
+	key_put(rka->dest_keyring);
 	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= %d", ret);

