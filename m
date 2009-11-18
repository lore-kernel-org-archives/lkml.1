Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZKROdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZKROdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZKROdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:33:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40623 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757309AbZKROdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:33:19 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 11/12] moxa: Kill the use of lock_kernel
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:16:55 +0000
Message-ID: <20091118141651.3346.39864.stgit@localhost.localdomain>
In-Reply-To: <20091118141354.3346.16910.stgit@localhost.localdomain>
References: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't needed here any more

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/moxa.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index f9816e6..f8e673a 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -34,7 +34,6 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/major.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
@@ -202,7 +201,6 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
 static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
-static void moxa_setup_empty_event(struct tty_struct *);
 static void moxa_shutdown(struct tty_port *);
 static int moxa_carrier_raised(struct tty_port *);
 static void moxa_dtr_rts(struct tty_port *, int);
@@ -1251,17 +1249,13 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 	struct moxa_port *ch = tty->driver_data;
 	int chars;
 
-	lock_kernel();
 	chars = MoxaPortTxQueue(ch);
-	if (chars) {
+	if (chars)
 		/*
 		 * Make it possible to wakeup anything waiting for output
 		 * in tty_ioctl.c, etc.
 		 */
-		if (!test_bit(EMPTYWAIT, &ch->statusflags))
-			moxa_setup_empty_event(tty);
-	}
-	unlock_kernel();
+        	set_bit(EMPTYWAIT, &ch->statusflags);
 	return chars;
 }
 
@@ -1503,12 +1497,6 @@ static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_term
 	tty_encode_baud_rate(tty, baud, baud);
 }
 
-static void moxa_setup_empty_event(struct tty_struct *tty)
-{
-	struct moxa_port *ch = tty->driver_data;
-	set_bit(EMPTYWAIT, &ch->statusflags);
-}
-
 /*****************************************************************************
  *	Driver level functions: 					     *
  *****************************************************************************/

