Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXE1Nam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXE1Nam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXE1Nad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:30:33 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:35810 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755670AbXE1Nac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:30:32 -0400
Message-id: <3227425537413113360@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 7/8] Char: ip2, use msleep for sleeping
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Mon, 28 May 2007 15:30:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ip2, use msleep for sleeping

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit c025c4b3eca99f50b05bc24c445b861e91226539
tree 92557f319d16e0ecd7cf5a9b1387e0805fdcdf92
parent 62bd843054a7b2b2a3e3003a6b57b6359f199837
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 22:21:42 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 22:21:42 +0200

 drivers/char/ip2/i2ellis.c |   44 +-------------------------------------------
 1 files changed, 1 insertions(+), 43 deletions(-)

diff --git a/drivers/char/ip2/i2ellis.c b/drivers/char/ip2/i2ellis.c
index dd761a1..61ef013 100644
--- a/drivers/char/ip2/i2ellis.c
+++ b/drivers/char/ip2/i2ellis.c
@@ -43,8 +43,6 @@ static void iiEnableMailIrqIIEX(i2eBordStrPtr);
 static void iiWriteMaskII(i2eBordStrPtr, unsigned char);
 static void iiWriteMaskIIEX(i2eBordStrPtr, unsigned char);
 
-static void ii2DelayTimer(unsigned int);
-static void ii2DelayWakeup(unsigned long id);
 static void ii2Nop(void);
 
 //***************
@@ -55,8 +53,6 @@ static int ii2Safe;         // Safe I/O address for delay routine
 
 static int iiDelayed;	// Set when the iiResetDelay function is
 							// called. Cleared when ANY board is reset.
-static struct timer_list * pDelayTimer;   // Used by iiDelayTimer
-static wait_queue_head_t pDelayWait;    // Used by iiDelayTimer
 static rwlock_t Dl_spinlock;
 
 //********
@@ -86,9 +82,6 @@ static rwlock_t Dl_spinlock;
 static void
 iiEllisInit(void)
 {
-	pDelayTimer = kmalloc ( sizeof (struct timer_list), GFP_KERNEL );
-	init_timer(pDelayTimer);
-	init_waitqueue_head(&pDelayWait);
 	LOCK_INIT(&Dl_spinlock);
 }
 
@@ -106,7 +99,6 @@ iiEllisInit(void)
 static void
 iiEllisCleanup(void)
 {
-	kfree(pDelayTimer);
 }
 
 //******************************************************************************
@@ -560,19 +552,6 @@ iiInitialize(i2eBordStrPtr pB)
 	COMPLETE(pB, I2EE_GOOD);
 }
 
-//=======================================================
-// Delay Routines
-//
-// iiDelayIO
-// iiNop
-//=======================================================
-
-static void
-ii2DelayWakeup(unsigned long id)
-{
-	wake_up_interruptible ( &pDelayWait );
-}
-
 //******************************************************************************
 // Function:   ii2DelayTimer(mseconds)
 // Parameters: mseconds - number of milliseconds to delay
@@ -594,28 +573,7 @@ ii2DelayWakeup(unsigned long id)
 static void
 ii2DelayTimer(unsigned int mseconds)
 {
-	wait_queue_t wait;
-
-	init_waitqueue_entry(&wait, current);
-
-	init_timer ( pDelayTimer );
-
-	add_wait_queue(&pDelayWait, &wait);
-
-	set_current_state( TASK_INTERRUPTIBLE );
-
-	pDelayTimer->expires  = jiffies + ( mseconds + 9 ) / 10;
-	pDelayTimer->function = ii2DelayWakeup;
-	pDelayTimer->data     = 0;
-
-	add_timer ( pDelayTimer );
-
-	schedule();
-
-	set_current_state( TASK_RUNNING );
-	remove_wait_queue(&pDelayWait, &wait);
-
-	del_timer ( pDelayTimer );
+	msleep_interruptible(mseconds);
 }
 
 #if 0
