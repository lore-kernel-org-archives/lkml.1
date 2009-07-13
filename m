Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZGMQvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZGMQvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZGMQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:51:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:50089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZGMQve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:51:34 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: balbir@linux.vnet.ibm.com
Subject: [PATCH] taskstats: Unify cgroupstats.h with taskstats.h and use a single nla_policy
Date: Mon, 13 Jul 2009 22:23:12 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
References: <200907131831.12994.knikanth@suse.de> <200907132116.43647.knikanth@suse.de> <20090713155439.GF5051@balbir.in.ibm.com>
In-Reply-To: <20090713155439.GF5051@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907132223.12627.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we never get message from kernel to userspace of type
TASKSTATS_TYPE_PID. Having the values in the same range would restrict one not
to use the same netlink socket for a command that would return response of
type TASKSTATS_TYPE_PID and the CGROUPSTATS_CMD_GET command.

Change it by using the same set of types and attributes for both
TASKSTATS_CMD_NEW/GET and CGROUPSTATS_CMD_GET/NEW by using the same
nla_policy.

Unify linux/cgroupstats.h with linux/taskstat.h

Bump the taskstat version while doing so.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index aa73e72..ffac484 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -25,7 +25,6 @@
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
-#include <linux/cgroupstats.h>
 
 /*
  * Generic macros for dealing with netlink sockets. Might be duplicated
@@ -133,7 +132,7 @@ int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	msg.n.nlmsg_seq = 0;
 	msg.n.nlmsg_pid = nlmsg_pid;
 	msg.g.cmd = genl_cmd;
-	msg.g.version = 0x1;
+	msg.g.version = 0x2;
 	na = (struct nlattr *) GENLMSG_DATA(&msg);
 	na->nla_type = nla_type;
 	na->nla_len = nla_len + 1 + NLA_HDRLEN;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 665fa70..dd7c675 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -12,7 +12,7 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/rcupdate.h>
-#include <linux/cgroupstats.h>
+#include <linux/taskstats.h>
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
diff --git a/include/linux/cgroupstats.h b/include/linux/cgroupstats.h
deleted file mode 100644
index 3753c33..0000000
--- a/include/linux/cgroupstats.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/* cgroupstats.h - exporting per-cgroup statistics
- *
- * Copyright IBM Corporation, 2007
- * Author Balbir Singh <balbir@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2.1 of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _LINUX_CGROUPSTATS_H
-#define _LINUX_CGROUPSTATS_H
-
-#include <linux/types.h>
-#include <linux/taskstats.h>
-
-/*
- * Data shared between user space and kernel space on a per cgroup
- * basis. This data is shared using taskstats.
- *
- * Most of these states are derived by looking at the task->state value
- * For the nr_io_wait state, a flag in the delay accounting structure
- * indicates that the task is waiting on IO
- *
- * Each member is aligned to a 8 byte boundary.
- */
-struct cgroupstats {
-	__u64	nr_sleeping;		/* Number of tasks sleeping */
-	__u64	nr_running;		/* Number of tasks running */
-	__u64	nr_stopped;		/* Number of tasks in stopped state */
-	__u64	nr_uninterruptible;	/* Number of tasks in uninterruptible */
-					/* state */
-	__u64	nr_io_wait;		/* Number of tasks waiting on IO */
-};
-
-/*
- * Commands sent from userspace
- * Not versioned. New commands should only be inserted at the enum's end
- * prior to __CGROUPSTATS_CMD_MAX
- */
-
-enum {
-	CGROUPSTATS_CMD_UNSPEC = __TASKSTATS_CMD_MAX,	/* Reserved */
-	CGROUPSTATS_CMD_GET,		/* user->kernel request/get-response */
-	CGROUPSTATS_CMD_NEW,		/* kernel->user event */
-	__CGROUPSTATS_CMD_MAX,
-};
-
-#define CGROUPSTATS_CMD_MAX (__CGROUPSTATS_CMD_MAX - 1)
-
-enum {
-	CGROUPSTATS_TYPE_UNSPEC = 0,	/* Reserved */
-	CGROUPSTATS_TYPE_CGROUP_STATS,	/* contains name + stats */
-	__CGROUPSTATS_TYPE_MAX,
-};
-
-#define CGROUPSTATS_TYPE_MAX (__CGROUPSTATS_TYPE_MAX - 1)
-
-enum {
-	CGROUPSTATS_CMD_ATTR_UNSPEC = 0,
-	CGROUPSTATS_CMD_ATTR_FD,
-	__CGROUPSTATS_CMD_ATTR_MAX,
-};
-
-#define CGROUPSTATS_CMD_ATTR_MAX (__CGROUPSTATS_CMD_ATTR_MAX - 1)
-
-#endif /* _LINUX_CGROUPSTATS_H */
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 341dddb..cba4594 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -165,6 +165,24 @@ struct taskstats {
 	__u64	freepages_delay_total;
 };
 
