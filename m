Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZJEJri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZJEJri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbZJEJri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:47:38 -0400
Received: from bosmailout03.eigbox.net ([66.96.190.3]:37214 "EHLO
	bosmailout03.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769AbZJEJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:47:37 -0400
X-EN-OrigOutIP: 10.20.18.12
X-EN-IMPSID: oxle1c0010FdZ9W0000000
Message-ID: <4AC9C05A.8000807@jaysonking.com>
Date: Mon, 05 Oct 2009 04:46:02 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Con Kolivas <kernel@kolivas.org>
Subject: [PATCH 3/4] sched: account system time properly
References: <4AC9B97B.6070900@jaysonking.com>
In-Reply-To: <4AC9B97B.6070900@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.67.11.191
X-EN-OrigHost: adsl-67-67-11-191.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>

[upstream commit f5f293a4e3d0a0c52cec31de6762c95050156516]
[this is not actually necessary for applying BFS, but is included for
the sake of completeness since it is mirrored in BFS]

Andrew Gallatin reported that IRQ and SOFTIRQ times were
sometime not reported correctly on recent kernels, and even
bisected to commit 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
([PATCH] fix scaled & unscaled cputime accounting) as the first
bad commit.

Further analysis pointed that commit
79741dd35713ff4f6fd0eafd59fa94e8a4ba922d ([PATCH] idle cputime
accounting) was the real cause of the problem.

account_process_tick() was not taking into account timer IRQ
interrupting the idle task servicing a hard or soft irq.

On mostly idle cpu, irqs were thus not accounted and top or
mpstat could tell user/admin that cpu was 100 % idle, 0.00 %
irq, 0.00 % softirq, while it was not.

[ Impact: fix occasionally incorrect CPU statistics in top/mpstat ]

Reported-by: Andrew Gallatin <gallatin@myri.com>
Re-reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: rick.jones2@hp.com
Cc: brice@myri.com
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <49F84BC1.7080602@cosmosbay.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
  kernel/sched.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff -udrNp linux-2.6.27.orig/kernel/sched.c linux-2.6.27/kernel/sched.c
--- linux-2.6.27.orig/kernel/sched.c	2009-10-02 05:14:57.590579107 -0500
+++ linux-2.6.27/kernel/sched.c	2009-10-02 05:15:19.947578991 -0500
@@ -4187,7 +4187,7 @@ void account_process_tick(struct task_st

  	if (user_tick)
  		account_user_time(p, one_jiffy, one_jiffy_scaled);
-	else if (p != rq->idle)
+	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
  		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
  				    one_jiffy_scaled);
  	else






