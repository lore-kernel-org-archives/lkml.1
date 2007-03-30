Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbXC3VNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbXC3VNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbXC3VNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:13:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51831 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXC3VNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:13:13 -0400
Date: Fri, 30 Mar 2007 14:07:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dsd@gentoo.org,
       rmk@arm.linux.org.uk
Subject: [patch 37/37] generic_serial: fix decoding of baud rate
Message-ID: <20070330210710.GN29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="generic_serial-fix-decoding-of-baud-rate.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Daniel Drake <dsd@gentoo.org>

Commit d720bc4b8fc5d6d179ef094908d4fbb5e436ffad partially removed a private
implementation of baud speed decoding.  However it doesn't seem to be
complete: after the speed is decoded, it is still being used as an index to
a local speed table (array overrun, no doubt).

This was found by Graham Murray who noticed it caused a 2.6.19 regression
with the SX driver: https://bugs.gentoo.org/170554

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/generic_serial.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -711,12 +711,6 @@ void gs_close(struct tty_struct * tty, s
 }
 
 
-static unsigned int     gs_baudrates[] = {
-  0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
-  9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600
-};
-
-
 void gs_set_termios (struct tty_struct * tty, 
                      struct ktermios * old_termios)
 {
@@ -772,7 +766,6 @@ void gs_set_termios (struct tty_struct *
 
 	baudrate = tty_get_baud_rate(tty);
 
-	baudrate = gs_baudrates[baudrate];
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
 		if (     (port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baudrate = 57600;

-- 
