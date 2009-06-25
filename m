Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZFYIwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZFYIwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFYIwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:52:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZFYIwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:52:05 -0400
Date: Thu, 25 Jun 2009 17:52:05 +0900 (JST)
Message-Id: <20090625.175205.339801709528649087.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] using value instead of symbol in modinfo string
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In modinfo documentation of scsi_transport_fc and sisusbvga modules, 
C MACRO symbols are embedded:

    $ modinfo scsi_transport_fc
    filename:       .../scsi_transport_fc.ko
    license:        GPL
    description:    FC Transport Attributes
    author:         James Smart
    srcversion:     7E754DB0E6EFF6A04CE1D21
    depends:        scsi_tgt
    vermagic:       2.6.29.4-167.fc11.x86_64 SMP mod_unload 
    parm:           dev_loss_tmo:Maximum number of seconds that the FC transport 
		    should insulate the loss of a remote port. Once this value is 
		    exceeded, the scsi target is removed. Value should be between 
		    1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT. (uint)
--------------------------^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    $ modinfo sisusbvga
    filename:       .../sisusbvga.ko
    license:        GPL
    description:    sisusbvga - Driver for Net2280/SiS315-based USB2VGA dongles
    author:         Thomas Winischhofer <thomas@winischhofer.net>
    srcversion:     788D4F88C46D2C2E4454388
    alias:          usb:v182Dp0269d*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v182Dp021Cd*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v0711p0918d*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v0711p0903d*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v0711p0902d*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v0711p0901d*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v0711p0900d*dc*dsc*dp*ic*isc*ip*
    alias:          usb:v0711p0550d*dc*dsc*dp*ic*isc*ip*
    depends:        
    vermagic:       2.6.29.4-167.fc11.x86_64 SMP mod_unload 
    parm:           first:Number of first console to take over (1 - MAX_NR_CONSOLES) (int)
--------------------------------------------------------------------^^^^^^^^^^^^^^^
    parm:           last:Number of last console to take over (1 - MAX_NR_CONSOLES) (int)
------------------------------------------------------------------^^^^^^^^^^^^^^^


For reading source code the macro symbols are useful, but for setting a value to one of
the module parameters, user may want to know actual values bining to the symbols.

Following patch replaces the symbols in parm descriptions to actual values.


Signed-off-by: Masatake YAMATO <yamato@redhat.com>

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3f64d93..1a4b6eb 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -461,6 +461,8 @@ static DECLARE_TRANSPORT_CLASS(fc_vport_class,
 /*
  * Module Parameters
  */
+#define SYMBOLSTR(X) #X
+#define VALUESTR(X)  SYMBOLSTR(X)
 
 /*
  * dev_loss_tmo: the default number of seconds that the FC transport
@@ -474,7 +476,7 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 "Maximum number of seconds that the FC transport should"
 		 " insulate the loss of a remote port. Once this value is"
 		 " exceeded, the scsi target is removed. Value should be"
-		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
+		 " between 1 and " VALUESTR(SCSI_DEVICE_BLOCK_MAX_TIMEOUT) ".");
 
 /*
  * Netlink Infrastructure
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index b4ec716..a6ca059 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -62,12 +62,15 @@
 /* Forward declarations / clean-up routines */
 
 #ifdef INCL_SISUSB_CON
+#define SYMBOLSTR(X) #X
+#define VALUESTR(X)  SYMBOLSTR(X)
+
 static int sisusb_first_vc = 0;
 static int sisusb_last_vc = 0;
 module_param_named(first, sisusb_first_vc, int, 0);
 module_param_named(last, sisusb_last_vc, int, 0);
-MODULE_PARM_DESC(first, "Number of first console to take over (1 - MAX_NR_CONSOLES)");
-MODULE_PARM_DESC(last, "Number of last console to take over (1 - MAX_NR_CONSOLES)");
+MODULE_PARM_DESC(first, "Number of first console to take over (1 - " VALUESTR(MAX_NR_CONSOLES) ")");
+MODULE_PARM_DESC(last, "Number of last console to take over (1 - " VALUESTR(MAX_NR_CONSOLES) ")");
 #endif
 
 static struct usb_driver sisusb_driver;
