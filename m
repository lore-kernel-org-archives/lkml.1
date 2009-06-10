Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZFJMJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZFJMJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZFJMIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:39 -0400
Received: from mx1.emlix.com ([193.175.82.87]:52053 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbZFJMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Schirmer <os@emlix.com>
Subject: [PATCH 9/9 -v2] imx: serial: use tty_encode_baud_rate to set true rate
Date: Wed, 10 Jun 2009 14:08:36 +0200
Message-Id: <1244635716-23315-10-git-send-email-os@emlix.com>
In-Reply-To: <1244635716-23315-1-git-send-email-os@emlix.com>
References: <1244635716-23315-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

real baud rate may be different from the one requested.
for upper layers, set the nearest value to the real rate
in favour of the rate previously requested.

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/imx.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 1c00e2a..c367160 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -818,6 +818,7 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
 	unsigned int div, ufcr;
 	unsigned long num, denom;
+	uint64_t tdiv64;
 
 	/*
 	 * If we don't support modem control lines, don't allow
@@ -930,6 +931,12 @@ imx_set_termios(struct uart_port *port, struct ktermios *termios,
 	rational_best_approximation(16 * div * baud, sport->port.uartclk,
 		1 << 16, 1 << 16, &num, &denom);
 
+	tdiv64 = sport->port.uartclk;
+	tdiv64 *= num;
+	do_div(tdiv64, denom * 16 * div);
+	tty_encode_baud_rate(sport->port.info->port.tty,
+		(speed_t)tdiv64, (speed_t)tdiv64);
+
 	num -= 1;
 	denom -= 1;
 
-- 
1.5.3.7

