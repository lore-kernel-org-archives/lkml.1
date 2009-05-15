Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbZEOFN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbZEOFN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbZEOFLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:46 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:45159 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZEOFLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jj1f4dBvOmzsT72uwrzhrgRH63HdXTatTvDSmlpb+h8uDgJBdk+CxDAIRUHPb3zYBm
         +6DkiZQZvqCzwRGLlTL99sxd3esKX/pXhud5Dq+bNPPafpE1GzPp8u1kOkL5EpRnjlnT
         4/sKsN2HWUb9Q32B5zel/3NZ/byXWeX0ac+jo=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] ide-tape: fix potential fs requests bug
Date: Fri, 15 May 2009 07:11:19 +0200
Message-Id: <1242364293-29223-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
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
1.6.3

