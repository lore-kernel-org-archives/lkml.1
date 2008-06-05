Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbYFEPWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbYFEPWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFEPVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:21:55 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46605 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYFEPVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:21:54 -0400
Date: Thu, 5 Jun 2008 19:23:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: TASK_WAKEKILL && /sbin/init (was: [PATCH 1/2] schedule: fix TASK_WAKEKILL vs SIGKILL race)
Message-ID: <20080605152316.GA257@tv-sign.ru>
References: <20080604170905.GA10273@tv-sign.ru> <20080604173318.GH3549@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604173318.GH3549@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Matthew, I left this part unanswered because I didn't have the
time yesterday...

On 06/04, Matthew Wilcox wrote:
>
> On Wed, Jun 04, 2008 at 09:09:05PM +0400, Oleg Nesterov wrote:
> > Note also that with or without this patch TASK_WAKEKILL is not exactly right
> > wrt /sbin/init, but this is another issue.
>
> That's certainly an interesting conversation to have.

If lock_page_killable() fails because the task was killed by SIGKILL or another
fatal signal, do_generic_file_read() returns -EIO.

This seems to be OK, because in fact the userspace won't see this error, the
task will dequeue SIGKILL and exit.

However, /sbin/init is different, it will dequeue SIGKILL, ignore it, and be
confused by this bogus -EIO. Please note that while this bug is not likely,
it is _not_ theoretical. It does happen that user-space sends the unhandled
fatal signals to init.

Imho, this is 2.6.26 material. Unless I missed something, of course.

It is not clear to me what should we do. I'd like very much to avoid adding
more SIGNAL_UNKILLABLE checks, but perhaps we don't have another choice.
We can fix the bug with

	--- kernel/signal.c
	+++ kernel/signal.c
	@@ -974,7 +974,7 @@ void zap_other_threads(struct task_struc
	 
	 int fastcall __fatal_signal_pending(struct task_struct *tsk)
	 {
	-	return sigismember(&tsk->pending.signal, SIGKILL);
	+	return signal_group_exit(tsk->signal);
	 }

, but this makes __fatal_signal_pending() slower, and because we use
tsk->signal, schedule() (in particular) can't use this helper.

Anyway. How about the (untested/uncompiled) patch for now? -EINTR or
-ERESTARTNOINTR looks "more correct" regardless.

Oleg.

--- mm/filemap.c
+++ mm/filemap.c
@@ -188,7 +188,7 @@ static int sync_page(void *word)
 static int sync_page_killable(void *word)
 {
 	sync_page(word);
-	return fatal_signal_pending(current) ? -EINTR : 0;
+	return fatal_signal_pending(current) ? -ERESTARTNOINTR : 0;
 }
 
 /**
@@ -1000,8 +1000,9 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		if (lock_page_killable(page))
-			goto readpage_eio;
+		error = lock_page_killable(page);
+		if (error)
+			goto readpage_error;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -1029,8 +1030,9 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			if (lock_page_killable(page))
-				goto readpage_eio;
+			error = lock_page_killable(page);
+			if (error)
+				goto readpage_error;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*

