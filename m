Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbXH3D3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbXH3D3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXH3D33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:29:29 -0400
Received: from mail.queued.net ([207.210.101.209]:1805 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbXH3D32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:29:28 -0400
Date: Wed, 29 Aug 2007 23:31:25 -0400
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: [PATCH 5/5] ALSA: cs5535audio: drop unused bus master stuff
Message-Id: <20070829233125.4b76ce39.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We really only care about the first two bus masters (playback and capture).
There's no need to have unused BM code lying around, so let's get rid of it.

If for some reason we trigger an IRQ for some BM that we're not using.. well,
that warrants spitting out an error message (imo).

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 sound/pci/cs5535audio/cs5535audio.c |   24 +++---------------------
 sound/pci/cs5535audio/cs5535audio.h |   31 +------------------------------
 2 files changed, 4 insertions(+), 51 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index b8e75ef..2b35889 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -206,7 +206,6 @@ static void process_bm1_irq(struct cs5535audio *cs5535au)
 static irqreturn_t snd_cs5535audio_interrupt(int irq, void *dev_id)
 {
 	u16 acc_irq_stat;
-	u8 bm_stat;
 	unsigned char count;
 	struct cs5535audio *cs5535au = dev_id;
 
@@ -217,7 +216,7 @@ static irqreturn_t snd_cs5535audio_interrupt(int irq, void *dev_id)
 
 	if (!acc_irq_stat)
 		return IRQ_NONE;
-	for (count = 0; count < 10; count++) {
+	for (count = 0; count < 4; count++) {
 		if (acc_irq_stat & (1 << count)) {
 			switch (count) {
 			case IRQ_STS:
@@ -232,26 +231,9 @@ static irqreturn_t snd_cs5535audio_interrupt(int irq, void *dev_id)
 			case BM1_IRQ_STS:
 				process_bm1_irq(cs5535au);
 				break;
-			case BM2_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM2_STATUS);
-				break;
-			case BM3_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM3_STATUS);
-				break;
-			case BM4_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM4_STATUS);
-				break;
-			case BM5_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM5_STATUS);
-				break;
-			case BM6_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM6_STATUS);
-				break;
-			case BM7_IRQ_STS:
-				bm_stat = cs_readb(cs5535au, ACC_BM7_STATUS);
-				break;
 			default:
-				snd_printk(KERN_ERR "Unexpected irq src\n");
+				snd_printk(KERN_ERR "Unexpected irq src: "
+						"0x%x\n", acc_irq_stat);
 				break;
 			}
 		}
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index 516219a..66bae76 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -16,48 +16,19 @@
 #define ACC_IRQ_STATUS			0x12
 #define ACC_BM0_CMD			0x20
 #define ACC_BM1_CMD			0x28
-#define ACC_BM2_CMD			0x30
-#define ACC_BM3_CMD			0x38
-#define ACC_BM4_CMD			0x40
-#define ACC_BM5_CMD			0x48
-#define ACC_BM6_CMD			0x50
-#define ACC_BM7_CMD			0x58
 #define ACC_BM0_PRD			0x24
 #define ACC_BM1_PRD			0x2C
-#define ACC_BM2_PRD			0x34
-#define ACC_BM3_PRD			0x3C
-#define ACC_BM4_PRD			0x44
-#define ACC_BM5_PRD			0x4C
-#define ACC_BM6_PRD			0x54
-#define ACC_BM7_PRD			0x5C
 #define ACC_BM0_STATUS			0x21
 #define ACC_BM1_STATUS			0x29
-#define ACC_BM2_STATUS			0x31
-#define ACC_BM3_STATUS			0x39
-#define ACC_BM4_STATUS			0x41
-#define ACC_BM5_STATUS			0x49
-#define ACC_BM6_STATUS			0x51
-#define ACC_BM7_STATUS			0x59
 #define ACC_BM0_PNTR			0x60
 #define ACC_BM1_PNTR			0x64
-#define ACC_BM2_PNTR			0x68
-#define ACC_BM3_PNTR			0x6C
-#define ACC_BM4_PNTR			0x70
-#define ACC_BM5_PNTR			0x74
-#define ACC_BM6_PNTR			0x78
-#define ACC_BM7_PNTR			0x7C
+
 /* acc_codec bar0 reg bits */
 /* ACC_IRQ_STATUS */
 #define IRQ_STS 			0
 #define WU_IRQ_STS 			1
 #define BM0_IRQ_STS 			2
 #define BM1_IRQ_STS 			3
-#define BM2_IRQ_STS 			4
-#define BM3_IRQ_STS 			5
-#define BM4_IRQ_STS 			6
-#define BM5_IRQ_STS		 	7
-#define BM6_IRQ_STS 			8
-#define BM7_IRQ_STS 			9
 /* ACC_BMX_STATUS */
 #define EOP				(1<<0)
 #define BM_EOP_ERR			(1<<1)
