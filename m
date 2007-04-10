Return-Path: <linux-kernel-owner+w=401wt.eu-S1030800AbXDJPRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800AbXDJPRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030807AbXDJPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:17:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53854 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800AbXDJPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:17:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
Subject: [PATCH] Only send pdeath_signal when getppid changes.
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu> <20070410133808.GA163@tv-sign.ru>
Date: Tue, 10 Apr 2007 09:16:47 -0600
In-Reply-To: <20070410133808.GA163@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 10 Apr 2007 17:38:08 +0400")
Message-ID: <m1y7l0xns0.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently each thread can requrest to be notified when it's parent
terminates, and receive a thread specific signal when that occurs.
That we set this on a per thread granularity and then send it to the
whole thread group seems silly, but whatever.

Currently we send a signal when the results of getppid don't change if
our parent thread dies and we are reparented to a different thread.
This seems counterintuitive to what I would expect when programming in
user space and is a major maitenance issue to continue doing.

The only users I recall using this have non threaded parents and
pdeath_signal predates CLONE_THREAD so arguably this code has been
broken with threaded parents since the day CLONE_THREAD was introduced
and no one ever screamed loudly enough to get it fixed.

So this patch fixes the pdeath_signal behaviour only sending a signal
when the results of getppid would change.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---

This patch is against 2.6.21-rc6-mm1 (with utrace applied)
but except for context in the diff that should not matter.

 kernel/exit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1d91de8..1ec0d1f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -618,10 +618,6 @@ choose_new_parent(struct task_struct *p, struct task_struct *reaper)
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father)
 {
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
 	/* Move the child from its dying parent to the new one.  */
 	list_move_tail(&p->sibling, &p->parent->children);
 
@@ -635,6 +631,10 @@ reparent_thread(struct task_struct *p, struct task_struct *father)
 	if (p->exit_signal != -1)
 		p->exit_signal = SIGCHLD;
 
+	if (p->pdeath_signal)
+		/* We already hold the tasklist_lock here.  */
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-- 
1.5.0.g53756

