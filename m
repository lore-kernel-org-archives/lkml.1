Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXDDVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXDDVqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXDDVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:46:30 -0400
Received: from mx0.karneval.cz ([81.27.192.15]:58538 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752055AbXDDVq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:46:28 -0400
Message-id: <7793186113082823019@karneval.cz>
In-reply-to: <16309194841640222796@karneval.cz>
Subject: [PATCH 3/5] Char: cyclades, timer cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed,  4 Apr 2007 23:45:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, timer cleanup

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d4e20e52c6084cff971d5b696c6eeac5ca2f9f48
tree 6372590725beebef60015ece7f910ce208cd5d0e
parent b0deeb148ea3d68519e313a08aad142aa44b0d41
author Jiri Slaby <jirislaby@gmail.com> Mon, 26 Mar 2007 16:20:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 27 Mar 2007 14:45:37 +0200

 drivers/char/cyclades.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index fc73537..0e530cb 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -851,7 +851,6 @@ static void cyz_poll(unsigned long);
 /* The Cyclades-Z polling cycle is defined by this variable */
 static long cyz_polling_cycle = CZ_DEF_POLL;
 
-static int cyz_timeron = 0;
 static DEFINE_TIMER(cyz_timerlist, cyz_poll, 0, 0);
 
 #else				/* CONFIG_CYZ_INTR */
@@ -1906,9 +1905,9 @@ static void cyz_poll(unsigned long arg)
 	static volatile struct BOARD_CTRL *board_ctrl;
 	static volatile struct CH_CTRL *ch_ctrl;
 	static volatile struct BUF_CTRL *buf_ctrl;
+	unsigned long expires = jiffies + HZ;
 	int card, port;
 
-	cyz_timerlist.expires = jiffies + (HZ);
 	for (card = 0; card < NR_CARDS; card++) {
 		cinfo = &cy_card[card];
 
@@ -1942,9 +1941,9 @@ static void cyz_poll(unsigned long arg)
 			cyz_handle_tx(info, ch_ctrl, buf_ctrl);
 		}
 		/* poll every 'cyz_polling_cycle' period */
-		cyz_timerlist.expires = jiffies + cyz_polling_cycle;
+		expires = jiffies + cyz_polling_cycle;
 	}
-	add_timer(&cyz_timerlist);
+	mod_timer(&cyz_timerlist, expires);
 }				/* cyz_poll */
 
 #endif				/* CONFIG_CYZ_INTR */
@@ -5504,10 +5503,8 @@ static int __init cy_init(void)
 	}
 
 #ifndef CONFIG_CYZ_INTR
-	if (number_z_boards && !cyz_timeron) {
-		cyz_timeron++;
-		cyz_timerlist.expires = jiffies + 1;
-		add_timer(&cyz_timerlist);
+	if (number_z_boards) {
+		mod_timer(&cyz_timerlist, jiffies + 1);
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z polling initialized\n");
 #endif
@@ -5523,10 +5520,7 @@ static void __exit cy_cleanup_module(void)
 	int i, e1;
 
 #ifndef CONFIG_CYZ_INTR
-	if (cyz_timeron){
-		cyz_timeron = 0;
-		del_timer(&cyz_timerlist);
-	}
+	del_timer_sync(&cyz_timerlist);
 #endif /* CONFIG_CYZ_INTR */
 
 	if ((e1 = tty_unregister_driver(cy_serial_driver)))
