Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0BPJx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:53:28 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39847 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0BPJv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:51:58 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 16 Feb 2010 10:51:24 +0100
Message-Id: <1266313885-1195-8-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266313885-1195-7-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
 <1266313885-1195-2-git-send-email-giometti@linux.it>
 <1266313885-1195-3-git-send-email-giometti@linux.it>
 <1266313885-1195-4-git-send-email-giometti@linux.it>
 <1266313885-1195-5-git-send-email-giometti@linux.it>
 <1266313885-1195-6-git-send-email-giometti@linux.it>
 <1266313885-1195-7-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 7/8] serial 8250: enable PPS support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automagically function serial8250_enable_ms() is called when PPS ldisc
is selected.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/serial/8250.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 737b4c9..e70187b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2415,6 +2415,21 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 }
 
 static void
+serial8250_set_ldisc(struct uart_port *port)
+{
+	int line = port->line;
+
+	if (line >= port->state->port.tty->driver->num)
+		return;
+
+	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+		port->flags |= UPF_HARDPPS_CD;
+		serial8250_enable_ms(port);
+	} else
+		port->flags &= ~UPF_HARDPPS_CD;
+}
+
+static void
 serial8250_pm(struct uart_port *port, unsigned int state,
 	      unsigned int oldstate)
 {
@@ -2628,6 +2643,7 @@ static struct uart_ops serial8250_pops = {
 	.startup	= serial8250_startup,
 	.shutdown	= serial8250_shutdown,
 	.set_termios	= serial8250_set_termios,
+	.set_ldisc	= serial8250_set_ldisc,
 	.pm		= serial8250_pm,
 	.type		= serial8250_type,
 	.release_port	= serial8250_release_port,
-- 
1.6.3.3

