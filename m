Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXDOKsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXDOKsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXDOKsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:48:52 -0400
Received: from dhuumrelay2.dtm.ops.eu.uu.net ([194.139.33.76]:43480 "EHLO
	dfallbackip2.mail.eu.uu.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068AbXDOKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:48:51 -0400
X-Greylist: delayed 929 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 06:48:51 EDT
X-Authenticated-As: win1683552@knuut.de at dhuumrelay2.dtm.ops.eu.uu.net 
From: Ulrich Eckhardt <doomster@knuut.de>
To: linux-kernel@vger.kernel.org
Subject: [patch] use C99 initialisers for PCI_VDEVICE()
Date: Sun, 15 Apr 2007 12:34:36 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151234.37463.doomster@knuut.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Note: CC me please, I'm not subscribed.)

Not much to say about the patch (it's against 2.6.20.6), it just converts a 
macro to generate C99-style initialisers.

--- include/linux/pci.h   (revision 17)
+++ include/linux/pci.h   (working copy)
@@ -407,9 +407,10 @@
  * private data.
  */
 
-#define PCI_VDEVICE(vendor, device)            \
-       PCI_VENDOR_ID_##vendor, (device),       \
-       PCI_ANY_ID, PCI_ANY_ID, 0, 0
+#define PCI_VDEVICE(vend, dev)         \
+       .vendor=PCI_VENDOR_ID_##vend, .device=(dev),    \
+       .subvendor=PCI_ANY_ID, .subdevice=PCI_ANY_ID,   \
+       .class=0, .class_mask=0


However, I still have two issues with this:
1. It explicitly allows in the comments for PCI_VDEVICE to have non-C99 fields 
follow for the driver_data field. IMHO this is wrong per se (just as 
old-style initialisers are), so the comment should perhaps be removed.
2. What happens to fields not initialised with this? I believe that these are 
initialised with zero, just like missing fields in old initialisers are, 
right? In that case, I would remove the initialisers for class and 
class_mask, so that people can at least optionally use them. However, this 
goes hand in hand with issue #1 because it would definitely break code that 
lets old-style initialisers follow.

As far as issue #2 is concerned, I did some checking (grep -r PCI_VDEVICE) and 
the only places where this is at all used is in the ATA code (drivers/ata)! 
Hmmm, no problem, that is grunt work but easily patched, too. If consensus 
exists that the class/class_mask fields should be removed, I hereby volunteer 
to submit a patch for that and the ATA code.

Uli
