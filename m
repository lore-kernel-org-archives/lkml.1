Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZDPTIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZDPTIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZDPTIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:08:42 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56583 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbZDPTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.40,200,1238976000"; 
   d="scan'208";a="287557460"
Date: Thu, 16 Apr 2009 12:08:37 -0700
From: VomLehn <dvomlehn@cisco.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: [PATCH] Wait for console to become available, v2
Message-ID: <20090416190837.GA26734@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parallelization to improve boot times has been successful enough that race
conditions now exist between the init_post() open of /dev/console and
initialization of the console device. When this occurs, opening /dev/console
fails and any applications inherited for init have no standard in/out/err
devices. This is expected behavior if no console device is available, but
quite unfortunate in the case where the console is just a bit slow waking up.

Some buses, such as USB, offer no guarantees about how long it takes to
discover devices, so there is no reliable way to distinguish between a missing
console and a slow one.  The pragmatic approach taken in this patch is to
wait for a while to see if a console shows up, and just go on if it doesn't.
The default delay interval is set to 500 msec (0.5 seconds) based on a sample
size of one device (cp2101) but is a tunable. If the console shows up sooner,
we will continue immediately.

History
v2	Wait for the preferred console rather than any console. Make the
	delay interval a tunable.
v1	Initial version

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 init/Kconfig    |   10 ++++++++++
 kernel/printk.c |   11 +++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 7be4d38..5d5b0fa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -835,6 +835,16 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PRINTK_CONSOLE_WAIT
+	int "Number of milliseconds to wait for console device"
+	default 500
+	help
+	  Some systems use console devices, such as USB serial devices, which
+	  may not be present or which may take an unspecified amount of time
+	  to be initialized. This setting determines the maximum number of
+	  milliseconds the system will wait for a console to be registered.
+	  Slow devices may require this value be increased.
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..3a05c8a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -105,6 +105,9 @@ static unsigned log_start;	/* Index into log_buf: next char to be read by syslog
 static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
 static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
+/* Wait queue controlling the wait for a console device */
+static DECLARE_WAIT_QUEUE_HEAD(console_wait);
+
 /*
  *	Array of consoles built from command line options (console=)
  */
@@ -1081,6 +1084,13 @@ struct tty_driver *console_device(int *index)
 	struct console *c;
 	struct tty_driver *driver = NULL;
 
+	/* Wait a while for a console to show up. If one doesn't show up
+	 * for too long, we'll just continue without a console. */
+	if (wait_event_timeout(console_wait, preferred_console >= 0,
+		CONFIG_PRINTK_CONSOLE_WAIT) == 0)
+		pr_warning("No preferred console after waiting %u msec; "
+			"continuing anyway\n", CONFIG_PRINTK_CONSOLE_WAIT);
+
 	acquire_console_sem();
 	for (c = console_drivers; c != NULL; c = c->next) {
 		if (!c->device)
@@ -1230,6 +1240,7 @@ void register_console(struct console *console)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+	wake_up_all(&console_wait);
 }
 EXPORT_SYMBOL(register_console);
 
