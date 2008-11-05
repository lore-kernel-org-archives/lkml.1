Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYKEWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYKEWJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYKEWJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:09:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48965 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYKEWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:08:59 -0500
Date: Wed, 5 Nov 2008 16:08:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] file capabilities: add no_file_caps switch (v4)
Message-ID: <20081105220852.GA1622@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James, do you mind adding this to the security-testing tree?

(It needs the recent file-caps-always-start-with-clear-bprm-caps patch
which is upstream but not in security-testing:next - if it's more
convenient for you I can resend that)

thanks,
-serge

>From bc846f3d1515a33d024eb56cb7ac58ee15baa769 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serue@us.ibm.com>
Date: Tue, 23 Sep 2008 17:17:27 -0500
Subject: [PATCH 1/1] file capabilities: add no_file_caps switch (v4)

Add a no_file_caps boot option when file capabilities are
compiled into the kernel (CONFIG_SECURITY_FILE_CAPABILITIES=y).

This allows distributions to ship a kernel with file capabilities
compiled in, without forcing users to use (and understand and
trust) them.

When no_file_caps is specified at boot, then when a process executes
a file, any file capabilities stored with that file will not be
used in the calculation of the process' new capability sets.

This means that booting with the no_file_caps boot option will
not be the same as booting a kernel with file capabilities
compiled out - in particular a task with  CAP_SETPCAP will not
have any chance of passing capabilities to another task (which
isn't "really" possible anyway, and which may soon by killed
altogether by David Howells in any case), and it will instead
be able to put new capabilities in its pI.  However since fI
will always be empty and pI is masked with fI, it gains the
task nothing.

We also support the extra prctl options, setting securebits and
dropping capabilities from the per-process bounding set.

The other remaining difference is that killpriv, task_setscheduler,
setioprio, and setnice will continue to be hooked.  That will
be noticable in the case where a root task changed its uid
while keeping some caps, and another task owned by the new uid
tries to change settings for the more privileged task.

Changelog:
	Nov 05 2008: (v4) trivial port on top of always-start-\
		with-clear-caps patch
	Sep 23 2008: nixed file_caps_enabled when file caps are
		not compiled in as it isn't used.
		Document no_file_caps in kernel-parameters.txt.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
---
 Documentation/kernel-parameters.txt |    4 ++++
 include/linux/capability.h          |    3 +++
 kernel/capability.c                 |   11 +++++++++++
 security/commoncap.c                |    3 +++
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 329dcab..ed397f4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1387,6 +1387,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			instruction doesn't work correctly and not to
 			use it.
 
+	no_file_caps	Tells the kernel not to honor file capabilities.  The
+			only way then for a file to be executed with privilege
+			is to be setuid root or executed by root.
+
 	nohalt		[IA-64] Tells the kernel not to use the power saving
 			function PAL_HALT_LIGHT when idle. This increases
 			power-consumption. On the positive side, it reduces
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 9d1fe30..5bc145b 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -68,6 +68,9 @@ typedef struct __user_cap_data_struct {
 #define VFS_CAP_U32             VFS_CAP_U32_2
 #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+extern int file_caps_enabled;
+#endif
 
 struct vfs_cap_data {
 	__le32 magic_etc;            /* Little endian */
diff --git a/kernel/capability.c b/kernel/capability.c
index 33e51e7..e13a685 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -33,6 +33,17 @@ EXPORT_SYMBOL(__cap_empty_set);
 EXPORT_SYMBOL(__cap_full_set);
 EXPORT_SYMBOL(__cap_init_eff_set);
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+int file_caps_enabled = 1;
+
+static int __init file_caps_disable(char *str)
+{
+	file_caps_enabled = 0;
+	return 1;
+}
+__setup("no_file_caps", file_caps_disable);
+#endif
+
 /*
  * More recent versions of libcap are available from:
  *
diff --git a/security/commoncap.c b/security/commoncap.c
index 3976613..f88119c 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -281,6 +281,9 @@ static int get_file_caps(struct linux_binprm *bprm)
 
 	bprm_clear_caps(bprm);
 
+	if (!file_caps_enabled)
+		return 0;
+
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
 		return 0;
 
-- 
1.5.6.3

