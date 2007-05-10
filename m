Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbXEKTNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbXEKTNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXEKTKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:10:21 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:60106 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763102AbXEKTKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:10:17 -0400
Message-Id: <20070511000028.927787000@goop.org>
References: <20070510235708.155502000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 16:57:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ralf Baechle <ralf@linux-mips.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Joel Becker <joel.becker@oracle.com>, Tony Luck <tony.luck@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>
Subject: [patch 7/7] tidy up usermode helper waiting a bit
Content-Disposition: inline; filename=usermodehelper-tidy.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using a tri-state integer for the wait flag in
call_usermodehelper_exec, define a proper enum, and use that.  I've
preserved the integer values so that any callers I've missed should
still work OK.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Howells <dhowells@redhat.com>
---
 arch/i386/mach-voyager/voyager_thread.c |    2 +-
 arch/x86_64/kernel/mce.c                |    2 +-
 drivers/macintosh/therm_pm72.c          |    3 ++-
 drivers/macintosh/windfarm_core.c       |    3 ++-
 drivers/net/hamradio/baycom_epp.c       |    2 +-
 drivers/pnp/pnpbios/core.c              |    2 +-
 fs/ocfs2/heartbeat.c                    |    2 +-
 include/linux/kmod.h                    |   12 +++++++++---
 kernel/cpuset.c                         |    2 +-
 kernel/kmod.c                           |   29 +++++++++++++++++------------
 kernel/sys.c                            |    2 +-
 lib/kobject_uevent.c                    |    2 +-
 net/bridge/br_stp_if.c                  |    2 +-
 security/keys/request_key.c             |    3 ++-
 14 files changed, 41 insertions(+), 27 deletions(-)

===================================================================
--- a/arch/i386/mach-voyager/voyager_thread.c
+++ b/arch/i386/mach-voyager/voyager_thread.c
@@ -52,7 +52,7 @@ execute(const char *string)
 		NULL,
 	};
 
-	if ((ret = call_usermodehelper(argv[0], argv, envp, 1)) != 0) {
+	if ((ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC)) != 0) {
 		printk(KERN_ERR "Voyager failed to run \"%s\": %i\n",
 		       string, ret);
 	}
===================================================================
--- a/arch/x86_64/kernel/mce.c
+++ b/arch/x86_64/kernel/mce.c
@@ -174,7 +174,7 @@ static void do_mce_trigger(void)
 	if (events != atomic_read(&mce_logged) && trigger[0]) {
 		/* Small race window, but should be harmless.  */
 		atomic_set(&mce_logged, events);
-		call_usermodehelper(trigger, trigger_argv, NULL, -1);
+		call_usermodehelper(trigger, trigger_argv, NULL, UMH_NO_WAIT);
 	}
 }
 
===================================================================
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -1770,7 +1770,8 @@ static int call_critical_overtemp(void)
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 				NULL };
 
-	return call_usermodehelper(critical_overtemp_path, argv, envp, 0);
+	return call_usermodehelper(critical_overtemp_path,
+				   argv, envp, UMH_WAIT_EXEC);
 }
 
 
===================================================================
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -80,7 +80,8 @@ int wf_critical_overtemp(void)
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 				NULL };
 
-	return call_usermodehelper(critical_overtemp_path, argv, envp, 0);
+	return call_usermodehelper(critical_overtemp_path,
+				   argv, envp, UMH_WAIT_EXEC);
 }
 EXPORT_SYMBOL_GPL(wf_critical_overtemp);
 
===================================================================
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -320,7 +320,7 @@ static int eppconfig(struct baycom_state
 	sprintf(portarg, "%ld", bc->pdev->port->base);
 	printk(KERN_DEBUG "%s: %s -s -p %s -m %s\n", bc_drvname, eppconfig_path, portarg, modearg);
 
-	return call_usermodehelper(eppconfig_path, argv, envp, 1);
+	return call_usermodehelper(eppconfig_path, argv, envp, UMH_WAIT_PROC);
 }
 
 /* ---------------------------------------------------------------------- */
