Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002Ab0AUUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0AUUGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072Ab0AUUGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:06:20 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44315 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0AUUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:06:19 -0500
Date: Thu, 21 Jan 2010 15:08:06 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoskovc@redhat.com, nhorman@tuxdriver.com,
       mingo@redhat.com, drbd-dev@lists.linbit.com, benh@kernel.crashing.org,
       t.sailer@alumni.ethz.ch, abelay@mit.edu, gregkh@suse.de,
       spock@gentoo.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       mfasheh@suse.com, menage@google.com, shemminger@linux-foundation.org,
       takedakn@nttdata.co.jp
Subject: [PATCH] exec: allow core_pipe recursion check to look for a value of
 1 rather than 0
Message-ID: <20100121200806.GA29801@shamino.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -3.9 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	So, about 6 months ago, I made a set of changes to how the
core-dump-to-a-pipe feature in the kernel works.  We had reports of several
races, including some reports of apps bypassing our recursion check so that a
process that was forked as part of a core_pattern setup could infinitely crash
and refork until the system crashed.

	We fixes those by improving our recursion checks.  The new check
basically refuses to fork a process if its core limit is zero, which works well.

	Unfortunately, I've been getting grief from maintainer of user space
programs that are inserted as the forked process of core_pattern.  They contend
that in order for their programs (such as abrt and apport) to work, all the
running processes in a system must have their core limits set to a non-zero
value, to which I say 'yes'.  I did this by design, and think thats the right
way to do things.

	But I've been asked to ease this burden on user space enough times that
I thought I would take a look at it.  The first suggestion was to make the
recursion check fail on a non-zero 'special' number, like one.  That way the
core collector process could set its core size ulimit to 1, and enable the
kernel's recursion detection.  This isn't a bad idea on the surface, but I don't
like it since its opt-in, in that if a program like abrt or apport has a bug and
fails to set such a core limit, we're left with a recursively crashing system
again.

	So I've come up with this.  What I've done is modify the
call_usermodehelper api such that an extra parameter is added, a function
pointer which will be called by the user helper task, after it forks, but before
it exec's the required process.  This will give the caller the opportunity to
get a call back in the processes context, allowing it to do whatever it needs to
to the process in the kernel prior to exec-ing the user space code.  In the case
of do_coredump, this callback is ues to set the core ulimit of the helper
process to 1.  This elimnates the opt-in problem that I had above, as it allows
the ulimit for core sizes to be set to the value of 1, which is what the
recursion check looks for in do_coredump.

	This patch has been tested successfully by some of the Abrt maintainers
in fedora, with good results.  Patch applies to the latest -mm tree as of this
AM.

Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Jiri Moskovcak <jmoskovc@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: drbd-dev@lists.linbit.com
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Thomas Sailer <t.sailer@alumni.ethz.ch>
CC: Adam Belay <abelay@mit.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Michal Januszewski <spock@gentoo.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Neil Brown <neilb@suse.de>
CC: Mark Fasheh <mfasheh@suse.com>
CC: Paul Menage <menage@google.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Kentaro Takeda <takedakn@nttdata.co.jp>

 arch/x86/kernel/cpu/mcheck/mce.c       |    2 +-
 drivers/block/drbd/drbd_nl.c           |    2 +-
 drivers/macintosh/therm_pm72.c         |    2 +-
 drivers/macintosh/windfarm_core.c      |    2 +-
 drivers/net/hamradio/baycom_epp.c      |    2 +-
 drivers/pnp/pnpbios/core.c             |    2 +-
 drivers/staging/rtl8187se/r8180_core.c |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 fs/exec.c                              |   18 +++++++++++++++---
 fs/nfs/cache_lib.c                     |    2 +-
 fs/ocfs2/stackglue.c                   |    2 +-
 include/linux/kmod.h                   |   16 ++++++++++------
 kernel/cgroup.c                        |    2 +-
 kernel/kmod.c                          |   17 +++++++++++++----
 kernel/sys.c                           |    2 +-
 lib/kobject_uevent.c                   |    2 +-
 net/bridge/br_stp_if.c                 |    4 ++--
 security/keys/request_key.c            |    2 +-
 security/tomoyo/common.c               |    2 +-
 19 files changed, 55 insertions(+), 30 deletions(-)


diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..1f59e0d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1164,7 +1164,7 @@ static void mce_start_timer(unsigned long data)
 
 static void mce_do_trigger(struct work_struct *work)
 {
-	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
+	call_usermodehelper(mce_helper, mce_helper_argv, NULL, NULL, UMH_NO_WAIT);
 }
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 4e0726a..ae2719b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -172,7 +172,7 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 	dev_info(DEV, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
 
 	drbd_bcast_ev_helper(mdev, cmd);
-	ret = call_usermodehelper(usermode_helper, argv, envp, 1);
+	ret = call_usermodehelper(usermode_helper, argv, envp, NULL, 1);
 	if (ret)
 		dev_warn(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
 				usermode_helper, cmd, mb,
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 454bc50..899f895 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -1763,7 +1763,7 @@ static int call_critical_overtemp(void)
 				NULL };
 
 	return call_usermodehelper(critical_overtemp_path,
-				   argv, envp, UMH_WAIT_EXEC);
+				   argv, envp, NULL, UMH_WAIT_EXEC);
 }
 
 
diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 075b4d9..640c856 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -81,7 +81,7 @@ int wf_critical_overtemp(void)
 				NULL };
 
 	return call_usermodehelper(critical_overtemp_path,
-				   argv, envp, UMH_WAIT_EXEC);
+				   argv, envp, NULL, UMH_WAIT_EXEC);
 }
 EXPORT_SYMBOL_GPL(wf_critical_overtemp);
 
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index a3c0dc9..daa2097 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -320,7 +320,7 @@ static int eppconfig(struct baycom_state *bc)
 	sprintf(portarg, "%ld", bc->pdev->port->base);
 	printk(KERN_DEBUG "%s: %s -s -p %s -m %s\n", bc_drvname, eppconfig_path, portarg, modearg);
 
-	return call_usermodehelper(eppconfig_path, argv, envp, UMH_WAIT_PROC);
+	return call_usermodehelper(eppconfig_path, argv, envp, NULL, UMH_WAIT_PROC);
 }
 
 /* ---------------------------------------------------------------------- */
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index cfe8685..00bb172 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -142,7 +142,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 			   info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 
-	value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
+	value = call_usermodehelper(argv [0], argv, envp, NULL, UMH_WAIT_EXEC);
 	kfree(buf);
 	kfree(envp);
 	return 0;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index e0f13ef..aaafc00 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -4287,7 +4287,7 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
                                 argv[0] = RadioPowerPath;
                                 argv[2] = NULL;
 
-                                call_usermodehelper(RadioPowerPath,argv,envp,1);
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
 			}
 		}
 }
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 54fbb29..188aea3 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -120,7 +120,7 @@ static int uvesafb_helper_start(void)
 		NULL,
 	};
 
-	return call_usermodehelper(v86d_path, argv, envp, 1);
+	return call_usermodehelper(v86d_path, argv, envp, NULL, 1);
 }
 
 /*
diff --git a/fs/exec.c b/fs/exec.c
index 632b02e..3f2f829 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1755,6 +1755,18 @@ static void wait_for_dump_helpers(struct file *file)
 
 }
 
+/*
+ * This is used as a helper to set up the task that execs
+ * our user space core collector application
+ * Its called in the context of the task thats going to 
+ * exec itself to be the helper, so we can modify current here
+ */
+void core_pipe_setup(void)
+{
+	task_lock(current->group_leader);
+	current->signal->rlim[RLIMIT_CORE].rlim_cur = 1;
+	task_unlock(current->group_leader);
+}
 
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
@@ -1836,7 +1848,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		goto fail_unlock;
 
  	if (ispipe) {
-		if (cprm.limit == 0) {
+		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
@@ -1852,7 +1864,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 			 * core_pattern process dies.
 			 */
 			printk(KERN_WARNING
-				"Process %d(%s) has RLIMIT_CORE set to 0\n",
+				"Process %d(%s) has RLIMIT_CORE set to 1\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
@@ -1877,7 +1889,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 		/* SIGPIPE can happen, but it's just never processed */
 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
-				&cprm.file)) {
+				&cprm.file, core_pipe_setup)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto fail_dropcount;
diff --git a/fs/nfs/cache_lib.c b/fs/nfs/cache_lib.c
index b4ffd01..73d79e9 100644
--- a/fs/nfs/cache_lib.c
+++ b/fs/nfs/cache_lib.c
@@ -46,7 +46,7 @@ int nfs_cache_upcall(struct cache_detail *cd, char *entry_name)
 
 	if (nfs_cache_getent_prog[0] == '\0')
 		goto out;
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	ret = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_EXEC);
 	/*
 	 * Disable the upcall mechanism if we're getting an ENOENT or
 	 * EACCES error. The admin can re-enable it on the fly by using
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index f3df0ba..dddf780 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -407,7 +407,7 @@ static void ocfs2_leave_group(const char *group)
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
 
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
+	ret = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_PROC);
 	if (ret < 0) {
 		printk(KERN_ERR
 		       "ocfs2: Error %d running user helper "
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 384ca8b..ca5e531 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -48,7 +48,9 @@ struct subprocess_info;
 
 /* Allocate a subprocess_info structure */
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask);
+						  char **envp, 
+						  void (*finit)(void),
+						  gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
@@ -72,12 +74,13 @@ int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper(char *path, char **argv, char **envp, 
+		    void (*finit)(void), enum umh_wait wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+	info = call_usermodehelper_setup(path, argv, envp, finit, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 	return call_usermodehelper_exec(info, wait);
@@ -85,12 +88,13 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 
 static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
+			 struct key *session_keyring, 
+			 void (*finit)(void), enum umh_wait wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+	info = call_usermodehelper_setup(path, argv, envp, finit, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 
@@ -102,7 +106,7 @@ extern void usermodehelper_init(void);
 
 struct file;
 extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
-				    struct file **filp);
+				    struct file **filp, void (*finit)(void));
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1fbcc74..2dcbd51 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3780,7 +3780,7 @@ static void cgroup_release_agent(struct work_struct *work)
 		 * since the exec could involve hitting disk and hence
 		 * be a slow process */
 		mutex_unlock(&cgroup_mutex);
-		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+		call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_EXEC);
 		mutex_lock(&cgroup_mutex);
  continue_free:
 		kfree(pathbuf);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index bf0e231..c80db3c 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -35,6 +35,7 @@
 #include <linux/resource.h>
 #include <linux/notifier.h>
 #include <linux/suspend.h>
