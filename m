Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZHYHO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZHYHO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbZHYHOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:14:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:40429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbZHYHOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:14:22 -0400
Date: Tue, 25 Aug 2009 07:13:40 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, h-shimamoto@ct.jp.nec.com,
       dwalker@fifo99.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, h-shimamoto@ct.jp.nec.com, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A937FDE.4050506@ct.jp.nec.com>
References: <4A937FDE.4050506@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping: Fix invalid getboottime() value
Message-ID: <tip-36d47481b3824b661b464077db95d447984df799@git.kernel.org>
Git-Commit-ID: 36d47481b3824b661b464077db95d447984df799
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 07:13:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36d47481b3824b661b464077db95d447984df799
Gitweb:     http://git.kernel.org/tip/36d47481b3824b661b464077db95d447984df799
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Tue, 25 Aug 2009 15:08:30 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 09:09:02 +0200

timekeeping: Fix invalid getboottime() value

Don't use timespec_add_safe() with wall_to_monotonic, because
wall_to_monotonic has negative values which will cause overflow
in timespec_add_safe(). That makes btime in /proc/stat invalid.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <4A937FDE.4050506@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/time/timekeeping.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 03cbeb3..fb0f46f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -826,9 +826,11 @@ void update_wall_time(void)
  */
 void getboottime(struct timespec *ts)
 {
-	struct timespec boottime;
+	struct timespec boottime = {
+		.tv_sec = wall_to_monotonic.tv_sec + total_sleep_time.tv_sec,
+		.tv_nsec = wall_to_monotonic.tv_nsec + total_sleep_time.tv_nsec
+	};
 
-	boottime = timespec_add_safe(wall_to_monotonic, total_sleep_time);
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
 
