Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZEMMIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZEMMIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbZEMMIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:08:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbZEMMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O42c0QzFM8naCQ0AA44HbyfCK7v2r/WjLYOoEpcpVjXb01OL1dIPJbA6KIeTkL4zVp
         +y0qRTzV4tA+953mDxDjRp6d62W2i9ByILaZUiGXEtT5xwMH1SYVdiF+5kV/mE6nRplI
         GjPqU/sBEPoUdNSdcmr85BoIlrzhq+arn3TZE=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Replace wait_noreap_copyout() by copy_wait_opts_to_user()
Date: Wed, 13 May 2009 14:08:12 +0200
Message-Id: <1242216490-8226-3-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
References: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_noreap_copyout() currently is a short wrapper for
copy_wait_opts_to_user(), and wait_task_zombie() is the only one caller
of it.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 kernel/exit.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f069bc1..cea85c9 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1154,17 +1154,6 @@ static int copy_wait_opts_to_user(struct wait_opts *wo, struct wait_info *wi)
 	return retval;
 }
 
-static int wait_noreap_copyout(struct wait_opts *wo, struct wait_info *wi)
-{
-	int retval;
-	wi->signal = SIGCHLD;
-	retval = copy_wait_opts_to_user(wo, wi);
-	put_task_struct(wi->p);
-	if (!retval)
-		retval = wi->pid;
-	return retval;
-}
-
 /*
  * Handle sys_wait4 work for one task in state EXIT_ZOMBIE.  We hold
  * read_lock(&tasklist_lock) on entry.  If we return zero, we still hold
@@ -1194,7 +1183,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			wi.why = (wi.status & 0x80) ? CLD_DUMPED : CLD_KILLED;
 			wi.status &= 0x7f;
 		}
-		return wait_noreap_copyout(wo, &wi);
+		retval = copy_wait_opts_to_user(wo, &wi);
+		put_task_struct(p);
+		if (!retval)
+			retval = wi.pid;
+		return retval;
 	}
 
 	/*
-- 
1.6.2.2


