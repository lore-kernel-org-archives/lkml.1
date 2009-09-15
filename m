Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbZIOIWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbZIOIWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbZIOIWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:22:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:43085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbZIOIWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:22:35 -0400
Date: Tue, 15 Sep 2009 08:22:02 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de,
       carsten.emde@osadl.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de,
       carsten.emde@osadl.org
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Prevent 32 bit overflow with set_normalized_timespec()
Message-ID: <tip-12e09337fe238981cb0c87543306e23775d1a143@git.kernel.org>
Git-Commit-ID: 12e09337fe238981cb0c87543306e23775d1a143
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 08:22:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12e09337fe238981cb0c87543306e23775d1a143
Gitweb:     http://git.kernel.org/tip/12e09337fe238981cb0c87543306e23775d1a143
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 14 Sep 2009 23:37:40 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Sep 2009 10:17:30 +0200

time: Prevent 32 bit overflow with set_normalized_timespec()

set_normalized_timespec() nsec argument is of type long. The recent
timekeeping changes of ktime_get_ts() feed 

	ts->tv_nsec + tomono.tv_nsec + nsecs

to set_normalized_timespec(). On 32 bit machines that sum can be
larger than (1 << 31) and therefor result in a negative value which
screws up the result completely.

Make the nsec argument of set_normalized_timespec() s64 to fix the
problem at hand. This also prevents similar problems for future users
of set_normalized_timespec().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Carsten Emde <carsten.emde@osadl.org>
LKML-Reference: <new-submission>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>



---
 include/linux/time.h |    2 +-
 kernel/time.c        |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 256232f..56787c0 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -75,7 +75,7 @@ extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int day, const unsigned int hour,
 			    const unsigned int min, const unsigned int sec);
 
-extern void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec);
+extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
 extern struct timespec timespec_add_safe(const struct timespec lhs,
 					 const struct timespec rhs);
 
diff --git a/kernel/time.c b/kernel/time.c
index 2951194..2e2e469 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -370,13 +370,20 @@ EXPORT_SYMBOL(mktime);
  *	0 <= tv_nsec < NSEC_PER_SEC
  * For negative values only the tv_sec field is negative !
  */
-void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec)
+void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec)
 {
 	while (nsec >= NSEC_PER_SEC) {
+		/*
+		 * The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation. See
+		 * also __iter_div_u64_rem() in include/linux/time.h
+		 */
+		asm("" : "+rm"(nsec));
 		nsec -= NSEC_PER_SEC;
 		++sec;
 	}
 	while (nsec < 0) {
+		asm("" : "+rm"(nsec));
 		nsec += NSEC_PER_SEC;
 		--sec;
 	}
