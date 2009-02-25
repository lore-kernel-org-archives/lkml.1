Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZBYTL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZBYTL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZBYTLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:11:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZBYTLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:11:48 -0500
Date: Wed, 25 Feb 2009 20:02:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
Message-ID: <20090225190211.GA7445@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clone(CLONE_PARENT | SIGXXX) blindly sets ->exit_signal = SIGXXX. It is not
clear to me what was the supposed behaviour but this does not look right.
The parent of the forking task will receive this signal which bypasses all
security checks.

With this patch CLONE_PARENT re-uses both ->real_parent and ->exit_signal,
this looks at least logical.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Chris Evans <scarybeasts@gmail.com>

--- 6.29-rc3/kernel/fork.c~1_EXIT_SIGNAL	2009-02-09 01:03:48.000000000 +0100
+++ 6.29-rc3/kernel/fork.c	2009-02-25 18:09:56.000000000 +0100
@@ -1217,10 +1217,16 @@ static struct task_struct *copy_process(
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());
 
-	/* CLONE_PARENT re-uses the old parent */
-	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
+	/* CLONE_PARENT re-uses the old parent and exit_signal */
+	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
+		/*
+		 * Do this under tasklist_lock to avoid the race with
+		 * re-parenting to init.
+		 */
+		if (!(clone_flags & CLONE_THREAD))
+			p->exit_signal = current->group_leader->exit_signal;
 		p->real_parent = current->real_parent;
-	else
+	} else
 		p->real_parent = current;
 
 	spin_lock(&current->sighand->siglock);