+/*
+ * Data shared between user space and kernel space on a per cgroup
+ * basis. This data is shared using taskstats.
+ *
+ * Most of these states are derived by looking at the task->state value
+ * For the nr_io_wait state, a flag in the delay accounting structure
+ * indicates that the task is waiting on IO
+ *
+ * Each member is aligned to a 8 byte boundary.
+ */
+struct cgroupstats {
+	__u64	nr_sleeping;		/* Number of tasks sleeping */
+	__u64	nr_running;		/* Number of tasks running */
+	__u64	nr_stopped;		/* Number of tasks in stopped state */
+	__u64	nr_uninterruptible;	/* Number of tasks in uninterruptible */
+					/* state */
+	__u64	nr_io_wait;		/* Number of tasks waiting on IO */
+};
 
 /*
  * Commands sent from userspace
@@ -176,6 +194,9 @@ enum {
 	TASKSTATS_CMD_UNSPEC = 0,	/* Reserved */
 	TASKSTATS_CMD_GET,		/* user->kernel request/get-response */
 	TASKSTATS_CMD_NEW,		/* kernel->user event */
+	CGROUPSTATS_CMD_GET,		/* user->kernel request/get-response */
+					/* for cgroup statistics */
+	CGROUPSTATS_CMD_NEW,		/* kernel->user event for cgroups */
 	__TASKSTATS_CMD_MAX,
 };
 
@@ -188,6 +209,7 @@ enum {
 	TASKSTATS_TYPE_STATS,		/* taskstats structure */
 	TASKSTATS_TYPE_AGGR_PID,	/* contains pid + stats */
 	TASKSTATS_TYPE_AGGR_TGID,	/* contains tgid + stats */
+	CGROUPSTATS_TYPE_CGROUP_STATS,	/* contains cgroup name + stats */
 	__TASKSTATS_TYPE_MAX,
 };
 
@@ -199,6 +221,7 @@ enum {
 	TASKSTATS_CMD_ATTR_TGID,
 	TASKSTATS_CMD_ATTR_REGISTER_CPUMASK,
 	TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK,
+	CGROUPSTATS_CMD_ATTR_FD,
 	__TASKSTATS_CMD_ATTR_MAX,
 };
 
@@ -207,6 +230,6 @@ enum {
 /* NETLINK_GENERIC related info */
 
 #define TASKSTATS_GENL_NAME	"TASKSTATS"
-#define TASKSTATS_GENL_VERSION	0x1
+#define TASKSTATS_GENL_VERSION	0x2
 
 #endif /* _LINUX_TASKSTATS_H */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3737a68..94bee03 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -43,7 +43,7 @@
 #include <linux/sort.h>
 #include <linux/kmod.h>
 #include <linux/delayacct.h>
-#include <linux/cgroupstats.h>
+#include <linux/taskstats.h>
 #include <linux/hash.h>
 #include <linux/namei.h>
 #include <linux/smp_lock.h>
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 888adbc..448caba 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -22,7 +22,6 @@
 #include <linux/delayacct.h>
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
-#include <linux/cgroupstats.h>
 #include <linux/cgroup.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -46,15 +45,12 @@ static struct genl_family family = {
 	.maxattr	= TASKSTATS_CMD_ATTR_MAX,
 };
 
-static struct nla_policy taskstats_cmd_get_policy[TASKSTATS_CMD_ATTR_MAX+1]
+static struct nla_policy policy[TASKSTATS_CMD_ATTR_MAX+1]
 __read_mostly = {
 	[TASKSTATS_CMD_ATTR_PID]  = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_TGID] = { .type = NLA_U32 },
 	[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK] = { .type = NLA_STRING },
-	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },};
-
-static struct nla_policy
-cgroupstats_cmd_get_policy[CGROUPSTATS_CMD_ATTR_MAX+1] __read_mostly = {
+	[TASKSTATS_CMD_ATTR_DEREGISTER_CPUMASK] = { .type = NLA_STRING },
 	[CGROUPSTATS_CMD_ATTR_FD] = { .type = NLA_U32 },
 };
 
@@ -582,13 +578,13 @@ err:
 static struct genl_ops taskstats_ops = {
 	.cmd		= TASKSTATS_CMD_GET,
 	.doit		= taskstats_user_cmd,
-	.policy		= taskstats_cmd_get_policy,
+	.policy		= policy,
 };
 
 static struct genl_ops cgroupstats_ops = {
 	.cmd		= CGROUPSTATS_CMD_GET,
 	.doit		= cgroupstats_user_cmd,
-	.policy		= cgroupstats_cmd_get_policy,
+	.policy		= policy,
 };
 
 /* Needed early in initialization */

