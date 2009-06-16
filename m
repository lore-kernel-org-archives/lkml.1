Return-Path: <linux-kernel-owner+w=401wt.eu-S1764427AbZFPUoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764427AbZFPUoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbZFPUkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59625 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762998AbZFPUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/17] KEYS: Add a function by which the contents of a keyring
	can be enumerated
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:40:08 +0100
Message-ID: <20090616204008.4526.31983.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function by which the contents of a keyring can be enumerated.

This allows AFS's VIOCGETTOK/PGetTokens pioctl to list the AFS RxRPC keys on
behalf of userspace.

The following text is added to Documentation/keys.txt:

(*) The contents of a keyring may be enumerated by the following function:

	typedef bool (*keyring_enum_filter_t)(const struct key *key,
					      void *filter_data);
	key_ref_t keyring_enum(key_ref_t keyring_ref,
			       unsigned skip,
			       keyring_enum_filter_t filter,
 			       void *filter_data,
			       key_perm_t perm)

    This scans the keyring in question for keys for which the caller has the
    specified permissions and that match the filter provided.  It returns a
    reference to the first of those keys, after the specified quantity of them
    have been skipped.  If no key is found error ENOKEY will be returned.

    If the keyring is invalid or unsearchable, error ENOTDIR or EACCES will be
    returned.

    The filter function should return true if the key it is passed is a match,
    and false if it is not.  The filter_data passed to keyring_enum() will be
    passed on to the filter function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt  |   23 +++++++++++++++++
 include/linux/key.h     |    5 ++++
 security/keys/keyring.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 0 deletions(-)


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index 35618d1..77bbe07 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -947,6 +947,29 @@ payload contents" for more information.
     reference pointer if successful.
 
 
+(*) The contents of a keyring may be enumerated by the following function:
+
+	typedef bool (*keyring_enum_filter_t)(const struct key *key,
+					      void *filter_data);
+	key_ref_t keyring_enum(key_ref_t keyring_ref,
+			       unsigned skip,
+			       keyring_enum_filter_t filter,
+ 			       void *filter_data,
+			       key_perm_t perm)
+
+    This scans the keyring in question for keys for which the caller has the
+    specified permissions and that match the filter provided.  It returns a
+    reference to the first of those keys, after the specified quantity of them
+    have been skipped.  If no key is found error ENOKEY will be returned.
+
+    If the keyring is invalid or unsearchable, error ENOTDIR or EACCES will be
+    returned.
+
+    The filter function should return true if the key it is passed is a match,
+    and false if it is not.  The filter_data passed to keyring_enum() will be
+    passed on to the filter function.
+
+
 (*) To check the validity of a key, this function can be called:
 
 	int validate_key(struct key *key);
diff --git a/include/linux/key.h b/include/linux/key.h
index 4d8cc1e..6d41a4e 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -273,6 +273,11 @@ extern key_ref_t keyring_search(key_ref_t keyring,
 extern int keyring_add_key(struct key *keyring,
 			   struct key *key);
 
+typedef bool (*keyring_enum_filter_t)(const struct key *key, void *data);
+extern key_ref_t keyring_enum(key_ref_t keyring_r, unsigned skip,
+			      keyring_enum_filter_t filter, void *filter_data,
+			      key_perm_t perm);
+
 extern struct key *key_lookup(key_serial_t id);
 
 static inline key_serial_t key_serial(struct key *key)
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 97529ab..c83ab26 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1000,3 +1000,68 @@ static void keyring_revoke(struct key *keyring)
 	}
 
 } /* end keyring_revoke() */
+
+/**
+ * keyring_enum -  Allow enumeration of a keyring
+ * @keyring_ref: The keyring to search
+ * @skip: Number of matching keys to skip
+ * @filter: A function to filter out unwanted matches
+ * @filter_data: Data to be passed to filter()
+ * @perm: The permissions desired on the key
+ *
+ * Allow the caller to enumerate a keyring by getting the (skip+1)'th
+ * permissible key that matched a particular filter.
+ *
+ * The caller must lock the keyring if they don't want the contents to change
+ * between calls.
+ */
+key_ref_t keyring_enum(key_ref_t keyring_ref, unsigned skip,
+		       keyring_enum_filter_t filter, void *filter_data,
+		       key_perm_t perm)
+{
+	struct keyring_list *klist;
+	unsigned long possessed;
+	struct key *keyring, *key;
+	long ret;
+	int loop;
+
+	key_check(keyring);
+
+	/* top keyring must have search permission to begin the search */
+        ret = key_permission(keyring_ref, WANT_KEY_SEARCH);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	keyring = key_ref_to_ptr(keyring_ref);
+	if (keyring->type != &key_type_keyring)
+		return ERR_PTR(-ENOTDIR);
+
+	possessed = is_key_possessed(keyring_ref);
+
+	rcu_read_lock();
+
+	klist = rcu_dereference(keyring->payload.subscriptions);
+	if (klist) {
+		for (loop = 0; loop < klist->nkeys; loop++) {
+			key = klist->keys[loop];
+
+			if (!filter(key, filter_data) ||
+			    key_permission(make_key_ref(key, possessed),
+					   perm) != 0 ||
+			    test_bit(KEY_FLAG_REVOKED, &key->flags))
+				continue;
+			if (skip == 0)
+				goto found;
+			skip--;
+		}
+	}
+
+	rcu_read_unlock();
+	return ERR_PTR(-ENOKEY);
+
+ found:
+	atomic_inc(&key->usage);
+	rcu_read_unlock();
+	return make_key_ref(key, possessed);
+}
+EXPORT_SYMBOL(keyring_enum);

