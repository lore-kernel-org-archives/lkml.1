Return-Path: <linux-kernel-owner+w=401wt.eu-S934668AbZLKXbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668AbZLKXbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934414AbZLKX3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:46 -0500
Received: from kroah.org ([198.145.64.141]:50535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934462AbZLKX3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/58] tty: moxa: Kill the use of lock_kernel
Date: Fri, 11 Dec 2009 15:28:36 -0800
Message-Id: <1260574122-10676-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

It isn't needed here any more

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index ac06d01..d53fac5 100644
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
-- 
1.6.5.5

