Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZC1XR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZC1XR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZC1XRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:17:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35383 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZC1XRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:17:14 -0400
Date: Sat, 28 Mar 2009 23:16:03 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] compat_do_execve should unshare_files
Message-ID: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26's commit fd8328be874f4190a811c58cd4778ec2c74d2c05
"sanitize handling of shared descriptor tables in failing execve()"
moved the unshare_files() from flush_old_exec() and several binfmts
to the head of do_execve(); but forgot to make the same change to
compat_do_execve(), leaving a CLONE_FILES files_struct shared across
exec from a 32-bit process on a 64-bit kernel.

It's arguable whether the files_struct really ought to be unshared
across exec; but 2.6.1 made that so to stop the loading binary's fd
leaking into other threads, and a 32-bit process on a 64-bit kernel
ought to behave in the same way as 32 on 32 and 64 on 64.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---

 fs/compat.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- 2.6.29/fs/compat.c	2009-03-23 23:12:14.000000000 +0000
+++ linux/fs/compat.c	2009-03-28 18:06:02.000000000 +0000
@@ -1392,12 +1392,17 @@ int compat_do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
+	struct files_struct *displaced;
 	int retval;
 
+	retval = unshare_files(&displaced);
+	if (retval)
+		goto out_ret;
+
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
-		goto out_ret;
+		goto out_files;
 
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
@@ -1457,6 +1462,8 @@ int compat_do_execve(char * filename,
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	if (displaced)
+		put_files_struct(displaced);
 	return retval;
 
 out:
@@ -1475,6 +1482,9 @@ out_unlock:
 out_free:
 	free_bprm(bprm);
 
+out_files:
+	if (displaced)
+		reset_files_struct(displaced);
 out_ret:
 	return retval;
 }
