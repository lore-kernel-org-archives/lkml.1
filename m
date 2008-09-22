Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYIVO63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYIVO63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYIVO6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:58:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39970 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752524AbYIVO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:58:22 -0400
Date: Mon, 22 Sep 2008 15:58:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: Fix broken abuse of dev->driver_data
Message-ID: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

PCMCIA abuses dev->private_data in the probe methods. Unfortunately it
continues to abuse it after calling drv->probe() which leads to crashes and
other nasties (such as bogus probes of multifunction devices) giving errors like

pcmcia: registering new device pcmcia0.1
kernel: 0.1: GetNextTuple: No more items

Extract the passed data before calling the driver probe function that way
we don't blow up when the driver reuses dev->private_data as its right.

As its close to the final release just move the hack so it works out,
hopefully someone will be sufficiently embarrassed to produce a nice rework
for 2.6.28.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/pcmcia/ds.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)


diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 4174d96..853d342 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -426,6 +426,18 @@ static int pcmcia_device_probe(struct device * dev)
 	p_dev = to_pcmcia_dev(dev);
 	p_drv = to_pcmcia_drv(dev->driver);
 	s = p_dev->socket;
+	
+	/* The PCMCIA code passes the match data in via dev->driver_data
+	 * which is an ugly hack. Once the driver probe is called it may
+	 * and often will overwrite the match data so we must save it first 
+	 *
+	 * handle pseudo multifunction devices:
+	 * there are at most two pseudo multifunction devices.
+	 * if we're matching against the first, schedule a
+	 * call which will then check whether there are two
+	 * pseudo devices, and if not, add the second one.
+	 */
+	did = p_dev->dev.driver_data;
 
 	ds_dbg(1, "trying to bind %s to %s\n", p_dev->dev.bus_id,
 	       p_drv->drv.name);
@@ -455,21 +467,14 @@ static int pcmcia_device_probe(struct device * dev)
 		goto put_module;
 	}
 
-	/* handle pseudo multifunction devices:
-	 * there are at most two pseudo multifunction devices.
-	 * if we're matching against the first, schedule a
-	 * call which will then check whether there are two
-	 * pseudo devices, and if not, add the second one.
-	 */
-	did = p_dev->dev.driver_data;
 	if (did && (did->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO) &&
 	    (p_dev->socket->device_count == 1) && (p_dev->device_no ==
0)) pcmcia_add_device_later(p_dev->socket, 0);
 
- put_module:
+put_module:
 	if (ret)
 		module_put(p_drv->owner);
- put_dev:
+put_dev:
 	if (ret)
 		put_device(dev);
 	return (ret);
--
<meme>discombobulated echidna</meme>
