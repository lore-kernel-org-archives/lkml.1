Return-Path: <linux-kernel-owner+w=401wt.eu-S1764956AbYETNgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764956AbYETNgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYETNgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:36:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39127 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbYETNgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:36:06 -0400
Date: Mon, 19 May 2008 20:11:41 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] serial: fix enable_irq_wake/disable_irq_wake imbalance in
 serial_core.c
Message-ID: <20080519201141.1dbe6cc1@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] serial: fix enable_irq_wake/disable_irq_wake imbalance in serial_core.c

enable_irq_wake() and disable_irq_wake() need to be balanced.
However, serial_core.c calls these for different conditions during
the suspend and resume functions...

This is causing a regular WARN_ON() as found at
http://www.kerneloops.org/search.php?search=set_irq_wake

This patch makes the conditions for triggering the _wake
enable/disable sequence identical.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/serial/serial_core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index eab0327..4df9ee1 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2054,6 +2054,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 {
 	struct uart_state *state = drv->state + port->line;
+	struct device *tty_dev;
+	struct uart_match match = {port, drv};
 
 	mutex_lock(&state->mutex);
 
@@ -2063,7 +2065,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		return 0;
 	}
 
-	if (!port->suspended) {
+	tty_dev = device_find_child(port->dev, &match, serial_match_port);
+	if (!port->suspended && device_may_wakeup(tty_dev)) {
 		disable_irq_wake(port->irq);
 		mutex_unlock(&state->mutex);
 		return 0;
-- 
1.5.4.5

