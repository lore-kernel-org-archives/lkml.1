Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYHBVeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYHBVeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYHBVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:33:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:62308 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYHBVdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id:from;
        b=dnpclP1rvmAjKgk25ZP1WfgkqP+zzd4k5c0njT551U4IX1XaU8Q4GbR3kcUD6a8bdy
         +IqGklwtC/V1o7E/cH5LVXTr+Q7MeUZRfVT5EkQyiat8RvqpeBgs9f9Y2FcOD7Rk1MuD
         NwIW9/2WwPVm8QaboEFQVjiJfJ/oRlMRSDyj0=
To: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process)
Date: Sat, 2 Aug 2008 23:45:20 +0200
User-Agent: KMail/1.9.9
Cc: w@1wt.eu, Roland McGrath <roland@redhat.com>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022345.20963.oliver.pntr@gmail.com>
From: Oliver Pinter <pinter.oliver.villany@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is an RFC for sending this patch for stable, when this patch needed, then send ACK and CC stable,
if not then send NAK.

---
>From 96347e7759e2e433c427defa0fa1adfc8cce6226 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@tv-sign.ru>
Date: Fri, 25 Jul 2008 01:47:27 -0700
Subject: [PATCH] posix timers: release_posix_timer: kill the bogus put_task_struct(->it_process);

[ Upstream commit 96347e7759e2e433c427defa0fa1adfc8cce6226 ]

release_posix_timer() can't be called with ->it_process != NULL.  Once
sys_timer_create() sets ->it_process it must not call
release_posix_timer(), otherwise we can race with another thread doing
sys_timer_delete(), this timer is visible to idr_find() and unlocked.

The same is true for two other callers (actually, for any possible
caller), sys_timer_delete() and itimer_delete().  They must clear
->it_process before unlock_timer() + release_posix_timer().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 17f5326..9a21681 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -449,9 +449,6 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
 	sigqueue_free(tmr->sigq);
-	if (unlikely(tmr->it_process) &&
-	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
-		put_task_struct(tmr->it_process);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
 
