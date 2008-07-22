Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYGVNYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYGVNYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYGVNYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:24:43 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:53554 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGVNYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:24:42 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] ip2: avoid add_timer() with pending timer
Date: Tue, 22 Jul 2008 15:22:07 +0200
Message-Id: <1216732927-27611-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

Alan Cox wrote:
> On Tue, 22 Jul 2008 03:06:55 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 22 Jul 2008 10:44:41 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Its queued but I can unqueue it as it isn't in the pile pending for Linus
> > > yet.
> > 
> > You've had it queued longer than I've had Jiri's sent-earlier patches
> > queued :(
> > 
> > I guess if Jiri can redo that patch for us then I can slip all five into
> > 2.6.27-rc1?
> 
> Fine by me

Ok, the patch follows:

--
add_timer() is not suppose to be called when the timer is pending.
ip2 driver attempts to avoid that condition by setting and resetting
a flag (TimerOn) in timer function. But there is some gap between
add_timer() and setting TimerOn.

This patch fix this problem by using mod_timer() and remove TimerOn
which has been unnecessary by this change.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michael H. Warfield <mhw@wittsend.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/ip2/ip2main.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 1146e88..89b9809 100644
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
@@ -772,10 +767,8 @@ static int __init ip2_loadmain(void)
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
@@ -1281,16 +1274,12 @@ ip2_poll(unsigned long arg)
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
-- 
1.5.6.2

