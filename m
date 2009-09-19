Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZISVn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZISVn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZISVnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:18 -0400
Received: from kroah.org ([198.145.64.141]:40521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZISVnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Deepak Saxena <dsaxena@laptop.org>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/79] Set proper console speed on resume if console suspend is disabled
Date: Sat, 19 Sep 2009 14:37:02 -0700
Message-Id: <1253396244-7885-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Saxena <dsaxena@laptop.org>

Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
XO laptop. Basically what happens is that upon returning from resume,
serial8250_resume_port() will reconfigure the port for high speed
mode and all console output will be garbled, making debug of the
resume path painful. This patch modifies uart_resume_port() to
reset the port to the state it was in before we suspended.

Original patch by Marcelo Tosatti

Second patch by Deepak then reworked by Alan to fit with the tty changes
before it got submitted. Also fixed the console path to set c_i/ospeed as
some drivers require the termios fields are valid

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 3fd0134..2514d00 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2068,11 +2068,29 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	struct tty_port *port = &state->port;
 	struct device *tty_dev;
 	struct uart_match match = {uport, drv};
+	struct ktermios termios;
 
 	mutex_lock(&port->mutex);
 
 	if (!console_suspend_enabled && uart_console(uport)) {
 		/* no need to resume serial console, it wasn't suspended */
+		/*
+		 * First try to use the console cflag setting.
+		 */
+		memset(&termios, 0, sizeof(struct ktermios));
+		termios.c_cflag = uport->cons->cflag;
+		/*
+		 * If that's unset, use the tty termios setting.
+		 */
+		if (termios.c_cflag == 0)
+			termios = *state->port.tty->termios;
+		else {
+			termios.c_ispeed = termios.c_ospeed =
+				tty_termios_input_baud_rate(&termios);
+			termios.c_ispeed = termios.c_ospeed =
+				tty_termios_baud_rate(&termios);
+		}
+		uport->ops->set_termios(uport, &termios, NULL);
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
@@ -2089,20 +2107,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	 * Re-enable the console device after suspending.
 	 */
 	if (uart_console(uport)) {
-		struct ktermios termios;
-
-		/*
-		 * First try to use the console cflag setting.
-		 */
-		memset(&termios, 0, sizeof(struct ktermios));
-		termios.c_cflag = uport->cons->cflag;
-
-		/*
-		 * If that's unset, use the tty termios setting.
-		 */
-		if (port->tty && termios.c_cflag == 0)
-			termios = *port->tty->termios;
-
 		uart_change_pm(state, 0);
 		uport->ops->set_termios(uport, &termios, NULL);
 		console_start(uport->cons);
-- 
1.6.4.2

