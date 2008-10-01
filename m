Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYJAPj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYJAPj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYJAPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:39:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYJAPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:39:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CRED: ptrace_attach() should use the target process's mutex
To: jmorris@namei.org
Cc: dhowells@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, serue@us.ibm.com,
       haradats@gmail.com, k.takeda26@gmail.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2008 16:38:26 +0100
Message-ID: <20081001153823.9930.86648.stgit@warthog.procyon.org.uk>
In-Reply-To: <200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp>
References: <200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_attach() should use the target process's mutex when attaching to it,
not the current (tracer) process's mutex.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 893a099..2ee343a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -174,7 +174,7 @@ int ptrace_attach(struct task_struct *task)
 	/* Protect exec's credential calculations against our interference;
 	 * SUID, SGID and LSM creds get determined differently under ptrace.
 	 */
-	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
+	retval = mutex_lock_interruptible(&task->cred_exec_mutex);
 	if (retval  < 0)
 		goto out;
 
@@ -218,7 +218,7 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
-	mutex_unlock(&current->cred_exec_mutex);
+	mutex_unlock(&task->cred_exec_mutex);
 out:
 	return retval;
 }

