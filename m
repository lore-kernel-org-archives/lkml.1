Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbZGIMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbZGIMEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758930AbZGIMEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:04:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:55022 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbZGIMEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:04:36 -0400
Date: Thu, 9 Jul 2009 12:04:08 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:timers/urgent] hrtimer: migration: always subtract base->offset
Message-ID: <tip-94d25649812b7d7055c162c7d910e94d3d213d34@git.kernel.org>
Git-Commit-ID: 94d25649812b7d7055c162c7d910e94d3d213d34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Jul 2009 12:04:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94d25649812b7d7055c162c7d910e94d3d213d34
Gitweb:     http://git.kernel.org/tip/94d25649812b7d7055c162c7d910e94d3d213d34
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jul 2009 12:49:34 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jul 2009 13:58:06 +0200

hrtimer: migration: always subtract base->offset

The new timer migration code treats the !HIGHRES case special when
calculating the CLOCK_MONOTONIC based expiry time to validate whether
a timer should be enqueued on a different CPU or not.

This is wrong as a CLOCK_REALTIME based timer expiry value needs to be
converted to CLOCK_MONOTONIC in any case.

Cc: Arun Bharadwaj <arun@linux.vnet.ibm.com
LKML-Reference: <new-submission>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/hrtimer.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9002958..0d43451 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -236,13 +236,8 @@ again:
 		/* Optimized away for NOHZ=n SMP=n */
 		if (cpu == preferred_cpu) {
 			/* Calculate clock monotonic expiry time */
-#ifdef CONFIG_HIGH_RES_TIMERS
 			ktime_t expires = ktime_sub(hrtimer_get_expires(timer),
-							new_base->offset);
-#else
-			ktime_t expires = hrtimer_get_expires(timer);
-#endif
-
+						    new_base->offset);
 			/*
 			 * Get the next event on target cpu from the
 			 * clock events layer.
