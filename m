Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYJEQLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYJEQLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYJEQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:07:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54872 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756493AbYJEQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:07:20 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 20/76] ip2: avoid add_timer with pending timer
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:07:21 +0100
Message-ID: <20081005160718.1997.97483.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

add_timer() is not suppose to be called when the timer is pending.
ip2 driver attempts to avoid that condition by setting and resetting
a flag (TimerOn) in timer function. But there is some gap between
add_timer() and setting TimerOn.

This patch fix this problem by using mod_timer() and remove TimerOn
which has been unnecessary by this change.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/ip2/ip2main.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 39269d1..66f52a2 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -249,7 +249,6 @@ static unsigned long bh_counter;
  */
 #define  POLL_TIMEOUT   (jiffies + 1)
 static DEFINE_TIMER(PollTimer, ip2_poll, 0, 0);
-static char  TimerOn;
 
 #ifdef IP2DEBUG_TRACE
 /* Trace (debug) buffer data */
@@ -374,11 +373,7 @@ static void __exit ip2_cleanup_module(void)
 	int err;
 	int i;
 
-	/* Stop poll timer if we had one. */
-	if (TimerOn) {
-		del_timer(&PollTimer);
-		TimerOn = 0;
-	}
+	del_timer_sync(&PollTimer);
 
 	/* Reset the boards we have. */
 	for (i = 0; i < IP2_MAX_BOARDS; i++)
@@ -774,10 +769,8 @@ static int __init ip2_loadmain(void)
 		}
 		if (ip2config.irq[i] == CIR_POLL) {
 retry:
-			if (!TimerOn) {
-				PollTimer.expires = POLL_TIMEOUT;
-				add_timer(&PollTimer);
-				TimerOn = 1;
+			if (!timer_pending(&PollTimer)) {
+				mod_timer(&PollTimer, POLL_TIMEOUT);
 				printk(KERN_INFO "IP2: polling\n");
 			}
 		} else {
@@ -1283,16 +1276,12 @@ ip2_poll(unsigned long arg)
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

