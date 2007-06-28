Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbXF1WGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbXF1WGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764951AbXF1WGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:06:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764975AbXF1WGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:06:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=LYCqGlctxhFbGUxmw5wM68xAhZP6pAmB7VjQU26SJikOI9LSNzjzi8F2M4HtD0vEa
	Fq6/1prvVhksJsuWNnoEQ==
Date: Thu, 28 Jun 2007 15:05:56 -0700 (PDT)
From: Joshua Wise <jwise@google.com>
X-X-Sender: jwise@internets.corp.google.com
To: linux-kernel@vger.kernel.org
cc: akpm@google.com, thockin@google.com, mikew@google.com, masouds@google.com
Subject: [PATCH] Info dump on Oops or panic()
Message-ID: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joshua Wise <jwise@google.com>

Background:
  When managing a large number of servers, as Google does, it's sometimes
  useful to get an "at-a-glance" view of a machine when it crashes. When no
  other post-mortem is possible, it's often useful to know how long the
  machine has been powered on, which kernel it was running, and possibly
  other information that a driver may have logged. Up until now, there was no
  real way to do this other than to keep statistics outside to the machine.

Description:
  This patch adds a call chain to be invoked when the system oopses or
  panics. Traps have been added to i386 and x86_64 kernels, but it should be
  trivial to add support for more architectures. Two sample notifiers have
  been added -- an uptime printer, and a utsname printer for showing various
  statistics about the running system.

Remaining issues:
  * Is do_posix_clock_monotonic_gettime really the right API?
  * Should this be on by default, or a disablable Kconfig entry?

Testing:
  I accidentally built my testing kernel without the IDE drivers. It panic()ed
  immediately, and informed me that my uptime was 0.38 seconds.

Credits:
  This code was mainly written by Mike Waychison <mikew@google.com> and
  Masoud Sharbiani <masouds@google.com>.

Patch:
  This patch is against git 48d8d7ee5dd17c64833e0343ab4ae8ef01cc2648.

Signed-off-by: Joshua Wise <jwise@google.com>
Acked-by: Mike Waychison <mikew@google.com>

--

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 06dfa65..42d4397 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -325,6 +325,8 @@ void show_regs(struct pt_regs * regs)
  	cr4 = read_cr4_safe();
  	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n", cr0, cr2, cr3, cr4);
  	show_trace(NULL, regs, &regs->esp);
+ 
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
  }

  /*
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 90da057..16668c2 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -341,6 +341,8 @@ void show_registers(struct pt_regs *regs
  		}
  	}
  	printk("\n");
+ 
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
  }

  int is_valid_bugaddr(unsigned long eip)
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 5909039..7b0619a 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -356,6 +356,7 @@ void show_regs(struct pt_regs *regs)
  	printk("CPU %d:", smp_processor_id());
  	__show_regs(regs);
  	show_trace(NULL, regs, (void *)(regs + 1));
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
  }

  /*
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index aac1c0b..e443613 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -439,6 +439,8 @@ bad:
  		}
  	}
  	printk("\n");
+ 
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
  }

  int is_valid_bugaddr(unsigned long rip)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7a48525..2058e58 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -104,6 +104,7 @@ #define abs(x) ({				\
  	})

  extern struct atomic_notifier_head panic_notifier_list;
+extern struct atomic_notifier_head info_dumper_list;
  extern long (*panic_blink)(long time);
  NORET_TYPE void panic(const char * fmt, ...)
  	__attribute__ ((NORET_AND format (printf, 1, 2)));
diff --git a/kernel/panic.c b/kernel/panic.c
index 623d182..8bae618 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -97,6 +97,7 @@ #ifdef CONFIG_SMP
  #endif

  	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);

  	if (!panic_blink)
  		panic_blink = no_blink;
diff --git a/kernel/sys.c b/kernel/sys.c
index 872271c..5bbe926 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -98,6 +98,39 @@ struct pid *cad_pid;
  EXPORT_SYMBOL(cad_pid);

  /*
+ *	Notifier list for kernel code which wants to printk hardware specific
+ *	information at Oops or panic time.
+ */
+
+ATOMIC_NOTIFIER_HEAD(info_dumper_list);
+EXPORT_SYMBOL(info_dumper_list);
+
+/*
+ * Dump out UTS info on oops / panic.
+ */
+ 
+static int dump_utsname(struct notifier_block *self, unsigned long v, void *p)
+{
+	printk ("%s %s %s %s %s %s\n",
+		utsname()->sysname,
+		utsname()->nodename,
+		utsname()->release,
+		utsname()->version,
+		utsname()->machine,
+		utsname()->domainname);
+	return 0;
+}
+
+static struct notifier_block utsname_notifier;
+
+static int __init register_utsname_dump(void) {
+	utsname_notifier.notifier_call = dump_utsname;
+	atomic_notifier_chain_register(&info_dumper_list, &utsname_notifier);
+	return 0;
+}
+__initcall(register_utsname_dump);
+
+/*
   *	Notifier list for kernel code which wants to be called
   *	at shutdown. This is used to stop any idling DMA operations
   *	and the like. 
diff --git a/kernel/time.c b/kernel/time.c
index f04791f..d5ae5e0 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -31,6 +31,7 @@ #include <linux/module.h>
  #include <linux/timex.h>
  #include <linux/capability.h>
  #include <linux/errno.h>
+#include <linux/notifier.h>
  #include <linux/syscalls.h>
  #include <linux/security.h>
  #include <linux/fs.h>
@@ -744,3 +745,33 @@ EXPORT_SYMBOL(get_jiffies_64);
  #endif

  EXPORT_SYMBOL(jiffies);
+
+/*
+ * Dump out uptime info on oops / panic.
+ * 
+ * FIXME: Should I be just using get_jiffies64()? what if the lock there
+ * is damaged beyond any recognition?
+ */
+static int dump_uptime(struct notifier_block *self, unsigned long v, void *p)
+{
+	struct timespec uptime;
+	/* The logic below is very much like how kernel 
+	 * prepares /proc/uptime. 
+	 */ 
+	do_posix_clock_monotonic_gettime(&uptime);
+	printk("Uptime(seconds): %lu.%02lu\n", 
+		(unsigned long) uptime.tv_sec,
+		(uptime.tv_nsec / (NSEC_PER_SEC / 100)));
+
+	return 0;
+}
+
+static struct notifier_block uptime_notifier;
+
+static int __init register_uptime_dump(void) {
+	uptime_notifier.notifier_call = dump_uptime;
+	atomic_notifier_chain_register(&info_dumper_list, &uptime_notifier);
+	return 0;
+}
+__initcall(register_uptime_dump);
+
