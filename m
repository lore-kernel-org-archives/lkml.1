Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZGBWaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZGBWaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZGBWaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:30:11 -0400
Received: from ru.mvista.com ([213.79.90.228]:29066 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbZGBWaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:30:10 -0400
Date: Fri, 3 Jul 2009 02:30:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] 8250: Now honours baud rate lower bounds
Message-ID: <20090702223013.GA26960@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090702213624.GA23193@oksana.dev.rtsoft.ru>
 <20090702225312.02f78ec4@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090702225312.02f78ec4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A platform clock drives 8250 ports in most SOC systems, the clock
might run at high frequencies, and so it's not always possible to
downscale uart clock to a desired value.

Currently the 8250 uart driver accepts not supported baud rates, and
what is worse, it is doing this silently, and then passes not accepted
values to a new termios, so userspace has no chance to catch this kind
of errors (userspace verifies that settings were accepted by reading
back and comparing the settings).

This patch fixes the issue by passing minimum baud rate to the
uart_get_baud_rate() call, the call should take care of all bounds,
so userspace should now report:

  # stty -F /dev/ttyS0 speed 300
  115200
  stty: /dev/ttyS0: unable to perform all requested operations

p.s. uart_get_baud_rate() falls back to 9600, which still might be too
     low for some 10 GHz platforms, but that's a separate issue, and
     we can wait with fixing this till we find such a platform.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Thu, Jul 02, 2009 at 10:53:12PM +0100, Alan Cox wrote:
> On Fri, 3 Jul 2009 01:36:24 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > A platform clock drives 8250 ports in most SOC systems, the clock
> > might run at high frequencies, and so it's not always possible to
> > downscale uart clock to a desired value.
> 
> > This patch fixes the issue by passing minimum baud rate to the
> > uart_get_baud_rate() call, the call should take care of all bounds,
> > so userspace should now report:
> 
> We ought to be able to deduce the minimum baud rate from the divisor
> being bigger than the chip supports - or do some of these devices not
> support the full hw divisor range of the real chip which is what I assume
> from your patch ?

No, HW supports full hw divisor range, but uart clk is 533 MHz,
and 533 MHz / 16 / 0xffff = 508 bauds. But currently the driver
calculates divisor without min value, and 300 bauds ends up with
0x1b2071 div value which doesn't fit into 16 bits, and so we're
getting bogus baud rate and garbage on the console, and no single
message that something went wrong.

> > +static unsigned int _serial_dl_max(struct uart_8250_port *up)
> > +{
> > +	return 0xffff;
> > +}
> > +
> 
> We have far too many magic ifdef routines for this sort of stuff already.
> Is there any reason we can't put info on the true divisor or at least the
> baud rate range into the uart_8250_port structure so that we get rid of
> all of 

Heh. I just found specs for Au1100, and it appears they use 32
bit registers, but the divisor itself is still 0xffff (other bits
are reserved). So I don't think we need any special cases, at least
for now.

How about this patch down below?

Thanks.

 drivers/serial/8250.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index fb867a9..7720816 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2272,7 +2272,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	/*
 	 * Ask the core to calculate the divisor for us.
 	 */
-	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
+	baud = uart_get_baud_rate(port, termios, old,
+				  port->uartclk / 16 / 0xffff,
+				  port->uartclk / 16);
 	quot = serial8250_get_divisor(port, baud);
 
 	/*
-- 
1.6.3.3

