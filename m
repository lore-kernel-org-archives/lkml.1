Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbXBDEPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbXBDEPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 23:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXBDEPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 23:15:50 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:4735
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752015AbXBDEPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 23:15:49 -0500
Date: Sat, 3 Feb 2007 20:15:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: oleg@tv-sign.ru, akpm@linux-foundation.org, johnstul@us.ibm.com,
       mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org
Subject: [PATCH] POSIX timers RCU optimization fix for clock_gettime
Message-ID: <20070204041524.GA6582@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an exit()/posix_cpu_clock_get() race spotted by Oleg Nesterov.
Solution is to move the p->signal check under the tasklist_lock.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 posix-cpu-timers.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.20-rc6-clockrcu/kernel/posix-cpu-timers.c linux-2.6.20-rc6-clockrcu-fixes/kernel/posix-cpu-timers.c
--- linux-2.6.20-rc6-clockrcu/kernel/posix-cpu-timers.c	2007-02-01 13:03:57.000000000 -0800
+++ linux-2.6.20-rc6-clockrcu-fixes/kernel/posix-cpu-timers.c	2007-02-03 16:53:41.000000000 -0800
@@ -312,10 +312,13 @@ int posix_cpu_clock_get(const clockid_t 
 					error = cpu_clock_sample(which_clock,
 								 p, &rtn);
 				}
-			} else if (p->tgid == pid && p->signal) {
+			} else {
 				read_lock(&tasklist_lock);
-				error = cpu_clock_sample_group(which_clock,
-							       p, &rtn);
+				if (p->tgid == pid && p->signal) {
+					error =
+					    cpu_clock_sample_group(which_clock,
+							           p, &rtn);
+				}
 				read_unlock(&tasklist_lock);
 			}
 		}
