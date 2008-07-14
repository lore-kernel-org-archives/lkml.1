Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYGNCuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYGNCuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYGNCuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:50:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:14449 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYGNCuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=a2DpGt/DZpxUlpYsUy+GYmH32RY9hVPZgNfyaHIZzg4p7uO0DrIIH7x03iYxu0Eorn
         7q/zpfo9Ai1vDBJU+7R9UhdciTA1zOmy6ByiJneCA7BnzbKP6ejVnk3lTeL3cLXQe9YV
         a7kk6gaY8fxA0s5oXMjrAnLwd4pqXI31wVS6c=
Date: Mon, 14 Jul 2008 11:49:55 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Subject: [PATCH] ip2: avoid add_timer() with pending timer
Message-ID: <20080714024955.GB30952@sssvn.sssvn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_timer() is not suppose to be called when the timer is pending.
ip2 driver attempts to avoid that condition by setting and resetting
a flag (TimerOn) in timer function. But there is some gap between
add_timer() and setting TimerOn.

This patch fix this problem by using mod_timer() and remove TimerOn
which has been unnecessary by this change.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michael H. Warfield <mhw@wittsend.com>
---
 drivers/char/ip2/ip2main.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

Index: 2.6-mmotm/drivers/char/ip2/ip2main.c
===================================================================
--- 2.6-mmotm.orig/drivers/char/ip2/ip2main.c
+++ 2.6-mmotm/drivers/char/ip2/ip2main.c
@@ -252,7 +252,6 @@ static unsigned long bh_counter = 0;
  */
 #define  POLL_TIMEOUT   (jiffies + 1)
 static DEFINE_TIMER(PollTimer, ip2_poll, 0, 0);
-static char  TimerOn;
 
 #ifdef IP2DEBUG_TRACE
 /* Trace (debug) buffer data */
@@ -372,10 +371,7 @@ ip2_cleanup_module(void)
 	printk (KERN_DEBUG "Unloading %s: version %s\n", pcName, pcVersion );
 #endif
 	/* Stop poll timer if we had one. */
-	if ( TimerOn ) {
-		del_timer ( &PollTimer );
-		TimerOn = 0;
-	}
+	del_timer_sync(&PollTimer);
 
 	/* Reset the boards we have. */
 	for( i = 0; i < IP2_MAX_BOARDS; ++i ) {
@@ -746,10 +742,8 @@ ip2_loadmain(int *iop, int *irqp)
 			}
 			if ( ip2config.irq[i] == CIR_POLL ) {
 retry:
-				if (!TimerOn) {
-					PollTimer.expires = POLL_TIMEOUT;
-					add_timer ( &PollTimer );
-					TimerOn = 1;
+				if (!timer_pending(&PollTimer)) {
+					mod_timer(&PollTimer, POLL_TIMEOUT);
 					printk( KERN_INFO "IP2: polling\n");
 				}
 			} else {
@@ -1250,16 +1244,12 @@ ip2_poll(unsigned long arg)
 {
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, 100, 0 );
 
-	TimerOn = 0; // it's the truth but not checked in service
-
 	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
 	// It will NOT poll boards handled by hard interrupts.
 	// The issue of queued BH interrupts is handled in ip2_interrupt().
 	ip2_polled_interrupt();
 
-	PollTimer.expires = POLL_TIMEOUT;
-	add_timer( &PollTimer );
-	TimerOn = 1;
+	mod_timer(&PollTimer, POLL_TIMEOUT);
 
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, ITRC_RETURN, 0 );
 }
