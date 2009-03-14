Return-Path: <linux-kernel-owner+w=401wt.eu-S1764932AbZCNBtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764932AbZCNBtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZCNBVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:34 -0400
Received: from kroah.org ([198.145.64.141]:35603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754626AbZCNBVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:43 2009
Message-Id: <20090314011043.083385451@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:56 -0700
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
       Roland McGrath <roland@redhat.com>, David Howells <dhowells@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: [patch 079/114] copy_process: fix CLONE_PARENT && parent_exec_id interaction
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=copy_process-fix-clone_parent-parent_exec_id-interaction.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 2d5516cbb9daf7d0e342a2e3b0fc6f8c39a81205 upstream.

CLONE_PARENT can fool the ->self_exec_id/parent_exec_id logic. If we
re-use the old parent, we must also re-use ->parent_exec_id to make
sure exit_notify() sees the right ->xxx_exec_id's when the CLONE_PARENT'ed
task exits.

Also, move down the "p->parent_exec_id = p->self_exec_id" thing, to place
two different cases together.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/fork.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1176,10 +1176,6 @@ static struct task_struct *copy_process(
 #endif
 	clear_all_latency_tracing(p);
 
-	/* Our parent execution domain becomes current domain
-	   These must match for thread signalling to apply */
-	p->parent_exec_id = p->self_exec_id;
-
 	/* ok, now we should be set up.. */
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
@@ -1217,10 +1213,13 @@ static struct task_struct *copy_process(
 		set_task_cpu(p, smp_processor_id());
 
 	/* CLONE_PARENT re-uses the old parent */
-	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
+	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
-	else
+		p->parent_exec_id = current->parent_exec_id;
+	} else {
 		p->real_parent = current;
+		p->parent_exec_id = current->self_exec_id;
+	}
 
 	spin_lock(&current->sighand->siglock);
 


