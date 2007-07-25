Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXGYIkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXGYIkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbXGYIkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:40:04 -0400
Received: from mail.beamnet.de ([87.106.41.124]:58682 "EHLO server2.beamnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbXGYIkD (ORCPT <rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 25 Jul 2007 04:40:03 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 04:40:03 EDT
Subject: [PATCH] usb-serial: fix oti6858.c segfault in termios handling
MIME-Version: 1.0
Message-Id: <12789.1185351681.852842@server2.beamnet.de>
Date: Wed, 25 Jul 2007 10:21:21 +0200
From: Thomas Viehmann <tv@beamnet.de>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-usb-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The oti6858 usb serial driver should use 
kernel_termios_to_user_termios/
user_termios_to_kernel_termios to avoid segfaults because the kernel
uses a structure differing from that of user space with a different 
size.

Signed-off-by: Thomas Viehmann <tv@beamnet.de>
---
I'm don't know the least thing about the type casting (it is lifted
from kobil_sct.c), but I do get better success with the patch...
--- linux-2.6.23-rc1/drivers/usb/serial/oti6858.c.orig
+++ linux-2.6.23-rc1/drivers/usb/serial/oti6858.c
@@ -818,19 +818,22 @@

        switch (cmd) {
                case TCGETS:
-                       if (copy_to_user(user_arg, port->tty->termios,
-                                               sizeof(struct 
ktermios))) {
+                       if (kernel_termios_to_user_termios(
+                                            (struct ktermios __user 
*)arg,
+                                            port->tty->termios))
                                return -EFAULT;
-                       }
                        return 0;

                case TCSETS:
                case TCSETSW:                  case TCSETSF:   -      
                  if (copy_from_user(port->tty->termios, user_arg,
-                                               sizeof(struct 
ktermios))) {
+                       if 
(user_termios_to_kernel_termios(port->tty->termios,
+                                               (struct ktermios 
__user *)arg))
                                return -EFAULT;
-                       }
                        oti6858_set_termios(port, NULL);
                        return 0;

--
Thomas Viehmann, http://thomas.viehmann.net/
