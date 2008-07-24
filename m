Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYGXNYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYGXNYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYGXNXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:23:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:35347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752751AbYGXNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:23:42 -0400
X-Authenticated: #2218979
X-Provags-ID: V01U2FsdGVkX18v8vEP6+Iv1mvm3KOGSWmZas4fbcj1cPiSgtatkL
	6iJdlDco7rvjqS
Message-ID: <4888825A.1080503@gmx.de>
Date: Thu, 24 Jul 2008 15:23:38 +0200
From: Thomas Kunze <thommycheck@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>, thommycheck@gmx.de,
       david-b@packbell.net
Subject: mmc_test with mmc_spi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I wrote a small hack to be able to use the mmc_test driver on mmc-spi host. You or somebody else might find it useful.
All test but "Correct xfer_size at write (start failure)", "Correct xfer_size at read (start failure)" and "Correct xfer_size 
at write (midway failure)" passed.
I'm not sure what these tests try to do and how they do it, so I don't know if my modifcations of mmc_test, my spi driver or the 
mmc-spi driver are responsible.

It would be great if you could provide some insight.

Regards,
Thomas

--
diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index d6b9b48..2366150 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -44,7 +44,7 @@ static int mmc_test_set_blksize(struct mmc_test_card *test, unsigned size)
 
 	cmd.opcode = MMC_SET_BLOCKLEN;
 	cmd.arg = size;
-	cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+	cmd.flags = MMC_RSP_SPI_R1;
 	ret = mmc_wait_for_cmd(test->card->host, &cmd, 0);
 	if (ret)
 		return ret;
@@ -70,14 +70,14 @@ static void mmc_test_prepare_mrq(struct mmc_test_card *test,
 	}
 
 	mrq->cmd->arg = dev_addr;
-	mrq->cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
+	mrq->cmd->flags = MMC_RSP_SPI_R1;
 
 	if (blocks == 1)
 		mrq->stop = NULL;
 	else {
 		mrq->stop->opcode = MMC_STOP_TRANSMISSION;
 		mrq->stop->arg = 0;
-		mrq->stop->flags = MMC_RSP_R1B | MMC_CMD_AC;
+		mrq->stop->flags = MMC_RSP_SPI_R1;
 	}
 
 	mrq->data->blksz = blksz;
@@ -103,7 +103,7 @@ static int mmc_test_wait_busy(struct mmc_test_card *test)
 
 		cmd.opcode = MMC_SEND_STATUS;
 		cmd.arg = test->card->rca << 16;
-		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+		cmd.flags = MMC_RSP_SPI_R2;
 
 		ret = mmc_wait_for_cmd(test->card->host, &cmd, 0);
 		if (ret)
@@ -155,10 +155,10 @@ static int mmc_test_buffer_transfer(struct mmc_test_card *test,
 	if (data.error)
 		return data.error;
 
-	ret = mmc_test_wait_busy(test);
+/*	ret = mmc_test_wait_busy(test);
 	if (ret)
 		return ret;
-
+*/
 	return 0;
 }
 
@@ -240,7 +240,7 @@ static void mmc_test_prepare_broken_mrq(struct mmc_test_card *test,
 			MMC_WRITE_BLOCK : MMC_READ_SINGLE_BLOCK;
 		mrq->stop = NULL;
 	} else {
-		mrq->cmd->opcode = MMC_SEND_STATUS;
+		mrq->cmd->opcode = MMC_SEND_CID;
 		mrq->cmd->arg = test->card->rca << 16;
 	}
 }
@@ -333,7 +333,7 @@ static int mmc_test_simple_transfer(struct mmc_test_card *test,
 
 	mmc_wait_for_req(test->card->host, &mrq);
 
-	mmc_test_wait_busy(test);
+	//mmc_test_wait_busy(test);
 
 	return mmc_test_check_result(test, &mrq);
 }
@@ -367,7 +367,7 @@ static int mmc_test_broken_transfer(struct mmc_test_card *test,
 
 	mmc_wait_for_req(test->card->host, &mrq);
 
-	mmc_test_wait_busy(test);
+	//mmc_test_wait_busy(test);
 
 	return mmc_test_check_broken_result(test, &mrq);
 }

