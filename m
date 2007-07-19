Return-Path: <linux-kernel-owner+w=401wt.eu-S940412AbXGSR0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940412AbXGSR0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765363AbXGSR0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:26:22 -0400
Received: from h146-az.mvista.com ([65.200.49.156]:64999 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762395AbXGSR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:26:22 -0400
Date: Thu, 19 Jul 2007 10:29:02 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: stephane@artesyncp.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH 2/4] serial: MPSC: Stop rx engine when CREAD cleared
Message-ID: <20070719172902.GB589@mag.az.mvista.com>
References: <20070719172617.GA589@mag.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719172617.GA589@mag.az.mvista.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Chazelas <stephane@artesyncp.com>

Currently, the MPSC driver doesn't stop recieving characters when the
CREAD flag in termios->c_cflag is cleared.  It should.  Also, only start
receiving if its not already started.

Signed-off-by: Stephane Chazelas <stephane@artesyncp.com>
Signed-off-by: Mark A. Greer <mgreer@mvista.com>
---
 drivers/serial/mpsc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 99715fe..108fa4c 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -1536,7 +1536,6 @@ mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
 	mpsc_set_baudrate(pi, baud);
 
 	/* Characters/events to read */
-	pi->rcv_data = 1;
 	pi->port.read_status_mask = SDMA_DESC_CMDSTAT_OR;
 
 	if (termios->c_iflag & INPCK)
@@ -1560,11 +1559,15 @@ mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
 			pi->port.ignore_status_mask |= SDMA_DESC_CMDSTAT_OR;
 	}
 
-	/* Ignore all chars if CREAD not set */
-	if (!(termios->c_cflag & CREAD))
+	if ((termios->c_cflag & CREAD)) {
+		if (!pi->rcv_data) {
+			pi->rcv_data = 1;
+			mpsc_start_rx(pi);
+		}
+	} else if (pi->rcv_data) {
+		mpsc_stop_rx(port);
 		pi->rcv_data = 0;
-	else
-		mpsc_start_rx(pi);
+	}
 
 	spin_unlock_irqrestore(&pi->port.lock, flags);
 	return;

