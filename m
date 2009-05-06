Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbZEFOvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbZEFOvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbZEFOtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:08 -0400
Received: from mail.crca.org.au ([67.207.131.56]:47434 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759548AbZEFOs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:58 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 16/19] TuxOnIce: Warn user if an initrd doesn't include an attempt at resuming.
Date: Thu,  7 May 2009 00:39:12 +1000
Message-Id: <1241620755-22133-17-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the user with a warning (in logs) if they're using an initrd and
no attempt is made at resuming.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 include/linux/suspend.h           |   14 ++++++++++++++
 init/do_mounts.c                  |    2 ++
 init/do_mounts_initrd.c           |    6 ++++++
 kernel/power/snapshot.c           |    1 +
 kernel/power/tuxonice_highlevel.c |    3 +++
 5 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 8faa15c..1f52617 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -359,5 +359,19 @@ extern void try_tuxonice_resume(void);
 #else
 #define try_tuxonice_resume() do { } while (0)
 #endif
+
+extern int resume_attempted;
+extern int software_resume(void);
+
+static inline void check_resume_attempted(void)
+{
+	if (resume_attempted)
+		return;
+
+	software_resume();
+}
+#else
+#define check_resume_attempted() do { } while (0)
+#define resume_attempted (0)
 #endif
 #endif /* _LINUX_SUSPEND_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index dd7ee5f..605adc5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -412,6 +412,8 @@ void __init prepare_namespace(void)
 	if (is_floppy && rd_doload && rd_load_disk(0))
 		ROOT_DEV = Root_RAM0;
 
+	check_resume_attempted();
+
 	mount_root();
 out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 614241b..f3ea292 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -6,6 +6,7 @@
 #include <linux/romfs_fs.h>
 #include <linux/initrd.h>
 #include <linux/sched.h>
+#include <linux/suspend.h>
 #include <linux/freezer.h>
 
 #include "do_mounts.h"
@@ -68,6 +69,11 @@ static void __init handle_initrd(void)
 
 	current->flags &= ~PF_FREEZER_SKIP;
 
+	if (!resume_attempted)
+		printk(KERN_ERR "TuxOnIce: No attempt was made to resume from "
+				"any image that might exist.\n");
+	clear_toi_state(TOI_BOOT_TIME);
+
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
 	sys_mount("/", ".", NULL, MS_MOVE, NULL);
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index df70aff..bae4278 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -47,6 +47,7 @@ static void swsusp_unset_page_forbidden(struct page *);
  * directly to their "original" page frames.
  */
 struct pbe *restore_pblist;
+int resume_attempted;
 
 /* Pointer to an auxiliary buffer (1 page) */
 static void *buffer;
diff --git a/kernel/power/tuxonice_highlevel.c b/kernel/power/tuxonice_highlevel.c
index f2ba0bb..06f97e7 100644
--- a/kernel/power/tuxonice_highlevel.c
+++ b/kernel/power/tuxonice_highlevel.c
@@ -970,6 +970,7 @@ out:
 void toi_try_resume(void)
 {
 	set_toi_state(TOI_TRYING_TO_RESUME);
+	resume_attempted = 1;
 
 	current->flags |= PF_MEMALLOC;
 
@@ -994,6 +995,8 @@ void toi_try_resume(void)
  **/
 static void toi_sys_power_disk_try_resume(void)
 {
+	resume_attempted = 1;
+
 	/*
 	 * There's a comment in kernel/power/disk.c that indicates
 	 * we should be able to use mutex_lock_nested below. That
-- 
1.5.6.3

