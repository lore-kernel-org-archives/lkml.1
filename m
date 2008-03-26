Return-Path: <linux-kernel-owner+w=401wt.eu-S1763824AbYCZUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763824AbYCZUTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763594AbYCZUS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:18:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46991 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763571AbYCZUS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:18:56 -0400
Date: Wed, 26 Mar 2008 23:16:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Emelyanov <xemul@openvz.org>, Pavel Machek <pavel@ucw.cz>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ptrace: allow to ptrace /sbin/init
Message-ID: <20080326201623.GA131@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afaics, currently there are no kernel problems with ptracing init, it can't
lose SIGNAL_UNKILLABLE flag and be killed/stopped by accident.

The ability to strace/debug init can be very useful if you try to figure
out why it does not work as expected.

However, admin should know what he does, "gdb /sbin/init 1" stops init, it
can't reap orphaned zombies or take care of /etc/inittab until continued.
It is even possible to crash init (and thus the whole system) if you wish,
ptracer has full control.

See also the long discussion: http://marc.info/?t=120628018600001

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/ptrace.c~INIT_PTRACEABLE	2008-03-26 21:31:39.000000000 +0300
+++ 25/kernel/ptrace.c	2008-03-26 21:33:35.000000000 +0300
@@ -168,8 +168,6 @@ int ptrace_attach(struct task_struct *ta
 	audit_ptrace(task);
 
 	retval = -EPERM;
-	if (task->pid <= 1)
-		goto out;
 	if (same_thread_group(task, current))
 		goto out;
 
@@ -517,12 +515,6 @@ struct task_struct *ptrace_get_task_stru
 {
 	struct task_struct *child;
 
-	/*
-	 * Tracing init is not allowed.
-	 */
-	if (pid == 1)
-		return ERR_PTR(-EPERM);
-
 	read_lock(&tasklist_lock);
 	child = find_task_by_vpid(pid);
 	if (child)

