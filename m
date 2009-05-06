Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbZEFOx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbZEFOx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbZEFOtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:14 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50310 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560AbZEFOs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:58 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 17/19] TuxOnIce: Support for replacing swsusp.
Date: Thu,  7 May 2009 00:39:13 +1000
Message-Id: <1241620755-22133-18-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support for activating TuxOnIce via

	echo disk > /sys/power/state

together with a compile time option to control the default and a sysfs
entry in TuxOnIce's directories to toggle it at run time. Since at
resume time we don't know whether we wrote a TuxOnIce image, always
check for TuxOnIce images when checking for swsusp images (TuxOnIce
recognises swsusp signatures and won't complain about them).

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 kernel/power/Kconfig              |   14 ++++++++++++++
 kernel/power/disk.c               |   10 ++++++++++
 kernel/power/tuxonice.h           |    1 +
 kernel/power/tuxonice_builtin.c   |    3 +++
 kernel/power/tuxonice_highlevel.c |    2 ++
 5 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index f669cdd..dfe0328 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -259,6 +259,20 @@ menuconfig TOI_CORE
 		  bit. Keep image mode is a little less user friendly on purpose - it
 		  should not be used without thought!
 
+	config TOI_REPLACE_SWSUSP
+		bool "Replace swsusp by default"
+		default y
+		depends on TOI_CORE
+		---help---
+		  TuxOnIce can replace swsusp. This option makes that the default state,
+		  requiring you to echo 0 > /sys/power/tuxonice/replace_swsusp if you want
+		  to use the vanilla kernel functionality. Note that your initrd/ramfs will
+		  need to do this before trying to resume, too.
+		  With overriding swsusp enabled, echoing disk  to /sys/power/state will
+		  start a TuxOnIce cycle. If resume= doesn't specify an allocator and both
+		  the swap and file allocators are compiled in, the swap allocator will be
+		  used by default.
+
 	config TOI_IGNORE_LATE_INITCALL
 		bool "Wait for initrd/ramfs to run, by default"
 		default n
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 9a1174c..510730a 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -556,6 +556,9 @@ int hibernate(void)
 {
 	int error;
 
+	if (test_action_state(TOI_REPLACE_SWSUSP))
+		return try_tuxonice_hibernate();
+
 	mutex_lock(&pm_mutex);
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
@@ -637,6 +640,13 @@ int software_resume(void)
 {
 	int error;
 	unsigned int flags;
+	resume_attempted = 1;
+
+	/*
+	 * We can't know (until an image header - if any - is loaded), whether
+	 * we did override swsusp. We therefore ensure that both are tried.
+	 */
+	try_tuxonice_resume();
 
 	/*
 	 * If the user said "noresume".. bail out early.
diff --git a/kernel/power/tuxonice.h b/kernel/power/tuxonice.h
index 2262973..1d6349d 100644
--- a/kernel/power/tuxonice.h
+++ b/kernel/power/tuxonice.h
@@ -55,6 +55,7 @@ enum {
 	TOI_TEST_BIO,
 	TOI_NO_PAGESET2,
 	TOI_IGNORE_ROOTFS,
+	TOI_REPLACE_SWSUSP,
 	TOI_PAGESET2_FULL,
 	TOI_ABORT_ON_RESAVE_NEEDED,
 	TOI_NO_MULTITHREADED_IO,
diff --git a/kernel/power/tuxonice_builtin.c b/kernel/power/tuxonice_builtin.c
index dab9de2..da7680e 100644
--- a/kernel/power/tuxonice_builtin.c
+++ b/kernel/power/tuxonice_builtin.c
@@ -165,6 +165,9 @@ struct toi_boot_kernel_data toi_bkd __nosavedata
 		__attribute__((aligned(PAGE_SIZE))) = {
 	MY_BOOT_KERNEL_DATA_VERSION,
 	0,
+#ifdef CONFIG_TOI_REPLACE_SWSUSP
+	(1 << TOI_REPLACE_SWSUSP) |
+#endif
 	(1 << TOI_NO_FLUSHER_THREAD) |
 	(1 << TOI_PAGESET2_FULL) | (1 << TOI_LATE_CPU_HOTPLUG),
 };
diff --git a/kernel/power/tuxonice_highlevel.c b/kernel/power/tuxonice_highlevel.c
index 06f97e7..9bd5b34 100644
--- a/kernel/power/tuxonice_highlevel.c
+++ b/kernel/power/tuxonice_highlevel.c
@@ -1190,6 +1190,8 @@ static struct toi_sysfs_data sysfs_params[] = {
 	SYSFS_BIT("full_pageset2", SYSFS_RW, &toi_bkd.toi_action,
 			TOI_PAGESET2_FULL, 0),
 	SYSFS_BIT("reboot", SYSFS_RW, &toi_bkd.toi_action, TOI_REBOOT, 0),
+	SYSFS_BIT("replace_swsusp", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_REPLACE_SWSUSP, 0),
 	SYSFS_STRING("resume_commandline", SYSFS_RW,
 			toi_bkd.toi_nosave_commandline, COMMAND_LINE_SIZE, 0,
 			NULL),
-- 
1.5.6.3

