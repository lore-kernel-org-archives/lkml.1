Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYKJTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYKJTA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 14:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYKJTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 14:00:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35097 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYKJTAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:00:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
Cc: akpm@linux-foundation.org, pterjan@mandriva.com, stable@kernel.org,
       jlayton@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Make request key instantiate the per-user keyrings
Date: Mon, 10 Nov 2008 19:00:05 +0000
Message-ID: <372.1226343605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make request_key() instantiate the per-user keyrings so that it doesn't oops
if it needs to get hold of the user session keyring because there isn't a
session keyring in place.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Steve French <smfrench@gmail.com>
Tested-by: Rutger Nijlunsing <rutger.nijlunsing@gmail.com>
---

 security/keys/internal.h     |    1 +
 security/keys/process_keys.c |    2 +-
 security/keys/request_key.c  |    4 ++++
 3 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/security/keys/internal.h b/security/keys/internal.h
index b39f5c2..239098f 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -107,6 +107,7 @@ extern key_ref_t search_process_keyrings(struct key_type *type,
 
 extern struct key *find_keyring_by_name(const char *name, bool skip_perm_check);
 
+extern int install_user_keyrings(struct task_struct *tsk);
 extern int install_thread_keyring(struct task_struct *tsk);
 extern int install_process_keyring(struct task_struct *tsk);
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 5be6d01..45b240a 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -40,7 +40,7 @@ struct key_user root_key_user = {
 /*
  * install user and user session keyrings for a particular UID
  */
-static int install_user_keyrings(struct task_struct *tsk)
+int install_user_keyrings(struct task_struct *tsk)
 {
 	struct user_struct *user = tsk->user;
 	struct key *uid_keyring, *session_keyring;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index ba32ca6..abea08f 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -74,6 +74,10 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	kenter("{%d},{%d},%s", key->serial, authkey->serial, op);
 
+	ret = install_user_keyrings(tsk);
+	if (ret < 0)
+		goto error_alloc;
+
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
 