===================================================================
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -147,7 +147,7 @@ static int pnp_dock_event(int dock, stru
 		info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 	
-	value = call_usermodehelper (argv [0], argv, envp, 0);
+	value = call_usermodehelper (argv [0], argv, envp, UMH_WAIT_EXEC);
 	kfree (buf);
 	kfree (envp);
 	return 0;
===================================================================
--- a/fs/ocfs2/heartbeat.c
+++ b/fs/ocfs2/heartbeat.c
@@ -209,7 +209,7 @@ void ocfs2_stop_heartbeat(struct ocfs2_s
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
 
-	ret = call_usermodehelper(argv[0], argv, envp, 1);
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
 	if (ret < 0)
 		mlog_errno(ret);
 }
===================================================================
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -51,15 +51,21 @@ void call_usermodehelper_setcleanup(stru
 void call_usermodehelper_setcleanup(struct subprocess_info *info,
 				    void (*cleanup)(char **argv, char **envp));
 
+enum umh_wait {
+	UMH_NO_WAIT = -1,	/* don't wait at all */
+	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
+	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
+};
+
 /* Actually execute the sub-process */
-int call_usermodehelper_exec(struct subprocess_info *info, int wait);
+int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
 
 /* Free the subprocess_info. This is only needed if you're not going
    to call call_usermodehelper_exec */
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, int wait)
+call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
 	struct subprocess_info *info;
 
@@ -71,7 +77,7 @@ call_usermodehelper(char *path, char **a
 
 static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, int wait)
+			 struct key *session_keyring, enum umh_wait wait)
 {
 	struct subprocess_info *info;
 
===================================================================
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -516,7 +516,7 @@ static void cpuset_release_agent(const c
 	envp[i++] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[i] = NULL;
 
-	call_usermodehelper(argv[0], argv, envp, 0);
+	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 	kfree(pathbuf);
 }
 
===================================================================
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -119,7 +119,7 @@ struct subprocess_info {
 	char **argv;
 	char **envp;
 	struct key *ring;
-	int wait;
+	enum umh_wait wait;
 	int retval;
 	struct file *stdin;
 	void (*cleanup)(char **argv, char **envp);
@@ -225,7 +225,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	if (sub_info->wait < 0)
+	if (sub_info->wait == UMH_NO_WAIT)
 		call_usermodehelper_freeinfo(sub_info);
 	else
 		complete(sub_info->complete);
@@ -238,26 +238,31 @@ static void __call_usermodehelper(struct
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
 	pid_t pid;
-	int wait = sub_info->wait;
+	enum umh_wait wait = sub_info->wait;
 
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait)
+	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
 		pid = kernel_thread(____call_usermodehelper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
 
-	if (wait < 0)
-		return;
-
-	if (pid < 0) {
+	switch(wait) {
+	case UMH_NO_WAIT:
+		break;
+
+	case UMH_WAIT_PROC:
+		if (pid > 0)
+			break;
 		sub_info->retval = pid;
+		/* FALLTHROUGH */
+
+	case UMH_WAIT_EXEC:
 		complete(sub_info->complete);
-	} else if (!wait)
-		complete(sub_info->complete);
+	}
 }
 
 /**
@@ -359,7 +364,7 @@ EXPORT_SYMBOL(call_usermodehelper_stdinp
  * (ie. it runs with full root capabilities).
  */
 int call_usermodehelper_exec(struct subprocess_info *sub_info,
-			     int wait)
+			     enum umh_wait wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval;
@@ -378,7 +383,7 @@ int call_usermodehelper_exec(struct subp
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait < 0) /* task has freed sub_info */
+	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
 		return 0;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
===================================================================
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2310,7 +2310,7 @@ int orderly_poweroff(bool force)
 
 	call_usermodehelper_setcleanup(info, argv_cleanup);
 
-	ret = call_usermodehelper_exec(info, -1);
+	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
 
   out:
 	if (ret && force) {
===================================================================
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -208,7 +208,7 @@ int kobject_uevent_env(struct kobject *k
 		argv [0] = uevent_helper;
 		argv [1] = (char *)subsystem;
 		argv [2] = NULL;
-		call_usermodehelper (argv[0], argv, envp, 0);
+		call_usermodehelper (argv[0], argv, envp, UMH_WAIT_EXEC);
 	}
 
 exit:
===================================================================
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -125,7 +125,7 @@ static void br_stp_start(struct net_brid
 	char *argv[] = { BR_STP_PROG, br->dev->name, "start", NULL };
 	char *envp[] = { NULL };
 
-	r = call_usermodehelper(BR_STP_PROG, argv, envp, 1);
+	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
 	if (r == 0) {
 		br->stp_enabled = BR_USER_STP;
 		printk(KERN_INFO "%s: userspace STP started\n", br->dev->name);
===================================================================
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -108,7 +108,8 @@ static int call_sbin_request_key(struct 
 	argv[i] = NULL;
 
 	/* do it */
-	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring, 1);
+	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring,
+				       UMH_WAIT_PROC);
 
 error_link:
 	key_put(keyring);

-- 

