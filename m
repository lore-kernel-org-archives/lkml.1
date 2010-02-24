Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab0BXUFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:05:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab0BXUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 09/10] notifiers: __rcu annotations
Date: Wed, 24 Feb 2010 21:04:05 +0100
Message-Id: <1267041846-10469-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX1+BfRIoeObEVbJmoV5Zjq2S3BfCGM2odkIEn8/
 5RUDW7ogGF8YYQinX8WGV8/My7QR3CmZVm6mE4VTTbl0mljjIr
 XrIyk7gQnBsp/whEN2OXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/notifier.h |   10 +++++-----
 kernel/notifier.c        |   22 +++++++++++-----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index fee6c2f..f05f5e4 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -49,28 +49,28 @@
 
 struct notifier_block {
 	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
-	struct notifier_block *next;
+	struct notifier_block __rcu *next;
 	int priority;
 };
 
 struct atomic_notifier_head {
 	spinlock_t lock;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct blocking_notifier_head {
 	struct rw_semaphore rwsem;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct raw_notifier_head {
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 struct srcu_notifier_head {
 	struct mutex mutex;
 	struct srcu_struct srcu;
-	struct notifier_block *head;
+	struct notifier_block __rcu *head;
 };
 
 #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
diff --git a/kernel/notifier.c b/kernel/notifier.c
index acd24e7..c0e8489 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -18,43 +18,43 @@ BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
  *	are layered on top of these, with appropriate locking added.
  */
 
-static int notifier_chain_register(struct notifier_block **nl,
+static int notifier_chain_register(struct notifier_block __rcu **nl,
 		struct notifier_block *n)
 {
 	while ((*nl) != NULL) {
-		if (n->priority > (*nl)->priority)
+		if (n->priority > __rcu_dereference(*nl)->priority)
 			break;
-		nl = &((*nl)->next);
+		nl = __rcu_dereference(&((*nl)->next));
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
 	return 0;
 }
 
-static int notifier_chain_cond_register(struct notifier_block **nl,
+static int notifier_chain_cond_register(struct notifier_block __rcu **nl,
 		struct notifier_block *n)
 {
 	while ((*nl) != NULL) {
-		if ((*nl) == n)
+		if (__rcu_dereference(*nl) == n)
 			return 0;
-		if (n->priority > (*nl)->priority)
+		if (n->priority > __rcu_dereference(*nl)->priority)
 			break;
-		nl = &((*nl)->next);
+		nl = __rcu_dereference(&((*nl)->next));
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
 	return 0;
 }
 
-static int notifier_chain_unregister(struct notifier_block **nl,
+static int notifier_chain_unregister(struct notifier_block __rcu **nl,
 		struct notifier_block *n)
 {
 	while ((*nl) != NULL) {
-		if ((*nl) == n) {
+		if (__rcu_dereference(*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
 			return 0;
 		}
-		nl = &((*nl)->next);
+		nl = __rcu_dereference(&((*nl)->next));
 	}
 	return -ENOENT;
 }
@@ -71,7 +71,7 @@ static int notifier_chain_unregister(struct notifier_block **nl,
  *	@returns:	notifier_call_chain returns the value returned by the
  *			last notifier function called.
  */
-static int __kprobes notifier_call_chain(struct notifier_block **nl,
+static int __kprobes notifier_call_chain(struct notifier_block __rcu **nl,
 					unsigned long val, void *v,
 					int nr_to_call,	int *nr_calls)
 {
-- 
1.6.3.3

