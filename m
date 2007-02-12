Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXBLHmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXBLHmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933091AbXBLHi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbXBLHiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:07 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [18/39] x86_64: Allow to run a program when a machine check event is detected
Message-Id: <20070212073805.89FEE13D7F@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a machine check event is detected (including a AMD RevF threshold 
overflow event) allow to run a "trigger" program. This allows user space
to react to such events sooner.

The trigger is configured using a new trigger entry in the 
machinecheck sysfs interface. It is currently shared between
all CPUs.

I also fixed the AMD threshold handler to run the machine 
check polling code immediately to actually log any events
that might have caused the threshold interrupt.

Also added some documentation for the mce sysfs interface.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/x86_64/machinecheck |   70 ++++++++++++++++++++++++++++++++++++++
 arch/x86_64/kernel/mce.c          |   66 +++++++++++++++++++++++++++++------
 arch/x86_64/kernel/mce_amd.c      |    4 ++
 include/asm-x86_64/mce.h          |    2 +
 kernel/kmod.c                     |   44 ++++++++++++++++-------
 5 files changed, 160 insertions(+), 26 deletions(-)

Index: linux/arch/x86_64/kernel/mce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce.c
+++ linux/arch/x86_64/kernel/mce.c
@@ -19,6 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/percpu.h>
 #include <linux/ctype.h>
+#include <linux/kmod.h>
 #include <asm/processor.h> 
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -42,6 +43,10 @@ static unsigned long console_logged;
 static int notify_user;
 static int rip_msr;
 static int mce_bootlog = 1;
+static atomic_t mce_events;
+
+static char trigger[128];
+static char *trigger_argv[2] = { trigger, NULL };
 
 /*
  * Lockless MCE logging infrastructure.
@@ -57,6 +62,7 @@ struct mce_log mcelog = { 
 void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
+	atomic_inc(&mce_events);
 	mce->finished = 0;
 	wmb();
 	for (;;) {
@@ -161,6 +167,17 @@ static inline void mce_get_rip(struct mc
 	}
 }
 
+static void do_mce_trigger(void)
+{
+	static atomic_t mce_logged;
+	int events = atomic_read(&mce_events);
+	if (events != atomic_read(&mce_logged) && trigger[0]) {
+		/* Small race window, but should be harmless.  */
+		atomic_set(&mce_logged, events);
+		call_usermodehelper(trigger, trigger_argv, NULL, -1);
+	}
+}
+
 /* 
  * The actual machine check handler
  */
@@ -234,8 +251,12 @@ void do_machine_check(struct pt_regs * r
 	}
 
 	/* Never do anything final in the polling timer */
-	if (!regs)
+	if (!regs) {
+		/* Normal interrupt context here. Call trigger for any new
+		   events. */
+		do_mce_trigger();
 		goto out;
+	}
 
 	/* If we didn't find an uncorrectable error, pick
 	   the last one (shouldn't happen, just being safe). */
@@ -606,17 +627,42 @@ DEFINE_PER_CPU(struct sys_device, device
 	}									   \
 	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
 
+/* TBD should generate these dynamically based on number of available banks */
 ACCESSOR(bank0ctl,bank[0],mce_restart())
 ACCESSOR(bank1ctl,bank[1],mce_restart())
 ACCESSOR(bank2ctl,bank[2],mce_restart())
 ACCESSOR(bank3ctl,bank[3],mce_restart())
 ACCESSOR(bank4ctl,bank[4],mce_restart())
 ACCESSOR(bank5ctl,bank[5],mce_restart())
-static struct sysdev_attribute * bank_attributes[NR_BANKS] = {
-	&attr_bank0ctl, &attr_bank1ctl, &attr_bank2ctl,
-	&attr_bank3ctl, &attr_bank4ctl, &attr_bank5ctl};
+
+static ssize_t show_trigger(struct sys_device *s, char *buf)
+{
+	strcpy(buf, trigger);
+	strcat(buf, "\n");
+	return strlen(trigger) + 1;
+}
+
+static ssize_t set_trigger(struct sys_device *s,const char *buf,size_t siz)
+{
+	char *p;
+	int len;
+	strncpy(trigger, buf, sizeof(trigger));
+	trigger[sizeof(trigger)-1] = 0;
+	len = strlen(trigger);
+	p = strchr(trigger, '\n');
+	if (*p) *p = 0;
+	return len;
+}
+
+static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 ACCESSOR(tolerant,tolerant,)
 ACCESSOR(check_interval,check_interval,mce_restart())
