Return-Path: <linux-kernel-owner+w=401wt.eu-S1763036AbXHCOJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763036AbXHCOJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762249AbXHCOJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:09:26 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14234 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762099AbXHCOJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:09:24 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Yinghai.Lu@sun.com
Subject: Re: REGRESSION: serial_cs broken by 8250 changes
Date: Fri, 3 Aug 2007 16:07:43 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
References: <200708030106.33917.daniel.ritz-ml@swissonline.ch> <20070802163547.39f41af1.akpm@linux-foundation.org> <46B27442.7010706@sun.com>
In-Reply-To: <46B27442.7010706@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031607.44276.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007 02:18:10 Yinghai Lu wrote:
> Andrew Morton wrote:
> > On Thu, 02 Aug 2007 16:24:42 -0700
> > Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > 
> >> Daniel Ritz wrote:
> >>> commit 18a8bd949d6adb311ea816125ff65050df1f3f6e breaks serial_cs badly
> >>> with an oops, completely killing PCMCIA.
> >>>
> >>> register_console() now calls console->early_setup(). which in case of
> >>> 8250.c (the only user anyway) is serial8250_console_early_setup()
> >>> which is __init, calling 8250_early.c:serial8250_find_port_for_earlycon()
> >>> which is __init as well. boom.
> >>>
> >>> the changelog mentions SERIAL_PORT_DFNS removal which happens to be
> >>> commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26. but this got reverted
> >>> by commit 57d4810ea0d9ca58a7bcc1336607f0cede0a2abf. so i'd suggest to
> >>> just revert the 8250 changes as well.
> >>>
> >>> rgds
> >>> -daniel
> >> Is there any flag or sign that init code has been released?
> > 
> > Nope.
> > 
> >> We could use that to prevent init code to be called after code is freed.
> > 
> > If we can omit a function call without breaking anything then we shouldn't
> > have been calling that function at all ;)
> > 
> > It sounds like making serial8250_console_early_setup() and
> > serial8250_find_port_for_earlycon() non-__init will fix this.
> > 
> 
> yes, together update_console_cmdline in kernel/printk.c
> 
> Daniel,
> can you test that in your setup?
> 

yep, seems to work. patch attached.

rgds
-daniel

----------

[PATCH] serial: fix 8250 early console setup

the early setup function serial8250_console_early_setup() can be called
from non __init code (eg. hotpluggable serial ports like serial_cs) so
remove the __init from the call chain to avoid crashes.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 2f5a5ac..3013130 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2514,7 +2514,7 @@ static int __init serial8250_console_setup(struct console *co, char *options)
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
-static int __init serial8250_console_early_setup(void)
+static int serial8250_console_early_setup(void)
 {
 	return serial8250_find_port_for_earlycon();
 }
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index 150cad5..4d4c9f0 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -227,7 +227,7 @@ int __init setup_early_serial8250_console(char *cmdline)
 	return 0;
 }
 
-int __init serial8250_find_port_for_earlycon(void)
+int serial8250_find_port_for_earlycon(void)
 {
 	struct early_serial8250_device *device = &early_device;
 	struct uart_port *port = &device->port;
diff --git a/kernel/printk.c b/kernel/printk.c
index 051d27e..bd2cd06 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -732,7 +732,7 @@ int __init add_preferred_console(char *name, int idx, char *options)
 	return 0;
 }
 
-int __init update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
+int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
 {
 	struct console_cmdline *c;
 	int i;


