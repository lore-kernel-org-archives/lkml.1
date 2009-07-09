Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbZGIME6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbZGIME6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbZGIMEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:04:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:55025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760288AbZGIMEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:04:45 -0400
Date: Thu, 9 Jul 2009 12:04:21 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:timers/urgent] hrtimer: migration: do not check expiry time on current CPU
Message-ID: <tip-de907e8432b08f2d5966c36e0747e97c0e596810@git.kernel.org>
Git-Commit-ID: de907e8432b08f2d5966c36e0747e97c0e596810
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Jul 2009 12:04:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de907e8432b08f2d5966c36e0747e97c0e596810
Gitweb:     http://git.kernel.org/tip/de907e8432b08f2d5966c36e0747e97c0e596810
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jul 2009 13:52:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jul 2009 13:59:11 +0200

hrtimer: migration: do not check expiry time on current CPU

The timer migration code needs to check whether the expiry time of the
timer is before the programmed clock event expiry time when the timer
is enqueued on another CPU because we can not reprogram the timer
device on the other CPU. The current logic checks the expiry time even
if we enqueue on the current CPU when nohz_get_load_balancer() returns
current CPU. This might lead to an endless loop in the expiry check
code when the expiry time of the timer is before the current
programmed next event.

Check whether nohz_get_load_balancer() returns current CPU and skip
the expiry check if this is the case.

Cc: Arun Bharadwaj <arun@linux.vnet.ibm.com
LKML-Reference: <new-submission>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/hrtimer.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0d43451..d171ecf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -206,8 +206,19 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
 		preferred_cpu = get_nohz_load_balancer();
-		if (preferred_cpu >= 0)
-			cpu = preferred_cpu;
+		if (preferred_cpu >= 0) {
+			/*
+			 * We must not check the expiry value when
+			 * preferred_cpu is the current cpu. If base
+			 * != new_base we would loop forever when the
+			 * timer expires before the current programmed
+			 * next timer event.
+			 */
+			if (preferred_cpu != cpu)
+				cpu = preferred_cpu;
+			else
+				preferred_cpu = -1;
+		}
 	}
 #endif
 
