Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZKTIRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZKTIRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZKTIRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:17:37 -0500
Received: from ns.tdt.de ([195.243.126.82]:58582 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbZKTIRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:17:35 -0500
X-Greylist: delayed 84807 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 03:17:32 EST
Message-ID: <4FB83C4383FA4C3BAE8DE2BD5D960C6C@mschille2>
From: "Martin Schiller" <mschiller@tdt.de>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] hso: memory leak in hso_free_net_device()
Date: Thu, 19 Nov 2009 09:44:10 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a memory leak in the hso_free_net_device() function.
The structure hso_net will be freed by free_netdev(). So, the rx/tx urbs
and buffers must be freed before free_netdev() is called.

Signed-off-by: Martin Schiller <mschiller@tdt.de>
---
kmemleak still finds 1 remaining leak, but I can't find it.
Maybe someone else has an idea for this:

unreferenced object 0xce461130 (size 32):
  comm "khubd", pid 1105, jiffies 17464
  backtrace:
    [<c10745b6>] create_object+0xe6/0x210
    [<c10747d7>] kmemleak_alloc+0x27/0x60
    [<c1071b0d>] kmem_cache_alloc+0xcd/0x120
    [<d0ba29a7>] hso_create_net_device+0x207/0x420 [hso]
    [<d0ba30c7>] hso_probe+0x417/0x690 [hso]
    [<d0998103>] usb_probe_interface+0x83/0x170 [usbcore]
    [<c113f9e2>] driver_probe_device+0x62/0x140
    [<c113fb81>] __device_attach+0x41/0x50
    [<c113f098>] bus_for_each_drv+0x48/0x70
    [<c113fc2d>] device_attach+0x6d/0x80
    [<c113eeed>] bus_probe_device+0x1d/0x40
    [<c113da66>] device_add+0x436/0x4f0
    [<d0997654>] usb_set_configuration+0x424/0x5c0 [usbcore]
    [<d099e68e>] generic_probe+0x2e/0xa0 [usbcore]
    [<d09979cf>] usb_probe_device+0x1f/0x30 [usbcore]
    [<c113f9e2>] driver_probe_device+0x62/0x140

--- linux-2.6.32-rc7-git3/drivers/net/usb/hso.c.orig 2009-11-19 09:04:29.000000000 +0100
+++ linux-2.6.32-rc7-git3/drivers/net/usb/hso.c 2009-11-19 09:08:17.000000000 +0100
@@ -2423,7 +2423,6 @@ static void hso_free_net_device(struct h
 
  if (hso_net->net) {
   unregister_netdev(hso_net->net);
-  free_netdev(hso_net->net);
  }
 
  /* start freeing */
@@ -2436,6 +2435,10 @@ static void hso_free_net_device(struct h
  kfree(hso_net->mux_bulk_tx_buf);
  hso_net->mux_bulk_tx_buf = NULL;
 
+ if (hso_net->net) {
+  free_netdev(hso_net->net);
+ }
+
  kfree(hso_dev);
 }
 


