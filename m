Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZGRJvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZGRJvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZGRJvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:51:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:42236 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbZGRJu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:50:57 -0400
Date: Sat, 18 Jul 2009 09:50:28 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090716104817.589309391@samba.org>
References: <20090716104817.589309391@samba.org>
Subject: [tip:perfcounters/urgent] perf_counter: Log vfork as a fork event
Message-ID: <tip-ed900c054b541254f0ce5cedaf75206e29bd614e@git.kernel.org>
Git-Commit-ID: ed900c054b541254f0ce5cedaf75206e29bd614e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 09:50:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed900c054b541254f0ce5cedaf75206e29bd614e
Gitweb:     http://git.kernel.org/tip/ed900c054b541254f0ce5cedaf75206e29bd614e
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 11:21:31 +0200

perf_counter: Log vfork as a fork event

Right now we don't output vfork events. Even though we should
always see an exec after a vfork, we may get perfcounter
samples between the vfork and exec. These samples can lead to
some confusion when parsing perfcounter data.

To keep things consistent we should always log a fork event. It
will result in a little more log data, but is less confusing to
trace parsing tools.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090716104817.589309391@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/fork.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 467746b..4812d60 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1408,14 +1408,11 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
-		} else if (!(clone_flags & CLONE_VM)) {
-			/*
-			 * vfork will do an exec which will call
-			 * set_task_comm()
-			 */
-			perf_counter_fork(p);
 		}
 
+		if (!(clone_flags & CLONE_THREAD))
+			perf_counter_fork(p);
+
 		audit_finish_fork(p);
 		tracehook_report_clone(regs, clone_flags, nr, p);
 
