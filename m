Return-Path: <linux-kernel-owner+w=401wt.eu-S1765310AbXH0V1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765310AbXH0V1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764384AbXH0V1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58787 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759844AbXH0V1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:12 -0400
Date: Mon, 27 Aug 2007 23:27:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] remove parport_device_num()
Message-ID: <20070827212711.GJ4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
> +sysctl-parport-remove-binary-paths.patch
>...
>  More sysctl work
>...

parport_device_num() is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/parport-lowlevel.txt |   29 +++--------------------------
 drivers/parport/daisy.c            |   29 -----------------------------
 include/linux/parport.h            |    1 -
 3 files changed, 3 insertions(+), 56 deletions(-)

0066510df2b5d4972cfd6a4450af8b82c763adfd 
diff --git a/Documentation/parport-lowlevel.txt b/Documentation/parport-lowlevel.txt
index 8f23024..265fcdc 100644
--- a/Documentation/parport-lowlevel.txt
+++ b/Documentation/parport-lowlevel.txt
@@ -25,7 +25,6 @@ Global functions:
   parport_open
   parport_close
   parport_device_id
-  parport_device_num
   parport_device_coords
   parport_find_class
   parport_find_device
@@ -735,7 +734,7 @@ NULL is returned.
 
 SEE ALSO
 
-parport_register_device, parport_device_num
+parport_register_device
 
 parport_close - unregister device for particular device number
 -------------
@@ -787,29 +786,7 @@ Many devices have ill-formed IEEE 1284 Device IDs.
 
 SEE ALSO
 
-parport_find_class, parport_find_device, parport_device_num
-
-parport_device_num - convert device coordinates to device number
-------------------
-
-SYNOPSIS
-
-#include <linux/parport.h>
-
-int parport_device_num (int parport, int mux, int daisy);
-
-DESCRIPTION
-
-Convert between device coordinates (port, multiplexor, daisy chain
-address) and device number (zero-based).
-
-RETURN VALUE
-
-Device number, or -1 if no device at given coordinates.
-
-SEE ALSO
-
-parport_device_coords, parport_open, parport_device_id
+parport_find_class, parport_find_device
 
 parport_device_coords - convert device number to device coordinates
 ------------------
@@ -833,7 +810,7 @@ Zero on success, in which case the coordinates are (*parport, *mux,
 
 SEE ALSO
 
-parport_device_num, parport_open, parport_device_id
+parport_open, parport_device_id
 
 parport_find_class - find a device by its class
 ------------------
diff --git a/drivers/parport/daisy.c b/drivers/parport/daisy.c
index ff9f344..5bbff20 100644
--- a/drivers/parport/daisy.c
+++ b/drivers/parport/daisy.c
@@ -275,35 +275,6 @@ void parport_close(struct pardevice *dev)
 	parport_unregister_device(dev);
 }
 
-/**
- *	parport_device_num - convert device coordinates
- *	@parport: parallel port number
- *	@mux: multiplexor port number (-1 for no multiplexor)
- *	@daisy: daisy chain address (-1 for no daisy chain address)
- *
- *	This tries to locate a device on the given parallel port,
- *	multiplexor port and daisy chain address, and returns its
- *	device number or %-ENXIO if no device with those coordinates
- *	exists.
- **/
-
-int parport_device_num(int parport, int mux, int daisy)
-{
-	int res = -ENXIO;
-	struct daisydev *dev;
-
-	spin_lock(&topology_lock);
-	dev = topology;
-	while (dev && dev->port->portnum != parport &&
-	       dev->port->muxport != mux && dev->daisy != daisy)
-		dev = dev->next;
-	if (dev)
-		res = dev->devnum;
-	spin_unlock(&topology_lock);
-
-	return res;
-}
-
 /* Send a daisy-chain-style CPP command packet. */
 static int cpp_daisy(struct parport *port, int cmd)
 {
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 9cdd694..ec3f765 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -510,7 +510,6 @@ extern struct pardevice *parport_open (int devnum, const char *name,
 				       int flags, void *handle);
 extern void parport_close (struct pardevice *dev);
 extern ssize_t parport_device_id (int devnum, char *buffer, size_t len);
-extern int parport_device_num (int parport, int mux, int daisy);
 extern void parport_daisy_deselect_all (struct parport *port);
 extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 

