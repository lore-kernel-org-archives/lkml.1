Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXFWJsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXFWJsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 05:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbXFWJso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 05:48:44 -0400
Received: from www.osadl.org ([213.239.205.134]:47256 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753545AbXFWJso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 05:48:44 -0400
Subject: [PATCH] FUTEX: Restore the dropped ERSCH fix
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 11:48:40 +0200
Message-Id: <1182592120.20203.181.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of futex_find_get_task() needs to be -ESRCH in case
that the search fails. This was part of the original futex fixes and 
got accidentally dropped, when the futex-tidy-up patch was split out.

Results in a NULL pointer dereference in case the search fails.

Restore it.

Please apply also to 2.6.21 stable

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stable Team <stable@kernel.org>

---
 kernel/futex.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c	2007-06-23 11:39:20.000000000 +0200
+++ linux-2.6/kernel/futex.c	2007-06-23 11:39:20.000000000 +0200
@@ -409,14 +409,12 @@ static struct task_struct * futex_find_g
 
 	rcu_read_lock();
 	p = find_task_by_pid(pid);
-	if (!p)
-		goto out_unlock;
-	if ((current->euid != p->euid) && (current->euid != p->uid)) {
-		p = NULL;
-		goto out_unlock;
-	}
-	get_task_struct(p);
-out_unlock:
+
+	if (!p || ((current->euid != p->euid) && (current->euid != p->uid)))
+		p = ERR_PTR(-ESRCH);
+	else
+		get_task_struct(p);
+
 	rcu_read_unlock();
 
 	return p;


