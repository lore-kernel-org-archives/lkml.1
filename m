Return-Path: <linux-kernel-owner+w=401wt.eu-S1762732AbYEAPxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732AbYEAPxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbYEAPxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:53:12 -0400
Received: from jade.aracnet.com ([216.99.193.136]:37518 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759374AbYEAPxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:53:11 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 11:53:11 EDT
Message-ID: <4819E594.2050303@BitWagon.com>
Date: Thu, 01 May 2008 08:45:24 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: execve filename: document and export via auxiliary vector
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel puts the filename argument of execve() into the
new address space.  Many developers are surprised to learn this.
Those who know and could use it, object "But it's not documented."
Those who want to use it dislike the expression
  (char *)(1+ strlen(env[-1+ n_env]) + env[-1+ n_env])
because it requires locating the last original environment variable,
and assumes that the filename follows the characters.

This patch documents the insertion of the filename, and makes it
easier to find by adding a new tag AT_EXECFN in the ElfXX_auxv_t;
see <elf.h>.

In many cases readlink("/proc/self/exe",) gives the same answer.
But if all the original pages get unmapped, then the kernel erases
the symlink for /proc/self/exe.  This can happen when a program
decompressor does a good job of cleaning up after uncompressing
directly to memory, so that the address space of the target program
looks the same as if compression had never happened.
One example is  http://upx.sourceforge.net .

One notable use of the underlying concept (what path containED
the executable) is glibc expanding $ORIGIN in DT_RUNPATH.
In practice for the near term, it may be a good idea for user-mode
code to use both /proc/self/exe and AT_EXECFN as fall-back methods
for each other.  /proc/self/exe can fail due to unmapping,
AT_EXECFN can fail because it won't be present on non-new systems.
The auxvec or {AT_EXECFN}.d_val also can get overwritten,
although in nearly all cases this would be the result of a bug.

The runtime cost is one NEW_AUX_ENT using two words of stack space.
The underlying value is maintained already as bprm->exec;
setup_arg_pages() in fs/exec.c slides it for stack_shift, etc.


Signed-off-by: John Reiser <jreiser@BitWagon.com>

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b25707f..3a1f609 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -205,6 +205,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index ad89545..19f58bc 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -26,8 +26,10 @@

 #define AT_SECURE 23   /* secure mode boolean */

+#define AT_EXECFN  31	/* filename of program */
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 17 /* NEW_AUX_ENT entries in auxiliary table */
+  /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif

 #endif /* _LINUX_AUXVEC_H */

-- 



