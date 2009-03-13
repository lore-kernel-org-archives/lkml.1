Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZCMFA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZCMFA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZCMFAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:00:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56779 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZCMFAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:00:48 -0400
Date: Fri, 13 Mar 2009 14:00:40 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: clemens@ladisch.de
Subject: [Patch] Fix the possibility of insane return value of hpet_calibrate() against SMI.
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.01 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I think there is a possibility that HPET driver will return
insane value due to a SMI interruption (or switching guests by hypervisor).
I found it by reviewing, and I would like to fix it.

Current HPET driver calibrates the adjustment value
by calculation the elapse time in CPU busy loop. 
However this way is too dangerous against SMI interruption.

Here is the calibration code in hpet_calibrate()

 701 static unsigned long hpet_calibrate(struct hpets *hpetp)
             :
             :
 728         do {
 729                 m = read_counter(&hpet->hpet_mc);
 730                 write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
 731         } while (i++, (m - start) < count);
 732 
 733         local_irq_restore(flags);
 734 
 735         return (m - start) / i;

If SMI interruption occurs between 728 to 731, then return value will be
bigger value than correct one. (SMI is not able to be controlled by OS.)


This patch is a simple solution to fix it.
hpet_calibrate() is called 5 times, and one of them is expected as
correct value.

Thanks.


---

hpet_calibrate() has a possibility of miss-calibration due to SMI.
If SMI interrupts in the while loop of calibration, then return value
will be big. This changes it tries 5 times and get minimum value as
correct value.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---

Index: hpet_test/drivers/char/hpet.c
===================================================================
--- hpet_test.orig/drivers/char/hpet.c	2008-12-04 16:24:02.000000000 +0900
+++ hpet_test/drivers/char/hpet.c	2008-12-04 16:34:59.000000000 +0900
@@ -713,7 +713,7 @@
  */
 #define	TICK_CALIBRATE	(1000UL)
 
-static unsigned long hpet_calibrate(struct hpets *hpetp)
+static unsigned long __hpet_calibrate(struct hpets *hpetp)
 {
 	struct hpet_timer __iomem *timer = NULL;
 	unsigned long t, m, count, i, flags, start;
@@ -750,6 +750,17 @@
 	return (m - start) / i;
 }
 
+static unsigned long hpet_calibrate(struct hpets *hpetp)
+{
+	unsigned long ret = ~0UL, i;
+
+	/* Try 5 times to remove impact of SMI.*/
+	for (i = 0; i < 5; i++)
+		ret = min(ret, __hpet_calibrate(hpetp));
+
+	return ret;
+}
+
 int hpet_alloc(struct hpet_data *hdp)
 {
 	u64 cap, mcfg;

-- 
Yasunori Goto 


