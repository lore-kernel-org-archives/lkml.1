Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab0BYKNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:13:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:40909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758958Ab0BYKN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:13:29 -0500
Date: Thu, 25 Feb 2010 10:12:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1266887105-1528-12-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-12-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] security: Apply lockdep-based checking to rcu_dereference() uses
Message-ID: <tip-e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe@git.kernel.org>
Git-Commit-ID: e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:12:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe
Gitweb:     http://git.kernel.org/tip/e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:56 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:52 +0100

security: Apply lockdep-based checking to rcu_dereference() uses

Apply lockdep-ified RCU primitives to key_gc_keyring() and
keyring_destroy().

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-12-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
