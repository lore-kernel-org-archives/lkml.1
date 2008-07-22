Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYGVX0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYGVX0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbYGVXTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:57738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbYGVXT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:29 -0400
Date: Tue, 22 Jul 2008 16:16:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [patch 23/47] serial: fix serial_match_port() for dynamic major
	tty-device numbers
Message-ID: <20080722231614.GX8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial-fix-serial_match_port-for-dynamic-major-tty-device-numbers.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 7ca796f492a11f9408e661c8f22cd8c4f486b8e5 upstream

As reported by Vipul Gandhi, the current serial_match_port() doesn't work
for tty-devices using dynamic major number allocation.  Fix it.

It oopses if you suspend a serial port with _dynamic_ major number.  ATM,
I think, there's only the drivers/serial/jsm/jsm_driver.c driver, that
does it in-tree.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Vipul Gandhi <vcgandhi1@aol.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/serial_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1950,7 +1950,9 @@ struct uart_match {
 static int serial_match_port(struct device *dev, void *data)
 {
 	struct uart_match *match = data;
-	dev_t devt = MKDEV(match->driver->major, match->driver->minor) + match->port->line;
+	struct tty_driver *tty_drv = match->driver->tty_driver;
+	dev_t devt = MKDEV(tty_drv->major, tty_drv->minor_start) +
+		match->port->line;
 
 	return dev->devt == devt; /* Actually, only one tty per port */
 }

-- 
