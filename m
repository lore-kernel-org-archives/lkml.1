Return-Path: <linux-kernel-owner+w=401wt.eu-S965175AbXCFQa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175AbXCFQa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXCFQa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:30:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:50362 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175AbXCFQa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pn4/FNdqTENi516/L7PbPp0JJQqC8+/NpFlPEQTO4ivFoTdMqgVgDxm0GNiFpVplNS/7kHIk5gjQNofFjlUguAXzQGmwmTuRELnLSOooMKimwfZ3jCWoI6U9wsCGpNBGjxYNmGBncJb3ejc6LoFaiSSG9NbcZrnT4+DO1sN96RI=
Message-ID: <57354eff0703060830j9e42a32hf405cac9c3274618@mail.gmail.com>
Date: Tue, 6 Mar 2007 17:30:22 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: "Maxim Komar" <komar@evologics.de>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: [PATCH -mm] serial: suppress RTS assertion with disabled CRTSCTS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch leaves RTS alone when CRTSCTS is not set.

Current behaviour doesn't give any possibility to
1. preconfigure port setting, because open operation implies
RTS assertion and initial serial port setting may be wrong.
2. realize peculiar serial flow control required by some hardware
especially in embedded devices.

Signed-off-by: Oleksiy Kebkal <lesha@evologics.de>

---


diff -puN a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c      2007-03-06 17:17:50.000000000 +0100
+++ b/drivers/serial/serial_core.c      2007-03-06 17:14:28.000000000 +0100
@@ -185,11 +185,15 @@ static int uart_startup(struct uart_stat
                        uart_change_speed(state, NULL);

                        /*
-                        * Setup the RTS and DTR signals once the
-                        * port is open and ready to respond.
+                        * Setup the RTS (in the case of hardware flow control)
+                        * and DTR signals once the port is open and ready to
+                        * respond.
                         */
-                       if (info->tty->termios->c_cflag & CBAUD)
-                               uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
+                       if (info->tty->termios->c_cflag & CBAUD) {
+                               uart_set_mctrl(port, TIOCM_DTR);
+                               if (info->flags & UIF_CTS_FLOW)
+                                       uart_set_mctrl(port, TIOCM_RTS);
+                       }
                }

                if (info->flags & UIF_CTS_FLOW) {
@@ -230,10 +234,14 @@ static void uart_shutdown(struct uart_st
                info->flags &= ~UIF_INITIALIZED;

                /*
-                * Turn off DTR and RTS early.
+                * Turn off DTR and RTS (in the case of hardware flow control)
+                * early.
                 */
-               if (!info->tty || (info->tty->termios->c_cflag & HUPCL))
-                       uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+               if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
+                       uart_clear_mctrl(port, TIOCM_DTR);
+                       if (info->flags & UIF_CTS_FLOW)
+                               uart_clear_mctrl(port, TIOCM_RTS);
+               }

                /*
                 * clear delta_msr_wait queue to avoid mem leaks: we may free
@@ -1164,14 +1172,16 @@ static void uart_set_termios(struct tty_
        uart_change_speed(state, old_termios);

        /* Handle transition to B0 status */
-       if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
-               uart_clear_mctrl(state->port, TIOCM_RTS | TIOCM_DTR);
+       if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD)) {
+               uart_clear_mctrl(state->port, TIOCM_DTR);
+                if (state->info->flags & UIF_CTS_FLOW)
+                       uart_clear_mctrl(state->port, TIOCM_RTS);
+       }

        /* Handle transition away from B0 status */
        if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
                unsigned int mask = TIOCM_DTR;
-               if (!(cflag & CRTSCTS) ||
-                   !test_bit(TTY_THROTTLED, &tty->flags))
+               if (!test_bit(TTY_THROTTLED, &tty->flags))
                        mask |= TIOCM_RTS;
                uart_set_mctrl(state->port, mask);
        }
@@ -1415,10 +1425,14 @@ static void uart_update_termios(struct u
                uart_change_speed(state, NULL);

                /*
-                * And finally enable the RTS and DTR signals.
+                * And finally enable the RTS (in the of case hardware flow
+                * control) and DTR signals.
                 */
-               if (tty->termios->c_cflag & CBAUD)
-                       uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+               if (tty->termios->c_cflag & CBAUD) {
+                       uart_set_mctrl(port, TIOCM_DTR);
+                       if (state->info->flags & UIF_CTS_FLOW)
+                               uart_set_mctrl(port, TIOCM_RTS);
+               }
        }
 }

_