+static struct sysdev_attribute *mce_attributes[] = {
+	&attr_bank0ctl, &attr_bank1ctl, &attr_bank2ctl,
+	&attr_bank3ctl, &attr_bank4ctl, &attr_bank5ctl,
+	&attr_tolerant, &attr_check_interval, &attr_trigger,
+	NULL
+};
 
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
 static __cpuinit int mce_create_device(unsigned int cpu)
@@ -632,11 +678,9 @@ static __cpuinit int mce_create_device(u
 	err = sysdev_register(&per_cpu(device_mce,cpu));
 
 	if (!err) {
-		for (i = 0; i < banks; i++)
+		for (i = 0; mce_attributes[i]; i++)
 			sysdev_create_file(&per_cpu(device_mce,cpu),
-				bank_attributes[i]);
-		sysdev_create_file(&per_cpu(device_mce,cpu), &attr_tolerant);
-		sysdev_create_file(&per_cpu(device_mce,cpu), &attr_check_interval);
+				mce_attributes[i]);
 	}
 	return err;
 }
@@ -645,11 +689,9 @@ static void mce_remove_device(unsigned i
 {
 	int i;
 
-	for (i = 0; i < banks; i++)
+	for (i = 0; mce_attributes[i]; i++)
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
-			bank_attributes[i]);
-	sysdev_remove_file(&per_cpu(device_mce,cpu), &attr_tolerant);
-	sysdev_remove_file(&per_cpu(device_mce,cpu), &attr_check_interval);
+			mce_attributes[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
 	memset(&per_cpu(device_mce, cpu).kobj, 0, sizeof(struct kobject));
 }
Index: linux/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce_amd.c
+++ linux/arch/x86_64/kernel/mce_amd.c
@@ -220,6 +220,10 @@ asmlinkage void mce_threshold_interrupt(
 			     (high & MASK_LOCKED_HI))
 				continue;
 
+			/* Log the machine check that caused the threshold
+			   event. */
+			do_machine_check(NULL, 0);
+
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
 				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c
+++ linux/kernel/kmod.c
@@ -217,7 +217,10 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	complete(sub_info->complete);
+	if (sub_info->wait < 0)
+		kfree(sub_info);
+	else
+		complete(sub_info->complete);
 	return 0;
 }
 
