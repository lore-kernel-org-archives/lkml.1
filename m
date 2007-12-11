Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbXLKWov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbXLKWov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbXLKWoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:44:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXLKWoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:44:07 -0500
Date: Tue, 11 Dec 2007 17:43:15 -0500 (EST)
Message-Id: <20071211.174315.57154895.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 06/30] blk_end_request: changing DAC960 (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts DAC960 to use blk_end_request interfaces.
Related 'UpToDate' arguments are converted to 'Error'.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/DAC960.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/block/DAC960.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/DAC960.c
+++ 2.6.24-rc4/drivers/block/DAC960.c
@@ -3455,19 +3455,12 @@ static inline bool DAC960_ProcessComplet
 						 bool SuccessfulIO)
 {
 	struct request *Request = Command->Request;
-	int UpToDate;
-
-	UpToDate = 0;
-	if (SuccessfulIO)
-		UpToDate = 1;
+	int Error = SuccessfulIO ? 0 : -EIO;
 
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
 
-	 if (!end_that_request_first(Request, UpToDate, Command->BlockCount)) {
-		add_disk_randomness(Request->rq_disk);
- 	 	end_that_request_last(Request, UpToDate);
-
+	 if (!__blk_end_request(Request, Error, Command->BlockCount << 9)) {
 		if (Command->Completion) {
 			complete(Command->Completion);
 			Command->Completion = NULL;
