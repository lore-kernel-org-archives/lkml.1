Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZBKVPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZBKVPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZBKVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:14:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbZBKVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:14:57 -0500
Date: Wed, 11 Feb 2009 22:12:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] move exit_ptrace() from forget_original_parent() to
	do_exit()
Message-ID: <20090211211221.GA16857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By discussion with Roland.

Call exit_ptrace() from do_exit(), no need to delay this call until
forget_original_parent().

If we ever change exit_ptrace() to do the blocking calls, it makes
sense to move it after exit_signals().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~3_MOVE	2009-02-11 06:37:36.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-02-11 07:20:54.000000000 +0100
@@ -803,8 +803,6 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_childs);
 
-	exit_ptrace(father);
-
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 
@@ -956,6 +954,7 @@ NORET_TYPE void do_exit(long code)
 		schedule();
 	}
 
+	exit_ptrace(tsk);
 	exit_signals(tsk);  /* sets PF_EXITING */
 	/*
 	 * tsk->flags are checked in the futex code to protect against

