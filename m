Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYCHRXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYCHRXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYCHRW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:22:59 -0500
Received: from mail2.iitk.ac.in ([203.197.196.2]:42498 "EHLO mail2.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbYCHRW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:22:59 -0500
Date: Sat, 8 Mar 2008 22:52:47 +0530 (IST)
From: Arun Raghavan <arunsr@cse.iitk.ac.in>
X-X-Sender: arun@peripatetic.hades
To: linux-kernel@vger.kernel.org
cc: dhowells@redhat.com, satyam@infradead.org
Subject: [PATCH] keyring: Incorrect permissions checking in __keyring_search_one()
Message-ID: <Pine.LNX.4.64.0803082235430.27953@peripatetic.hades>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __keyring_search_one() function currently has 2 issues with regards
to permissions:

 1. It does not check for KEY_SEARCH on the keyring before performing a
    search

 2. It accepts a "perm" parameter to check whether a given key in the
    keyring may be returned. This is incorrect, because it *must* check
    for KEY_SEARCH on the key before considering it a candidate for a
    match (and only KEY_SEARCH, since it is merely a search function).
    In fact, it's only caller, key_create_or_update() passes 0 as the
    permissions to check for (=> a key will be returned even if it
    doesn't have KEY_SEARCH set)

The second was discovered by Satyam Sharma <satyam@infradead.org>. Here
is a patch that fixes both issues.

Signed-off-by: Arun Raghavan <arunsr@cse.iitk.ac.in>
Acked-by: Satyam Sharma <satyam@infradead.org>

diff --git a/security/keys/internal.h b/security/keys/internal.h
index d36d693..94bffb8 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -83,8 +83,7 @@ extern int __key_link(struct key *keyring, struct key *key);
 
 extern key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 				      const struct key_type *type,
-				      const char *description,
-				      key_perm_t perm);
+				      const char *description);
 
 extern struct key *keyring_search_instkey(struct key *keyring,
 					  key_serial_t target_id);
diff --git a/security/keys/key.c b/security/keys/key.c
index ca1d921..524249a 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -800,8 +800,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 	 * update that instead if possible
 	 */
 	if (ktype->update) {
-		key_ref = __keyring_search_one(keyring_ref, ktype, description,
-					       0);
+		key_ref = __keyring_search_one(keyring_ref, ktype, description);
 		if (!IS_ERR(key_ref))
 			goto found_matching_key;
 	}
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 88292e3..c7f6fd2 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -446,17 +446,22 @@ EXPORT_SYMBOL(keyring_search);
  */
 key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 			       const struct key_type *ktype,
-			       const char *description,
-			       key_perm_t perm)
+			       const char *description)
 {
 	struct keyring_list *klist;
 	unsigned long possessed;
 	struct key *keyring, *key;
 	int loop;
+	long err;
 
 	keyring = key_ref_to_ptr(keyring_ref);
 	possessed = is_key_possessed(keyring_ref);
 
+	/* the keyring must have search permission to begin the search */
+	err = key_permission(keyring_ref, KEY_SEARCH);
+	if (err < 0)
+		return ERR_PTR(err);
+
 	rcu_read_lock();
 
 	klist = rcu_dereference(keyring->payload.subscriptions);
@@ -468,7 +473,7 @@ key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 			    (!key->type->match ||
 			     key->type->match(key, description)) &&
 			    key_permission(make_key_ref(key, possessed),
-					   perm) == 0 &&
+					   KEY_SEARCH) == 0 &&
 			    !test_bit(KEY_FLAG_REVOKED, &key->flags)
 			    )
 				goto found;
