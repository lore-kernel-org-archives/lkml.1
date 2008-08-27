Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbYH0OIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbYH0OIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759224AbYH0N4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:56:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759216AbYH0N4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:56:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 57/59] CRED: Wrap task credential accesses in the key
	management code
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>
Date: Wed, 27 Aug 2008 14:50:36 +0100
Message-ID: <20080827135036.19980.8006.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 security/keys/key.c              |    2 +-
 security/keys/keyctl.c           |    2 +-
 security/keys/request_key.c      |   10 +++++-----
 security/keys/request_key_auth.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/security/keys/key.c b/security/keys/key.c
index 14948cf..a6ca39e 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -802,7 +802,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	}
 
 	/* allocate a new key */
-	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
+	key = key_alloc(ktype, description, current_fsuid(), current_fsgid(),
 			current, perm, flags);
 	if (IS_ERR(key)) {
 		key_ref = ERR_CAST(key);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index acc9c89..3f09e5b 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -817,7 +817,7 @@ long keyctl_setperm_key(key_serial_t id, key_perm_t perm)
 	down_write(&key->sem);
 
 	/* if we're not the sysadmin, we can only change a key that we own */
-	if (capable(CAP_SYS_ADMIN) || key->uid == current->fsuid) {
+	if (capable(CAP_SYS_ADMIN) || key->uid == current_fsuid()) {
 		key->perm = perm;
 		ret = 0;
 	}
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index ba32ca6..a8ebc95 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -77,7 +77,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
-	keyring = keyring_alloc(desc, current->fsuid, current->fsgid, current,
+	keyring = keyring_alloc(desc, current_fsuid(), current_fsgid(), current,
 				KEY_ALLOC_QUOTA_OVERRUN, NULL);
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
@@ -90,8 +90,8 @@ static int call_sbin_request_key(struct key_construction *cons,
 		goto error_link;
 
 	/* record the UID and GID */
-	sprintf(uid_str, "%d", current->fsuid);
-	sprintf(gid_str, "%d", current->fsgid);
+	sprintf(uid_str, "%d", current_fsuid());
+	sprintf(gid_str, "%d", current_fsgid());
 
 	/* we say which key is under construction */
 	sprintf(key_str, "%d", key->serial);
@@ -279,7 +279,7 @@ static int construct_alloc_key(struct key_type *type,
 	mutex_lock(&user->cons_lock);
 
 	key = key_alloc(type, description,
-			current->fsuid, current->fsgid, current, KEY_POS_ALL,
+			current_fsuid(), current_fsgid(), current, KEY_POS_ALL,
 			flags);
 	if (IS_ERR(key))
 		goto alloc_failed;
@@ -342,7 +342,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 	struct key *key;
 	int ret;
 
-	user = key_user_lookup(current->fsuid);
+	user = key_user_lookup(current_fsuid());
 	if (!user)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index bd237b0..729156b 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -195,7 +195,7 @@ struct key *request_key_auth_new(struct key *target, const void *callout_info,
 	sprintf(desc, "%x", target->serial);
 
 	authkey = key_alloc(&key_type_request_key_auth, desc,
-			    current->fsuid, current->fsgid, current,
+			    current_fsuid(), current_fsgid(), current,
 			    KEY_POS_VIEW | KEY_POS_READ | KEY_POS_SEARCH |
 			    KEY_USR_VIEW, KEY_ALLOC_NOT_IN_QUOTA);
 	if (IS_ERR(authkey)) {

