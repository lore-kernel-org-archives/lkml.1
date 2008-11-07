Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYKGNTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYKGNTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYKGNTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:19:17 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:33962 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbYKGNTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:19:16 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: ensure correct logging in do_io_probe
Date: Fri, 7 Nov 2008 14:19:10 +0100
User-Agent: KMail/1.9.9
Cc: linux@dominikbrodowski.net, dbrownell@users.sourceforge.net,
       linux-pcmcia@lists.infradead.org
References: <200811031942.20360.elendil@planet.nl>
In-reply-To: <200811031942.20360.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071419.11050.elendil@planet.nl>
X-OriginalArrivalTime: 07 Nov 2008 13:19:14.0035 (UTC) FILETIME=[6DC40C30:01C940DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Toshiba Satellite (i386):
> yenta_cardbus 0000:01:0b.0: ISA IRQ mask 0x0c38, PCI irq 18
> yenta_cardbus 0000:01:0b.0: Socket status: 30000020
> yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
> : cs: IO port probe 0xc000-0xcfff: clean. 
> ^^--- missing device ID
> 
> Note that a bit later the device ID _is_ present in the same message:
> yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0xcfe00000 - 0xcfefffff
> yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
> pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
> pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.

The following patch fixes this issue and also fixes another minor error.

The patch prefixes "yenta_cardbus 0000:01:0b.0" for the first IO probe and
leaves the later ones unchanged.
Alternative would be to just unconditionally use &s->cb_dev->dev.

It might be good to clean up the seemingly inconsistent use in the messages
of "pcmcia: ", "pccard: " and "cs: " at some point. (Or even just just remove
them altogether as they are now redundant?)

Cheers,
FJP

---
From: Frans Pop <elendil@planet.nl>

pcmcia: ensure correct logging in do_io_probe
    
During early probing of the parent PCI bridge I/O window no socket
has been allocated yet.
In that case print &s->cb_dev->dev instead of &s->dev as device.
    
Also properly close previous dev_printk if kzalloc fails.

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 17f4ecf..2a6a3d1 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -200,14 +200,17 @@ static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
     int any;
     u_char *b, hole, most;
 
-    dev_printk(KERN_INFO, &s->dev, "cs: IO port probe %#x-%#x:",
-	       base, base+num-1);
+    dev_printk(KERN_INFO,
+	       s->state & SOCKET_PRESENT ? &s->dev : &s->cb_dev->dev,
+	       "cs: IO port probe %#x-%#x:", base, base+num-1);
 
     /* First, what does a floating port look like? */
     b = kzalloc(256, GFP_KERNEL);
     if (!b) {
-	    dev_printk(KERN_ERR, &s->dev,
-		   "do_io_probe: unable to kmalloc 256 bytes");
+	    printk("\n");
+	    dev_printk(KERN_ERR,
+		   s->state & SOCKET_PRESENT ? &s->dev : &s->cb_dev->dev,
+		   "cs: do_io_probe: unable to kmalloc 256 bytes");
             return;
     }
     for (i = base, most = 0; i < base+num; i += 8) {
