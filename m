Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZAMB5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZAMB5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbZAMBz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:55:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38413 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604AbZAMBzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:55:54 -0500
Message-ID: <496BF4B5.5010100@redhat.com>
Date: Mon, 12 Jan 2009 20:56:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][PATCH -mm 4/6] kprobes: rename kprobe_enabled to kprobes_all_disarmed
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename kprobe_enabled to kprobes_all_disarmed and invert logic due to
avoiding naming confusion from per-probe disabling.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/kprobes.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: 2.6.28-mm1/kernel/kprobes.c
===================================================================
--- 2.6.28-mm1.orig/kernel/kprobes.c
+++ 2.6.28-mm1/kernel/kprobes.c
@@ -67,7 +67,7 @@ static struct hlist_head kprobe_table[KP
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];

 /* NOTE: change this value only with kprobe_mutex held */
-static bool kprobe_enabled;
+static bool kprobes_all_disarmed;

 static DEFINE_MUTEX(kprobe_mutex);	/* Protects kprobe_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
@@ -597,7 +597,7 @@ static int __kprobes register_aggr_kprob
 		 * If the old_p has gone, its breakpoint has been disarmed.
 		 * We have to arm it again after preparing real kprobes.
 		 */
-		if (kprobe_enabled)
+		if (!kprobes_all_disarmed)
 			arch_arm_kprobe(ap);
 	}

@@ -707,7 +707,7 @@ int __kprobes register_kprobe(struct kpr
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);

-	if (kprobe_enabled)
+	if (!kprobes_all_disarmed)
 		arch_arm_kprobe(p);

 out:
@@ -747,7 +747,7 @@ valid_p:
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled && !kprobe_gone(old_p))
+		if (!kprobes_all_disarmed && !kprobe_gone(old_p))
 			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
 	} else {
@@ -1185,8 +1185,8 @@ static int __init init_kprobes(void)
 		}
 	}

-	/* By default, kprobes are enabled */
-	kprobe_enabled = true;
+	/* By default, kprobes are armed */
+	kprobes_all_disarmed = false;

 	err = arch_init_kprobes();
 	if (!err)
@@ -1284,7 +1284,7 @@ static struct file_operations debugfs_kp
 	.release        = seq_release,
 };

-static void __kprobes enable_all_kprobes(void)
+static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -1293,8 +1293,8 @@ static void __kprobes enable_all_kprobes

 	mutex_lock(&kprobe_mutex);

-	/* If kprobes are already enabled, just return */
-	if (kprobe_enabled)
+	/* If kprobes are armed, just return */
+	if (!kprobes_all_disarmed)
 		goto already_enabled;

 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
@@ -1304,7 +1304,7 @@ static void __kprobes enable_all_kprobes
 				arch_arm_kprobe(p);
 	}

-	kprobe_enabled = true;
+	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");

 already_enabled:
@@ -1312,7 +1312,7 @@ already_enabled:
 	return;
 }

-static void __kprobes disable_all_kprobes(void)
+static void __kprobes disarm_all_kprobes(void)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -1321,11 +1321,11 @@ static void __kprobes disable_all_kprobe

 	mutex_lock(&kprobe_mutex);

-	/* If kprobes are already disabled, just return */
-	if (!kprobe_enabled)
+	/* If kprobes are already disarmed, just return */
+	if (kprobes_all_disarmed)
 		goto already_disabled;

-	kprobe_enabled = false;
+	kprobes_all_disarmed = true;
 	printk(KERN_INFO "Kprobes globally disabled\n");
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
@@ -1355,7 +1355,7 @@ static ssize_t read_enabled_file_bool(st
 {
 	char buf[3];

-	if (kprobe_enabled)
+	if (!kprobes_all_disarmed)
 		buf[0] = '1';
 	else
 		buf[0] = '0';
@@ -1378,12 +1378,12 @@ static ssize_t write_enabled_file_bool(s
 	case 'y':
 	case 'Y':
 	case '1':
-		enable_all_kprobes();
+		arm_all_kprobes();
 		break;
 	case 'n':
 	case 'N':
 	case '0':
-		disable_all_kprobes();
+		disarm_all_kprobes();
 		break;
 	}

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com




