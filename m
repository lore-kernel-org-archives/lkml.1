Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZLNILB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZLNILB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbZLNILA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:11:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41808 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZLNIK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:10:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B25F2DE.4000703@jp.fujitsu.com>
Date: Mon, 14 Dec 2009 17:10:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH] acpi: fix for lapic_timer_propagate_broadcast()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got following warning on ia64 box:
  In function 'acpi_processor_power_verify':
  642: warning: passing argument 2 of 'smp_call_function_single' from
  incompatible pointer type

This smp_call_function_single() was introduced by a commit
f833bab87fca5c3ce13778421b1365845843b976:

 > @@ -162,8 +162,9 @@
 >               pr->power.timer_broadcast_on_state = state;
 >  }
 >
 > -static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
 > +static void lapic_timer_propagate_broadcast(void *arg)
 >  {
 > +       struct acpi_processor *pr = (struct acpi_processor *) arg;
 >         unsigned long reason;
 >
 >         reason = pr->power.timer_broadcast_on_state < INT_MAX ?
 > @@ -635,7 +636,8 @@
 >                 working++;
 >         }
 >
 > -       lapic_timer_propagate_broadcast(pr);
 > +       smp_call_function_single(pr->id, lapic_timer_propagate_broadcast,
 > +                                pr, 1);
 >
 >         return (working);
 >  }

The problem is that the lapic_timer_propagate_broadcast() has 2 versions:
One is real code that modified in the above commit, and the other is NOP
code that used when !ARCH_APICTIMER_STOPS_ON_C3:

  static void lapic_timer_propagate_broadcast(struct acpi_processor *pr) { }

So I got warning because of !ARCH_APICTIMER_STOPS_ON_C3.

We really want to do nothing here on !ARCH_APICTIMER_STOPS_ON_C3, so
modify lapic_timer_propagate_broadcast() of real version to use
smp_call_function_single() in it.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index bbd066e..d1676b1 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -164,7 +164,7 @@ static void lapic_timer_check_state(int state, struct acpi_processor *pr,
 		pr->power.timer_broadcast_on_state = state;
 }
 
-static void lapic_timer_propagate_broadcast(void *arg)
+static void __lapic_timer_propagate_broadcast(void *arg)
 {
 	struct acpi_processor *pr = (struct acpi_processor *) arg;
 	unsigned long reason;
@@ -175,6 +175,12 @@ static void lapic_timer_propagate_broadcast(void *arg)
 	clockevents_notify(reason, &pr->id);
 }
 
+static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
+{
+	smp_call_function_single(pr->id, __lapic_timer_propagate_broadcast,
+				 (void *)pr, 1);
+}
+
 /* Power(C) State timer broadcast control */
 static void lapic_timer_state_broadcast(struct acpi_processor *pr,
 				       struct acpi_processor_cx *cx,
@@ -638,8 +644,7 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 		working++;
 	}
 
-	smp_call_function_single(pr->id, lapic_timer_propagate_broadcast,
-				 pr, 1);
+	lapic_timer_propagate_broadcast(pr);
 
 	return (working);
 }
-- 
1.6.5.6


