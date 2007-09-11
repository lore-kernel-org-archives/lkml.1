Return-Path: <linux-kernel-owner+w=401wt.eu-S933335AbXIKIuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbXIKIuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXIKIuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:50:44 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:53897 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311AbXIKIun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:50:43 -0400
Date: Tue, 11 Sep 2007 17:50:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] sysctl: Fix syscall disabled build.
Message-ID: <20070911085027.GA19770@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

deprecated_sysctl_warning() is used for sys_sysctl(), whether
CONFIG_SYSCTL_SYSCALL is enabled or not. When it was added, it was
added under the CONFIG_SYSCTL section, so it's not defined if we have
the support disabled completely.

  CC      kernel/sysctl.o
kernel/sysctl.c: In function 'sys_sysctl':
kernel/sysctl.c:2601: error: implicit declaration of function 'deprecated_sysctl_warning'
make[1]: *** [kernel/sysctl.o] Error 1
make: *** [kernel] Error 2

This just moves the function past the end of the CONFIG_SYSCTL space
so both configurations are happy.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 kernel/sysctl.c |   56 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

--- linux-2.6.23-rc4-mm1.orig/kernel/sysctl.c	2007-09-11 15:15:56.000000000 +0900
+++ linux-2.6.23-rc4-mm1/kernel/sysctl.c	2007-09-11 17:43:36.000000000 +0900
@@ -55,6 +55,8 @@
 #include <asm/stacktrace.h>
 #endif
 
+static int deprecated_sysctl_warning(struct __sysctl_args *args);
+
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
@@ -1330,33 +1332,6 @@
 	return NULL;
 }
 
-static int deprecated_sysctl_warning(struct __sysctl_args *args)
-{
-	static int msg_count;
-	int name[CTL_MAXNAME];
-	int i;
-
-	/* Read in the sysctl name for better debug message logging */
-	for (i = 0; i < args->nlen; i++)
-		if (get_user(name[i], args->name + i))
-			return -EFAULT;
-
-	/* Ignore accesses to kernel.version */
-	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
-		return 0;
-
-	if (msg_count < 5) {
-		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the deprecated sysctl "
-			"system call with ", current->comm);
-		for (i = 0; i < args->nlen; i++)
-			printk("%d.", name[i]);
-		printk("\n");
-	}
-	return 0;
-}
-
 #ifdef CONFIG_SYSCTL_SYSCALL
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
@@ -2644,6 +2619,33 @@
 
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
+static int deprecated_sysctl_warning(struct __sysctl_args *args)
+{
+	static int msg_count;
+	int name[CTL_MAXNAME];
+	int i;
+
+	/* Read in the sysctl name for better debug message logging */
+	for (i = 0; i < args->nlen; i++)
+		if (get_user(name[i], args->name + i))
+			return -EFAULT;
+
+	/* Ignore accesses to kernel.version */
+	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return 0;
+
+	if (msg_count < 5) {
+		msg_count++;
+		printk(KERN_INFO
+			"warning: process `%s' used the deprecated sysctl "
+			"system call with ", current->comm);
+		for (i = 0; i < args->nlen; i++)
+			printk("%d.", name[i]);
+		printk("\n");
+	}
+	return 0;
+}
+
 /*
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
