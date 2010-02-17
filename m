Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0BQUd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:33:26 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38853 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab0BQUaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:30:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/18] security: apply lockdep-based checking to rcu_dereference() uses
Date: Wed, 17 Feb 2010 12:29:38 -0800
Message-Id: <1266438584-29173-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100217202924.GA29007@linux.vnet.ibm.com>
References: <20100217202924.GA29007@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply lockdep-ified RCU primitives to key_gc_keyring() and
keyring_destroy().

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 security/keys/gc.c      |    3 ++-
 security/keys/keyring.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index 4770be3..1990231 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -77,7 +77,8 @@ static bool key_gc_keyring(struct key *keyring, time_t limit)
 		goto dont_gc;
 
 	/* scan the keyring looking for dead keys */
-	klist = rcu_dereference(keyring->payload.subscriptions);
+	klist = rcu_dereference_check(keyring->payload.subscriptions,
+				      lockdep_is_held(&key_serial_lock));
 	if (!klist)
 		goto dont_gc;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 8ec0274..e814d21 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -151,7 +151,9 @@ static void keyring_destroy(struct key *keyring)
 		write_unlock(&keyring_name_lock);
 	}
 
-	klist = rcu_dereference(keyring->payload.subscriptions);
+	klist = rcu_dereference_check(keyring->payload.subscriptions,
+				      rcu_read_lock_held() ||
+				      atomic_read(&keyring->usage) == 0);
 	if (klist) {
 		for (loop = klist->nkeys - 1; loop >= 0; loop--)
 			key_put(klist->keys[loop]);
-- 
1.6.6

