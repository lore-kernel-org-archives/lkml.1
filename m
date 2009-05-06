Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZEFWBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZEFWBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761450AbZEFVyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:36 -0400
Received: from kroah.org ([198.145.64.141]:57045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761252AbZEFVyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:57 2009
Message-Id: <20090506214757.609252331@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Roland McGrath <roland@redhat.com>
Subject: [patch 17/58] exit_notify: kill the wrong capable(CAP_KILL) check (CVE-2009-1337)
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=exit_notify-kill-the-wrong-capable-check.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

CVE-2009-1337

commit 432870dab85a2f69dc417022646cb9a70acf7f94 upstream.

The CAP_KILL check in exit_notify() looks just wrong, kill it.

Whatever logic we have to reset ->exit_signal, the malicious user
can bypass it if it execs the setuid application before exiting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/exit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -950,8 +950,7 @@ static void exit_notify(struct task_stru
 	 */
 	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
 	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
-	     tsk->self_exec_id != tsk->parent_exec_id) &&
-	    !capable(CAP_KILL))
+	     tsk->self_exec_id != tsk->parent_exec_id))
 		tsk->exit_signal = SIGCHLD;
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);


