Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbZJGAdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbZJGAdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933569AbZJGAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:33:23 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52781 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbZJGAdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KszN53GNP9o3DUF+G5GRKvYULcTRZDXkai/s5YAzr2PzJpxALTRUw3udNwsO6qBwAM
         CACQ0989RyoGe9PjJnqq/qzr+cInCwEcjlB0FsNEnbJr3Kw2ZL1aPwBvMdZXTdiNR+Bx
         EGp3KgxFvU1o+j5wVr9H6+GCb6O8HRrG3AK5k=
Subject: [PATCH] rtc: disable hpet emulation on suspend
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Oct 2009 02:32:40 +0200
Message-Id: <1254875560.12975.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that rtc wont generate interrupts after a resume from disk.
Here hpet rtc emulation is used.

Problem is that rtc hpet comparator, isn't reinitialized after resume.
Easiest way to solve this, is always mask all hpet interrupts on suspend
This is triggered, when suspending with alarm set.

----

>From e0e249d298ab0e92d247fb20440f33adf5e0a923 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Wed, 7 Oct 2009 02:25:22 +0200
Subject: [PATCH] rtc: disable hpet emulation on suspend

Otherwise, hpet driver will think it doesn't need to reinitialize
the rtc comparator, thus rtc interrupts won't work.

This emulation isn't need for wakealarm.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/rtc/rtc-cmos.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f7a4701..876e3fc 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -871,8 +871,9 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
-		hpet_mask_rtc_irq_bit(mask);
 
+		/* shut down hpet emulation - we don't need it for alarm */
+		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
-- 
1.6.3.3


