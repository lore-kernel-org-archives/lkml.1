Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZLIQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZLIQNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZLIQNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:13:39 -0500
Received: from www.tglx.de ([62.245.132.106]:48589 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114AbZLIQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:13:38 -0500
Date: Wed, 9 Dec 2009 17:13:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] capabilities: Use RCU to protect task lookup in sys_capget
Message-ID: <alpine.LFD.2.00.0912091710420.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cap_get_target_pid() protects the task lookup with tasklist_lock.
security_capget() is called under tasklist_lock as well but
tasklist_lock does not protect anything there. The capabilities are
protected by RCU already.

So tasklist_lock only protects the lookup and prevents the task going
away, which can be done with rcu_read_lock() as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/capability.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/capability.c
===================================================================
--- linux-2.6-tip.orig/kernel/capability.c
+++ linux-2.6-tip/kernel/capability.c
@@ -135,7 +135,7 @@ static inline int cap_get_target_pid(pid
 	if (pid && (pid != task_pid_vnr(current))) {
 		struct task_struct *target;
 
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 
 		target = find_task_by_vpid(pid);
 		if (!target)
@@ -143,7 +143,7 @@ static inline int cap_get_target_pid(pid
 		else
 			ret = security_capget(target, pEp, pIp, pPp);
 
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	} else
 		ret = security_capget(current, pEp, pIp, pPp);
 
