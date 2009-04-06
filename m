Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZDFOVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZDFOVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZDFOVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:21:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46545 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbZDFOVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:21:02 -0400
Date: Mon, 6 Apr 2009 16:16:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH, RESEND] exit_notify: kill the wrong capable(CAP_KILL) check
Message-ID: <20090406141602.GA17561@redhat.com>
References: <20090225190218.GA7453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225190218.GA7453@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CAP_KILL check in exit_notify() looks just wrong, kill it.

Whatever logic we have to reset ->exit_signal, the malicious user
can bypass it if it execs the setuid application before exiting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

--- 6.30/kernel/exit.c~EXIT_CAP_KILL	2009-04-06 00:03:42.000000000 +0200
+++ 6.30/kernel/exit.c	2009-04-06 15:30:32.000000000 +0200
@@ -837,8 +837,7 @@ static void exit_notify(struct task_stru
 	 */
 	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
 	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id != tsk->parent_exec_id) &&
-	    !capable(CAP_KILL))
+	     tsk->self_exec_id != tsk->parent_exec_id))
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);

