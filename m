Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZJASww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZJASww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZJASwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:52:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60828
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952AbZJASwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:52:51 -0400
Date: Thu, 01 Oct 2009 11:53:10 -0700 (PDT)
Message-Id: <20091001.115310.100974682.davem@davemloft.net>
To: manty@manty.net
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091001.114755.132624639.davem@davemloft.net>
References: <20090930110529.GA3676@dis.manty.net>
	<20091001.114755.132624639.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 01 Oct 2009 11:47:55 -0700 (PDT)

> Please add this test patch and let us know what messages
> you end up with in the logs.  It won't BUG() any more,
> so you have to watch for the messages.

Sorry, there's a small bug in the test patch, please use this one
instead.

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7f87801..6e0dfa9 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -184,7 +184,12 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
-	BUG_ON(!blk_fs_request(rq));
+	if (!blk_fs_request(rq)) {
+		pr_alert("IDE: Non-FS req in ide_do_rw_disk(), cmd_type %d\n",
+			 rq->cmd_type);
+		ide_kill_rq(drive, rq);
+		return ide_stopped;
+	}
 
 	ledtrig_ide_activity();
 
