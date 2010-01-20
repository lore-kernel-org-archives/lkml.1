Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415Ab0ATXwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab0ATXwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228Ab0ATXuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:54 -0500
Received: from kroah.org ([198.145.64.141]:33653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0ATXuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/8] serial: Fix crash if the minimum rate of the device is > 9600 baud
Date: Wed, 20 Jan 2010 15:50:00 -0800
Message-Id: <1264031403-32239-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

In that situation if the old rate is invalid and the new rate is invalid
and the chip cannot do 9600 baud we report zero, which makes all the
drivers explode.

Instead force the rate based on min/max

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index fa4f170..7f28307 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -385,13 +385,20 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		}
 
 		/*
-		 * As a last resort, if the quotient is zero,
-		 * default to 9600 bps
+		 * As a last resort, if the range cannot be met then clip to
+		 * the nearest chip supported rate.
 		 */
-		if (!hung_up)
-			tty_termios_encode_baud_rate(termios, 9600, 9600);
+		if (!hung_up) {
+			if (baud <= min)
+				tty_termios_encode_baud_rate(termios,
+							min + 1, min + 1);
+			else
+				tty_termios_encode_baud_rate(termios,
+							max - 1, max - 1);
+		}
 	}
-
+	/* Should never happen */
+	WARN_ON(1);
 	return 0;
 }
 
-- 
1.6.5.7

