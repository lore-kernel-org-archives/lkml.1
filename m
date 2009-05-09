Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZEIHqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZEIHqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZEIHpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:45:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63017 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZEIHph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hx/Q/IM1/NmpICGi37F8S4w09mIdjg1oFV6t2VIo6zZxSN8l6KKvPM3rgJBkbiA3/3
         Cax3Op3v3lwB60Pi7aWhOi+p3iznYNz3NCiRCfTwYBIJdufqAlt5Li8SsUKkkwamFY4a
         mM6+lEjgdjXM7amy/vFKP9c+NywF3vd0l3sOA=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] ide-tape: fix potential fs requests bug
Date: Sat,  9 May 2009 09:45:21 +0200
Message-Id: <1241855134-4984-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide-tape had a potential bug for fs requests when preparing the command
packet: it was writing the transfer length as a number of fixed blocks.
However, the block layer implies 512 byte blocks and ide-tape can have
other block sizes so account for that too.

ide-floppy does this calculation properly with the block size factor
(floppy->bs_factor).

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index e166045..fc79cf4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -586,7 +586,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 				   struct ide_atapi_pc *pc, struct request *rq,
 				   u8 opcode)
 {
-	unsigned int length = blk_rq_sectors(rq);
+	unsigned int length = blk_rq_sectors(rq) / (tape->blk_size >> 9);
 
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
-- 
1.6.2.4

