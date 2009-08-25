Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZHYGJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZHYGJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZHYGJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:09:32 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63271 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZHYGJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:09:31 -0400
Message-ID: <4A937FDE.4050506@ct.jp.nec.com>
Date: Tue, 25 Aug 2009 15:08:30 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip] timekeeping: fix getboottime() sets invalid value
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Don't use timespec_add_safe() with wall_to_monotonic, because wall_to_monotonic
has negative values which will cause overflow in timespec_add_safe().
That makes btime in /proc/stat invalid.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
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
 
-- 
1.6.3.3

