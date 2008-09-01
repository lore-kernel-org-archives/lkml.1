Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYIAQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYIAQqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYIAQqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:46:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55135 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYIAQqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:46:34 -0400
Date: Mon, 1 Sep 2008 18:46:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Make taint bit reliable
Message-ID: <20080901164632.GA18159@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make taint bit reliable

It's somewhat unlikely that it happens, but right now a race window 
between interrupts or machine checks or oopses could corrupt the tainted 
bitmap because it is modified in a non atomic fashion.

Convert the taint variable to an unsigned long and use only atomic bit
operations on it.

Unfortunately this means the intvec sysctl functions cannot be used on 
it anymore.

It turned out the taint sysctl handler could actually be simplified
a bit (since it only increases capabilities) so this patch actually
removes code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kernel.h |    2 -
 kernel/panic.c         |    5 ++-
 kernel/sysctl.c        |   67 +++++++++++++++++++++----------------------------
 3 files changed, 33 insertions(+), 41 deletions(-)

Index: linux/kernel/panic.c
===================================================================
--- linux.orig/kernel/panic.c
+++ linux/kernel/panic.c
@@ -21,9 +21,10 @@
 #include <linux/debug_locks.h>
 #include <linux/random.h>
 #include <linux/kallsyms.h>
+#include <linux/log2.h>
 
 int panic_on_oops;
-int tainted;
+unsigned long tainted;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -194,7 +195,7 @@ const char *print_tainted(void)
 void add_taint(unsigned flag)
 {
 	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
-	tainted |= flag;
+	set_bit(ilog2(flag), &tainted);
 }
 EXPORT_SYMBOL(add_taint);
 
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -152,7 +152,7 @@ extern int max_lock_depth;
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+static int proc_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -382,9 +382,9 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "tainted",
 		.data		= &tainted,
-		.maxlen		= sizeof(int),
+		.maxlen 	= sizeof(long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_taint,
+		.proc_handler	= &proc_taint,
 	},
 #endif
 #ifdef CONFIG_LATENCYTOP
@@ -2236,49 +2236,39 @@ int proc_dointvec(struct ctl_table *tabl
 		    	    NULL,NULL);
 }
 
-#define OP_SET	0
-#define OP_AND	1
-#define OP_OR	2
-
-static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
-				      int *valp,
-				      int write, void *data)
-{
-	int op = *(int *)data;
-	if (write) {
-		int val = *negp ? -*lvalp : *lvalp;
-		switch(op) {
-		case OP_SET:	*valp = val; break;
-		case OP_AND:	*valp &= val; break;
-		case OP_OR:	*valp |= val; break;
-		}
-	} else {
-		int val = *valp;
-		if (val < 0) {
-			*negp = -1;
-			*lvalp = (unsigned long)-val;
-		} else {
-			*negp = 0;
-			*lvalp = (unsigned long)val;
-		}
-	}
-	return 0;
-}
-
 /*
- *	Taint values can only be increased
+ * Taint values can only be increased
+ * This means we can safely use a temporary.
  */
-static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+static int proc_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int op;
+	struct ctl_table t;
+	unsigned long tmptaint = tainted;
+	int err;
 
 	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	op = OP_OR;
-	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
-				do_proc_dointvec_bset_conv,&op);
+	t = *table;
+	t.data = &tmptaint;
+	err = proc_doulongvec_minmax(&t, write, filp, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+
+	if (write) {
+		/*
+		 * Poor man's atomic or. Not worth adding a primitive
+		 * to everyone's atomic.h for this
+		 */
+		int i;
+		for (i = 0; i < BITS_PER_LONG && tmptaint >> i; i++) {
+			if ((tmptaint >> i) & 1)
+				set_bit(i, &tainted);
+		}
+	}
+
+	return err;
 }
 
 struct do_proc_dointvec_minmax_conv_param {
Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -235,7 +235,7 @@ extern int oops_in_progress;		/* If set,
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
-extern int tainted;
+extern unsigned long tainted;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned);
 extern int root_mountflags;
