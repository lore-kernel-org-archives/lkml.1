Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZD2OHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZD2OHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZD2OHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:07:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50002 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZD2OHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:07:05 -0400
Date: Wed, 29 Apr 2009 16:02:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: ptrace: selinux_bprm_committed_creds: simplify __wake_up_parent()
	code and s/parent/real_parent/
Message-ID: <20090429140224.GA31948@redhat.com>
References: <20090428223025.GA11997@redhat.com> <1241011116.18249.193.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241011116.18249.193.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of David's "[PATCH] SELinux: Don't flush inherited SIGKILL during execve()",
 but can be applied independently).

selinux_bprm_committed_creds() should wake up ->real_parent, not ->parent.

We shouldn't worry about the tracer if current is ptraced, exec() must not
succeed if the tracer has no rights to trace this task after cred changing.
But we should notify ->real_parent which is, well, real parent.

Also, we don't need _irq to take tasklist, and we don't need parent's
->siglock to wake_up_interruptible(real_parent->signal->wait_chldexit).
Since we hold tasklist, real_parent->signal must be stable. Otherwise
spin_lock(siglock) is not safe too and can't help anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/security/selinux/hooks.c~SELINUX_PARENT	2009-04-29 15:45:28.000000000 +0200
+++ PTRACE/security/selinux/hooks.c	2009-04-29 15:48:41.000000000 +0200
@@ -2375,10 +2375,8 @@ static void selinux_bprm_committed_creds
 {
 	const struct task_security_struct *tsec = current_security();
 	struct itimerval itimer;
-	struct sighand_struct *psig;
 	u32 osid, sid;
 	int rc, i;
-	unsigned long flags;
 
 	osid = tsec->osid;
 	sid = tsec->sid;
@@ -2409,12 +2407,9 @@ static void selinux_bprm_committed_creds
 
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
-	read_lock_irq(&tasklist_lock);
-	psig = current->parent->sighand;
-	spin_lock_irqsave(&psig->siglock, flags);
-	wake_up_interruptible(&current->parent->signal->wait_chldexit);
-	spin_unlock_irqrestore(&psig->siglock, flags);
-	read_unlock_irq(&tasklist_lock);
+	read_lock(&tasklist_lock);
+	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
+	read_unlock(&tasklist_lock);
 }
 
 /* superblock security operations */

