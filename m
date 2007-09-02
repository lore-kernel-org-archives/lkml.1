Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXIBTyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXIBTyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIBTyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:54:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37256 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXIBTyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:54:24 -0400
Date: Mon, 3 Sep 2007 01:37:31 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Thomas Winischhofer <thomas@winischhofer.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH -mm] sisusbvga: Fix bug and build warnings
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1616065580-1188763655=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1616065580-1188763655=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/usb/misc/sisusbvga/sisusb.c: In function ‘usb_sisusb_init’:
drivers/usb/misc/sisusbvga/sisusb.c:3321: warning: unused variable ‘sisusb’
drivers/usb/misc/sisusbvga/sisusb.c:3320: warning: unused variable ‘retval’

are trivially solved by getting rid of the unused variables.

drivers/usb/misc/sisusbvga/sisusb.c: In function ‘sisusb_open’:
drivers/usb/misc/sisusbvga/sisusb.c:2444: warning: ‘sisusb’ is used uninitialized in this function

is a genuine bug (which will cause oops). We cannot use "sisusb" in
error path for (!interface), because sisusb will itself be derived
from "interface" later.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/usb/misc/sisusbvga/sisusb.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- linux-2.6.23-rc4-mm1/drivers/usb/misc/sisusbvga/sisusb.c~fix	2007-09-02 19:06:01.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/usb/misc/sisusbvga/sisusb.c	2007-09-02 19:10:52.000000000 +0530
@@ -2440,10 +2440,8 @@ sisusb_open(struct inode *inode, struct 
 	struct usb_interface *interface;
 	int subminor = iminor(inode);
 
-	if (!(interface = usb_find_interface(&sisusb_driver, subminor))) {
-		dev_err(&sisusb->sisusb_dev->dev, "Failed to find interface\n");
+	if (!(interface = usb_find_interface(&sisusb_driver, subminor)))
 		return -ENODEV;
-	}
 
 	if (!(sisusb = usb_get_intfdata(interface)))
 		return -ENODEV;
@@ -3317,9 +3315,6 @@ static struct usb_driver sisusb_driver =
 
 static int __init usb_sisusb_init(void)
 {
-	int retval;
-	struct sisusb_usb_data *sisusb;
-
 #ifdef INCL_SISUSB_CON
 	sisusb_init_concode();
 #endif
--464262402-1616065580-1188763655=:29617--
