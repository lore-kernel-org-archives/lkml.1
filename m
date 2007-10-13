Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbXJMOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbXJMOt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbXJMOml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:41 -0400
Received: from 1wt.eu ([62.212.114.60]:3002 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761942AbXJMOmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:40 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143455.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:38 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 16/35] setpgid(child) fails if the child was forked by sub-thread
Content-Disposition: inline; filename=0058-setpgid-child-fails-if-the-child-was-forked-by-sub.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit b07e35f94a7b6a059f889b904529ee907dc0634d in mainline tree

Spotted by Marcin Kowalczyk <qrczak@knm.org.pl>.

sys_setpgid(child) fails if the child was forked by sub-thread.

Fix the "is it our child" check. The previous commit
ee0acf90d320c29916ba8c5c1b2e908d81f5057d was not complete.

(this patch asks for the new same_thread_group() helper, but mainline doesn't
 have it yet).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Tested-by: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sys.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Index: 2.6/kernel/sys.c
===================================================================
--- 2.6.orig/kernel/sys.c
+++ 2.6/kernel/sys.c
@@ -1358,7 +1358,6 @@ asmlinkage long sys_times(struct tms __u
  * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
  * LBT 04.03.94
  */
-
 asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
 {
 	struct task_struct *p;
@@ -1386,7 +1385,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (!thread_group_leader(p))
 		goto out;
 
-	if (p->real_parent == group_leader) {
+	if (p->real_parent->tgid == group_leader->tgid) {
 		err = -EPERM;
 		if (process_session(p) != process_session(group_leader))
 			goto out;

-- 
