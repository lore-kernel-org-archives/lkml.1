Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYHUNx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYHUNx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYHUNxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:53:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYHUNxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:53:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: Document the credential API's (ab)use of const pointers
To: jmorris@namei.org, akpm@linux-foundation.org, harvey.harrison@gmail.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 21 Aug 2008 14:52:24 +0100
Message-ID: <20080821135224.17166.32291.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the credential API's (ab)use of const pointers.  Various pointers to
credentials, such as those in the task_struct, are declared const.  The purpose
of this is to compile-time discouragement of altering credentials through those
pointers.  Once a set of credentials has been made public through one of these
pointers, it may not be modified, except under special circumstances:

  (1) Its reference count may incremented and decremented.

  (2) The keyrings to which it points may be modified, but not replaced.

The only safe way to modify anything else is to create a replacement and commit
using the functions described in Documentation/credentials.txt.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/credentials.txt |   19 +++++++++++++++++++
 include/linux/cred.h          |   12 +++++++++++-
 kernel/cred.c                 |    2 +-
 3 files changed, 31 insertions(+), 2 deletions(-)


diff --git a/Documentation/credentials.txt b/Documentation/credentials.txt
index d1f1391..df03169 100644
--- a/Documentation/credentials.txt
+++ b/Documentation/credentials.txt
@@ -14,6 +14,7 @@ Contents:
 
  (*) Task credentials.
 
+     - Immutable credentials.
      - Accessing task credentials.
      - Accessing another task's credentials.
      - Altering credentials.
@@ -309,6 +310,24 @@ attachment to process-specific keyrings in the requesting process as the
 instantiating process may need to create them.
 
 
+IMMUTABLE CREDENTIALS
+---------------------
+
+Once a set of credentials has been made public (by calling commit_creds() for
+example), it must be considered immutable, barring two exceptions:
+
+ (1) The reference count may be altered.
+
+ (2) Whilst the keyring subscriptions of a set of credentials may not be
+     changed, the keyrings subscribed to may have their contents altered.
+
+To catch accidental credential alteration at compile time, struct task_struct
+has _const_ pointers to its credential sets, as does struct file.  Furthermore,
+certain functions such as get_cred() and put_cred() operate on const pointers,
+thus rendering casts unnecessary, but require to temporarily ditch the const
+qualification to be able to alter the reference count.
+
+
 ACCESSING TASK CREDENTIALS
 --------------------------
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index b156ed4..1f8d8d0 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -1,4 +1,4 @@
-/* Credentials management
+/* Credentials management - see Documentation/credentials.txt
  *
  * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -175,6 +175,12 @@ static inline struct cred *get_new_cred(struct cred *cred)
  *
  * Get a reference on the specified set of credentials.  The caller must
  * release the reference.
+ *
+ * This is used to deal with a committed set of credentials.  Although the
+ * pointer is const, this will temporarily discard the const and increment the
+ * usage count.  The purpose of this is to attempt to catch at compile time the
+ * accidental alteration of a set of credentials that should be considered
+ * immutable.
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
@@ -187,6 +193,10 @@ static inline const struct cred *get_cred(const struct cred *cred)
  *
  * Release a reference to a set of credentials, deleting them when the last ref
  * is released.
+ *
+ * This takes a const pointer to a set of credentials because the credentials
+ * on task_struct are attached by const pointers to prevent accidental
+ * alteration of otherwise immutable credential sets.
  */
 static inline void put_cred(const struct cred *_cred)
 {
diff --git a/kernel/cred.c b/kernel/cred.c
index decd080..9006c75 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -1,4 +1,4 @@
-/* Task credentials management
+/* Task credentials management - see Documentation/credentials.txt
  *
  * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)

