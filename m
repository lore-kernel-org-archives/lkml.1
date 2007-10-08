Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXJHVet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXJHVet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXJHVeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:34:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbXJHVeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:34:12 -0400
Subject: [PATCH 3/3] Audit: remove the limit on execve arguments when audit
	is running
From: Eric Paris <eparis@redhat.com>
To: linux-audit@redhat.com
Cc: sgrubb@redhat.com, aviro@redhat.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, mchouque@free.fr
Content-Type: text/plain
Date: Mon, 08 Oct 2007 17:34:06 -0400
Message-Id: <1191879246.3132.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Remove the limitation on argv size.  The audit system now logs arguments in
    smaller chunks (currently about 8k due to userspace audit system buffer sizes)
    so this is no longer a requirement.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

---

This patch hasn't changed since the last series, just reposted as 3/3 and rediffed.

 kernel/auditsc.c |   10 ----------
 kernel/sysctl.c  |   11 -----------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index ffc8d4b..5d39727 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1917,8 +1917,6 @@ int __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, mode_t mode
 	return 0;
 }
 
-int audit_argv_kb = 32;
-
 int audit_bprm(struct linux_binprm *bprm)
 {
 	struct audit_aux_data_execve *ax;
@@ -1927,14 +1925,6 @@ int audit_bprm(struct linux_binprm *bprm)
 	if (likely(!audit_enabled || !context || context->dummy))
 		return 0;
 
-	/*
-	 * Even though the stack code doesn't limit the arg+env size any more,
-	 * the audit code requires that _all_ arguments be logged in a single
-	 * netlink skb. Hence cap it :-(
-	 */
-	if (bprm->argv_len > (audit_argv_kb << 10))
-		return -E2BIG;
-
 	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
 	if (!ax)
 		return -ENOMEM;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 53a456e..88e5d06 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -77,7 +77,6 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
-extern int audit_argv_kb;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -347,16 +346,6 @@ static ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-#ifdef CONFIG_AUDITSYSCALL
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "audit_argv_kb",
-		.data		= &audit_argv_kb,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-#endif
 	{
 		.ctl_name	= KERN_CORE_PATTERN,
 		.procname	= "core_pattern",


