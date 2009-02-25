Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbZBYTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbZBYTMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZBYTLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:11:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbZBYTLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:11:49 -0500
Date: Wed, 25 Feb 2009 20:02:18 +0100
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
Subject: [PATCH 2/2] exit_notify: kill the wrong capable(CAP_KILL) check
Message-ID: <20090225190218.GA7453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't understand why exit_notify() checks capable(CAP_KILL), but this
looks just wrong.

Whatever logic we have to reset ->exit_signal, the bad user can bypass
it if it execs the setuid application before exiting, kill the CAP_KILL
check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~2_EXIT_NOTIFY	2009-02-13 07:04:12.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-02-25 19:41:57.000000000 +0100
@@ -874,8 +874,7 @@ static void exit_notify(struct task_stru
 	 */
 	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
 	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id != tsk->parent_exec_id) &&
-	    !capable(CAP_KILL))
+	     tsk->self_exec_id != tsk->parent_exec_id))
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);

