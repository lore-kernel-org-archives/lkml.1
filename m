Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYGVK6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYGVK6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYGVK6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:58:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:36932 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750971AbYGVK6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:58:15 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19C86gPqKVCD3yydVzq1c9DnhlzXi4ATADX49B6oN
	HmolYoBaq2kAi7
Date: Tue, 22 Jul 2008 12:58:12 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: xiyou.wangcong@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [Patch] um: fix a build error
Message-ID: <20080722105812.GB5283@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 12:54:40 up  2:34,  1 user,  load average: 0.09, 0.26, 0.49
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just ran across the same build error, does
something like this look reasonable? Only build
and boot tested.

This fixes the following build error:

  CC      arch/um/drivers/line.o
  arch/um/drivers/line.c: In function ‘line_write_interrupt’:
  arch/um/drivers/line.c:366: error: ‘struct tty_ldisc’ has no member
  named ‘write_wakeup’
  arch/um/drivers/line.c:367: error: ‘struct tty_ldisc’ has no member
  named ‘write_wakeup’
  make[1]: *** [arch/um/drivers/line.o] Error 1
  make: *** [arch/um/drivers] Error 2


Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux-2.6/arch/um/drivers/line.c.orig	2008-07-22 12:06:17.000000000 +0200
+++ linux-2.6/arch/um/drivers/line.c	2008-07-22 12:06:49.000000000 +0200
@@ -362,10 +362,8 @@ static irqreturn_t line_write_interrupt(
 	if (tty == NULL)
 		return IRQ_NONE;
 
-	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
-	   (tty->ldisc.write_wakeup != NULL))
-		(tty->ldisc.write_wakeup)(tty);
-
+	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
+		tty_wakeup(tty);
 	/*
 	 * BLOCKING mode
 	 * In blocking mode, everything sleeps on tty->write_wait.
