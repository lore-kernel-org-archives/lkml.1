Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYAMUYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYAMUYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYAMUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:28 -0500
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:35949 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753460AbYAMUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=x2lOfuIHzjByNuYAJSFoTtqrYtfY6R4wA2BwuffHR54/hz1aHBE7/xlIpyixpltFLtGNKNSoQ8vQzIC29s1M4puRpeVL5Jusiw81PNLTusUFuIMNRXk4xnSWNYxq6s7XcuQHwKrjUmXazMNgS0N0DGoBDQHT/jAOiRRmKRAsjmo=  ;
X-YMail-OSG: OOxLx24VM1mYYlxuRsECBBGvCv3zGHeJyxiz1hjJFf5mIa68GIz5lDbweviaJlZC76Moa8TaHQ--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 9/12] ide-floppy: remove unused IDEFLOPPY_USE_READ12
Date: Sun, 13 Jan 2008 21:18:22 +0100
Message-Id: <1200255505-31418-10-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-9-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-6-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-7-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-8-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-9-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is not being set anywhere in the driver so it can go.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 6c917fc..790e33f 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -180,7 +180,6 @@ typedef struct ide_floppy_obj {
  */
 #define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
 #define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
-#define IDEFLOPPY_USE_READ12		2	/* Use READ12/WRITE12 or READ10/WRITE10 */
 #define	IDEFLOPPY_FORMAT_IN_PROGRESS	3	/* Format in progress */
 #define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported in Clik drive */
 #define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for packets */
@@ -889,25 +888,21 @@ static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
 	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
-static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
+static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
+		idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
-	debug_log("create_rw1%d_cmd: block == %d, blocks == %d\n",
-		2 * test_bit (IDEFLOPPY_USE_READ12, &floppy->flags),
+	debug_log("create_rw10_cmd: block == %d, blocks == %d\n",
 		block, blocks);
 
 	idefloppy_init_pc(pc);
-	if (test_bit(IDEFLOPPY_USE_READ12, &floppy->flags)) {
-		pc->c[0] = cmd == READ ? GPCMD_READ_12 : GPCMD_WRITE_12;
-		put_unaligned(cpu_to_be32(blocks), (unsigned int *) &pc->c[6]);
-	} else {
-		pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
-		put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
-	}
+	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
+	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
+
 	pc->callback = &idefloppy_rw_callback;
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
-- 
1.5.3.7

