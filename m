Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXDYTwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXDYTwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXDYTwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:52:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:19916 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752929AbXDYTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:52:41 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: mingo@elte.hu
Subject: [PATCH 2.6.21-rc6-rt0] ns2cyc() result fix
Date: Wed, 25 Apr 2007 22:54:17 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, dwalker@mvista.com,
       johnstul@us.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704252354.17404.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the dubious use of cycles_t where cycle_t was appropriate.  On the machines
with 32-bit cycles_t (like ARM/PPC) it caused these warnings:

In file included from arch/powerpc/kernel/time.c:1045:
include/linux/clocksource.h: In function `ns2cyc':
include/linux/clocksource.h:213: warning: comparison of distinct pointer types lacks a cast
include/linux/clocksource.h:213: warning: right shift count >= width of type
include/linux/clocksource.h:213: warning: passing argument 1 of `__div64_32' from incompatible pointer type

This function and therefore usecs_to_cycles() was unlikely to return a correct
result on such machines because of the shift result truncation.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
I'm also uncertain about 'preempt_max_latency' and 'preempt_thresh' variables
being declared as 'unsigned long' -- however, looks like those are unlikely to
overflow... yet it's unclear why there's casts to 'cycle_t' (which is always
64-bit) when initializing/comparing them...

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -206,9 +206,9 @@ static inline s64 cyc2ns(struct clocksou
  * @cs:		Pointer to clocksource
  * @nsecs:	Nanoseconds
  */
-static inline cycles_t ns2cyc(struct clocksource *cs, u64 nsecs)
+static inline cycle_t ns2cyc(struct clocksource *cs, u64 nsecs)
 {
-	cycles_t ret = nsecs << cs->shift;
+	cycle_t ret = nsecs << cs->shift;
 
 	do_div(ret, cs->mult + 1);
 

