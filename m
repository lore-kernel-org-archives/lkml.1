Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbZEFWS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbZEFWS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbZEFVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:23 -0400
Received: from kroah.org ([198.145.64.141]:57469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761535AbZEFVzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:03 2009
Message-Id: <20090506214803.103171041@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rick.jones2@hp.com,
       brice@myri.com, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 56/58] sched: account system time properly
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=sched-account-system-time-properly.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

commit f5f293a4e3d0a0c52cec31de6762c95050156516 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4347,7 +4347,7 @@ void account_process_tick(struct task_st
 
 	if (user_tick)
 		account_user_time(p, one_jiffy, one_jiffy_scaled);
-	else if (p != rq->idle)
+	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
 		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
 				    one_jiffy_scaled);
 	else


