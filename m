Return-Path: <linux-kernel-owner+w=401wt.eu-S1759762AbZJGTOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762AbZJGTOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZJGTOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:14:48 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:45319 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZJGTOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:14:47 -0400
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: John Kacur <jkacur@redhat.com>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 12:14:08 -0700
Message-Id: <1254942848.15477.16.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 20:19 +0200, John Kacur wrote:
> I've been staring at the BKL lock in cpuid_open, and I can't see what it 
> is protecting. However, I may have missed something - even something 
> obvious, so comments are welcome.

I have been using this patch to first see if the BKL is being used
simply as mutex, which would allow easier break-down.

Sven

Subject: Introduce the BKL-MUTEX, to allow proving the code that
From: Sven-Thorsten Dietrich sdietrich@suse.de Sat Oct 3 01:26:01 2009 -0700
Date: Sat Oct 3 01:26:01 2009 -0700:
Git: 4bfea26de550100d193c49278d657485e792dfe5

just needs a global kernel mutex, without all the funky
preemption bits...

Acked-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
diff --git a/include/linux/smp_mutex.h b/include/linux/smp_mutex.h
new file mode 100644
index 0000000..6c45a96
--- /dev/null
+++ b/include/linux/smp_mutex.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_SMPMUTEX_H
+#define __LINUX_SMPMUTEX_H
+
+#ifdef CONFIG_LOCK_KERNEL
+
+extern void lock_kernel_mutex(void);
+extern void unlock_kernel_mutex(void);
+
+static inline void cycle_kernel_mutex(void)
+{
+	lock_kernel_mutex();
+	unlock_kernel_mutex();
+}
+
+#else
+
+#define lock_kernel_mutex()				do { } while(0)
+#define unlock_kernel_mutex()				do { } while(0)
+#define cycle_kernel_mutex()			do { } while(0)
+
+#endif /* CONFIG_LOCK_KERNEL */
+#endif /* __LINUX_SMPMUTEX_H */
diff --git a/lib/Makefile b/lib/Makefile
index 2e78277..c71ffdc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -40,7 +40,7 @@ lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
-obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
+obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o kernel_mutex.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
diff --git a/lib/kernel_mutex.c b/lib/kernel_mutex.c
new file mode 100644
index 0000000..1d587a8
--- /dev/null
+++ b/lib/kernel_mutex.c
@@ -0,0 +1,37 @@
+/*
+ * lib/kernel_mutex.c
+ *
+ * This is the preemptible BKL - To be used transitionally to
+ * prove those subsystems still using lock_kernel, but really
+ * requiring a global mutex.
+ */
+#include <linux/smp_mutex.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/semaphore.h>
+#include <linux/mutex.h>
+
+/*
+ * The 'big kernel mutex'
+ *
+ * Don't use in new code.
+ */
+static  __cacheline_aligned_in_smp DEFINE_MUTEX(kernel_mutex);
+
+
+/*
+ * Getting the kernel mutex.
+ */
+void __lockfunc lock_kernel_mutex(void)
+{
+	mutex_lock(&kernel_mutex);
+}
+
+void __lockfunc unlock_kernel_mutex(void)
+{
+	mutex_unlock(&kernel_mutex);
+}
+
+EXPORT_SYMBOL(lock_kernel_mutex);
+EXPORT_SYMBOL(unlock_kernel_mutex);
+


