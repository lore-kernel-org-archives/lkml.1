Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYFUWpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYFUWpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYFUWp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:45:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:54777 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750941AbYFUWp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:45:27 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/n2p0EM8nnMg+m2qONNE2AZYDcBQdTgxJ19lrKO8
	78x8C+3zu0eFhX
Date: Sun, 22 Jun 2008 00:45:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: vcgandhi1@aol.com, linux-kernel@vger.kernel.org
cc: linux-serial@vger.kernel.org
Subject: [PATCH] Fix serial_match_port() for dynamic major tty-device numbers
In-Reply-To: <8CA914AC0F6817C-1684-368@webmail-nc03.sysops.aol.com>
Message-ID: <Pine.LNX.4.64.0806220037250.461@axis700.grange>
References: <8CA6D5E4DEA920C-1128-2973@webmail-nb07.sysops.aol.com>
 <Pine.LNX.4.64.0804160046460.6851@axis700.grange>
 <8CA6D67D9E313CC-1128-35BB@webmail-nb07.sysops.aol.com>
 <8CA6D6D112DB4D4-1128-38B0@webmail-nb07.sysops.aol.com>
 <Pine.LNX.4.64.0804170103040.7335@axis700.grange>
 <8CA6E48B50204C0-15A8-47D0@webmail-nb06.sysops.aol.com>
 <Pine.LNX.4.64.0804171657320.6716@axis700.grange>
 <8CA6EC102F70775-15A8-8B4A@webmail-nb06.sysops.aol.com>
 <Pine.LNX.4.64.0804171915180.6716@axis700.grange>
 <8CA6EF5BC26E069-12A0-1888@webmail-nc13.sysops.aol.com>
 <Pine.LNX.4.64.0804181700300.5725@axis700.grange>
 <8CA6FF4B03B281A-E10-2E1C@webmail-nf05.sim.aol.com>
 <Pine.LNX.4.64.0804231108170.5160@axis700.grange>
 <8CA73B83C791846-148-41B9@webmail-nb17.sysops.aol.com>
 <Pine.LNX.4.64.0804241557340.5283@axis700.grange>
 <8CA914AC0F6817C-1684-368@webmail-nc03.sysops.aol.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Vipul Gandhi, the current serial_match_port() doesn't work 
for tty-devices using dynamic major number allocation. Fix it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Vipul Gandhi <vcgandhi1@aol.com>

---

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0f5a179..593ae85 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1949,7 +1949,9 @@ struct uart_match {
 static int serial_match_port(struct device *dev, void *data)
 {
 	struct uart_match *match = data;
-	dev_t devt = MKDEV(match->driver->major, match->driver->minor) + match->port->line;
+	struct tty_driver *tty_drv = match->driver->tty_driver;
+	dev_t devt = MKDEV(tty_drv->major, tty_drv->minor_start) +
+		match->port->line;
 
 	return dev->devt == devt; /* Actually, only one tty per port */
 }
