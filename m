Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbXIZPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbXIZPtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXIZPto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:49:44 -0400
Received: from sacred.ru ([62.205.161.221]:46403 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbXIZPtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:49:43 -0400
Message-ID: <46FA7EC8.3020800@openvz.org>
Date: Wed, 26 Sep 2007 19:46:16 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Serge Hallyn <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] Move the UST namespace under the option
References: <46FA7D4D.8040808@openvz.org>
In-Reply-To: <46FA7D4D.8040808@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 26 Sep 2007 19:48:38 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all the namespace management code is in the
kernel/utsname.c file, so just compile it out and make
stub in .h file.

The init namespace itself is in init/version.c and is
left in the kernel.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 923db99..52b9116 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -35,6 +35,7 @@ struct new_utsname {
 #include <linux/sched.h>
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
+#include <linux/err.h>
 #include <asm/atomic.h>
 
 struct uts_namespace {
@@ -43,6 +44,7 @@ struct uts_namespace {
 };
 extern struct uts_namespace init_uts_ns;
 
+#ifdef CONFIG_NAMESPACES
 static inline void get_uts_ns(struct uts_namespace *ns)
 {
 	kref_get(&ns->kref);
@@ -56,6 +58,25 @@ static inline void put_uts_ns(struct uts
 {
 	kref_put(&ns->kref, free_uts_ns);
 }
+#else
+static inline void get_uts_ns(struct uts_namespace *ns)
+{
+}
+
+static inline void put_uts_ns(struct uts_namespace *ns)
+{
+}
+
+static inline struct uts_namespace *copy_utsname(unsigned long flags,
+					struct uts_namespace *ns)
+{
+	if (flags & CLONE_NEWUTS)
+		return ERR_PTR(-EINVAL);
+
+	return ns;
+}
+#endif
+
 static inline struct new_utsname *utsname(void)
 {
 	return &current->nsproxy->uts_ns->name;
diff --git a/kernel/Makefile b/kernel/Makefile
index 76f782f..5817bfe 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -4,8 +4,7 @@
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
-	    utsname.o notifier.o sysctl.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o notifier.o sysctl.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
@@ -50,6 +49,7 @@ obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
+obj-$(CONFIG_NAMESPACES) += utsname.o
 obj-$(CONFIG_SYSFS) += ksysfs.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/

