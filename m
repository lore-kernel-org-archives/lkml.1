Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYIVSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYIVSst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYIVSsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:48:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43914 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYIVSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:48:39 -0400
Date: Mon, 22 Sep 2008 13:48:35 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
Message-ID: <20080922184835.GA2826@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend of two patches from late August.  If noone objects, would it be
possible to see this pair take a turn in security-testing?)

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

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
---
 kernel/capability.c  |   13 +++++++++++++
 security/commoncap.c |   11 +++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 33e51e7..5d034ec 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -33,6 +33,19 @@ EXPORT_SYMBOL(__cap_empty_set);
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
+#else
+static const int file_caps_enabled = 0;
+#endif
+
 /*
  * More recent versions of libcap are available from:
  *
diff --git a/security/commoncap.c b/security/commoncap.c
index e4c4b3f..8c66d34 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -27,6 +27,12 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+extern int file_caps_enabled;
+#else
+static const int file_caps_enabled = 0;
+#endif
+
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
 	NETLINK_CB(skb).eff_cap = current->cap_effective;
@@ -279,6 +285,11 @@ static int get_file_caps(struct linux_binprm *bprm)
 	struct vfs_cap_data vcaps;
 	struct inode *inode;
 
+	if (!file_caps_enabled) {
+		bprm_clear_caps(bprm);
+		return 0;
+	}
+
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
 		bprm_clear_caps(bprm);
 		return 0;
-- 
1.5.4.3

