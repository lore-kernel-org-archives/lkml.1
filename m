Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYFSVcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYFSVcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYFSVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:31:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbYFSVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:31:40 -0400
Date: Thu, 19 Jun 2008 14:29:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: [patch 02/15] Fix tty speed handling on 8250
Message-ID: <20080619212943.GC20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tty-speed-handling-on-8250.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

commit e991a2bd4fa0b2f475b67dfe8f33e8ecbdcbb40b upstream.

We try and write the correct speed back but the serial midlayer already
mangles the speed on us and that means if we request B0 we report back B9600
when we should not.  For now we'll hack around this in the drivers and serial
code, pending a better long term solution.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2174,7 +2174,9 @@ serial8250_set_termios(struct uart_port 
 	}
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	tty_termios_encode_baud_rate(termios, baud, baud);
+	/* Don't rewrite B0 */
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
 }
 
 static void

-- 
