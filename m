Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYLDKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYLDKei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYLDKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:34:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44479 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYLDKe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:34:29 -0500
Date: Thu, 04 Dec 2008 19:34:24 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: clemens@ladisch.de
Subject: [Patch] Fix the possibility of insane return value of hpet_calibrate() against SMI.
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       mingo@redhat.com
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081204192607.6B38.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I think there is a possibility that hpet_calibrate() will return 
an insane value when SMI interrupts.

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

If SMI interrupts between 728 to 731, then return value will be
bigger value than correct one. This is the fix for it. 

I found it by just reviewing about SMI and the codes of timer calibration.
But, I've not encountered this issue, and this issue is very difficult
to produce. So, if I'm something wrong, sorry for noise.

Thanks.


---

hpet_calibrate() has a possibility of miss-calibration due to SMI.
If SMI interrupts in the while loop of calibration, then return value
will be big. This changes it tries 3 times and get minimum value.

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
+	/* Try 3 times to remove impact of SMI.*/
+	for (i = 0; i < 3; i++)
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


