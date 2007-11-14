Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbXKNLi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbXKNLi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXKNLiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:38:05 -0500
Received: from sacred.ru ([62.205.161.221]:43949 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXKNLiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:38:03 -0500
Message-ID: <473ADC3E.8090609@openvz.org>
Date: Wed, 14 Nov 2007 14:30:06 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] Move the UTS namespace under UTS_NS option
References: <473ADB5B.50902@openvz.org>
In-Reply-To: <473ADB5B.50902@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 14 Nov 2007 14:30:06 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all the namespace management code is in the 
kernel/utsname.c file, so just compile it out and make stubs 
in the appropriate header.

The init namespace itself is in init/version.c and is in the
kernel all the time.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 923db99..1123267 100644
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
 
+#ifdef CONFIG_UTS_NS
 static inline void get_uts_ns(struct uts_namespace *ns)
 {
 	kref_get(&ns->kref);
@@ -56,6 +58,25 @@ static inline void put_uts_ns(struct uts_namespace *ns)
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
diff --git a/init/Kconfig b/init/Kconfig
index 4ccc1a0..2139218 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -413,6 +413,13 @@ config NAMESPACES
 	  or same user id or pid may refer to different tasks when used in
 	  different namespaces.
 
+config UTS_NS
+	bool "UTS namespace"
+	depends on NAMESPACES
+	help
+	  In this namespace tasks see different info provided with the
+	  uname() system call
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff --git a/kernel/Makefile b/kernel/Makefile
index 876dbcd..19d2411 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o \
-	    utsname.o notifier.o pm_qos_params.o
+	    notifier.o pm_qos_params.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
@@ -48,6 +48,7 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
+obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_SYSFS) += ksysfs.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
-- 
1.5.3.4

