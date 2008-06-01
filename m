Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYFAP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYFAP3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYFAP3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 11:29:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58890 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbYFAP3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 11:29:12 -0400
Date: Sun, 1 Jun 2008 19:30:45 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] coredump: zap_threads() must skip kernel threads
Message-ID: <20080601153045.GA8244@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main loop in zap_threads() must skip kthreads which may use the same mm.
Otherwise we "kill" this thread erroneously (for example, it can not fork or
exec after that), and the coredumping task stucks in the TASK_UNINTERRUPTIBLE
state forever because of the wrong ->core_waiters count.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/fs/exec.c~3_CD_FIX_RACE_USE_MM	2008-05-31 20:05:21.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-06-01 19:04:39.000000000 +0400
@@ -1568,11 +1568,13 @@ static inline int zap_threads(struct tas
 	for_each_process(g) {
 		if (g == tsk->group_leader)
 			continue;
+		if (g->flags & PF_KTHREAD)
+			continue;
 
 		p = g;
 		do {
 			if (p->mm) {
-				if (p->mm == mm) {
+				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
 					zap_process(p);
 					unlock_task_sighand(p, &flags);

