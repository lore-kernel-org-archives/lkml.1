Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbZEMSFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbZEMSFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZEMSFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:05:31 -0400
Received: from plexity.net ([206.123.115.38]:54101 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZEMSFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:05:30 -0400
Date: Wed, 13 May 2009 18:04:36 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
	is disabled
Message-ID: <20090513180436.GA5592@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20090512210015.GA25540@plexity.net> <alpine.LFD.2.01.0905121452190.3343@localhost.localdomain> <20090513011842.22d9cd6c@lxorguk.ukuu.org.uk> <20090513002850.GA28422@plexity.net> <20090513094409.50c2409f@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0905130755090.3343@localhost.localdomain> <20090513163507.556c3832@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20090513163507.556c3832@lxorguk.ukuu.org.uk>
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On May 13 2009, at 16:35, Alan Cox was caught saying:
> Deepak's original patch from 2008 is actually much better. He puts the
> chip back in the right hardware configuration for the speed. He doesn't
> randomly regress other platforms and configurations and he does it by
> calling the standard methods in the driver to do the job.
> 
> http://dev.laptop.org/~dsaxena/patches/console_suspend_old.patch
> 
> It also has another advantage - it fixes the behaviour for almost
> everything in drivers/serial not just a specific uart. Technically he
> should take tty->termios_mutex before state->mutex in that code path as
> the upstream code has changed but in every other respect its the proper
> solution.

I thought the fact that we were touching a core driver to fix what
seemed like an XO issue was too intrusive.

> So can we apply Deepak's original correct 2008 patch instead please ?

I've updated it with proper header and attached.

~Deepak


--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="restore_console_settings_on_suspend.patch"

Set proper console speed on resume if console suspend is disabled
    
Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC
XO laptop. Basically what happens is that upon returning from resume,
serial8250_resume_port() will reconfigure the port for high speed
mode and all console output will be garbled, making debug of the
resume path painful. This patch modifies uart_resume_port() to
reset the port to the state it was in before we suspended.
    
Original patch by Marcelo Tosatti
    
Signed-off-by: Deepak Saxena <dsaxena@laptop.org>

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index b0bb29d..3b71038 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2052,11 +2052,26 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 	struct uart_state *state = drv->state + port->line;
 	struct device *tty_dev;
 	struct uart_match match = {port, drv};
+	struct ktermios termios;
 
 	mutex_lock(&state->mutex);
 
+	/*
+	 * First try to use the console cflag setting.
+	 */
+	memset(&termios, 0, sizeof(struct ktermios));
+	termios.c_cflag = port->cons->cflag;
+
+	/*
+	 * If that's unset, use the tty termios setting.
+	 */
+	if (termios.c_cflag == 0)
+		termios = *state->info.port.tty->termios;
+
+
 	if (!console_suspend_enabled && uart_console(port)) {
 		/* no need to resume serial console, it wasn't suspended */
+		port->ops->set_termios(port, &termios, NULL);
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
@@ -2073,20 +2088,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 	 * Re-enable the console device after suspending.
 	 */
 	if (uart_console(port)) {
-		struct ktermios termios;
-
-		/*
-		 * First try to use the console cflag setting.
-		 */
-		memset(&termios, 0, sizeof(struct ktermios));
-		termios.c_cflag = port->cons->cflag;
-
-		/*
-		 * If that's unset, use the tty termios setting.
-		 */
-		if (state->info.port.tty && termios.c_cflag == 0)
-			termios = *state->info.port.tty->termios;
-
 		uart_change_pm(state, 0);
 		port->ops->set_termios(port, &termios, NULL);
 		console_start(port->cons);

--y0ulUmNC+osPPQO6--
