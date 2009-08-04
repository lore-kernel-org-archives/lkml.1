Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZHDIWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZHDIWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZHDIWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:22:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:39114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZHDIWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:22:10 -0400
Date: Tue, 4 Aug 2009 08:21:34 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, h-shimamoto@ct.jp.nec.com,
       akpm@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: h-shimamoto@ct.jp.nec.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A764FF3.50607@ct.jp.nec.com>
References: <4A764FF3.50607@ct.jp.nec.com>
Subject: [tip:timers/urgent] posix-timers: Fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW
Message-ID: <tip-70d715fd0597f18528f389b5ac59102263067744@git.kernel.org>
Git-Commit-ID: 70d715fd0597f18528f389b5ac59102263067744
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 08:21:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70d715fd0597f18528f389b5ac59102263067744
Gitweb:     http://git.kernel.org/tip/70d715fd0597f18528f389b5ac59102263067744
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Mon, 3 Aug 2009 11:48:19 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 10:16:41 +0200

posix-timers: Fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW

Prevent calling do_nanosleep() with clockid
CLOCK_MONOTONIC_RAW, it may cause oops, such as NULL pointer
dereference.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: <stable@kernel.org>
LKML-Reference: <4A764FF3.50607@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/posix-timers.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 052ec4d..d089d05 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -202,6 +202,12 @@ static int no_timer_create(struct k_itimer *new_timer)
 	return -EOPNOTSUPP;
 }
 
+static int no_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsave, struct timespec __user *rmtp)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -254,6 +260,7 @@ static __init int init_posix_timers(void)
 		.clock_get = posix_get_monotonic_raw,
 		.clock_set = do_posix_clock_nosettime,
 		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
