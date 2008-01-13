Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYAMUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYAMUXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYAMUWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:17 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:46596 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753575AbYAMUWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=1pwgPtNjuadMWSxvNCKzl8/2kEYIB40x31vGDB94zLAJX2mvefLUbHH1F9Wf3tOkmk/aEmz2MbPl3vwzLgoD3QZDOMt6pvFE9O3cKFfr/VgO/TASVvVlEpYIqJFogRELdTj2E7/yiyt62C2WirPKmKEPEXWsGG7vqt+i3/x5iAQ=  ;
X-YMail-OSG: nYx3o2MVM1mr0g0oxzH8BOsaigzFecB94_1nArtY80wkhcEywQ16qxiwcT5zd2MM8p6d5AV7YQ--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 5/12] ide-floppy: report DMA handling in idefloppy_pc_intr() properly
Date: Sun, 13 Jan 2008 21:18:18 +0100
Message-Id: <1200255505-31418-6-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 00ea8d6..5004773 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -534,11 +534,17 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	unsigned int temp;
 	u16 bcount;
 	u8 stat, ireason;
+	int dma_error = 0;
 
 	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
-		if (HWIF(drive)->ide_dma_end(drive)) {
+		dma_error = HWIF(drive)->ide_dma_end(drive);
+		if (dma_error) {
+			printk(KERN_ERR "%s: DMA %s error\n",
+				drive->name,
+				rq_data_dir(rq) == WRITE ? "write" :"read");
+
 			set_bit(PC_DMA_ERROR, &pc->flags);
 		} else {
 			pc->actually_transferred = pc->request_transfer;
-- 
1.5.3.7

