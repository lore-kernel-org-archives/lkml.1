Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZENJvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZENJvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZENJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:50:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:3706 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZENJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FVy0DR1BKaoOKeAMlk9An6b7MUftjd73X7X9tapu7O7BpqSYdGKT3C0RHL+g48wt/2
         rZw9RAQmBDCXzWzUyzM2m4HqJedgcae3KIumE7NVWbG9XAgxtiUsdogZUJDsXDUvJLNO
         LO//TmkfFIsksYAUfeEpW3Pw697InoXTAJLcI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Completely replace wait_noreap_copyout() by copy_wait_opts_to_user()
Date: Thu, 14 May 2009 11:50:13 +0200
Message-Id: <1242294612-28680-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242294612-28680-1-git-send-email-v.mayatskih@gmail.com>
References: <1242294612-28680-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_noreap_copyout() currently is a short wrapper for
copy_wait_opts_to_user(), and wait_task_zombie() is the only one caller
of it.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f22e82c..3952385 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1143,14 +1143,6 @@ static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
 		if (!retval)
 			retval = put_user(status, &infop->si_status);
 	}
-	return retval;
-}
-
-static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
-				pid_t pid, uid_t uid, int why, int status)
-{
-	int retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
-	put_task_struct(p);
 	if (!retval)
 		retval = pid;
 	return retval;
@@ -1184,7 +1176,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
 			status = exit_code & 0x7f;
 		}
-		return wait_noreap_copyout(wo, p, pid, uid, why, status);
+		retval = copy_wait_opts_to_user(wo, p, pid, uid,
+						why, status, SIGCHLD);
+		put_task_struct(p);
+		return retval;
 	}
 
 	/*
-- 
1.6.2.2


