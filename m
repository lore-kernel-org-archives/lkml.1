Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZKHMWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZKHMWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZKHMWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49536 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZKHMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:27 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 08/23] sysctl ipc: Remove dead binary sysctl support code.
Date: Sun,  8 Nov 2009 04:21:55 -0800
Message-Id: <1257682930-31401-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 ipc/ipc_sysctl.c |   77 ------------------------------------------------------
 ipc/mq_sysctl.c  |    7 ++---
 2 files changed, 3 insertions(+), 81 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 7d37047..56410fa 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -129,136 +129,60 @@ static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 #define proc_ipcauto_dointvec_minmax NULL
 #endif
 
-#ifdef CONFIG_SYSCTL_SYSCALL
-/* The generic sysctl ipc data routine. */
-static int sysctl_ipc_data(ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	size_t len;
-	void *data;
-
-	/* Get out of I don't have a variable */
-	if (!table->data || !table->maxlen)
-		return -ENOTDIR;
-
-	data = get_ipc(table);
-	if (!data)
-		return -ENOTDIR;
-
-	if (oldval && oldlenp) {
-		if (get_user(len, oldlenp))
-			return -EFAULT;
-		if (len) {
-			if (len > table->maxlen)
-				len = table->maxlen;
-			if (copy_to_user(oldval, data, len))
-				return -EFAULT;
-			if (put_user(len, oldlenp))
-				return -EFAULT;
-		}
-	}
-
-	if (newval && newlen) {
-		if (newlen > table->maxlen)
-			newlen = table->maxlen;
-
-		if (copy_from_user(data, newval, newlen))
-			return -EFAULT;
-	}
-	return 1;
-}
-
-static int sysctl_ipc_registered_data(ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	int rc;
-
-	rc = sysctl_ipc_data(table, oldval, oldlenp, newval, newlen);
-
-	if (newval && newlen && rc > 0)
-		/*
-		 * Tunable has successfully been changed from userland
-		 */
-		unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-
-	return rc;
-}
-#else
-#define sysctl_ipc_data NULL
-#define sysctl_ipc_registered_data NULL
-#endif
-
 static int zero;
 static int one = 1;
 
 static struct ctl_table ipc_kern_table[] = {
 	{
-		.ctl_name	= KERN_SHMMAX,
 		.procname	= "shmmax",
 		.data		= &init_ipc_ns.shm_ctlmax,
 		.maxlen		= sizeof (init_ipc_ns.shm_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_doulongvec_minmax,
-		.strategy	= sysctl_ipc_data,
 	},
 	{
-		.ctl_name	= KERN_SHMALL,
 		.procname	= "shmall",
 		.data		= &init_ipc_ns.shm_ctlall,
 		.maxlen		= sizeof (init_ipc_ns.shm_ctlall),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_doulongvec_minmax,
-		.strategy	= sysctl_ipc_data,
 	},
 	{
-		.ctl_name	= KERN_SHMMNI,
 		.procname	= "shmmni",
 		.data		= &init_ipc_ns.shm_ctlmni,
 		.maxlen		= sizeof (init_ipc_ns.shm_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
 	},
 	{
-		.ctl_name	= KERN_MSGMAX,
 		.procname	= "msgmax",
 		.data		= &init_ipc_ns.msg_ctlmax,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
 	},
 	{
-		.ctl_name	= KERN_MSGMNI,
 		.procname	= "msgmni",
 		.data		= &init_ipc_ns.msg_ctlmni,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_callback_dointvec,
-		.strategy	= sysctl_ipc_registered_data,
 	},
 	{
-		.ctl_name	= KERN_MSGMNB,
 		.procname	=  "msgmnb",
 		.data		= &init_ipc_ns.msg_ctlmnb,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
 	},
 	{
-		.ctl_name	= KERN_SEM,
 		.procname	= "sem",
 		.data		= &init_ipc_ns.sem_ctls,
 		.maxlen		= 4*sizeof (int),
 		.mode		= 0644,
 		.proc_handler	= proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "auto_msgmni",
 		.data		= &init_ipc_ns.auto_msgmni,
 		.maxlen		= sizeof(int),
@@ -272,7 +196,6 @@ static struct ctl_table ipc_kern_table[] = {
 
 static struct ctl_table ipc_root_table[] = {
 	{
-		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
 		.mode		= 0555,
 		.child		= ipc_kern_table,
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 8a05871..0c09366 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -88,7 +88,7 @@ static ctl_table mq_sysctls[] = {
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
-	{ .ctl_name = 0 }
+	{}
 };
 
 static ctl_table mq_sysctl_dir[] = {
@@ -97,17 +97,16 @@ static ctl_table mq_sysctl_dir[] = {
 		.mode		= 0555,
 		.child		= mq_sysctls,
 	},
-	{ .ctl_name = 0 }
+	{}
 };
 
 static ctl_table mq_sysctl_root[] = {
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.mode		= 0555,
 		.child		= mq_sysctl_dir,
 	},
-	{ .ctl_name = 0 }
+	{}
 };
 
 struct ctl_table_header *mq_register_sysctl_table(void)
-- 
1.6.5.2.143.g8cc62

