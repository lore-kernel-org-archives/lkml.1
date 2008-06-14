Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbYFNA1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbYFNA1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762280AbYFNAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:26 -0400
Received: from ns.suse.de ([195.135.220.2]:34623 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbYFNAPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:24 -0400
Date: Fri, 13 Jun 2008 17:12:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 43/47] serial: fix enable_irq_wake/disable_irq_wake
	imbalance in serial_core.c
Message-ID: <20080614001214.GQ24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial-fix-enable_irq_wake-disable_irq_wake-imbalance-in-serial_core.c.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Arjan van de Ven <arjan@linux.intel.com>

commit 03a74dcc7eebe6edd778317e82fafdf71e68488c in mainline.

enable_irq_wake() and disable_irq_wake() need to be balanced.  However,
serial_core.c calls these for different conditions during the suspend and
resume functions...

This is causing a regular WARN_ON() as found at
http://www.kerneloops.org/search.php?search=set_irq_wake

This patch makes the conditions for triggering the _wake enable/disable
sequence identical.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/serial_core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2022,6 +2022,8 @@ int uart_suspend_port(struct uart_driver
 int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 {
 	struct uart_state *state = drv->state + port->line;
+	struct device *tty_dev;
+	struct uart_match match = {port, drv};
 
 	mutex_lock(&state->mutex);
 
@@ -2031,7 +2033,8 @@ int uart_resume_port(struct uart_driver 
 		return 0;
 	}
 
-	if (!port->suspended) {
+	tty_dev = device_find_child(port->dev, &match, serial_match_port);
+	if (!port->suspended && device_may_wakeup(tty_dev)) {
 		disable_irq_wake(port->irq);
 		mutex_unlock(&state->mutex);
 		return 0;

-- 
