Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbYGJPRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbYGJPRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYGJPRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:17:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:52515 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYGJPRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:17:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] rtc: fix reported IRQ rate for when HPET is enabled.
Date: Thu, 10 Jul 2008 11:23:47 -0400
Message-Id: <1215703427-28798-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 10 Jul 2008 15:16:35.0071 (UTC) FILETIME=[F0FAE0F0:01C8E29F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ rate reported back by the RTC is incorrect when
HPET is enabled.

Newer hardware that has HPET to emulate the legacy RTC
device gets this value wrong since after it sets the
rate, it returns before setting the variable used to
report the IRQ rate back to users of the device -- so
the set rate and the reported rate get out of sync.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/rtc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 5f80a9d..909cac9 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -678,12 +678,13 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 		if (arg != (1<<tmp))
 			return -EINVAL;
 
+		rtc_freq = arg;
+
 		spin_lock_irqsave(&rtc_lock, flags);
 		if (hpet_set_periodic_freq(arg)) {
 			spin_unlock_irqrestore(&rtc_lock, flags);
 			return 0;
 		}
-		rtc_freq = arg;
 
 		val = CMOS_READ(RTC_FREQ_SELECT) & 0xf0;
 		val |= (16 - tmp);
-- 
1.5.6.2

