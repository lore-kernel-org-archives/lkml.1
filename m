Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYCMQh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYCMQh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYCMQhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:37:21 -0400
Received: from sacred.ru ([62.205.161.221]:49796 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbYCMQhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:37:20 -0400
Message-ID: <47D95834.8020706@openvz.org>
Date: Thu, 13 Mar 2008 19:37:08 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Avoid potential kernel stack overflow in binfmt_misc.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 13 Mar 2008 19:37:08 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be triggered with root help only, but...

Register the ":text:E::txt::/root/cat.txt:' rule in binfmt_misc
(by root) and try launching the cat.txt file (by anyone) :) The 
result is - the endless recursion in the load_misc_binary -> 
open_exec -> load_misc_binary chain and stack overflow.

There's a similar problem with binfmt_script, and there's a sh_bang 
memner on linux_binprm structure to handle this, but simply raising 
this in binfmt_misc may break some setups when the interpreter of 
some misc binaries is a script.

So the proposal is to turn sh_bang into a bit, add a new one (the 
misc_bang) and raise it in load_misc_binary. After this, even if 
we set up the misc -> script -> misc loop for binfmts one of them 
will step on its own bang and exit.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index f95ae97..f9c88d0 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 			return -ENOEXEC;
 	}
 
-	bprm->sh_bang++;	/* Well, the bang-shell is implicit... */
+	bprm->sh_bang = 1;	/* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index b53c7e5..d7d1b00 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -116,6 +116,12 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (!enabled)
 		goto _ret;
 
+	retval = -ENOEXEC;
+	if (bprm->misc_bang)
+		goto _ret;
+
+	bprm->misc_bang = 1;
+
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index ab33939..9e3963f 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -29,7 +29,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->sh_bang++;
+	bprm->sh_bang = 1;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 1dd7567..b512e48 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -34,7 +34,8 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	int sh_bang;
+	unsigned int sh_bang:1,
+		     misc_bang:1;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_inheritable, cap_permitted;
