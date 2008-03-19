Return-Path: <linux-kernel-owner+w=401wt.eu-S936274AbYCSWob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274AbYCSWob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbYCSVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:14:39 -0400
Received: from mail2.iitk.ac.in ([203.197.196.2]:59400 "EHLO mail2.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765036AbYCSVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:14:38 -0400
Date: Thu, 20 Mar 2008 02:44:21 +0530 (IST)
From: Arun Raghavan <arunsr@cse.iitk.ac.in>
X-X-Sender: arun@peripatetic.hades
To: linux-kernel@vger.kernel.org
cc: dhowells@redhat.com
Subject: [PATCH] [keys] Always use key_get() to increment key refcount
Message-ID: <Pine.LNX.4.64.0803200227440.22605@peripatetic.hades>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to use key_get() wherever the keys code manually increments the
key refcount.

This should make debugging a little simpler for clients, since it
becomes easier to track where a key's refcount changes.

Signed-off-by: Arun Raghavan <arunsr@cse.iitk.ac.in>

diff --git a/security/keys/key.c b/security/keys/key.c
index ca1d921..8b51c39 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -661,7 +661,7 @@ struct key *key_lookup(key_serial_t id)
 	/* this races with key_put(), but that doesn't matter since key_put()
 	 * doesn't actually change the key
 	 */
-	atomic_inc(&key->usage);
+	key_get(key);
 
  error:
 	spin_unlock(&key_serial_lock);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 88292e3..5f31eb7 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -405,7 +405,7 @@ not_this_keyring:
 
 	/* we found a viable match */
 found:
-	atomic_inc(&key->usage);
+	key_get(key);
 	key_check(key);
 	key_ref = make_key_ref(key, possessed);
 error_2:
@@ -479,7 +479,7 @@ key_ref_t __keyring_search_one(key_ref_t keyring_ref,
 	return ERR_PTR(-ENOKEY);
 
  found:
-	atomic_inc(&key->usage);
+	key_get(key);
 	rcu_read_unlock();
 	return make_key_ref(key, possessed);
 
@@ -528,7 +528,7 @@ struct key *find_keyring_by_name(const char *name, key_serial_t bound)
 				continue;
 
 			/* we've got a match */
-			atomic_inc(&keyring->usage);
+			key_get(keyring);
 			read_unlock(&keyring_name_lock);
 			goto error;
 		}
@@ -713,7 +713,7 @@ int __key_link(struct key *keyring, struct key *key)
 					goto error2;
 
 				/* replace matched key */
-				atomic_inc(&key->usage);
+				key_get(key);
 				nklist->keys[loop] = key;
 
 				rcu_assign_pointer(
@@ -741,7 +741,7 @@ int __key_link(struct key *keyring, struct key *key)
 
 	if (klist && klist->nkeys < klist->maxkeys) {
 		/* there's sufficient slack space to add directly */
-		atomic_inc(&key->usage);
+		key_get(key);
 
 		klist->keys[klist->nkeys] = key;
 		smp_wmb();
@@ -776,7 +776,7 @@ int __key_link(struct key *keyring, struct key *key)
 		}
 
 		/* add the key into the new space */
-		atomic_inc(&key->usage);
+		key_get(key);
 		nklist->keys[nklist->nkeys++] = key;
 
 		rcu_assign_pointer(keyring->payload.subscriptions, nklist);
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 2a0eb94..2b29cce 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -232,7 +232,7 @@ static int install_session_keyring(struct task_struct *tsk,
 			return PTR_ERR(keyring);
 	}
 	else {
-		atomic_inc(&keyring->usage);
+		key_get(keyring);
 	}
 
 	/* install the keyring */
@@ -589,7 +589,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		}
 
 		key = context->thread_keyring;
-		atomic_inc(&key->usage);
+		key_get(key);
 		key_ref = make_key_ref(key, 1);
 		break;
 
@@ -606,7 +606,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		}
 
 		key = context->signal->process_keyring;
-		atomic_inc(&key->usage);
+		key_get(key);
 		key_ref = make_key_ref(key, 1);
 		break;
 
@@ -622,20 +622,20 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 
 		rcu_read_lock();
 		key = rcu_dereference(context->signal->session_keyring);
-		atomic_inc(&key->usage);
+		key_get(key);
 		rcu_read_unlock();
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
 		key = context->user->uid_keyring;
-		atomic_inc(&key->usage);
+		key_get(key);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
 		key = context->user->session_keyring;
-		atomic_inc(&key->usage);
+		key_get(key);
 		key_ref = make_key_ref(key, 1);
 		break;
 
@@ -649,7 +649,7 @@ key_ref_t lookup_user_key(struct task_struct *context, key_serial_t id,
 		if (!key)
 			goto error;
 
-		atomic_inc(&key->usage);
+		key_get(key);
 		key_ref = make_key_ref(key, 1);
 		break;
 
