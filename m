Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZFJNPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZFJNPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZFJNPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:15:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbZFJNPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:15:41 -0400
Date: Wed, 10 Jun 2009 15:11:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: PTRACE_ATTACH && -EINTR
Message-ID: <20090610131116.GA10406@redhat.com>
References: <20090608161204.GA3986@redhat.com> <20090608173944.B57EBFC3C6@magilla.sf.frob.com> <20090608183627.GA14734@redhat.com> <20090609014449.8BE46FC3C6@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609014449.8BE46FC3C6@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Roland McGrath wrote:
>
> > It was renamed in -next. Should I send these fixes now for 2.6.20, or we can
> 								 30
> > wait for 2.6.31 ?
>
> IMHO they should go in ASAP since we know this is a regression just
> introduced in 2.6.29.  To me, the fact that nobody has noticed yet
> makes it more important not to delay--this new problem is so obscure
> that whoever is affected by it is likely to waste a lot of time figuring
> out what has started happening deep down in a huge pile of userland code.

2,6,30 is already released.

So, we need the trivial patch below, and perhaps a similar fix in
proc_pid_attr_write().

But giwen that ->cred_exec_mutex was renamed, I do not know where to send
this patch. This rename conflicts with ptrace changes in -mm, and the patch
below will add more confusion.

I'll wait until rename or -mm bits will be applied, then send this patch.
Fortunately the problem is not serious, ->cred_exec_mutex should be mostly
free.

Oleg.

--- T/fs/exec.c~	2009-05-24 21:46:20.000000000 +0200
+++ T/fs/exec.c	2009-06-10 14:58:27.000000000 +0200
@@ -1296,8 +1296,8 @@ int do_execve(char * filename,
 	if (!bprm)
 		goto out_files;
 
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&current->cred_exec_mutex))
 		goto out_free;
 	current->in_execve = 1;
 
--- T/kernel/ptrace.c~	2009-06-10 14:46:57.000000000 +0200
+++ T/kernel/ptrace.c	2009-06-10 14:54:24.000000000 +0200
@@ -189,8 +189,8 @@ int ptrace_attach(struct task_struct *ta
 	 * Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
-	if (retval < 0)
+	retval = -ERESTARTNOINTR;
+	if (mutex_lock_interruptible(&task->cred_exec_mutex))
 		goto out;
 
 	task_lock(task);