@@ -239,6 +242,9 @@ static void __call_usermodehelper(struct
 		pid = kernel_thread(____call_usermodehelper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
 
+	if (wait < 0)
+		return;
+
 	if (pid < 0) {
 		sub_info->retval = pid;
 		complete(sub_info->complete);
@@ -253,6 +259,9 @@ static void __call_usermodehelper(struct
  * @envp: null-terminated environment list
  * @session_keyring: session keyring for process (NULL for an empty keyring)
  * @wait: wait for the application to finish and return status.
+ *        when -1 don't wait at all, but you get no useful error back when
+ *        the program couldn't be exec'ed. This makes it safe to call
+ *        from interrupt context.
  *
  * Runs a user-space application.  The application is started
  * asynchronously if wait is not set, and runs as a child of keventd.
@@ -265,17 +274,8 @@ int call_usermodehelper_keys(char *path,
 			     struct key *session_keyring, int wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
-	struct subprocess_info sub_info = {
-		.work		= __WORK_INITIALIZER(sub_info.work,
-						     __call_usermodehelper),
-		.complete	= &done,
-		.path		= path,
-		.argv		= argv,
-		.envp		= envp,
-		.ring		= session_keyring,
-		.wait		= wait,
-		.retval		= 0,
-	};
+	struct subprocess_info *sub_info;
+	int retval;
 
 	if (!khelper_wq)
 		return -EBUSY;
@@ -283,9 +283,25 @@ int call_usermodehelper_keys(char *path,
 	if (path[0] == '\0')
 		return 0;
 
-	queue_work(khelper_wq, &sub_info.work);
+	sub_info = kzalloc(sizeof(struct subprocess_info),  GFP_ATOMIC);
+	if (!sub_info)
+		return -ENOMEM;
+
+	INIT_WORK(&sub_info->work, __call_usermodehelper);
+	sub_info->complete = &done;
+	sub_info->path = path;
+	sub_info->argv = argv;
+	sub_info->envp = envp;
+	sub_info->ring = session_keyring;
+	sub_info->wait = wait;
+
+	queue_work(khelper_wq, &sub_info->work);
+	if (wait < 0) /* task has freed sub_info */
+		return 0;
 	wait_for_completion(&done);
-	return sub_info.retval;
+	retval = sub_info->retval;
+	kfree(sub_info);
+	return retval;
 }
 EXPORT_SYMBOL(call_usermodehelper_keys);
 
Index: linux/include/asm-x86_64/mce.h
===================================================================
--- linux.orig/include/asm-x86_64/mce.h
+++ linux/include/asm-x86_64/mce.h
@@ -103,6 +103,8 @@ void mce_log_therm_throt_event(unsigned 
 
 extern atomic_t mce_entry;
 
+extern void do_machine_check(struct pt_regs *, long);
+
 #endif
 
 #endif
Index: linux/Documentation/x86_64/machinecheck
===================================================================
--- /dev/null
+++ linux/Documentation/x86_64/machinecheck
@@ -0,0 +1,70 @@
+
+Configurable sysfs parameters for the x86-64 machine check code.
+
+Machine checks report internal hardware error conditions detected
+by the CPU. Uncorrected errors typically cause a machine check
+(often with panic), corrected ones cause a machine check log entry.
+
+Machine checks are organized in banks (normally associated with
+a hardware subsystem) and subevents in a bank. The exact meaning
+of the banks and subevent is CPU specific.
+
+mcelog knows how to decode them.
+
+When you see the "Machine check errors logged" message in the system
+log then mcelog should run to collect and decode machine check entries
+from /dev/mcelog. Normally mcelog should be run regularly from a cronjob.
+
+Each CPU has a directory in /sys/devices/system/machinecheck/machinecheckN
+(N = CPU number)
+
+The directory contains some configurable entries:
+
+Entries:
+
+bankNctl
+(N bank number)
+	64bit Hex bitmask enabling/disabling specific subevents for bank N
+	When a bit in the bitmask is zero then the respective
+	subevent will not be reported.
+	By default all events are enabled.
+	Note that BIOS maintain another mask to disable specific events
+	per bank.  This is not visible here
+
+The following entries appear for each CPU, but they are truly shared
+between all CPUs.
+
+check_interval
+	How often to poll for corrected machine check errors, in seconds
+	(Note output is hexademical). Default 5 minutes.
+
+tolerant
+	Tolerance level. When a machine check exception occurs for a non
+	corrected machine check the kernel can take different actions.
+	Since machine check exceptions can happen any time it is sometimes
+	risky for the kernel to kill a process because it defies
+	normal kernel locking rules. The tolerance level configures
+	how hard the kernel tries to recover even at some risk of deadlock.
+
+	0: always panic,
+	1: panic if deadlock possible,
+	2: try to avoid panic,
+   	3: never panic or exit (for testing only)
+
+	Default: 1
+
+	Note this only makes a difference if the CPU allows recovery
+	from a machine check exception. Current x86 CPUs generally do not.
+
+trigger
+	Program to run when a machine check event is detected.
+	This is an alternative to running mcelog regularly from cron
+	and allows to detect events faster.
+
+TBD document entries for AMD threshold interrupt configuration
+
+For more details about the x86 machine check architecture
+see the Intel and AMD architecture manuals from their developer websites.
+
+For more details about the architecture see
+see http://one.firstfloor.org/~andi/mce.pdf
