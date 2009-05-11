Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZEKKOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZEKKOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbZEKKNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:12 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41364 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbZEKKNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p/p0+wnGJHSzPqOtF1ynBA6jAQBhKgDO3G9hFxAYZ75oYE5lPA8peu+GSMNCPQfVsK
         CZgYkSeaUJAf7gxipLFOFO1RDfYYnBdX949Sf7Bg2Y0wTnkQSn+gfXeN9GBzPkiB9BhM
         heGQYZNs56nwJhU2AOd4/GJ1uch4lOEKxsgVM=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Use wait_copyout() in wait_task_continued()
Date: Mon, 11 May 2009 12:12:44 +0200
Message-Id: <1242036759-4025-6-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All copy-paste getrusage() and put_user() code in wait_task_* functions
is replaced by call to wait_copyout()

It makes no sense to do conditional siginfo's fill, wait_copyout() knows
how to handle it right.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1ff490d..690a1a6 100644
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
+	retval = wait_copyout(wo, p, pid, uid,
+			      CLD_CONTINUED, SIGCONT, SIGCHLD);
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

