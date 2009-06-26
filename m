Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZFZWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZFZWa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZFZWav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:30:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZFZWau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:30:50 -0400
Date: Fri, 26 Jun 2009 21:16:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/2] do_coredump: move !ispipe code into "else" branch
Message-ID: <20090626191602.GC22603@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626180222.GD7337@hmsreliant.think-freely.org> <20090626165908.GB12063@redhat.com> <20090626202411.GH7337@hmsreliant.think-freely.org> <20090626191418.GA22603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626191418.GA22603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_coredump() does a lot of file checks which are only needed when !ispipe,
move them into "else" branch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- WAIT/fs/exec.c~CD_2_ISPIPE	2009-06-26 20:06:01.000000000 +0200
+++ WAIT/fs/exec.c	2009-06-26 20:59:57.000000000 +0200
@@ -1784,9 +1784,6 @@ void do_coredump(long signr, int exit_co
 	 * at which point file size limits and permissions will be imposed
 	 * as it does with any other process
 	 */
-	if ((!ispipe) && (core_limit < binfmt->min_coredump))
-		goto fail_unlock;
-
  	if (ispipe) {
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
@@ -1818,39 +1815,43 @@ void do_coredump(long signr, int exit_co
 			       corename);
  			goto fail_unlock;
  		}
- 	} else
+	} else {
+		if (core_limit < binfmt->min_coredump)
+			goto fail_unlock;
+
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(file))
-		goto fail_unlock;
-	inode = file->f_path.dentry->d_inode;
-	if (inode->i_nlink > 1)
-		goto close_fail;	/* multiple links - don't dump */
-	if (!ispipe && d_unhashed(file->f_path.dentry))
-		goto close_fail;
+		if (IS_ERR(file))
+			goto fail_unlock;
 
-	/* AK: actually i see no reason to not allow this for named pipes etc.,
-	   but keep the previous behaviour for now. */
-	if (!ispipe && !S_ISREG(inode->i_mode))
-		goto close_fail;
-	/*
-	 * Dont allow local users get cute and trick others to coredump
-	 * into their pre-created files:
-	 */
-	if (inode->i_uid != current_fsuid())
-		goto close_fail;
-	if (!file->f_op)
-		goto close_fail;
-	if (!file->f_op->write)
-		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
-		goto close_fail;
+		if (d_unhashed(file->f_path.dentry))
+			goto close_fail;
+		inode = file->f_path.dentry->d_inode;
+		if (inode->i_nlink > 1)
+			goto close_fail;   /* multiple links - don't dump */
+		/* AK: actually i see no reason to not allow this for named
+		   pipes etc, but keep the previous behaviour for now. */
+		if (!S_ISREG(inode->i_mode))
+			goto close_fail;
+		/*
+		 * Dont allow local users get cute and trick others to coredump
+		 * into their pre-created files:
+		 */
+		if (inode->i_uid != current_fsuid())
+			goto close_fail;
+		if (!file->f_op)
+			goto close_fail;
+		if (!file->f_op->write)
+			goto close_fail;
+		if (do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+			goto close_fail;
+	}
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
-
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
+
 close_fail:
 	filp_close(file, NULL);
 fail_unlock:

