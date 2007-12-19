Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbXLSUCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbXLSUCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbXLSUBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:01:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:42609 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbXLSUBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:01:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:mime-version:x-mailer:content-transfer-encoding:sender:message-id;
        b=NN7CCQ5HQPomr7Bj7bXlIvZQY9OG9OntFu5ju3bRjXW2fKGFjrxHtbcNAeRg52b80xUE5P+JNt5EnpBgJbaIKff/wxCQn6aOkBNSB6NCzs0V9YhbGFTrV/b2HCCHbFapyJ6J48wBldQIc2jBPnYdoYwXKGfA5r6oTBjnjrx0U7I=
References: <20071219194551.315868746@bohmer.net>>
User-Agent: quilt/0.46-1
Date: Wed, 19 Dec 2007 20:45:54 +0100
From: Remy Bohmer <linux@bohmer.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Juergen Beisert <jbe@pengutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, Remy Bohmer <linux@bohmer.net>
Subject: [patch 3/3] Enable setting of IRQ-thread priorities from kernel
	cmdline. (repost:CC to LKML)
Content-Disposition: inline; filename=changing_softirq_prios_from_kernel_cmdline.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Message-ID: <47697888.143f420a.5466.ffff89ba@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RT-patch originally creates all its softirq-threads at
priority 50. Of course, this is not a usable default for many
realtime systems and therefor these priorities has to be tuneable
for each RT-system. But, currently there is no way within the
kernel to adjust this to the needs of the user. Some scripts
are floating around to do this from userspace, but for several
applications the priorities should already be set properly by
the kernel itself before userland is started.

This patch changes this by adding a kernel cmd-line option that
can handle a map of priorities.

Remarks:
* Priorities are only set at creation time of the softirq.
* Priorities has to be set per-cpu.
* If userland overrules, it is NOT restored by this code.
* if no new kernel cmdline options are given, the kernel works
  as before, and all softirqs start at 50.
* No wildcards are supported on the cmdline.

See kernel/Documentation/kernel-parameters.txt for usage info.

Signed-off-by: Remy Bohmer <linux@bohmer.net>

---
 Documentation/kernel-parameters.txt |   11 +++
 kernel/softirq.c                    |  105 ++++++++++++++++++++++++++++++------
 2 files changed, 99 insertions(+), 17 deletions(-)

Index: linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.24-rc5-rt1.orig/Documentation/kernel-parameters.txt	2007-12-18 22:06:11.000000000 +0100
+++ linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt	2007-12-18 22:07:19.000000000 +0100
@@ -806,6 +806,17 @@ and is between 256 and 4096 characters. 
 			If this cmdline argument is ommitted, every thread
 			runs at prio 50.
 
+	sirq_pmap=	[IRQ-threading] List of priorities each softirq
+			thread must have.
+			Format: sirq_pmap=block/0:90,sched/0:75,50
+			The priorities have to be specified per-cpu.
+			The first field without ':', is the default prio.
+			The names have to match the softirq_names[] table in
+			kernel/softirq.c, (thus without 'softirq-' prefix) to
+			keep the cmd-line short.
+			If this cmdline argument is ommitted, every softirq
+			runs at prio 50.
+
 	ports=		[IP_VS_FTP] IPVS ftp helper module
 			Default is 21.
 			Up to 8 (IP_VS_APP_MAX_PORTS) ports
