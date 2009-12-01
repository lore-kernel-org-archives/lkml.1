Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZLAPuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZLAPuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZLAPuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:50:39 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51652 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752107AbZLAPui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:50:38 -0500
Date: Tue, 1 Dec 2009 15:52:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: divide by zero in termios when setting bluetooth
Message-ID: <20091201155244.0523d9c9@lxorguk.ukuu.org.uk>
In-Reply-To: <20091201151315.GC2262@elf.ucw.cz>
References: <20091201151315.GC2262@elf.ucw.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 16:13:16 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> I triggered this by mistake... "W" taint is from the  WARN_ON()
> before.

This ought to fix it

serial: Fix crash if the minimum rate of the device is > 9600 baud

From: Alan Cox <alan@linux.intel.com>

In that situation if the old rate is invalid and the new rate is invalid
and the chip cannot do 9600 baud we report zero, which makes all the
drivers explode.

Instead force the rate based on min/max

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/serial_core.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 047530b..bd7ec4b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -385,13 +385,20 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		}
 
 		/*
-		 * As a last resort, if the quotient is zero,
-		 * default to 9600 bps
+		 * As a last resort, if the range cannot be met then clip to
+		 * the nearest chip supported rate.
 		 */
-		if (!hung_up)
-			tty_termios_encode_baud_rate(termios, 9600, 9600);
+		if (!hung_up) {
+			if (baud <= min)                
+				tty_termios_encode_baud_rate(termios,
+							min + 1, min + 1);
+			else
+				tty_termios_encode_baud_rate(termios,
+							max - 1, max - 1);
+		}
 	}
-
+	/* Should never happen */
+	WARN_ON(1);
 	return 0;
 }
 
