Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbYKGOW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbYKGOW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYKGOWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:22:46 -0500
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:52111 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbYKGOWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:22:46 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: ensure correct logging in do_io_probe [v2]
Cc: linux@dominikbrodowski.net, dbrownell@users.sourceforge.net,
       linux-pcmcia@lists.infradead.org
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Fri, 7 Nov 2008 15:22:42 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811071522.43618.elendil@planet.nl>
X-OriginalArrivalTime: 07 Nov 2008 14:22:44.0038 (UTC) FILETIME=[4CB45E60:01C940E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added parens around the conditions. Maybe not strictly needed,
but better readable and consistent with similar usage in cs.c.

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
CC: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/rsrc_nonstatic.c 
b/drivers/pcmcia/rsrc_nonstatic.c
index 17f4ecf..2a6a3d1 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -200,14 +200,17 @@ static void do_io_probe(struct pcmcia_socket *s, 
unsigned int base,
     int any;
     u_char *b, hole, most;
 
-    dev_printk(KERN_INFO, &s->dev, "cs: IO port probe %#x-%#x:",
-	       base, base+num-1);
+    dev_printk(KERN_INFO,
+	       (s->state & SOCKET_PRESENT) ? &s->dev : &s->cb_dev->dev,
+	       "cs: IO port probe %#x-%#x:", base, base+num-1);
 
     /* First, what does a floating port look like? */
     b = kzalloc(256, GFP_KERNEL);
     if (!b) {
-	    dev_printk(KERN_ERR, &s->dev,
-		   "do_io_probe: unable to kmalloc 256 bytes");
+	    printk("\n");
+	    dev_printk(KERN_ERR,
+		   (s->state & SOCKET_PRESENT) ? &s->dev : &s->cb_dev->dev,
+		   "cs: do_io_probe: unable to kmalloc 256 bytes");
             return;
     }
     for (i = base, most = 0; i < base+num; i += 8) {
