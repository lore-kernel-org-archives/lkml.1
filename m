Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbXETV0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbXETV0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbXETVZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:25:54 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:43454 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756784AbXETVZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:25:53 -0400
Message-id: <3216512390173476416@wsc.cz>
In-reply-to: <20461285551864014911@wsc.cz>
Subject: [PATCH 2/3] Char: isicom, del_timer at exit
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 20 May 2007 23:25:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

isicom, del_timer at exit

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 017f1314b3de8cf20bfff7df0d3d55e6498de104
tree 938fec328f3b24588575540771f65c8fadeaf961
parent af05316f4ba7503ae531f3afdb5264c10e3b8e2c
author Jiri Slaby <jirislaby@gmail.com> Sun, 20 May 2007 21:43:42 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 20 May 2007 21:43:42 +0200

 drivers/char/isicom.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index b133b92..2f8aaf8 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -171,9 +171,6 @@ static struct pci_driver isicom_driver = {
 static int prev_card = 3;	/*	start servicing isi_card[0]	*/
 static struct tty_driver *isicom_normal;
 
-static DECLARE_COMPLETION(isi_timerdone);
-static char re_schedule = 1;
-
 static void isicom_tx(unsigned long _data);
 static void isicom_start(struct tty_struct *tty);
 
@@ -502,11 +499,6 @@ unlock:
 	spin_unlock_irqrestore(&isi_card[card].card_lock, flags);
 	/*	schedule another tx for hopefully in about 10ms	*/
 sched_again:
-	if (!re_schedule) {
-		complete(&isi_timerdone);
- 		return;
-	}
-
 	mod_timer(&tx, jiffies + msecs_to_jiffies(10));
 }
 
@@ -1890,9 +1882,7 @@ error:
 
 static void __exit isicom_exit(void)
 {
-	re_schedule = 0;
-
-	wait_for_completion_timeout(&isi_timerdone, HZ);
+	del_timer_sync(&tx);
 
 	pci_unregister_driver(&isicom_driver);
 	tty_unregister_driver(isicom_normal);
