Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbXGaHFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbXGaHFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbXGaHFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:05:07 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:24274 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXGaHFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from:sender;
        b=VA1HbNaxM68grXxOkGMHIgLNEyR0C8Jef1gkiBpFSJzppLkmQt0bWEByLoHRbkMUXT0ICv9CL9f9LZLb6qY+rENuFLBUXfS6PvZjfUxKxuLUsmwrnrd70qEoQynpLZXT+Xsj8uV/yVDBIVZcQCdK749sTqQz3ibAc0VTXD0X1O8=
Date: Tue, 31 Jul 2007 15:04:58 +0800
To: linux-kernel@vger.kernel.org
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/3] coredump: remove suidsafe mode related dead code
Message-ID: <20070731070458.GC2412@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731070238.GA2412@kernel.sg>
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes suidsafe core dump mode related dead code.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/exec.c               |   16 +---------------
 include/linux/binfmts.h |    3 ---
 2 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7bdea79..60b4080 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1723,8 +1723,6 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	struct inode * inode;
 	struct file * file;
 	int retval = 0;
-	int fsuid = current->fsuid;
-	int flag = 0;
 	int ispipe = 0;
 
 	audit_core_dumps(signr);
@@ -1737,16 +1735,6 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}
-
-	/*
-	 *	We cannot trust fsuid as being the "true" uid of the
-	 *	process nor do we know its entire history. We only know it
-	 *	was tainted so we dump it as root in mode 2.
-	 */
-	if (get_dumpable(mm) == 2) {	/* Setuid core dump mode */
-		flag = O_EXCL;		/* Stop rewrite attacks */
-		current->fsuid = 0;	/* Dump root private */
-	}
 	set_dumpable(mm, 0);
 
 	retval = coredump_wait(exit_code);
@@ -1778,8 +1766,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
  		}
  	} else
  		file = filp_open(corename,
-				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
-				 0600);
+				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE, 0600);
 	if (IS_ERR(file))
 		goto fail_unlock;
 	inode = file->f_path.dentry->d_inode;
@@ -1806,7 +1793,6 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 close_fail:
 	filp_close(file, NULL);
 fail_unlock:
-	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
 fail:
 	return retval;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 91c8c07..ca75ee4 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -81,9 +81,6 @@ extern int search_binary_handler(struct linux_binprm *,struct pt_regs *);
 extern int flush_old_exec(struct linux_binprm * bprm);
 
 extern int suid_dumpable;
-#define SUID_DUMP_DISABLE	0	/* No setuid dumping */
-#define SUID_DUMP_USER		1	/* Dump as user of process */
-#define SUID_DUMP_ROOT		2	/* Dump as root */
 
 /* Stack area protections */
 #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */

