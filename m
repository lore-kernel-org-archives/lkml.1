Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbYBTQI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbYBTQI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYBTQIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:08:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbYBTQH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:07:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/37] KEYS: Allow the callout data to be passed as a blob
	rather than a string
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:14 +0000
Message-ID: <20080220160614.4715.26590.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the callout data to be passed as a blob rather than a string for internal
kernel services that call any request_key_*() interface other than
request_key().  request_key() itself still takes a NUL-terminated string.

The functions that change are:

	request_key_with_auxdata()
	request_key_async()
	request_key_async_with_auxdata()

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys-request-key.txt |   11 +++++---
 Documentation/keys.txt             |   14 +++++++---
 include/linux/key.h                |    9 ++++---
 security/keys/internal.h           |    9 ++++---
 security/keys/keyctl.c             |    7 ++++-
 security/keys/request_key.c        |   49 ++++++++++++++++++++++--------------
 security/keys/request_key_auth.c   |   12 +++++----
 7 files changed, 70 insertions(+), 41 deletions(-)


diff --git a/Documentation/keys-request-key.txt b/Documentation/keys-request-key.txt
index 266955d..09b55e4 100644
--- a/Documentation/keys-request-key.txt
+++ b/Documentation/keys-request-key.txt
@@ -11,26 +11,29 @@ request_key*():
 
 	struct key *request_key(const struct key_type *type,
 				const char *description,
-				const char *callout_string);
+				const char *callout_info);
 
 or:
 
 	struct key *request_key_with_auxdata(const struct key_type *type,
 					     const char *description,
-					     const char *callout_string,
+					     const char *callout_info,
+					     size_t callout_len,
 					     void *aux);
 
 or:
 
 	struct key *request_key_async(const struct key_type *type,
 				      const char *description,
-				      const char *callout_string);
+				      const char *callout_info,
+				      size_t callout_len);
 
 or:
 
 	struct key *request_key_async_with_auxdata(const struct key_type *type,
 						   const char *description,
-						   const char *callout_string,
+						   const char *callout_info,
+					     	   size_t callout_len,
 						   void *aux);
 
 Or by userspace invoking the request_key system call:
diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index 51652d3..b82d38d 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -771,7 +771,7 @@ payload contents" for more information.
 
 	struct key *request_key(const struct key_type *type,
 				const char *description,
-				const char *callout_string);
+				const char *callout_info);
 
     This is used to request a key or keyring with a description that matches
     the description specified according to the key type's match function. This
@@ -793,24 +793,28 @@ payload contents" for more information.
 
 	struct key *request_key_with_auxdata(const struct key_type *type,
 					     const char *description,
-					     const char *callout_string,
+					     const void *callout_info,
+					     size_t callout_len,
 					     void *aux);
 
     This is identical to request_key(), except that the auxiliary data is
-    passed to the key_type->request_key() op if it exists.
+    passed to the key_type->request_key() op if it exists, and the callout_info
+    is a blob of length callout_len, if given (the length may be 0).
 
 
 (*) A key can be requested asynchronously by calling one of:
 
 	struct key *request_key_async(const struct key_type *type,
 				      const char *description,
-				      const char *callout_string);
+				      const void *callout_info,
+				      size_t callout_len);
 
     or:
 
 	struct key *request_key_async_with_auxdata(const struct key_type *type,
 						   const char *description,
-						   const char *callout_string,
+						   const char *callout_info,
+					     	   size_t callout_len,
 					     	   void *aux);
 
     which are asynchronous equivalents of request_key() and
diff --git a/include/linux/key.h b/include/linux/key.h
index a70b8a8..163f864 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -208,16 +208,19 @@ extern struct key *request_key(struct key_type *type,
 
 extern struct key *request_key_with_auxdata(struct key_type *type,
 					    const char *description,
-					    const char *callout_info,
+					    const void *callout_info,
+					    size_t callout_len,
 					    void *aux);
 
 extern struct key *request_key_async(struct key_type *type,
 				     const char *description,
-				     const char *callout_info);
+				     const void *callout_info,
+				     size_t callout_len);
 
 extern struct key *request_key_async_with_auxdata(struct key_type *type,
 						  const char *description,
-						  const char *callout_info,
+						  const void *callout_info,
+						  size_t callout_len,
 						  void *aux);
 
 extern int wait_for_key_construction(struct key *key, bool intr);
diff --git a/security/keys/internal.h b/security/keys/internal.h
index d36d693..f004835 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -109,7 +109,8 @@ extern int install_process_keyring(struct task_struct *tsk);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
-					const char *callout_info,
+					const void *callout_info,
+					size_t callout_len,
 					void *aux,
 					struct key *dest_keyring,
 					unsigned long flags);
