Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZEKKOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZEKKOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZEKKNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:43793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291AbZEKKNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=krI3vYILbNCabAYn7V9PjscUgN0kdaR4eFIkslESzP5skNu+o3ogltwytMTT2ptODc
         L73J9BLNXruqFThUe2ezcs9S/OF4L3YFvpwLCSRJbAaPeySGgNX9ybVfQiWy0GTRLua3
         ibWVyo7+GTegGwKkuKrgz5HJ21RVELQF/IQhw=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] Use wait_copyout() in do_wait()
Date: Mon, 11 May 2009 12:12:42 +0200
Message-Id: <1242036759-4025-4-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All copy-paste getrusage() and put_user() code in wait_task_* functions
is replaced by call to wait_copyout()

Use wait_copyout() in do_wait() to clean up user's siginfo structure.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 3b2fdd9..6ee6b53 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1600,8 +1600,6 @@ end:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
 	if (wo->wo_info) {
-		struct siginfo __user *infop = wo->wo_info;
-
 		if (retval > 0)
 			retval = 0;
 		else {
@@ -1610,18 +1608,7 @@ end:
 			 * we would set so the user can easily tell the
 			 * difference.
 			 */
-			if (!retval)
-				retval = put_user(0, &infop->si_signo);
-			if (!retval)
-				retval = put_user(0, &infop->si_errno);
-			if (!retval)
-				retval = put_user(0, &infop->si_code);
-			if (!retval)
-				retval = put_user(0, &infop->si_pid);
-			if (!retval)
-				retval = put_user(0, &infop->si_uid);
-			if (!retval)
-				retval = put_user(0, &infop->si_status);
+			retval = wait_copyout(wo, 0, 0, 0, 0, 0, 0);
 		}
 	}
 	return retval;
-- 
1.6.2.2


