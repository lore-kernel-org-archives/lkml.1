Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYBIQTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYBIQTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYBIQSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:18:11 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:42918 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYBIQSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=XHf2wpB63+5LF/mkW3MApVbnu4XYZGqy7kQrSTy9oGyn5k6Qa3QvCAdOSDdQ01wAOslA6BHrnqERyypGXRpEe6pWSO48xk05ptETA9M/ha5UKkeCYuTQOAFzat2SduzRI6SSaxzVxZCuz57K2Vlds9TQrHeYfC+cU0KEuxN60jw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ide-tape: remove never executed code
Date: Sat, 9 Feb 2008 16:23:46 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802091623.46896.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rq->cmd[0] is never set to REQ_IDETAPE_READ_BUFFER so remove
REQ_IDETAPE_READ_BUFFER handling from idetape_create_write_cmd()
and the define itself.

Then remove no longer used idetape_create_read_buffer_cmd()
and IDETAPE_RETRIEVE_FAULTY_BLOCK define.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -466,9 +466,6 @@ static void ide_tape_put(struct ide_tape
 /* 0 = no tape is loaded, so we don't rewind after ejecting */
 #define IDETAPE_MEDIUM_PRESENT		9
 
-/* A define for the READ BUFFER command */
-#define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
-
 /* Some defines for the SPACE command */
 #define IDETAPE_SPACE_OVER_FILEMARK	1
 #define IDETAPE_SPACE_TO_EOD		3
@@ -490,7 +487,6 @@ enum {
 	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
 	REQ_IDETAPE_READ	= (1 << 2),
 	REQ_IDETAPE_WRITE	= (1 << 3),
-	REQ_IDETAPE_READ_BUFFER	= (1 << 4),
 };
 
 /* Error codes returned in rq->errors to the higher part of the driver. */
@@ -1523,29 +1519,6 @@ static void idetape_create_read_cmd(idet
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
 }
 
-static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
-		idetape_pc_t *pc, struct idetape_bh *bh)
-{
-	int size = 32768;
-	struct idetape_bh *p = bh;
-
-	idetape_init_pc(pc);
-	pc->c[0] = READ_BUFFER;
-	pc->c[1] = IDETAPE_RETRIEVE_FAULTY_BLOCK;
-	pc->c[7] = size >> 8;
-	pc->c[8] = size & 0xff;
-	pc->callback = &idetape_pc_callback;
-	pc->bh = bh;
-	atomic_set(&bh->b_count, 0);
-	pc->buffer = NULL;
-	while (p) {
-		atomic_set(&p->b_count, 0);
-		p = p->b_reqnext;
-	}
-	pc->request_transfer = size;
-	pc->buffer_size = size;
-}
-
 static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
 		unsigned int length, struct idetape_bh *bh)
 {
@@ -1655,13 +1628,6 @@ static ide_startstop_t idetape_do_reques
 					 (struct idetape_bh *)rq->special);
 		goto out;
 	}
-	if (rq->cmd[0] & REQ_IDETAPE_READ_BUFFER) {
-		tape->postpone_cnt = 0;
-		pc = idetape_next_pc_storage(drive);
-		idetape_create_read_buffer_cmd(tape, pc,
-				(struct idetape_bh *)rq->special);
-		goto out;
-	}
 	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
 		pc = (idetape_pc_t *) rq->buffer;
 		rq->cmd[0] &= ~(REQ_IDETAPE_PC1);
