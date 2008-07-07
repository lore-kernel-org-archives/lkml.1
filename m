Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYGGQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYGGQwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYGGQuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:12 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753697AbYGGQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:09 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/20] selinux: simplify ioctl checking
Date: Tue,  8 Jul 2008 01:42:10 +0900
Message-Id: <1215448942-17581-9-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Simplify and improve the robustness of the SELinux ioctl checking by
using the "access mode" bits of the ioctl command to determine the
permission check rather than dealing with individual command values.
This removes any knowledge of specific ioctl commands from SELinux
and follows the same guidance we gave to Smack earlier.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/hooks.c |   48 +++++++--------------------------------------
 1 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 91b666a..f530008 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -42,9 +42,7 @@
 #include <linux/fdtable.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
-#include <linux/ext2_fs.h>
 #include <linux/proc_fs.h>
-#include <linux/kd.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/tty.h>
@@ -2903,46 +2901,16 @@ static void selinux_file_free_security(struct file *file)
 static int selinux_file_ioctl(struct file *file, unsigned int cmd,
 			      unsigned long arg)
 {
-	int error = 0;
-
-	switch (cmd) {
-	case FIONREAD:
-	/* fall through */
-	case FIBMAP:
-	/* fall through */
-	case FIGETBSZ:
-	/* fall through */
-	case EXT2_IOC_GETFLAGS:
-	/* fall through */
-	case EXT2_IOC_GETVERSION:
-		error = file_has_perm(current, file, FILE__GETATTR);
-		break;
-
-	case EXT2_IOC_SETFLAGS:
-	/* fall through */
-	case EXT2_IOC_SETVERSION:
-		error = file_has_perm(current, file, FILE__SETATTR);
-		break;
-
-	/* sys_ioctl() checks */
-	case FIONBIO:
-	/* fall through */
-	case FIOASYNC:
-		error = file_has_perm(current, file, 0);
-		break;
+	u32 av = 0;
 
-	case KDSKBENT:
-	case KDSKBSENT:
-		error = task_has_capability(current, CAP_SYS_TTY_CONFIG);
-		break;
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		av |= FILE__WRITE;
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		av |= FILE__READ;
+	if (!av)
+		av = FILE__IOCTL;
 
-	/* default case assumes that the command will go
-	 * to the file's ioctl() function.
-	 */
-	default:
-		error = file_has_perm(current, file, FILE__IOCTL);
-	}
-	return error;
+	return file_has_perm(current, file, av);
 }
 
 static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
-- 
1.5.5.1

