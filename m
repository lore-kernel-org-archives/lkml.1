Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZFSAnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZFSAnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZFSAmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:42:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZFSAmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:42:52 -0400
Date: Fri, 19 Jun 2009 02:38:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cred_guard_mutex: do not return -EINTR to user-space
Message-ID: <20090619003819.GA11170@redhat.com>
References: <20090608161204.GA3986@redhat.com> <20090608173944.B57EBFC3C6@magilla.sf.frob.com> <20090608183627.GA14734@redhat.com> <20090609014449.8BE46FC3C6@magilla.sf.frob.com> <20090610131116.GA10406@redhat.com> <20090610174058.6F48CFC3D3@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610174058.6F48CFC3D3@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_execve() and ptrace_attach() return -EINTR if
mutex_lock_interruptible(->cred_guard_mutex) fails.

This is not right, change the code to return ERESTARTNOINTR.

Perhaps we should also change proc_pid_attr_write().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c       |    4 ++--
 fs/compat.c     |    4 ++--
 kernel/ptrace.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1277,8 +1277,8 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_guard_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&current->cred_guard_mutex))
 		goto out_free;
 	current->in_execve = 1;
 
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1486,8 +1486,8 @@ int compat_do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_guard_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&current->cred_guard_mutex))
 		goto out_free;
 	current->in_execve = 1;
 
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -181,8 +181,8 @@ int ptrace_attach(struct task_struct *ta
 	 * interference; SUID, SGID and LSM creds get determined differently
 	 * under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&task->cred_guard_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&task->cred_guard_mutex))
 		goto out;
 
 	task_lock(task);

