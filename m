Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZJST6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZJST6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZJST6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:58:13 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55757 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZJST6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:58:12 -0400
X-SpamScore: 10
X-BigFish: VPS10(zza4b1ozz1202hzzed1kz2fh6bh66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
Message-ID: <4ADCC4E3.8060104@am.sony.com>
Date: Mon, 19 Oct 2009 12:58:27 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jim Paris <jim@jtan.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] block/ps3: Fix slow VRAM IO
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 19:58:07.0635 (UTC) FILETIME=[7A3B1630:01CA50F6]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hideyuki Sasaki <Hideyuki_Sasaki@hq.scei.sony.co.jp>

The current PS3 VRAM driver uses msleep() to wait for completion
of RSX DMA transfers between system memory and VRAM.  Depending
on the system timing, the processing delay and overhead of this
msleep() call can significantly impact VRAM driver IO.

To avoid the condition, add a short duration (200 usec max)
udelay() polling loop before entering the msleep() polling
loop.

Signed-off-by: Hideyuki Sasaki <xhide@rd.scei.sony.co.jp>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---

 drivers/block/ps3vram.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -123,7 +123,15 @@ static int ps3vram_notifier_wait(struct 
 {
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 	u32 *notify = ps3vram_get_notifier(priv->reports, NOTIFIER);
-	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
+	unsigned long timeout;
+
+	for (timeout = 20; timeout; timeout--) {
+		if (!notify[3])
+			return 0;
+		udelay(10);
+	}
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
 
 	do {
 		if (!notify[3])

