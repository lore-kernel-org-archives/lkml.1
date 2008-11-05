Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYKEXNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYKEXNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYKEXMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:12:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbYKEXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:12:24 -0500
Date: Wed, 5 Nov 2008 15:12:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
       dhowells@redhat.com
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 02/11] Add in_execve flag into
 task_struct.
Message-Id: <20081105151203.df9727ca.akpm@linux-foundation.org>
In-Reply-To: <20081104060936.021370709@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
	<20081104060936.021370709@nttdata.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2008 15:08:49 +0900
Kentaro Takeda <takedakn@nttdata.co.jp> wrote:

> This patch allows LSM modules to determine whether current process is in an
> execve operation or not so that they can behave differently while an execve
> operation is in progress.
> 
> This allows TOMOYO to dispense with a readability check on a file to be
> executed under the process's current credentials, and to do it instead under
> the proposed credentials.
> 
> This is required with the new COW credentials because TOMOYO is no longer
> allowed to mark the state temporarily in the security struct attached to the
> task_struct.

None of this patch applied.  It seems that some credentials code has
disappeared from linux-next.  So I took a bet shot at reimplementing it
- please check.

If/when that code gets restored to linux-next I get to fix the patch
again.  It's a bit of collateral damage whcih happens when people muck
up their trees.

 fs/compat.c           |    3 +++
 fs/exec.c             |    3 +++
 include/linux/sched.h |    2 ++
 3 files changed, 8 insertions(+)

diff -puN fs/compat.c~tomoyo-add-in_execve-flag-into-task_struct fs/compat.c
--- a/fs/compat.c~tomoyo-add-in_execve-flag-into-task_struct
+++ a/fs/compat.c
@@ -1388,6 +1388,7 @@ int compat_do_execve(char * filename,
 	struct file *file;
 	int retval;
 
+	current->in_execve = 1;
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
@@ -1440,6 +1441,7 @@ int compat_do_execve(char * filename,
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
 		/* execve success */
+		current->in_execve = 0;
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		free_bprm(bprm);
@@ -1464,6 +1466,7 @@ out_kfree:
 	free_bprm(bprm);
 
 out_ret:
+	current->in_execve = 0;
 	return retval;
 }
 
diff -puN fs/exec.c~tomoyo-add-in_execve-flag-into-task_struct fs/exec.c
--- a/fs/exec.c~tomoyo-add-in_execve-flag-into-task_struct
+++ a/fs/exec.c
@@ -1268,6 +1268,7 @@ int do_execve(char * filename,
 	struct files_struct *displaced;
 	int retval;
 
+	current->in_execve = 1;
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
@@ -1325,6 +1326,7 @@ int do_execve(char * filename,
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
 		/* execve success */
+		current->in_execve = 0;
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		free_bprm(bprm);
@@ -1353,6 +1355,7 @@ out_files:
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
+	current->in_execve = 0;
 	return retval;
 }
 
diff -puN include/linux/sched.h~tomoyo-add-in_execve-flag-into-task_struct include/linux/sched.h
--- a/include/linux/sched.h~tomoyo-add-in_execve-flag-into-task_struct
+++ a/include/linux/sched.h
@@ -1130,6 +1130,8 @@ struct task_struct {
 	/* ??? */
 	unsigned int personality;
 	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
 	pid_t pid;
 	pid_t tgid;
 
_

