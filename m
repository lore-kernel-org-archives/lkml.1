Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZDZXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZDZXrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 19:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZDZXrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 19:47:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42983 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbZDZXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 19:47:04 -0400
Date: Mon, 27 Apr 2009 01:41:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Hugh Dickins <hugh@veritas.com>,
       stable@kernel.org
Subject: [PATCH] ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex
Message-ID: <20090426234134.GA13391@redhat.com>
References: <20090425172524.GA3432@redhat.com> <20090424163949.GA12035@redhat.com> <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com> <31842.1240656853@redhat.com> <394.1240686417@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <394.1240686417@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_attach() needs task->cred_exec_mutex, not current->cred_exec_mutex.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/ptrace.c~	2009-04-15 12:53:58.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-04-27 01:22:51.000000000 +0200
@@ -188,7 +188,7 @@ int ptrace_attach(struct task_struct *ta
 	/* Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval  < 0)
 		goto out;
 
@@ -232,7 +232,7 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&task->cred_exec_mutex);
 out:
 	return retval;
 }

