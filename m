Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZFJMIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZFJMIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZFJMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:08:38 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38108 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZFJMIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:08:37 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oskar Schirmer <os@emlix.com>,
       Fabian Godehardt <fg@emlix.com>
Subject: [PATCH 4/9 -v2] imx: serial: be sure to stop xmit upon shutdown
Date: Wed, 10 Jun 2009 14:08:31 +0200
Message-Id: <1244635716-23315-5-git-send-email-os@emlix.com>
In-Reply-To: <1244635716-23315-1-git-send-email-os@emlix.com>
References: <1244635716-23315-1-git-send-email-os@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Godehardt <fg@emlix.com>

needed to avoid continued transmission by hardware
while software already shuts down, which might
cause dangling characters to show up in hardware
queues when restarting the device.

Signed-off-by: Fabian Godehardt <fg@emlix.com>
Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 drivers/serial/imx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index afcec9e..3fa07a9 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -634,6 +634,10 @@ static void imx_shutdown(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
+	temp = readl(sport->port.membase + UCR2);
+	temp &= ~(UCR2_TXEN);
+	writel(temp, sport->port.membase + UCR2);
+
 	/*
 	 * Stop our timer.
 	 */
-- 
1.5.3.7

