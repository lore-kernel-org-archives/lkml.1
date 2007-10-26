Return-Path: <linux-kernel-owner+w=401wt.eu-S1763526AbXJZDhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbXJZDhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXJZDhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:37:36 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:42837 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbXJZDhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:37:35 -0400
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 23:37:34 EDT
Date: Fri, 26 Oct 2007 12:12:36 +0900 (JST)
Message-Id: <20071026.121236.96687354.nemoto@toshiba-tops.co.jp>
To: rmk+lkml@arm.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial: do not call ->pm() on initialization for
 console port
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20071025213644.GA30141@flint.arm.linux.org.uk>
References: <20071026.010510.59032545.anemo@mba.ocn.ne.jp>
	<20071025134044.58ca9d35.akpm@linux-foundation.org>
	<20071025213644.GA30141@flint.arm.linux.org.uk>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 13:40:44 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Now rc1 is released.  Any chances for this patch?
> > If none, I should push other workaround to fix this issue on 2.6.24.
> 
> I don't know what patch you're referring to.  I don't appear to have
> whatever-patch-this-is queued up anywhere?

Here is an original patch I proposed (http://lkml.org/lkml/2007/10/18/292)

------------------------------------------------------
Subject: serial: do not call ->pm() on initialization for console port
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

If the port was already enabled as a serial console, there is no need
to call pm callback to power it up.  This patch fixes serial console
initialization on serial_txx9 driver.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 68aa4da..5a38076 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2326,7 +2326,6 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	}
 
 	state->port = port;
-	state->pm_state = -1;
 
 	port->cons = drv->cons;
 	port->info = state->info;
@@ -2336,6 +2335,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	 * initialised.
 	 */
 	if (!(uart_console(port) && (port->cons->flags & CON_ENABLED))) {
+		state->pm_state = -1;
 		spin_lock_init(&port->lock);
 		lockdep_set_class(&port->lock, &port_lock_key);
 	}

On Thu, 25 Oct 2007 22:36:44 +0100, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> "Further investigation" is quite a good indication that a patch needs to
> be worked on, no?  In any case, I'm ill at the moment, so things are very
> much on hold.

OK, then I'd like to propose this alternative
(http://lkml.org/lkml/2007/10/18/301).  This should be work regardless
of the patch above.

------------------------------------------------------
Subject: serial: Fix serial_txx9 console initialization
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Now serial_core calls ->pm() on initialization even if the port was
used for console.  This behaviour breaks serial_txx9 console since The
serial_txx9 driver initialize its port entirely on its ->pm() method
if new state was 0.  This patch adds checking for oldstate value to
fix this probelm.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 6846a6c..7ad2192 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -657,7 +657,15 @@ static void
 serial_txx9_pm(struct uart_port *port, unsigned int state,
 	      unsigned int oldstate)
 {
-	if (state == 0)
+	/*
+	 * If oldstate was -1 this is called from
+	 * uart_configure_port().  In this case do not initialize the
+	 * port now, because the port was already initialized (for
+	 * non-console port) or should not be initialized here (for
+	 * console port).  If we initialized the port here we lose
+	 * serial console settings.
+	 */
+	if (state == 0 && oldstate != -1)
 		serial_txx9_initialize(port);
 }


