Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYKET7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYKET7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbYKET6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbYKET57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:57:59 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 09/15] x86: Emergency virtualization disable function
Date: Wed,  5 Nov 2008 17:56:52 -0200
Message-Id: <1225915018-6548-10-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to set a function that can be used to
disable virtualization extensions on the CPU on emergency cases, such
as on kdump or emergency reboot.

The function will be set by code that enables virtualization extensions
on the CPUs (i.e. KVM), and should do the very least to disable virt
extensions on the CPU where it is being called.

The functions that set the function pointer uses RCU synchronization,
just in case the crash NMI is triggered while KVM is unloading.

We can't just use the same notifiers used at reboot time (that are used
by non-crash-dump kexec), because at crash time some CPUs may have IRQs
disabled, so we can't use IPIs. The crash shutdown code use NMIs to tell
the other CPUs to be halted, so the notifier call will be hooked into
the CPU halting code that is on the crash shutdown NMI handler.

[v2: drop 'unsigned int cpu' arg from function]
[v3: make emergency_virt_disable() non-static]
[v4: add a config option for it: CPU_VIRT_EXTENSIONS]
[v5: add has_virt_extensions() function]
[v6: don't define the registering functions if CPU_VIRT_EXTENSIONS is
 not enabled]
[v7: use EXPORT_SYMBOL_GPL]

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |   29 +++++++++++++
 arch/x86/kernel/Makefile       |    1 +
 arch/x86/kernel/virtext.c      |   89 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/Kconfig           |    5 ++
 4 files changed, 124 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/virtext.h
 create mode 100644 arch/x86/kernel/virtext.c

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
new file mode 100644
index 0000000..72b7caa
--- /dev/null
+++ b/arch/x86/include/asm/virtext.h
@@ -0,0 +1,29 @@
+/* CPU virtualization extensions handling
+ */
+#ifndef _ASM_X86_VIRTEX_H
+#define _ASM_X86_VIRTEX_H
+
+#ifdef CONFIG_CPU_VIRT_EXTENSIONS
+
+int set_virt_disable_func(void (*fn)(void));
+void clear_virt_disable_func(void);
+void emergency_virt_disable(void);
+int has_virt_extensions(void);
+
+
+#else /* !CONFIG_CPU_VIRT_EXTENSIONS */
+
+static inline
+void emergency_virt_disable(void)
+{
+}
+
+static inline
+int has_virt_extensions(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CPU_VIRT_EXTENSIONS */
+
+#endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 58814cc..84a0e23 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
+obj-$(CONFIG_CPU_VIRT_EXTENSIONS) += virtext.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
diff --git a/arch/x86/kernel/virtext.c b/arch/x86/kernel/virtext.c
new file mode 100644
index 0000000..10d90f2
--- /dev/null
+++ b/arch/x86/kernel/virtext.c
@@ -0,0 +1,89 @@
+/* Core CPU virtualization extensions handling
+ *
+ * This should carry the code for handling CPU virtualization extensions
+ * that needs to live in the kernel core.
+ *
+ * Author: Eduardo Habkost <ehabkost@redhat.com>
+ *
+ * Copyright (C) 2008, Red Hat Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/rcupdate.h>
+
+static DEFINE_SPINLOCK(virt_disable_lock);
+static void (*virt_disable_fn)(void);
+
+/**	set function to be called to disable virtualization on crash
+ *
+ *	Registers a function to be called when CPUs are being halted at
+ *	machine_crash_shutdown().
+ *
+ *	There is only one function pointer, so the function
+ *	is reserved to be set by the KVM module at load time, before
+ *	enabling virtualization.
+ *
+ *	The function is called once on each online CPU, possibly
+ *	from a NMI handler. It should do the very least to allow the CPU
+ *	to be halted before booting the kdump kernel, as the kernel has
+ *	just crashed.
+ */
+int set_virt_disable_func(void (*fn)(void))
+{
+	int r = 0;
+
+	spin_lock(&virt_disable_lock);
+	if (!virt_disable_fn)
+		rcu_assign_pointer(virt_disable_fn, fn);
+	else
+		r = -EEXIST;
+	spin_unlock(&virt_disable_lock);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(set_virt_disable_func);
+
+/** clear the virt_disable function set by set_virt_disable_func()
+ *
+ * You must call this function only if you sucessfully set
+ * the virt_disable function on a previous set_virt_disable_func()
+ * call.
+ *
+ * This function will use synchronize_sched() to wait until it's safe
+ * to free any data or code related to the previous existing virt_disable
+ * func, before returning.
+ */
+void clear_virt_disable_func(void)
+{
+	spin_lock(&virt_disable_lock);
+	rcu_assign_pointer(virt_disable_fn, NULL);
+	spin_unlock(&virt_disable_lock);
+
+	synchronize_sched();
+}
+EXPORT_SYMBOL_GPL(clear_virt_disable_func);
+
+/* Disable virtualization extensions if needed
+ *
+ * Runs thefunction set by set_virt_disable_func()
+ *
+ * Must be called on the CPU that is being halted.
+ */
+void emergency_virt_disable(void)
+{
+	void (*fn)(void);
+	fn = rcu_dereference(virt_disable_fn);
+	if (fn)
+		fn();
+}
+
+/* Returns non-zero if a virt_disable function was set
+ *
+ * The function pointer may be set just after you've called this function.
+ * Use with care.
+ */
+int has_virt_extensions(void)
+{
+	return rcu_dereference(virt_disable_fn) != NULL;
+}
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ce3251c..69373cc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -15,6 +15,10 @@ menuconfig VIRTUALIZATION
 
 	  If you say N, all options in this submenu will be skipped and disabled.
 
+# Core code for handling CPU virt extensions
+config CPU_VIRT_EXTENSIONS
+	bool
+
 if VIRTUALIZATION
 
 config KVM
@@ -23,6 +27,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
+	select CPU_VIRT_EXTENSIONS
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
1.5.5.GIT

