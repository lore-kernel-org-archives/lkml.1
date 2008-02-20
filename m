Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbYBTQN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbYBTQN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764843AbYBTQJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:09:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762819AbYBTQIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:08:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/37] KEYS: Check starting keyring as part of search
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:09 +0000
Message-ID: <20080220160608.4715.31033.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the starting keyring as part of the search to (a) see if that is what
we're searching for, and (b) to check it is still valid for searching.

The scenario:  User in process A does things that cause things to be
created in its process session keyring.  The user then does an su to
another user and starts a new process, B.  The two processes now
share the same process session keyring.

Process B does an NFS access which results in an upcall to gssd.
When gssd attempts to instantiate the context key (to be linked
into the process session keyring), it is denied access even though it
has an authorization key.

The order of calls is:

   keyctl_instantiate_key()
      lookup_user_key()				    (the default: case)
         search_process_keyrings(current)
	    search_process_keyrings(rka->context)   (recursive call)
	       keyring_search_aux()

keyring_search_aux() verifies the keys and keyrings underneath the
top-level keyring it is given, but that top-level keyring is neither
fully validated nor checked to see if it is the thing being searched for.

This patch changes keyring_search_aux() to:
1) do more validation on the top keyring it is given and
2) check whether that top-level keyring is the thing being searched for


Signed-off-by: Kevin Coffman <kwc@citi.umich.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyring.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)


diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 88292e3..76b89b2 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -292,7 +292,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 
 	struct keyring_list *keylist;
 	struct timespec now;
-	unsigned long possessed;
+	unsigned long possessed, kflags;
 	struct key *keyring, *key;
 	key_ref_t key_ref;
 	long err;
@@ -318,6 +318,32 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
 	now = current_kernel_time();
 	err = -EAGAIN;
 	sp = 0;
+	
+	/* firstly we should check to see if this top-level keyring is what we
+	 * are looking for */
+	key_ref = ERR_PTR(-EAGAIN);
+	kflags = keyring->flags;
+	if (keyring->type == type && match(keyring, description)) {
+		key = keyring;
+
+		/* check it isn't negative and hasn't expired or been
+		 * revoked */
+		if (kflags & (1 << KEY_FLAG_REVOKED))
+			goto error_2;
+		if (key->expiry && now.tv_sec >= key->expiry)
+			goto error_2;
+		key_ref = ERR_PTR(-ENOKEY);
+		if (kflags & (1 << KEY_FLAG_NEGATIVE))
+			goto error_2;
+		goto found;
+	}
+
+	/* otherwise, the top keyring must not be revoked, expired, or
+	 * negatively instantiated if we are to search it */
+	key_ref = ERR_PTR(-EAGAIN);
+	if (kflags & ((1 << KEY_FLAG_REVOKED) | (1 << KEY_FLAG_NEGATIVE)) ||
+	    (keyring->expiry && now.tv_sec >= keyring->expiry))
+		goto error_2;
 
 	/* start processing a new keyring */
 descend:
@@ -331,13 +357,14 @@ descend:
 	/* iterate through the keys in this keyring first */
 	for (kix = 0; kix < keylist->nkeys; kix++) {
 		key = keylist->keys[kix];
+		kflags = key->flags;
 
 		/* ignore keys not of this type */
 		if (key->type != type)
 			continue;
 
 		/* skip revoked keys and expired keys */
-		if (test_bit(KEY_FLAG_REVOKED, &key->flags))
+		if (kflags & (1 << KEY_FLAG_REVOKED))
 			continue;
 
 		if (key->expiry && now.tv_sec >= key->expiry)
@@ -352,8 +379,8 @@ descend:
 					context, KEY_SEARCH) < 0)
 			continue;
 
-		/* we set a different error code if we find a negative key */
-		if (test_bit(KEY_FLAG_NEGATIVE, &key->flags)) {
+		/* we set a different error code if we pass a negative key */
+		if (kflags & (1 << KEY_FLAG_NEGATIVE)) {
 			err = -ENOKEY;
 			continue;
 		}

