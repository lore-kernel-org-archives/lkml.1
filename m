Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZDNX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZDNX2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 19:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZDNX2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 19:28:37 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:55717 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZDNX2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 19:28:36 -0400
X-IronPort-AV: E=Sophos;i="4.40,188,1238976000"; 
   d="scan'208";a="153310227"
Date: Tue, 14 Apr 2009 16:28:36 -0700
From: VomLehn <dvomlehn@cisco.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Embedded Mailing List <linux-embedded@vger.kernel.org>
Subject: [PATCH] Wait for console to become available
Message-ID: <20090414232835.GA20307@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-2; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work to improve boot times appears to be successful enough that a race
condition has been created between the open of /dev/console in init_post
and USB serial device initialization. Embedded systems are probably the
primary users of USB serial devices, though I can certainly image blade
servers using them, as well.

This patch works for me and, though it's possible this is all that needs
to be done, I think it's likely there are some other changes required,
as well.

Signed-off-by: David VomLehn <dvomlehn@cisco>
---
 kernel/printk.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index e3602d0..39f554a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -104,6 +104,10 @@ static unsigned log_start;	/* Index into log_buf: next char to be read by syslog
 static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
+/* Definitions for waiting until a console is registered */
+#define MAX_CONSOLE_WAIT	msecs_to_jiffies(2000)
+static DECLARE_WAIT_QUEUE_HEAD(console_wait);
+
 /*
  *	Array of consoles built from command line options (console=)
  */
@@ -1062,6 +1066,10 @@ struct tty_driver *console_device(int *index)
 	struct console *c;
 	struct tty_driver *driver = NULL;
 
+	/* Wait a while for a console to show up. If one doesn't show up
+	 * for too long, we'll just continue without a console. */
+	wait_event_timeout(console_wait, console_drivers, MAX_CONSOLE_WAIT);
+
 	acquire_console_sem();
 	for (c = console_drivers; c != NULL; c = c->next) {
 		if (!c->device)
@@ -1211,6 +1219,7 @@ void register_console(struct console *console)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+	wake_up_all(&console_wait);
 }
 EXPORT_SYMBOL(register_console);
 
