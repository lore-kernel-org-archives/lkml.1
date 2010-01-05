Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642Ab0AECRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0AECRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246Ab0AECPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:15:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43065 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0AECP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
In-Reply-To: <20100105315.789846878@firstfloor.org>
To: ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/9] SYSCTL: Add proc_rcu_string to manage sysctls using rcu strings
Message-Id: <20100105021528.1D752B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 03:15:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a helper to use the new rcu strings for managing access
to text sysctls. Conversions will be in follow-on patches.

An alternative would be to use seqlocks here, but RCU seemed
cleaner.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/sysctl.h |    2 +
 kernel/sysctl.c        |   66 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl_check.c  |    1 
 3 files changed, 69 insertions(+)

Index: linux-2.6.33-rc2-ak/include/linux/sysctl.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/sysctl.h
+++ linux-2.6.33-rc2-ak/include/linux/sysctl.h
@@ -969,6 +969,8 @@ typedef int proc_handler (struct ctl_tab
 
 extern int proc_dostring(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
+extern int proc_rcu_string(struct ctl_table *, int,
+			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
Index: linux-2.6.33-rc2-ak/kernel/sysctl.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/sysctl.c
+++ linux-2.6.33-rc2-ak/kernel/sysctl.c
@@ -50,6 +50,7 @@
 #include <linux/ftrace.h>
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
+#include <linux/rcustring.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -2016,6 +2017,60 @@ static int _proc_do_string(void* data, i
 }
 
 /**
+ * proc_rcu_string - sysctl string with rcu protection
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Handle a string sysctl similar to proc_dostring.
+ * The main difference is that the data pointer in the table
+ * points to a pointer to a string. The string should be initially
+ * pointing to a statically allocated (as a C object, not on the heap)
+ * default. When it is replaced old uses will be protected by
+ * RCU. The reader should use rcu_read_lock()/unlock() or
+ * access_rcu_string().
+ */
+int proc_rcu_string(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	if (write) {
+		/* protect writers against each other */
+		static DEFINE_MUTEX(rcu_string_mutex);
+		char *old;
+		char *new;
+
+		new = alloc_rcu_string(table->maxlen, GFP_KERNEL);
+		if (!new)
+			return -ENOMEM;
+		mutex_lock(&rcu_string_mutex);
+		old = *(char **)(table->data);
+		strcpy(new, old);
+		ret = _proc_do_string(new, table->maxlen, write, buffer, lenp, ppos);
+		rcu_assign_pointer(*(char **)(table->data), new);
+		/*
+		 * For the first initialization allow constant strings.
+		 */
+		if (!kernel_address((unsigned long)old))
+			free_rcu_string(old);
+		mutex_unlock(&rcu_string_mutex);
+	} else {
+		char *str;
+
+		str = access_rcu_string((char **)(table->data), table->maxlen,
+					GFP_KERNEL);
+		if (!str)
+			return -ENOMEM;
+		ret = _proc_do_string(str, table->maxlen, write, buffer, lenp, ppos);
+		kfree(str);
+	}
+	return ret;
+}
+
+/**
  * proc_dostring - read a string sysctl
  * @table: the sysctl table
  * @write: %TRUE if this is a write to the sysctl file
@@ -2030,6 +2085,10 @@ static int _proc_do_string(void* data, i
  * and a newline '\n' is added. It is truncated if the buffer is
  * not large enough.
  *
+ * WARNING: this should be only used for read only strings
+ * or when you have a wrapper with special locking. Otherwise
+ * use proc_rcu_string to avoid races with the consumer.
+ *
  * Returns 0 on success.
  */
 int proc_dostring(struct ctl_table *table, int write,
@@ -2614,6 +2673,12 @@ int proc_dostring(struct ctl_table *tabl
 	return -ENOSYS;
 }
 
+int proc_rcu_string(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2670,6 +2735,7 @@ EXPORT_SYMBOL(proc_dointvec_minmax);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
 EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_dostring);
+EXPORT_SYMBOL(proc_rcu_string);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
 EXPORT_SYMBOL(register_sysctl_table);
Index: linux-2.6.33-rc2-ak/kernel/sysctl_check.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/sysctl_check.c
+++ linux-2.6.33-rc2-ak/kernel/sysctl_check.c
@@ -131,6 +131,7 @@ int sysctl_check_table(struct nsproxy *n
 				set_fail(&fail, table, "Directory with extra2");
 		} else {
 			if ((table->proc_handler == proc_dostring) ||
+			    (table->proc_handler == proc_rcu_string) ||
 			    (table->proc_handler == proc_dointvec) ||
 			    (table->proc_handler == proc_dointvec_minmax) ||
 			    (table->proc_handler == proc_dointvec_jiffies) ||
