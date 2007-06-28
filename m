Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbXF1XNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbXF1XNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763604AbXF1XMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:12:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761584AbXF1XMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:12:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=NKPrbH8zyQllgeV6mzGkgykVa6yfYSFYn4Yz1Xny2RcEAHKyCEvgJtaQbJz8Au8Er
	M/sL08LOgJSq8RzWyOhvw==
Date: Thu, 28 Jun 2007 16:12:23 -0700 (PDT)
From: Joshua Wise <jwise@google.com>
X-X-Sender: jwise@internets.corp.google.com
To: Kyle McMartin <kyle@mcmartin.ca>
cc: linux-kernel@vger.kernel.org, akpm@google.com, thockin@google.com,
       mikew@google.com, masouds@google.com
Subject: Re: [PATCH] [revised -- version 2] Info dump on Oops or panic()
In-Reply-To: <20070628221835.GI2784@fattire.cabal.ca>
Message-ID: <Pine.LNX.4.64.0706281603590.617@internets.corp.google.com>
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
 <20070628221835.GI2784@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Kyle McMartin wrote:
> woah woah woah. This could push critical bits of the register dump or
> stacktrace off the screen... Barring any other problems with the patch,
> this should probably be dumped in the oops header, not trailing it where
> it could hide critical debugging info.

Okay, fair enough. Fixed version follows. I also fixed some checkpatch
issues that I missed before.

However, please note that in general, the info dumped by this will consist
of only a few lines. In our implementations, I believe that we only dump one
line per notifier.

joshua

--
From: Joshua Wise <jwise@google.com>

Version: 2

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

Changelog:
  v2 -- fixed some checkpatch issues. Moved dumping to before Oopses, as per
  the suggestion of Kyle McMartin <kyle@mcmartin.ca>.

Patch:
  This patch is against git 48d8d7ee5dd17c64833e0343ab4ae8ef01cc2648.

Signed-off-by: Joshua Wise <jwise@google.com>
Acked-by: Mike Waychison <mikew@google.com>

--

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 06dfa65..f969c04 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -301,6 +301,8 @@ void show_regs(struct pt_regs * regs)
  {
  	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;

+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
+
  	printk("\n");
  	printk("Pid: %d, comm: %20s\n", current->pid, current->comm);
  	printk("EIP: %04x:[<%08lx>] CPU: %d\n",0xffff & regs->xcs,regs->eip, smp_processor_id());
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 90da057..2ad7f8c 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -289,6 +289,9 @@ void show_registers(struct pt_regs *regs
  		ss = regs->xss & 0xffff;
  	}
  	print_modules();
+
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
+
  	printk(KERN_EMERG "CPU:    %d\n"
  		KERN_EMERG "EIP:    %04x:[<%08lx>]    %s VLI\n"
  		KERN_EMERG "EFLAGS: %08lx   (%s %.*s)\n",
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 5909039..e7f0298 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -353,6 +353,7 @@ void __show_regs(struct pt_regs * regs)

  void show_regs(struct pt_regs *regs)
  {
+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
  	printk("CPU %d:", smp_processor_id());
  	__show_regs(regs);
  	show_trace(NULL, regs, (void *)(regs + 1));
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index aac1c0b..3d228d0 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -410,6 +410,8 @@ void show_registers(struct pt_regs *regs
  	const int cpu = smp_processor_id();
  	struct task_struct *cur = cpu_pda(cpu)->pcurrent;

+	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
+
  	rsp = regs->rsp;
  	printk("CPU %d ", cpu);
  	__show_regs(regs);
diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
deleted file mode 100644
index e69de29..0000000
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
index 872271c..21b9ca1 100644
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
+	printk (KERN_EMERG "%s %s %s %s %s %s\n",
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
index f04791f..9c81504 100644
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
@@ -744,3 +745,34 @@ EXPORT_SYMBOL(get_jiffies_64);
  #endif

  EXPORT_SYMBOL(jiffies);
+
+/*
+ * Dump out uptime info on oops / panic.
+ *
+ * FIXME: Should I be just using get_jiffies64()? what if the lock there
+ * is damaged beyond any recognition?
+ */
+
+static int dump_uptime(struct notifier_block *self, unsigned long v, void *p)
+{
+	struct timespec uptime;
+	/* The logic below is very much like how kernel
+	 * prepares /proc/uptime.
+	 */
+	do_posix_clock_monotonic_gettime(&uptime);
+	printk(KERN_EMERG "Uptime (seconds): %lu.%02lu\n",
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
