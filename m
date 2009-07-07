Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbZGGOuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbZGGOuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758221AbZGGOuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:50:11 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:61551 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbZGGOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VZyPtXIHO6/tX5yeFGN7wdFJC9BbdH97XdCLoVMjW9QhUwHJMPOTv6kMbp/Bjh+F7C
         SKjVcAehEwxLCe9VXZoG+5HMi6LlMg+/mE+IAwDwy6zPvnqIyIfoLjLjX+esqoPvfNCH
         rUMawa29d57EJJNyHdVwJ6te99A+yU8fI61R8=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Check for ->wo_info != NULL in wait_noreap_copyout()
Date: Tue,  7 Jul 2009 16:50:03 +0200
Message-Id: <1246978201-10875-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246978201-10875-1-git-send-email-v.mayatskih@gmail.com>
References: <1246978201-10875-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current behaviour of sys_waitid() looks odd. If user passes infop == NULL,
sys_waitid() returns success. When user additionally specifies flag WNOWAIT,
sys_waitid() returns -EFAULT on the same conditions. When user combines
WNOWAIT with WCONTINUED, sys_waitid() again returns success.

This patch adds check for ->wo_info in wait_noreap_copyout().

User-visible change: starting from this commit, sys_waitid() always checks
infop != NULL and does not fail if it is NULL.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 62e3646..f306f20 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1134,18 +1134,20 @@ static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
 
 	put_task_struct(p);
 	infop = wo->wo_info;
-	if (!retval)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval)
-		retval = put_user((short)why, &infop->si_code);
-	if (!retval)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval)
-		retval = put_user(uid, &infop->si_uid);
-	if (!retval)
-		retval = put_user(status, &infop->si_status);
+	if (infop) {
+		if (!retval)
+			retval = put_user(SIGCHLD, &infop->si_signo);
+		if (!retval)
+			retval = put_user(0, &infop->si_errno);
+		if (!retval)
+			retval = put_user((short)why, &infop->si_code);
+		if (!retval)
+			retval = put_user(pid, &infop->si_pid);
+		if (!retval)
+			retval = put_user(uid, &infop->si_uid);
+		if (!retval)
+			retval = put_user(status, &infop->si_status);
+	}
 	if (!retval)
 		retval = pid;
 	return retval;
-- 
1.6.2.5

