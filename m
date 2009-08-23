Return-Path: <linux-kernel-owner+w=401wt.eu-S933480AbZHWJEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480AbZHWJEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbZHWJEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:37029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361AbZHWJEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:04:14 -0400
Date: Sun, 23 Aug 2009 09:03:43 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090822222313.74b9619c@skybase>
References: <20090822222313.74b9619c@skybase>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping: Increase granularity of read_persistent_clock(), build fix
Message-ID: <tip-d90246cd8e0141332a8ab09c3c1800cc2028a686@git.kernel.org>
Git-Commit-ID: d90246cd8e0141332a8ab09c3c1800cc2028a686
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:03:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d90246cd8e0141332a8ab09c3c1800cc2028a686
Gitweb:     http://git.kernel.org/tip/d90246cd8e0141332a8ab09c3c1800cc2028a686
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Sat, 22 Aug 2009 22:23:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:49:48 +0200

timekeeping: Increase granularity of read_persistent_clock(), build fix

Fix the following build problem on powerpc:

  arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
  arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void
  arch/powerpc/kernel/time.c:791: error: 'return' with a value, in function returning void

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: dwalker@fifo99.com
Cc: johnstul@us.ibm.com
LKML-Reference: <20090822222313.74b9619c@skybase>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/time.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index ad63f30..a508388 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -774,6 +774,7 @@ void read_persistent_clock(struct timespec *ts)
 	struct rtc_time tm;
 	static int first = 1;
 
+	ts->tv_nsec = 0;
 	/* XXX this is a litle fragile but will work okay in the short term */
 	if (first) {
 		first = 0;
@@ -781,15 +782,18 @@ void read_persistent_clock(struct timespec *ts)
 			timezone_offset = ppc_md.time_init();
 
 		/* get_boot_time() isn't guaranteed to be safe to call late */
-		if (ppc_md.get_boot_time)
-			return ppc_md.get_boot_time() -timezone_offset;
+		if (ppc_md.get_boot_time) {
+			ts->tv_sec = ppc_md.get_boot_time() - timezone_offset;
+			return;
+		}
+	}
+	if (!ppc_md.get_rtc_time) {
+		ts->tv_sec = 0;
+		return;
 	}
-	if (!ppc_md.get_rtc_time)
-		return 0;
 	ppc_md.get_rtc_time(&tm);
 	ts->tv_sec = mktime(tm.tm_year+1900, tm.tm_mon+1, tm.tm_mday,
 			    tm.tm_hour, tm.tm_min, tm.tm_sec);
-	ts->tv_nsec = 0;
 }
 
 /* clocksource code */
