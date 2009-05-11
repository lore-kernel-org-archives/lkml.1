Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZEKN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZEKN2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZEKN1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:27:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:53707 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZEKN1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kBNIzcRz9SCqTf3LuRnClZDkOdsyuXmZg8UjGUCJPPZgbaBzMS03H4iRCQIk3bn/uf
         2jbmAS9Ut8CJtu9C6cSoRkkaIV75/jUOLBLSQN7AKOQdVvNMu+m+bdMBBldzx+nTo1TK
         LWuocyklKQmz/KkRYIal1HPvSEEe1fwWi0C8A=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] Use copy_wait_opts_to_user() in do_wait()
Date: Mon, 11 May 2009 15:25:52 +0200
Message-Id: <1242048349-2766-4-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
References: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All copy-paste getrusage() and put_user() code in wait_task_* functions
is replaced by call to copy_wait_opts_to_user()

Use copy_wait_opts_to_user() in do_wait() to clean up user's siginfo structure.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 0bf2d3c..a742ae9 100644
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
+			retval = copy_wait_opts_to_user(wo, 0, 0, 0, 0, 0, 0);
 		}
 	}
 	return retval;
-- 
1.6.2.2


