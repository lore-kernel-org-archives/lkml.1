Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0CBIZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:25:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:51746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab0CBIZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:25:11 -0500
Date: Tue, 2 Mar 2010 08:24:35 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, aaro.koskinen@iki.fi,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, aaro.koskinen@iki.fi,
       tglx@linutronix.de
In-Reply-To: <1267475683.4216.61.camel@localhost.localdomain>
References: <1267475683.4216.61.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timekeeping: Prevent oops when GENERIC_TIME=n
Message-ID: <tip-ad6759fbf35d104dbf573cd6f4c6784ad6823f7e@git.kernel.org>
Git-Commit-ID: ad6759fbf35d104dbf573cd6f4c6784ad6823f7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 08:24:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad6759fbf35d104dbf573cd6f4c6784ad6823f7e
Gitweb:     http://git.kernel.org/tip/ad6759fbf35d104dbf573cd6f4c6784ad6823f7e
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Mon, 1 Mar 2010 12:34:43 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 2 Mar 2010 09:22:25 +0100

timekeeping: Prevent oops when GENERIC_TIME=n

Aaro Koskinen reported an issue in kernel.org bugzilla #15366, where
on non-GENERIC_TIME systems, accessing
/sys/devices/system/clocksource/clocksource0/current_clocksource
results in an oops.

It seems the timekeeper/clocksource rework missed initializing the
curr_clocksource value in the !GENERIC_TIME case.

Thanks to Aaro for reporting and diagnosing the issue as well as
testing the fix!

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: stable@kernel.org
LKML-Reference: <1267475683.4216.61.camel@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/clocksource.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f663d2..1f5dde6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -592,6 +592,10 @@ static inline void clocksource_select(void) { }
  */
 static int __init clocksource_done_booting(void)
 {
+	mutex_lock(&clocksource_mutex);
+	curr_clocksource = clocksource_default_clock();
+	mutex_unlock(&clocksource_mutex);
+
 	finished_booting = 1;
 
 	/*
