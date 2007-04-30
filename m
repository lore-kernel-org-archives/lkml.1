Return-Path: <linux-kernel-owner+w=401wt.eu-S1946855AbXD3WJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946855AbXD3WJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946854AbXD3WJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:09:04 -0400
Received: from mta15.mail.adelphia.net ([68.168.78.77]:60362 "EHLO
	mta15.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946849AbXD3WJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:09:01 -0400
Date: Mon, 30 Apr 2007 17:08:59 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-serial@vger.kernel.org
Subject: Serial 8250: clear the lsr_break_flag at open
Message-ID: <20070430220858.GA28890@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the double send, but I messed up on the subject.  I'll
get used to mutt one of these days.

I think I've spotted a bug in the 8250 code, but I'm not really
sure.  I'm having a hard time understanding why the lsr_break_flag
is necessary.

Subject: Serial 8250: clear the lsr_break_flag at open

The lsr_break_flag in the 8250 driver is not cleared when the port is
opened.  This means that on a serial console, if a break has occurred
while the port is closed, the first call to receive_chars() will
result in a break being delivered at that point.  Clear the flag at
open to fix the problem.

Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.21/drivers/serial/8250.c
===================================================================
--- linux-2.6.21.orig/drivers/serial/8250.c
+++ linux-2.6.21/drivers/serial/8250.c
@@ -1638,6 +1638,7 @@ static int serial8250_startup(struct uar
 
 	up->capabilities = uart_config[up->port.type].flags;
 	up->mcr = 0;
+	up->lsr_break_flag = 0;
 
 	if (up->port.type == PORT_16C950) {
 		/* Wake up and initialize UART */