+#include <linux/gfp.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -117,7 +118,7 @@ int __request_module(bool wait, const char *fmt, ...)
 	trace_module_request(module_name, wait, _RET_IP_);
 
 	ret = call_usermodehelper(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+			NULL, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
@@ -134,6 +135,7 @@ struct subprocess_info {
 	enum umh_wait wait;
 	int retval;
 	struct file *stdin;
+	void (*finit)(void);
 	void (*cleanup)(char **argv, char **envp);
 };
 
@@ -184,6 +186,9 @@ static int ____call_usermodehelper(void *data)
 	 */
 	set_user_nice(current, 0);
 
+	if (sub_info->finit)
+		sub_info->finit();
+
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
@@ -365,7 +370,9 @@ static inline void helper_unlock(void) {}
  * exec the process and free the structure.
  */
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask)
+						  char **envp, 
+						  void (*finit)(void),
+						  gfp_t gfp_mask)
 {
 	struct subprocess_info *sub_info;
 	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
@@ -381,6 +388,7 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
 		kfree(sub_info);
 		return NULL;
 	}
+	sub_info->finit = finit;
 
   out:
 	return sub_info;
@@ -510,12 +518,13 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
  * lower-level call_usermodehelper_* functions.
  */
 int call_usermodehelper_pipe(char *path, char **argv, char **envp,
-			     struct file **filp)
+			     struct file **filp,
+			     void (*finit)(void))
 {
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
+	sub_info = call_usermodehelper_setup(path, argv, envp, finit, GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 26a6b73..0ad1306 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1629,7 +1629,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
+	info = call_usermodehelper_setup(argv[0], argv, envp, NULL, GFP_ATOMIC);
 	if (info == NULL) {
 		argv_free(argv);
 		goto out;
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 920a3ca..df55126 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -258,7 +258,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			goto exit;
 
 		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
+					     env->envp, NULL, UMH_WAIT_EXEC);
 	}
 
 exit:
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 9a52ac5..9d75e7d 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -123,7 +123,7 @@ static void br_stp_start(struct net_bridge *br)
 	char *argv[] = { BR_STP_PROG, br->dev->name, "start", NULL };
 	char *envp[] = { NULL };
 
-	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
+	r = call_usermodehelper(BR_STP_PROG, argv, envp, NULL, UMH_WAIT_PROC);
 	if (r == 0) {
 		br->stp_enabled = BR_USER_STP;
 		printk(KERN_INFO "%s: userspace STP started\n", br->dev->name);
@@ -146,7 +146,7 @@ static void br_stp_stop(struct net_bridge *br)
 	char *envp[] = { NULL };
 
 	if (br->stp_enabled == BR_USER_STP) {
-		r = call_usermodehelper(BR_STP_PROG, argv, envp, 1);
+		r = call_usermodehelper(BR_STP_PROG, argv, envp, NULL, 1);
 		printk(KERN_INFO "%s: userspace STP stopped, return code %d\n",
 			br->dev->name, r);
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 03fe63e..f929b69 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -139,7 +139,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	/* do it */
 	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring,
-				       UMH_WAIT_PROC);
+				       NULL, UMH_WAIT_PROC);
 	kdebug("usermode -> 0x%x", ret);
 	if (ret >= 0) {
 		/* ret is the exit/wait code */
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index e0d0354..4aeefd7 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -1882,7 +1882,7 @@ void tomoyo_load_policy(const char *filename)
 	envp[0] = "HOME=/";
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
-	call_usermodehelper(argv[0], argv, envp, 1);
+	call_usermodehelper(argv[0], argv, envp, NULL, 1);
 
 	printk(KERN_INFO "TOMOYO: 2.2.0   2009/04/01\n");
 	printk(KERN_INFO "Mandatory Access Control activated.\n");
