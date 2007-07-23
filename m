Return-Path: <linux-kernel-owner+w=401wt.eu-S933352AbXGWSAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbXGWSAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbXGWR7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:59:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43382 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933163AbXGWR7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:59:49 -0400
Subject: Possible clocksource wrapping issues w/ new vdso clock_gettime()
	code?
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 10:59:43 -0700
Message-Id: <1185213583.8850.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andi,
	I've not been able to review the new vdso code very carefully yet, but
I noticed one thing right off: the offset calculation is not masked, so
its possible w/ counters less then 64bits wide to have wrapping issues.


It seems something like the following would be needed.

diff --git a/arch/x86_64/vdso/vclock_gettime.c b/arch/x86_64/vdso/vclock_gettime.c
index 17f6a00..9570f8e 100644
--- a/arch/x86_64/vdso/vclock_gettime.c
+++ b/arch/x86_64/vdso/vclock_gettime.c
@@ -36,8 +36,8 @@ static inline long vgetns(void)
 {
 	cycles_t (*vread)(void);
 	vread = gtod->clock.vread;
-	return ((vread() - gtod->clock.cycle_last) * gtod->clock.mult) >>
-		gtod->clock.shift;
+	return (((vread() - gtod->clock.cycle_last) & gtod->clock.mask) *
+		 gtod->clock.mult) >> gtod->clock.shift;
 }
 
 static noinline int do_realtime(struct timespec *ts)



Or am I just missing something? 

thanks
-john


