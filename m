Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbYGVJpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbYGVJpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYGVJpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:45:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbYGVJpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:45:09 -0400
Date: Tue, 22 Jul 2008 02:44:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] Char: merge ip2main and ip2base
Message-Id: <20080722024458.f609bb12.akpm@linux-foundation.org>
In-Reply-To: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
References: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Jul 2008 15:28:23 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> It's pretty useless to have one setup() function separated along with
> module_init() which only calls a function from ip2main anyway. Get rid
> of ip2base.
> 
> Remove also checks of always-true now.
> 

<catching up>

I applied these four, but there's a fly in our ointment.

On 14 July, Akinobu Mita <akinobu.mita@gmail.com> sent a patch titled
"ip2: avoid add_timer() with pending timer" which Alan acked and then
claimed was "Queued for ttydev tree".  But afaict he then lost it.

If it gets unlost, it will conflict with these changes and I might need
to drop these four (I didn't check).

Perhaps you could review this patch and maybe merge this change on top
of these four?

Thanks.


Date: 	Mon, 14 Jul 2008 11:49:55 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Subject: [PATCH] ip2: avoid add_timer() with pending timer


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
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

