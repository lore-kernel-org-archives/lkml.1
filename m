Return-Path: <linux-kernel-owner+w=401wt.eu-S1766649AbXDTOQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766649AbXDTOQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993255AbXDTOQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:16:02 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:53700 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993034AbXDTOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:16:00 -0400
Date: Fri, 20 Apr 2007 16:15:51 +0200
From: Jan Yenya Kasprzak <kas@fi.muni.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Char: mxser_new, fix recursive locking
Message-ID: <20070420141551.GQ22955@fi.muni.cz>
References: <20225157853131727049@wsc.cz> <20070420131210.166fcd40@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420131210.166fcd40@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 20 Apr 2007 16:15:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
: > Acquire a port lock only if not in_interrupt in some places, because ISR
: > holds the lock yet (and ldisc calls some of driver's routines which tries to
: > acquire it again due to tty->low_latency).
: 
: NAK
: 
: This is the wrong way to do it. If you don't support recursive entry then
: don't use ->low_latency. If you do then ensure you drop the lock before
: you call tty_flip_buffer_push().

	I did as you suggested, and I am not able to reproduce the problem
now. The patch is attached. I think it is quite minimal, so it should be
safe to apply it. What do you think, Jiri?

Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

--- linux-2.6.21-rc2/drivers/char/mxser_new.c.orig	2007-04-20 15:41:46.000000000 +0200
+++ linux-2.6.21-rc2/drivers/char/mxser_new.c	2007-04-20 15:46:46.000000000 +0200
@@ -2230,7 +2230,14 @@
 	port->mon_data.rxcnt += cnt;
 	port->mon_data.up_rxcnt += cnt;
 
+	/*
+	 * We are called from an interrupt context with &port->slock
+	 * being held. Drop it temporarily in order to prevent
+	 * recursive locking.
+	 */
+	spin_unlock(&port->slock);
 	tty_flip_buffer_push(tty);
+	spin_lock(&port->slock);
 }
 
 static void mxser_transmit_chars(struct mxser_port *port)


-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
