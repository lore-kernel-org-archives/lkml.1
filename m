Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXBSNaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXBSNaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbXBSNaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:30:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:47270 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbXBSNaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:30:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=QIopT3XCM6zUAsfw1xDwlvZkr30V7tcFOp0lcB95nsDqKc1FhnhrdoAC64PbWPLc/pTLQKFg0BUBGzAVi4NMmPsI3j+klayZ0a4YOjGLWhbGp3dBnYGK2gdGU4BBXa24zejxmK73QuREAB3ZwqSYspUwzq2dcjFbLH+Bf4giqJY=
Date: Tue, 20 Feb 2007 13:29:09 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: rmk+lkml@arm.linux.org.uk
Cc: jose.goncalves@inov.pt, tie-fei.zang@freescale.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Serial related oops
Message-ID: <20070220132909.GD566@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the resend, I forgot to cc the list)
Hi Russell,

It seems that the following change in drivers/serial/8250.c

+
+	/*
+	 * Do a quick test to see if we receive an
+	 * interrupt when we enable the TX irq.
+	 */
+	serial_outp(up, UART_IER, UART_IER_THRI);
+	lsr = serial_in(up, UART_LSR);
+	iir = serial_in(up, UART_IIR);
+	serial_outp(up, UART_IER, 0);
+
+	if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
+		if (!(up->capabilities & UART_BUG_TXEN)) {
+			up->capabilities |= UART_BUG_TXEN;
+			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
+				 port->line);
+		}
+	} else {
+		up->capabilities &= ~UART_BUG_TXEN;
+	}
+

that was introduced in 2.6.12[1], is causing oopses on some hardware. In
particular Jose Goncalves reported[2] an oops in 2.6.16.38 reproducible
(after a few days of open()/close() on the serial port). He bisected this
to that change -thanks for the long debugging Jose ;)-. and reverting
that part of the 2.6.12 git patch seems to fix the problem.
I was wondering:
- what is the goal of the test?
- could this be CONFIGed ?

Regards,
Frederik

PS: CCing Andrew and Zang Roy-r61911 as they seemed to discuss this in
http://lkml.org/lkml/2006/6/13/21

[1]http://lkml.org/lkml/2005/6/23/266
[2]http://lkml.org/lkml/2007/1/26/157
