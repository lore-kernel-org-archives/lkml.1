Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZLBRTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZLBRTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZLBRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:19:16 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42315 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZLBRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:12 -0500
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
       Rodolfo Giometti <giometti@linux.it>
Date: Wed,  2 Dec 2009 18:18:48 +0100
Message-Id: <1259774329-29663-11-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259774329-29663-10-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
 <1259774329-29663-3-git-send-email-giometti@linux.it>
 <1259774329-29663-4-git-send-email-giometti@linux.it>
 <1259774329-29663-5-git-send-email-giometti@linux.it>
 <1259774329-29663-6-git-send-email-giometti@linux.it>
 <1259774329-29663-7-git-send-email-giometti@linux.it>
 <1259774329-29663-8-git-send-email-giometti@linux.it>
 <1259774329-29663-9-git-send-email-giometti@linux.it>
 <1259774329-29663-10-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 10/11] serial amba-pl010: enable PPS support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pl010_enable_ms() is automagically called when PPS ldisc
is selected.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/serial/amba-pl010.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/amba-pl010.c b/drivers/serial/amba-pl010.c
index 429a8ae..e4b3c2c 100644
--- a/drivers/serial/amba-pl010.c
+++ b/drivers/serial/amba-pl010.c
@@ -471,6 +471,20 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	spin_unlock_irqrestore(&uap->port.lock, flags);
 }
 
+static void pl010_set_ldisc(struct uart_port *port)
+{
+	int line = port->line;
+
+	if (line >= port->state->port.tty->driver->num)
+		return;
+
+	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
+		port->flags |= UPF_HARDPPS_CD;
+		pl010_enable_ms(port);
+	} else
+		port->flags &= ~UPF_HARDPPS_CD;
+}
+
 static const char *pl010_type(struct uart_port *port)
 {
 	return port->type == PORT_AMBA ? "AMBA" : NULL;
@@ -531,6 +545,7 @@ static struct uart_ops amba_pl010_pops = {
 	.startup	= pl010_startup,
 	.shutdown	= pl010_shutdown,
 	.set_termios	= pl010_set_termios,
+	.set_ldisc	= pl010_set_ldisc,
 	.type		= pl010_type,
 	.release_port	= pl010_release_port,
 	.request_port	= pl010_request_port,
-- 
1.6.3.3

