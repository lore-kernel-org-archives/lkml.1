Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYDKXFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYDKXFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYDKXEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:04:55 -0400
Received: from mga07.intel.com ([143.182.124.22]:2594 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754212AbYDKXEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:04:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,643,1199692800"; 
   d="scan'208";a="230730288"
Date: Fri, 11 Apr 2008 16:05:36 -0700
From: mark gross <mgross@linux.intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC] Patch to add private notification data to block notifier.
Message-ID: <20080411230536.GA10992@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 11 Apr 2008 22:59:56.0497 (UTC) FILETIME=[C2BE5410:01C89C27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We where trying to get pm-qos to work with a wireless driver and found
that the idiom of passing the *dev in the callback (notification)
parameters was not supported.

This makes having drivers as clients of PM-QOS sort of a challenge.  The
driver writer would have to mimic code in md.c where it keeps a list of
all its instances and iterates over each upon notifier callback.  Not
that difficult but as the driver writers are so accustomed to having
there instance data passed to them by the callers its a pain.

The following patch adds a void * private_data to the notifier_block,
and an export for pm-qos to call.

this code compiles(tm), I want to get some feedback before I go too far
down this path.


thanks,

--mgross

Signed-off-by: mgross@linux.intel.com

---------------

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index f4df400..a14f0c0 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -51,6 +51,7 @@ struct notifier_block {
 	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
 	struct notifier_block *next;
 	int priority;
+	void *private_data;
 };
 
 struct atomic_notifier_head {
@@ -138,6 +139,9 @@ extern int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v);
 extern int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	unsigned long val, void *v, int nr_to_call, int *nr_calls);
+extern int __blocking_notifier_call_chain_parm(
+	struct blocking_notifier_head *nh, unsigned long val, int nr_to_call,
+	int *nr_calls);
 extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
 extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 643360d..6e5179d 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -80,6 +80,42 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 	return ret;
 }
 
+/**
+ * notifier_call_chain_param - Informs the registered notifiers about an event.
+ *	@nl:		Pointer to head of the blocking notifier chain
+ *	@val:		Value passed unmodified to notifier function
+ *	@v:		Pointer passed unmodified to notifier function
+ *	@nr_to_call:	Number of notifier functions to be called. Don't care
+ *			value of this parameter is -1.
+ *	@nr_calls:	Records the number of notifications sent. Don't care
+ *			value of this field is NULL.
+ *	@returns:	notifier_call_chain returns the value returned by the
+ *			last notifier function called.
+ */
+static int __kprobes notifier_call_chain_parm(struct notifier_block **nl,
+					unsigned long val, int nr_to_call,
+					int *nr_calls)
+{
+	int ret = NOTIFY_DONE;
+	struct notifier_block *nb, *next_nb;
+
+	nb = rcu_dereference(*nl);
+
+	while (nb && nr_to_call) {
+		next_nb = rcu_dereference(nb->next);
+		ret = nb->notifier_call(nb, val, nb->private_data);
+
+		if (nr_calls)
+			(*nr_calls)++;
+
+		if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK)
+			break;
+		nb = next_nb;
+		nr_to_call--;
+	}
+	return ret;
+}
+
 /*
  *	Atomic notifier chain routines.  Registration and unregistration
  *	use a spinlock, and call_chain is synchronized by RCU (no locks).
@@ -273,6 +309,44 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 }
 EXPORT_SYMBOL_GPL(__blocking_notifier_call_chain);
 
+/**
+ *	__blocking_notifier_call_chain_parm - Call functions in a blocking notifier chain
+ *	@nh: Pointer to head of the blocking notifier chain
+ *	@val: Value passed unmodified to notifier function
+ *	@nr_to_call: See comment for notifier_call_chain.
+ *	@nr_calls: See comment for notifier_call_chain.
+ *
+ *	Calls each function in a notifier chain in turn.  The functions
+ *	run in a process context, so they are allowed to block.
+ *
+ *	If the return value of the notifier can be and'ed
+ *	with %NOTIFY_STOP_MASK then blocking_notifier_call_chain()
+ *	will return immediately, with the return value of
+ *	the notifier function which halted execution.
+ *	Otherwise the return value is the return value
+ *	of the last notifier function called.
+ */
+int __blocking_notifier_call_chain_parm(struct blocking_notifier_head *nh,
+				   unsigned long val, int nr_to_call,
+				   int *nr_calls)
+{
+	int ret = NOTIFY_DONE;
+
+	/*
+	 * We check the head outside the lock, but if this access is
+	 * racy then it does not matter what the result of the test
+	 * is, we re-check the list after having taken the lock anyway:
+	 */
+	if (rcu_dereference(nh->head)) {
+		down_read(&nh->rwsem);
+		ret = notifier_call_chain_parm(&nh->head, val, nr_to_call,
+					nr_calls);
+		up_read(&nh->rwsem);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__blocking_notifier_call_chain_parm);
+
 int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v)
 {
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 0afe32b..005fb51 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -158,8 +158,9 @@ static void update_target(int target)
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (call_notifier)
-		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
-			(unsigned long) extreme_value, NULL);
+		__blocking_notifier_call_chain_parm(
+			pm_qos_array[target]->notifiers,
+			(unsigned long) extreme_value, -1, NULL);
 }
 
 static int register_pm_qos_misc(struct pm_qos_object *qos)
