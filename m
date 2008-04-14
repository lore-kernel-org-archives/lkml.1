Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbYDNQOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbYDNQOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbYDNQNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:13:55 -0400
Received: from mga07.intel.com ([143.182.124.22]:49799 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755892AbYDNQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:13:54 -0400
X-ExtLoop1: 1
Date: Mon, 14 Apr 2008 09:19:18 -0700
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH]add private data to struct notifier_bock
Message-ID: <20080414161918.GA4286@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 14 Apr 2008 16:13:40.0946 (UTC) FILETIME=[8105AB20:01C89E4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working with one of the iwl4965 developers to add pm_qos based
power management to its power states.  We relalized that the block
notifier I used in the PM_QOS has no way of passing in any driver device
instance data.  In this case the developer expected the notification
call backs to call the iwl4965 notification function with an instance
pointer to the correct *dev.

Poking around I've noticed a handful of drivers using notifications that
seem to keep a list of instance pointers around so it can plug into the
notification infrastructure.  including : ipmi_msghandler.c adb_hid.c
md.c ips.c

As having a registered call back called with a private data pointer set
up at registration time  is such a common idiom I thought it might be a
good thing to add a private_data pointer to the struct notifier_block
and add the interfaces needed to pass the private data as the
notification chain is processed.

please consider adding this to the mm-tree to get some eyeballs on it.
I've boot tested this code and will be testing its use within the
iwl4965 when the iwl4965 developer is ready.

Thanks,

--mgross

Signed-off-by: mgross@linux.intel.com


diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index f4df400..995dcda 100644
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
+extern int __blocking_notifier_call_chain_param(
+	struct blocking_notifier_head *nh, unsigned long val, int nr_to_call,
+		int *nr_calls);
 extern int raw_notifier_call_chain(struct raw_notifier_head *nh,
 		unsigned long val, void *v);
 extern int __raw_notifier_call_chain(struct raw_notifier_head *nh,
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 643360d..c1b5127 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -80,6 +80,41 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 	return ret;
 }
 
+/**
+ * notifier_call_chain_param - Informs the registered notifiers about an event.
+ *	@nl:		Pointer to head of the blocking notifier chain
+ *	@val:		Value passed unmodified to notifier function
+ *	@nr_to_call:	Number of notifier functions to be called. Don't care
+ *			value of this parameter is -1.
+ *	@nr_calls:	Records the number of notifications sent. Don't care
+ *			value of this field is NULL.
+ *	@returns:	notifier_call_chain returns the value returned by the
+ *			last notifier function called.
+ */
+static int __kprobes notifier_call_chain_param(struct notifier_block **nl,
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
@@ -273,6 +308,45 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 }
 EXPORT_SYMBOL_GPL(__blocking_notifier_call_chain);
 
+/**
+ *	__blocking_notifier_call_chain_param - Call functions in a blocking
+ *	notifier chain
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
+int __blocking_notifier_call_chain_param(struct blocking_notifier_head *nh,
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
+		ret = notifier_call_chain_param(&nh->head, val, nr_to_call,
+					nr_calls);
+		up_read(&nh->rwsem);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__blocking_notifier_call_chain_param);
+
 int blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 		unsigned long val, void *v)
 {
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 0afe32b..cffd8bc 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -158,8 +158,9 @@ static void update_target(int target)
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (call_notifier)
-		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
-			(unsigned long) extreme_value, NULL);
+		__blocking_notifier_call_chain_param(
+			pm_qos_array[target]->notifiers,
+			(unsigned long) extreme_value, -1, NULL);
 }
 
 static int register_pm_qos_misc(struct pm_qos_object *qos)
