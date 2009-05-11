Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZEKN2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZEKN2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZEKN1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:27:13 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35806 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZEKN1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:27:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lRhjAHEph++ibiLkzAzIzr0bktkrWxp/0+4ZIUB8rojg/xR1LaO6MSBlC6SiI5x4Fw
         cbt/lZH54LRDxnG0ikg9ifGJLcWh8FXCU4J8+w9XJYKj58r0uGVZ+6Ppgu+5fSwmnmic
         n4D2xla6eQdZ900s+Yrl9tJV2HUib+xz6Egy8=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Use copy_wait_opts_to_user() in wait_task_continued()
Date: Mon, 11 May 2009 15:25:54 +0200
Message-Id: <1242048349-2766-6-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All copy-paste getrusage() and put_user() code in wait_task_* functions
is replaced by call to copy_wait_opts_to_user()

It makes no sense to do conditional siginfo's fill, copy_wait_opts_to_user() knows
how to handle it right.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 9806332..f22e82c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1416,19 +1416,16 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	if (!wo->wo_info) {
-		retval = wo->wo_rusage
-			? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
-		put_task_struct(p);
-		if (!retval && wo->wo_stat)
-			retval = put_user(0xffff, wo->wo_stat);
-		if (!retval)
-			retval = pid;
-	} else {
-		retval = wait_noreap_copyout(wo, p, pid, uid,
-					     CLD_CONTINUED, SIGCONT);
-		BUG_ON(retval == 0);
-	}
+	retval = copy_wait_opts_to_user(wo, p, pid, uid,
+					CLD_CONTINUED, SIGCONT, SIGCHLD);
+	put_task_struct(p);
+
+	if (!retval && wo->wo_stat)
+		retval = put_user(0xffff, wo->wo_stat);
+	if (!retval)
+		retval = pid;
+
+	BUG_ON(retval == 0);
 
 	return retval;
 }
-- 
1.6.2.2

