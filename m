Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZCYGIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZCYGIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 02:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZCYGHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 02:07:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54840 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbZCYGHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 02:07:37 -0400
Date: Wed, 25 Mar 2009 17:07:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicolas Pitre <nico@cam.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       =?UTF-8?B?Ik1hcmVrIFZhxaF1dCI=?= <marek.vasut@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] input: ucb1400_ts: move single use function from header
Message-Id: <20090325170730.e9b80106.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ucb1400_adc_read is only used in
drivers/input/touchscreen/ucb1400_ts.c, so move it there from
include/linux/ucb1400.h.

This fixes this build warning:

  CC [M]  drivers/mfd/ucb1400_core.o
include/linux/ucb1400.h:139: warning: 'ucb1400_adc_read' defined but not used

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/input/touchscreen/ucb1400_ts.c |   19 +++++++++++++++++++
 include/linux/ucb1400.h                |   19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 5498662..f4393e3 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -44,6 +44,25 @@ static inline void ucb1400_ts_mode_int(struct snd_ac97 *ac97)
 			UCB_TS_CR_MODE_INT);
 }
 
+static unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
+					int adcsync)
+{
+	unsigned int val;
+
+	if (adcsync)
+		adc_channel |= UCB_ADC_SYNC_ENA;
+
+	ucb1400_reg_write(ac97, UCB_ADC_CR, UCB_ADC_ENA | adc_channel);
+	ucb1400_reg_write(ac97, UCB_ADC_CR, UCB_ADC_ENA | adc_channel |
+				UCB_ADC_START);
+
+	while (!((val = ucb1400_reg_read(ac97, UCB_ADC_DATA))
+			& UCB_ADC_DAT_VALID))
+		schedule_timeout_uninterruptible(1);
+
+	return val & UCB_ADC_DAT_MASK;
+}
+
 /*
  * Switch to pressure mode, and read pressure.  We don't need to wait
  * here, since both plates are being driven.
diff --git a/include/linux/ucb1400.h b/include/linux/ucb1400.h
index 970473b..bf4f547 100644
--- a/include/linux/ucb1400.h
+++ b/include/linux/ucb1400.h
@@ -134,25 +134,6 @@ static inline void ucb1400_adc_enable(struct snd_ac97 *ac97)
 	ucb1400_reg_write(ac97, UCB_ADC_CR, UCB_ADC_ENA);
 }
 
-static unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
-					int adcsync)
-{
-	unsigned int val;
-
-	if (adcsync)
-		adc_channel |= UCB_ADC_SYNC_ENA;
-
-	ucb1400_reg_write(ac97, UCB_ADC_CR, UCB_ADC_ENA | adc_channel);
-	ucb1400_reg_write(ac97, UCB_ADC_CR, UCB_ADC_ENA | adc_channel |
-				UCB_ADC_START);
-
-	while (!((val = ucb1400_reg_read(ac97, UCB_ADC_DATA))
-			& UCB_ADC_DAT_VALID))
-		schedule_timeout_uninterruptible(1);
-
-	return val & UCB_ADC_DAT_MASK;
-}
-
 static inline void ucb1400_adc_disable(struct snd_ac97 *ac97)
 {
 	ucb1400_reg_write(ac97, UCB_ADC_CR, 0);
-- 
1.6.2.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