@@ -120,13 +121,15 @@ extern struct key *request_key_and_link(struct key_type *type,
 struct request_key_auth {
 	struct key		*target_key;
 	struct task_struct	*context;
-	char			*callout_info;
+	void			*callout_info;
+	size_t			callout_len;
 	pid_t			pid;
 };
 
 extern struct key_type key_type_request_key_auth;
 extern struct key *request_key_auth_new(struct key *target,
-					const char *callout_info);
+					const void *callout_info,
+					size_t callout_len);
 
 extern struct key *key_get_instantiation_authkey(key_serial_t target_id);
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 8ec8432..1698bf9 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -152,6 +152,7 @@ asmlinkage long sys_request_key(const char __user *_type,
 	struct key_type *ktype;
 	struct key *key;
 	key_ref_t dest_ref;
+	size_t callout_len;
 	char type[32], *description, *callout_info;
 	long ret;
 
@@ -169,12 +170,14 @@ asmlinkage long sys_request_key(const char __user *_type,
 
 	/* pull the callout info into kernel space */
 	callout_info = NULL;
+	callout_len = 0;
 	if (_callout_info) {
 		callout_info = strndup_user(_callout_info, PAGE_SIZE);
 		if (IS_ERR(callout_info)) {
 			ret = PTR_ERR(callout_info);
 			goto error2;
 		}
+		callout_len = strlen(callout_info);
 	}
 
 	/* get the destination keyring if specified */
@@ -195,8 +198,8 @@ asmlinkage long sys_request_key(const char __user *_type,
 	}
 
 	/* do the search */
-	key = request_key_and_link(ktype, description, callout_info, NULL,
-				   key_ref_to_ptr(dest_ref),
+	key = request_key_and_link(ktype, description, callout_info,
+				   callout_len, NULL, key_ref_to_ptr(dest_ref),
 				   KEY_ALLOC_IN_QUOTA);
 	if (IS_ERR(key)) {
 		ret = PTR_ERR(key);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 5ecc505..a3f94c6 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -161,21 +161,22 @@ error_alloc:
  * call out to userspace for key construction
  * - we ignore program failure and go on key status instead
  */
-static int construct_key(struct key *key, const char *callout_info, void *aux)
+static int construct_key(struct key *key, const void *callout_info,
+			 size_t callout_len, void *aux)
 {
 	struct key_construction *cons;
 	request_key_actor_t actor;
 	struct key *authkey;
 	int ret;
 
-	kenter("%d,%s,%p", key->serial, callout_info, aux);
+	kenter("%d,%p,%zu,%p", key->serial, callout_info, callout_len, aux);
 
 	cons = kmalloc(sizeof(*cons), GFP_KERNEL);
 	if (!cons)
 		return -ENOMEM;
 
 	/* allocate an authorisation key */
-	authkey = request_key_auth_new(key, callout_info);
+	authkey = request_key_auth_new(key, callout_info, callout_len);
 	if (IS_ERR(authkey)) {
 		kfree(cons);
 		ret = PTR_ERR(authkey);
@@ -331,6 +332,7 @@ alloc_failed:
 static struct key *construct_key_and_link(struct key_type *type,
 					  const char *description,
 					  const char *callout_info,
+					  size_t callout_len,
 					  void *aux,
 					  struct key *dest_keyring,
 					  unsigned long flags)
@@ -348,7 +350,7 @@ static struct key *construct_key_and_link(struct key_type *type,
 	key_user_put(user);
 
 	if (ret == 0) {
-		ret = construct_key(key, callout_info, aux);
+		ret = construct_key(key, callout_info, callout_len, aux);
 		if (ret < 0)
 			goto construction_failed;
 	}
@@ -370,7 +372,8 @@ construction_failed:
  */
 struct key *request_key_and_link(struct key_type *type,
 				 const char *description,
-				 const char *callout_info,
+				 const void *callout_info,
+				 size_t callout_len,
 				 void *aux,
 				 struct key *dest_keyring,
 				 unsigned long flags)
@@ -378,8 +381,8 @@ struct key *request_key_and_link(struct key_type *type,
 	struct key *key;
 	key_ref_t key_ref;
 
-	kenter("%s,%s,%s,%p,%p,%lx",
-	       type->name, description, callout_info, aux,
+	kenter("%s,%s,%p,%zu,%p,%p,%lx",
+	       type->name, description, callout_info, callout_len, aux,
 	       dest_keyring, flags);
 
 	/* search all the process keyrings for a key */
@@ -398,7 +401,8 @@ struct key *request_key_and_link(struct key_type *type,
 			goto error;
 
 		key = construct_key_and_link(type, description, callout_info,
-					     aux, dest_keyring, flags);
+					     callout_len, aux, dest_keyring,
+					     flags);
 	}
 
 error:
@@ -434,10 +438,13 @@ struct key *request_key(struct key_type *type,
 			const char *callout_info)
 {
 	struct key *key;
+	size_t callout_len = 0;
 	int ret;
 
-	key = request_key_and_link(type, description, callout_info, NULL,
-				   NULL, KEY_ALLOC_IN_QUOTA);
+	if (callout_info)
+		callout_len = strlen(callout_info);
+	key = request_key_and_link(type, description, callout_info, callout_len,
+				   NULL, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
 		if (ret < 0) {
@@ -458,14 +465,15 @@ EXPORT_SYMBOL(request_key);
  */
 struct key *request_key_with_auxdata(struct key_type *type,
 				     const char *description,
-				     const char *callout_info,
+				     const void *callout_info,
+				     size_t callout_len,
 				     void *aux)
 {
 	struct key *key;
 	int ret;
 
-	key = request_key_and_link(type, description, callout_info, aux,
-				   NULL, KEY_ALLOC_IN_QUOTA);
+	key = request_key_and_link(type, description, callout_info, callout_len,
+				   aux, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
 		if (ret < 0) {
@@ -485,10 +493,12 @@ EXPORT_SYMBOL(request_key_with_auxdata);
  */
 struct key *request_key_async(struct key_type *type,
 			      const char *description,
-			      const char *callout_info)
+			      const void *callout_info,
+			      size_t callout_len)
 {
-	return request_key_and_link(type, description, callout_info, NULL,
-				    NULL, KEY_ALLOC_IN_QUOTA);
+	return request_key_and_link(type, description, callout_info,
+				    callout_len, NULL, NULL,
+				    KEY_ALLOC_IN_QUOTA);
 }
 EXPORT_SYMBOL(request_key_async);
 
@@ -500,10 +510,11 @@ EXPORT_SYMBOL(request_key_async);
  */
 struct key *request_key_async_with_auxdata(struct key_type *type,
 					   const char *description,
-					   const char *callout_info,
+					   const void *callout_info,
+					   size_t callout_len,
 					   void *aux)
 {
-	return request_key_and_link(type, description, callout_info, aux,
-				    NULL, KEY_ALLOC_IN_QUOTA);
+	return request_key_and_link(type, description, callout_info,
+				    callout_len, aux, NULL, KEY_ALLOC_IN_QUOTA);
 }
 EXPORT_SYMBOL(request_key_async_with_auxdata);
diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index e42b525..c615d47 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -61,7 +61,7 @@ static void request_key_auth_describe(const struct key *key,
 
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
-	seq_printf(m, " pid:%d ci:%zu", rka->pid, strlen(rka->callout_info));
+	seq_printf(m, " pid:%d ci:%zu", rka->pid, rka->callout_len);
 
 } /* end request_key_auth_describe() */
 
@@ -77,7 +77,7 @@ static long request_key_auth_read(const struct key *key,
 	size_t datalen;
 	long ret;
 
-	datalen = strlen(rka->callout_info);
+	datalen = rka->callout_len;
 	ret = datalen;
 
 	/* we can return the data as is */
@@ -137,7 +137,8 @@ static void request_key_auth_destroy(struct key *key)
  * create an authorisation token for /sbin/request-key or whoever to gain
  * access to the caller's security data
  */
-struct key *request_key_auth_new(struct key *target, const char *callout_info)
+struct key *request_key_auth_new(struct key *target, const void *callout_info,
+				 size_t callout_len)
 {
 	struct request_key_auth *rka, *irka;
 	struct key *authkey = NULL;
@@ -152,7 +153,7 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
 		kleave(" = -ENOMEM");
 		return ERR_PTR(-ENOMEM);
 	}
-	rka->callout_info = kmalloc(strlen(callout_info) + 1, GFP_KERNEL);
+	rka->callout_info = kmalloc(callout_len, GFP_KERNEL);
 	if (!rka->callout_info) {
 		kleave(" = -ENOMEM");
 		kfree(rka);
@@ -186,7 +187,8 @@ struct key *request_key_auth_new(struct key *target, const char *callout_info)
 	}
 
 	rka->target_key = key_get(target);
-	strcpy(rka->callout_info, callout_info);
+	memcpy(rka->callout_info, callout_info, callout_len);
+	rka->callout_len = callout_len;
 
 	/* allocate the auth key */
 	sprintf(desc, "%x", target->serial);

