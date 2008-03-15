Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYCOA1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYCOA1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 20:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYCOA1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 20:27:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYCOA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 20:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=ODiNgPIUhkrwidYZVwI2FjxHYjG/5EYFGOZgUlaZKLt2BZQjL+eLFkyhPjBBOYzcfaAceegNGEhUyRQ73CuY7PNdNBr4xC2w1e20+rFp5/oVDY39SxvKXzrw+iRSHZinjMeeHaBjcoJ4lf7UQGHkiv0kXIijVJc01FxJRzoWC38=
Date: Sat, 15 Mar 2008 01:26:44 +0100 (CET)
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Gadi Oxman <gadio@netvision.net.il>, LKML <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] ide-tape: Avoid potential null pointer dereference in
 idetape_abort_pipeline()
Message-ID: <alpine.LNX.1.00.0803150123450.29784@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If a NULL 'new_last_stage' is passed to idetape_abort_pipeline() then 
we'll dereference a NULL pointer and go *boom*. 
The function does test for a null pointer, unfortunately it only does it 
after having already dereferenced it.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 ide-tape.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 43e0e05..943290c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -814,11 +814,14 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
 				   idetape_stage_t *new_last_stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_stage_t *stage = new_last_stage->next;
+	idetape_stage_t *stage = NULL;
 	idetape_stage_t *nstage;
 
 	debug_log(DBG_PROCS, "%s: Enter %s\n", tape->name, __func__);
 
+	if (new_last_stage)
+		stage = new_last_stage->next;
+
 	while (stage) {
 		nstage = stage->next;
 		idetape_kfree_stage(tape, stage);