Index: linux-2.6.24-rc5-rt1/kernel/softirq.c
===================================================================
--- linux-2.6.24-rc5-rt1.orig/kernel/softirq.c	2007-12-18 22:06:11.000000000 +0100
+++ linux-2.6.24-rc5-rt1/kernel/softirq.c	2007-12-18 22:08:54.000000000 +0100
@@ -66,6 +66,10 @@ struct softirqdata {
 
 static DEFINE_PER_CPU(struct softirqdata [MAX_SOFTIRQ], ksoftirqd);
 
+static char *cmdline;
+static int  default_prio = MAX_USER_RT_PRIO/2;
+
+
 #ifdef CONFIG_PREEMPT_SOFTIRQS
 /*
  * Preempting the softirq causes cases that would not be a
@@ -770,10 +774,28 @@ EXPORT_SYMBOL(tasklet_unlock_wait);
 
 #endif
 
+static const char *softirq_names [] =
+{
+  [HI_SOFTIRQ]		= "high",
+  [SCHED_SOFTIRQ]	= "sched",
+  [TIMER_SOFTIRQ]	= "timer",
+  [NET_TX_SOFTIRQ]	= "net-tx",
+  [NET_RX_SOFTIRQ]	= "net-rx",
+  [BLOCK_SOFTIRQ]	= "block",
+  [TASKLET_SOFTIRQ]	= "tasklet",
+#ifdef CONFIG_HIGH_RES_TIMERS
+  [HRTIMER_SOFTIRQ]	= "hrtimer",
+#endif
+  [RCU_SOFTIRQ]		= "rcu",
+};
+
+static int get_softirq_prio(const char *name);
+
 static int ksoftirqd(void * __data)
 {
-	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2 };
+	struct sched_param param = { 0, };
 	struct softirqdata *data = __data;
+	char buf[50];
 	u32 softirq_mask = (1 << data->nr);
 	struct softirq_action *h;
 	int cpu = data->cpu;
@@ -781,8 +803,12 @@ static int ksoftirqd(void * __data)
 #ifdef CONFIG_PREEMPT_SOFTIRQS
 	init_waitqueue_head(&data->wait);
 #endif
-
+	/* Lookup the priority of this softirq, and set the prio accordingly */
+	snprintf(buf, sizeof(buf), "%s/%lu",
+		 softirq_names[data->nr], data->cpu);
+	param.sched_priority = get_softirq_prio(buf);
 	sys_sched_setscheduler(current->pid, SCHED_FIFO, &param);
+
 	current->flags |= PF_SOFTIRQ;
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -911,21 +937,6 @@ void takeover_tasklets(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static const char *softirq_names [] =
-{
-  [HI_SOFTIRQ]		= "high",
-  [SCHED_SOFTIRQ]	= "sched",
-  [TIMER_SOFTIRQ]	= "timer",
-  [NET_TX_SOFTIRQ]	= "net-tx",
-  [NET_RX_SOFTIRQ]	= "net-rx",
-  [BLOCK_SOFTIRQ]	= "block",
-  [TASKLET_SOFTIRQ]	= "tasklet",
-#ifdef CONFIG_HIGH_RES_TIMERS
-  [HRTIMER_SOFTIRQ]	= "hrtimer",
-#endif
-  [RCU_SOFTIRQ]		= "rcu",
-};
-
 static int __cpuinit cpu_callback(struct notifier_block *nfb,
 				  unsigned long action,
 				  void *hcpu)
@@ -1051,3 +1062,63 @@ int on_each_cpu(void (*func) (void *info
 }
 EXPORT_SYMBOL(on_each_cpu);
 #endif
+
+/*
+ * Lookup the softirq thread priority.
+ * A map for the priorities can be given on the kernel commandline.
+ * if name is NULL, or no kernel commandline options is given, the default
+ * prio is returned, which is either MAX_PRIO/2, or the default given on the
+ * kernel commandline.
+ */
+static int get_softirq_prio(const char *name)
+{
+	int prio = default_prio; /* Set the default for all threads */
+
+	/* If no commandline options, use thread prio defaults the old style.*/
+	if (!cmdline)
+		return prio;
+
+	if (!get_map_option(cmdline, name, &prio)) {
+		prio = default_prio;
+		if (name != NULL)
+			printk(KERN_INFO
+				"No priority specified for 'softirq-%s', " \
+				"using default(=%d)\n", name, prio);
+	} else {
+		if ((prio <= 0) || (prio >= MAX_USER_RT_PRIO))
+			prio = default_prio;
+
+		if (name != NULL)
+			printk(KERN_INFO "Using priority %d for 'softirq-%s'\n",
+				prio, name);
+	}
+	return prio;
+}
+
+/*
+ * Store the pointer to the arguments in a global var, and store the
+ * default prio globally
+ */
+static int __init softirq_prio_map_setup(char *str)
+{
+	if (!str) /* sanity check */
+		return 1;
+
+	cmdline		= str; /* store it for later use */
+	default_prio	= get_softirq_prio(NULL);
+
+	printk(KERN_INFO "Default softirq priority: %d\n", default_prio);
+
+	return 1;
+}
+
+/*
+ * The commandline looks like this:
+ *                 sirq_pmap=block/0:90,sched/0:75,50
+ * The first field without the ':' is used as the default for all
+ * soft-irq-threads. The priorities are only set on creation of the
+ * softirq threads. Unknown or redundant fields are ignored.
+ * The names have to match the softirq_names[] table without 'softirq-' prefix
+ * to keep the cmd-line short.
+ */
+__setup("sirq_pmap=", softirq_prio_map_setup);

-- 

