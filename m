Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZLSO6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZLSO6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZLSO6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:58:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZLSO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:58:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091219358.549678091@firstfloor.org>
In-Reply-To: <20091219358.549678091@firstfloor.org>
To: torvalds@linux-foundation.org, akpm@osdl.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] SYSCTL: Warn once for every binary sysctl
Message-Id: <20091219145833.A2EE6B158A@basil.firstfloor.org>
Date: Sat, 19 Dec 2009 15:58:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even with my recent patch to not warn for CTL_KERN,KERN_VERSION there
is still the theoretical possibility that some program who uses another
binary sysctl regularly will get a flooded syslog.

Only warn once for every possible binary sysctl.

To avoid bloating the tables i used a high bit in `ctl_name' as a flag
bit.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sysctl_binary.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

Index: linux-2.6.33-rc1-ak/kernel/sysctl_binary.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sysctl_binary.c
+++ linux-2.6.33-rc1-ak/kernel/sysctl_binary.c
@@ -17,6 +17,8 @@
 #ifdef CONFIG_SYSCTL_SYSCALL
 
 struct bin_table;
+static void deprecated_sysctl_warning(struct bin_table *table,
+				      const int *name, int nlen);
 typedef ssize_t bin_convert_t(struct file *file,
 	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen);
 
@@ -36,9 +38,12 @@ static bin_convert_t bin_dn_node_address
 
 #define BUFSZ 256
 
+#define CTL_MASK 0xffffff /* upper 8 bits for flags */
+#define CTL_WARNED (1U << 30)
+
 struct bin_table {
 	bin_convert_t		*convert;
-	int			ctl_name;
+	int			ctl_name;	/* Some upper bits for flags */
 	const char		*procname;
 	struct bin_table	*child;
 };
@@ -1268,12 +1273,13 @@ repeat:
 	nlen--;
 	for ( ; table->convert; table++) {
 		int len = 0;
+		int cn = table->ctl_name & CTL_MASK;
 
 		/*
 		 * For a wild card entry map from ifindex to network
 		 * device name.
 		 */
-		if (!table->ctl_name) {
+		if (!cn) {
 #ifdef CONFIG_NET
 			struct net *net = current->nsproxy->net_ns;
 			struct net_device *dev;
@@ -1285,7 +1291,7 @@ repeat:
 			}
 #endif
 		/* Use the well known sysctl number to proc name mapping */
-		} else if (ctl_name == table->ctl_name) {
+		} else if (ctl_name == cn) {
 			len = strlen(table->procname);
 			memcpy(path, table->procname, len);
 		}
@@ -1338,6 +1344,8 @@ static ssize_t binary_sysctl(const int *
 	if (IS_ERR(pathname))
 		goto out;
 
+	deprecated_sysctl_warning(table, name, nlen);
+
 	/* How should the sysctl be accessed? */
 	if (oldval && oldlen && newval && newlen) {
 		flags = O_RDWR;
@@ -1394,8 +1402,8 @@ static ssize_t binary_sysctl(const int *
 
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
-
-static void deprecated_sysctl_warning(const int *name, int nlen)
+static void deprecated_sysctl_warning(struct bin_table *table,
+				      const int *name, int nlen)
 {
 	int i;
 
@@ -1406,6 +1414,14 @@ static void deprecated_sysctl_warning(co
 	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
 		return;
 
+	/*
+	 * Warn only once for every sysctl
+	 */
+	if (table->ctl_name & CTL_WARNED)
+		return;
+	/* Not atomic, but races are harmless */
+	table->ctl_name |= CTL_WARNED;
+
 	if (printk_ratelimit()) {
 		printk(KERN_INFO
 			"warning: process `%s' used the deprecated sysctl "
@@ -1431,7 +1447,6 @@ static ssize_t do_sysctl(int __user *arg
 		if (get_user(name[i], args_name + i))
 			return -EFAULT;
 
-	deprecated_sysctl_warning(name, nlen);
 
 	return binary_sysctl(name, nlen, oldval, oldlen, newval, newlen);
 }
