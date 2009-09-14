Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZINQ0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZINQ0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZINQ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:26:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775AbZINQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:26:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Fix garbage collector
To: torvalds@osdl.org, jmorris@namei.org, eparis@redhat.com, mingo@elte.hu
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Mon, 14 Sep 2009 17:26:13 +0100
Message-ID: <20090914162613.9016.79225.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a number of problems with the new key garbage collector:

 (1) A rogue semicolon in keyring_gc() was causing the initial count of dead
     keys to be miscalculated.

 (2) A missing return in keyring_gc() meant that under certain circumstances,
     the keyring semaphore would be unlocked twice.

 (3) The key serial tree iterator (key_garbage_collector()) part of the garbage
     collector has been modified to:

     (a) Complete each scan of the keyrings before setting the new timer.

     (b) Only set the new timer for keys that have yet to expire.  This means
         that the new timer is now calculated correctly, and the gc doesn't
         get into a loop continually scanning for keys that have expired, and
         preventing other things from happening, like RCU cleaning up the old
         keyring contents.

     (c) Perform an extra scan if any keys were garbage collected in this one
     	 as a key might become garbage during a scan, and (b) could mean we
     	 don't set the timer again.

 (4) Made key_schedule_gc() take the time at which to do a collection run,
     rather than the time at which the key expires.  This means the collection
     of dead keys (key type unregistered) can happen immediately.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/gc.c      |   78 +++++++++++++++++++++++++++++++----------------
 security/keys/key.c     |    4 +-
 security/keys/keyctl.c  |    2 +
 security/keys/keyring.c |   24 +++++++++++---
 4 files changed, 73 insertions(+), 35 deletions(-)


diff --git a/security/keys/gc.c b/security/keys/gc.c
index 1e616ae..485fc62 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -26,8 +26,10 @@ static void key_garbage_collector(struct work_struct *);
 static DEFINE_TIMER(key_gc_timer, key_gc_timer_func, 0, 0);
 static DECLARE_WORK(key_gc_work, key_garbage_collector);
 static key_serial_t key_gc_cursor; /* the last key the gc considered */
+static bool key_gc_again;
 static unsigned long key_gc_executing;
 static time_t key_gc_next_run = LONG_MAX;
+static time_t key_gc_new_timer;
 
 /*
  * Schedule a garbage collection run
@@ -40,9 +42,7 @@ void key_schedule_gc(time_t gc_at)
 
 	kenter("%ld", gc_at - now);
 
-	gc_at += key_gc_delay;
-
-	if (now >= gc_at) {
+	if (gc_at <= now) {
 		schedule_work(&key_gc_work);
 	} else if (gc_at < key_gc_next_run) {
 		expires = jiffies + (gc_at - now) * HZ;
@@ -112,16 +112,18 @@ static void key_garbage_collector(struct work_struct *work)
 	struct rb_node *rb;
 	key_serial_t cursor;
 	struct key *key, *xkey;
-	time_t new_timer = LONG_MAX, limit;
+	time_t new_timer = LONG_MAX, limit, now;
 
-	kenter("");
+	now = current_kernel_time().tv_sec;
+	kenter("[%x,%ld]", key_gc_cursor, key_gc_new_timer - now);
 
 	if (test_and_set_bit(0, &key_gc_executing)) {
-		key_schedule_gc(current_kernel_time().tv_sec);
+		key_schedule_gc(current_kernel_time().tv_sec + 1);
+		kleave(" [busy; deferring]");
 		return;
 	}
 
-	limit = current_kernel_time().tv_sec;
+	limit = now;
 	if (limit > key_gc_delay)
 		limit -= key_gc_delay;
 	else
@@ -129,12 +131,19 @@ static void key_garbage_collector(struct work_struct *work)
 
 	spin_lock(&key_serial_lock);
 
-	if (RB_EMPTY_ROOT(&key_serial_tree))
-		goto reached_the_end;
+	if (unlikely(RB_EMPTY_ROOT(&key_serial_tree))) {
+		spin_unlock(&key_serial_lock);
+		clear_bit(0, &key_gc_executing);
+		return;
+	}
 
 	cursor = key_gc_cursor;
 	if (cursor < 0)
 		cursor = 0;
+	if (cursor > 0)
+		new_timer = key_gc_new_timer;
+	else
+		key_gc_again = false;
 
 	/* find the first key above the cursor */
 	key = NULL;
@@ -160,35 +169,50 @@ static void key_garbage_collector(struct work_struct *work)
 
 	/* trawl through the keys looking for keyrings */
 	for (;;) {
-		if (key->expiry > 0 && key->expiry < new_timer)
+		if (key->expiry > now && key->expiry < new_timer) {
+			kdebug("will expire %x in %ld",
+			       key_serial(key), key->expiry - now);
 			new_timer = key->expiry;
+		}
 
 		if (key->type == &key_type_keyring &&
-		    key_gc_keyring(key, limit)) {
-			/* the gc ate our lock */
-			schedule_work(&key_gc_work);
-			goto no_unlock;
-		}
+		    key_gc_keyring(key, limit))
+			/* the gc had to release our lock so that the keyring
+			 * could be modified, so we have to get it again */
+			goto gc_released_our_lock;
 
 		rb = rb_next(&key->serial_node);
