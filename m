Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZFINrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZFINrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZFINq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:56 -0400
Received: from mx1.emlix.com ([193.175.82.87]:44944 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZFINqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:53 -0400
From: "Oskar Schirmer" <os@emlix.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>,
       Oskar Schirmer <os@emlix.com>
Subject: [PATCH 4/8] imx: serial: be sure to stop xmit upon shutdown
Date: Tue,  9 Jun 2009 15:46:47 +0200
Message-Id: <1244555211-15618-5-git-send-email-os@emlix.com>
In-Reply-To: <1244555211-15618-4-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
 <1244555211-15618-2-git-send-email-os@emlix.com>
 <1244555211-15618-3-git-send-email-os@emlix.com>
 <1244555211-15618-4-git-send-email-os@emlix.com>
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

