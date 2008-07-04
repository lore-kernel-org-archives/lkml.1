Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYGDArx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYGDArx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 20:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYGDArp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 20:47:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:6441 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYGDAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CpFx+KafKPPutB/dKYHLuRjaXakMVcaKn06On0FTuuTgs6vqmonIMsfzmTaSkg5YJH
         kJABtE010q8E74TzNABh39pmU6LOmb+JlmawrBJEx73fZCBFQjD0gbWmEs2K+aJHqiEI
         tRTbpL32SYdb/B7Y0YsqKZFjK7+WA2S84a0aI=
Subject: [PATCH 1/2] input: ads7846.c remove sparse endian warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 17:47:09 -0700
Message-Id: <1215132429.16647.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove the temporary pointer and use ->rx_buf directly.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/input/touchscreen/ads7846.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 907a45f..4d06032 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -633,19 +633,17 @@ static void ads7846_rx_val(void *ads)
 	struct ads7846 *ts = ads;
 	struct spi_message *m;
 	struct spi_transfer *t;
-	u16 *rx_val;
 	int val;
 	int action;
 	int status;
 
 	m = &ts->msg[ts->msg_idx];
 	t = list_entry(m->transfers.prev, struct spi_transfer, transfer_list);
-	rx_val = t->rx_buf;
 
 	/* adjust:  on-wire is a must-ignore bit, a BE12 value, then padding;
 	 * built from two 8 bit values written msb-first.
 	 */
-	val = be16_to_cpu(*rx_val) >> 3;
+	val = be16_to_cpup((__be16 *)t->rx_buf) >> 3;
 
 	action = ts->filter(ts->filter_data, ts->msg_idx, &val);
 	switch (action) {
@@ -659,7 +657,7 @@ static void ads7846_rx_val(void *ads)
 		m = ts->last_msg;
 		break;
 	case ADS7846_FILTER_OK:
-		*rx_val = val;
+		*(u16 *)t->rx_buf = val;
 		ts->tc.ignore = 0;
 		m = &ts->msg[++ts->msg_idx];
 		break;
-- 
1.5.6.1.281.g1087e