-		if (!rb) {
-			key_gc_cursor = 0;
-			break;
-		}
+		if (!rb)
+			goto reached_the_end;
 		key = rb_entry(rb, struct key, serial_node);
 	}
 
-out:
-	spin_unlock(&key_serial_lock);
-no_unlock:
+gc_released_our_lock:
+	kdebug("gc_released_our_lock");
+	key_gc_new_timer = new_timer;
+	key_gc_again = true;
 	clear_bit(0, &key_gc_executing);
-	if (new_timer < LONG_MAX)
-		key_schedule_gc(new_timer);
-
-	kleave("");
+	schedule_work(&key_gc_work);
+	kleave(" [continue]");
 	return;
 
+	/* when we reach the end of the run, we set the timer for the next one */
 reached_the_end:
+	kdebug("reached_the_end");
+	spin_unlock(&key_serial_lock);
+	key_gc_new_timer = new_timer;
 	key_gc_cursor = 0;
-	goto out;
+	clear_bit(0, &key_gc_executing);
+
+	if (key_gc_again) {
+		/* there may have been a key that expired whilst we were
+		 * scanning, so if we discarded any links we should do another
+		 * scan */
+		new_timer = now + 1;
+		key_schedule_gc(new_timer);
+	} else if (new_timer < LONG_MAX) {
+		new_timer += key_gc_delay;
+		key_schedule_gc(new_timer);
+	}
+	kleave(" [end]");
 }
diff --git a/security/keys/key.c b/security/keys/key.c
index 08531ad..e50d264 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -500,7 +500,7 @@ int key_negate_and_link(struct key *key,
 		set_bit(KEY_FLAG_INSTANTIATED, &key->flags);
 		now = current_kernel_time();
 		key->expiry = now.tv_sec + timeout;
-		key_schedule_gc(key->expiry);
+		key_schedule_gc(key->expiry + key_gc_delay);
 
 		if (test_and_clear_bit(KEY_FLAG_USER_CONSTRUCT, &key->flags))
 			awaken = 1;
@@ -909,7 +909,7 @@ void key_revoke(struct key *key)
 	time = now.tv_sec;
 	if (key->revoked_at == 0 || key->revoked_at > time) {
 		key->revoked_at = time;
-		key_schedule_gc(key->revoked_at);
+		key_schedule_gc(key->revoked_at + key_gc_delay);
 	}
 
 	up_write(&key->sem);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 60983f3..2fb28ef 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1115,7 +1115,7 @@ long keyctl_set_timeout(key_serial_t id, unsigned timeout)
 	}
 
 	key->expiry = expiry;
-	key_schedule_gc(key->expiry);
+	key_schedule_gc(key->expiry + key_gc_delay);
 
 	up_write(&key->sem);
 	key_put(key);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index ac977f6..8ec0274 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1019,18 +1019,18 @@ void keyring_gc(struct key *keyring, time_t limit)
 	struct key *key;
 	int loop, keep, max;
 
-	kenter("%x", key_serial(keyring));
+	kenter("{%x,%s}", key_serial(keyring), keyring->description);
 
 	down_write(&keyring->sem);
 
 	klist = keyring->payload.subscriptions;
 	if (!klist)
-		goto just_return;
+		goto no_klist;
 
 	/* work out how many subscriptions we're keeping */
 	keep = 0;
 	for (loop = klist->nkeys - 1; loop >= 0; loop--)
-		if (!key_is_dead(klist->keys[loop], limit));
+		if (!key_is_dead(klist->keys[loop], limit))
 			keep++;
 
 	if (keep == klist->nkeys)
@@ -1041,7 +1041,7 @@ void keyring_gc(struct key *keyring, time_t limit)
 	new = kmalloc(sizeof(struct keyring_list) + max * sizeof(struct key *),
 		      GFP_KERNEL);
 	if (!new)
-		goto just_return;
+		goto nomem;
 	new->maxkeys = max;
 	new->nkeys = 0;
 	new->delkey = 0;
@@ -1081,7 +1081,21 @@ void keyring_gc(struct key *keyring, time_t limit)
 discard_new:
 	new->nkeys = keep;
 	keyring_clear_rcu_disposal(&new->rcu);
+	up_write(&keyring->sem);
+	kleave(" [discard]");
+	return;
+
 just_return:
 	up_write(&keyring->sem);
-	kleave(" [no]");
+	kleave(" [no dead]");
+	return;
+
+no_klist:
+	up_write(&keyring->sem);
+	kleave(" [no_klist]");
+	return;
+
+nomem:
+	up_write(&keyring->sem);
+	kleave(" [oom]");
 }

