Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZJASrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZJASrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZJASrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:47:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55081
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736AbZJASrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:47:36 -0400
Date: Thu, 01 Oct 2009 11:47:55 -0700 (PDT)
Message-Id: <20091001.114755.132624639.davem@davemloft.net>
To: manty@manty.net
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090930110529.GA3676@dis.manty.net>
References: <20090930110529.GA3676@dis.manty.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santiago Garcia Mantinan <manty@manty.net>
Date: Wed, 30 Sep 2009 13:05:29 +0200

>  [<c010f865>] ? dequeue_task+x90/0x9e
>  [<c029d777>] ? schedule+0x2ad/0x2d9
>  [<c019f63a>] ? __blk_run_queue+0x39/0x60
>  [<c0la4f97>] ? cfq_kick_queue+0x0/0xb
>  [<c01a4fa0>] ? cfq_kick_queue+0x9/0xb
>  [<c011dd82>] ? worker_thread+0xae/0x11c

So it does look like a normal block I/O request to the disk
going through the CFQ scheduler.

But ->cmd_type of the request is corrupted, but we have no
idea in what way.

Well, we know it's not a special request, because one layer
up the IDE I/O layer driver does special processing for
blk_special_request() by calling ide_special_rq().

I suspect the request structure has been freed already and
we're referencing free'd memory.

Please add this test patch and let us know what messages
you end up with in the logs.  It won't BUG() any more,
so you have to watch for the messages.

Thanks!

-DaveM (the IDE bug dodger)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7f87801..54b9dbc 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -184,7 +184,11 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
-	BUG_ON(!blk_fs_request(rq));
+	if (!blk_fs_request(rq)) {
+		pr_alert("IDE: Non-FS req in ide_do_rw_disk(), cmd_type %d\n",
+			 rq->cmd_type);
+		ide_kill_rq(drive, rq);
+	}
 
 	ledtrig_ide_activity();
 
