Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYJ3PyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYJ3PyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYJ3PyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:54:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50408 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752460AbYJ3PyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:54:14 -0400
Date: Thu, 30 Oct 2008 15:54:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 i/o error on /dev/ttyUSB0
Message-ID: <20081030155412.33d57ca0@lxorguk.ukuu.org.uk>
In-Reply-To: <490856FA.20609@aitel.hist.no>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	<4906F54A.7020909@aitel.hist.no>
	<alpine.LFD.2.00.0810280928320.3386@nehalem.linux-foundation.org>
	<20081028170605.611c7759@lxorguk.ukuu.org.uk>
	<490856FA.20609@aitel.hist.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 13:28:42 +0100
Helge Hafting <helge.hafting@aitel.hist.no> wrote:

> Alan Cox wrote:
> >> squarely in the "oops, kref's are screwed up" corner, and you should talk 
> >> to Alan about your particular USB dongle. I bet that bisection would just 
> >> show you one of the kref commits (eg 4a90f09b "tty: usb-serial krefs" or 
> >> maybe 7d7b93c14 "tty: kref the tty driver object"). 

Please try:

tty: Fix USB kref leak

From: Alan Cox <alan@redhat.com>

When we close we must clear the extra reference we got when we read
port->tty. Setting the port tty NULL will clear the kref held by the driver
but not the one we obtained ourselves while doing the lookup.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/usb-serial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 8be3f39..794b5ff 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -281,6 +281,7 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
 			if (tty->driver_data)
 				tty->driver_data = NULL;
 			tty_port_tty_set(&port->port, NULL);
+			tty_kref_put(tty);
 		}
 	}
 
