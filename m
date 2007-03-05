Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbXCEQ6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbXCEQ6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXCEQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:58:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:51954 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324AbXCEQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:58:37 -0500
Message-Id: <20070305165648.518964015@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 05 Mar 2007 08:56:48 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH] fix vsyscall settimeofday
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've only seen this on x86_64 .

The vsyscall state only gets updated when a timer interrupts comes in . So
if the time is set long before the next timer, there will be a period when
a gettimeofday() won't reflect the correct time.

I added an explicit update_vsyscall() during the settimeofday(), that way
the vsyscall state doesn't get stale.

Any thought John?

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/timer.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.20/kernel/timer.c
===================================================================
--- linux-2.6.20.orig/kernel/timer.c
+++ linux-2.6.20/kernel/timer.c
@@ -861,6 +861,8 @@ int do_settimeofday(struct timespec *tv)
 	clock->error = 0;
 	ntp_clear();
 
+	update_vsyscall(&xtime, clock);
+
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* signal hrtimers about time change */
-- 
