Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXCBUGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXCBUGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965248AbXCBUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:06:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22039 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbXCBUGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:06:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=miEd8RlqX2VWS8LzB8EftbtzNXhKDMzmfiMFtI4s6wYX3F3EDZW05/PsKbOVqNLeMcsxGW4zfjPy27eZAmuBQsRUQID7VPOUQFeJljGkGGrGGUFxS8tb1GZ5IifXcYAnbjOPgZR4TcnGeJY6J98ZLO1rhonvHlK5hVqghjB6wYA=
Message-ID: <57354eff0703021206u182678d8p8f49528a58a9b1c9@mail.gmail.com>
Date: Fri, 2 Mar 2007 21:06:00 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RTS/CTS handshaking for embedded devices
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use arm-linux platform to program some peripheral where pecular
serial flow control is required:

- There is no flow control for the arm-linux device -> control unit
- For the control unix -> arm-linux device
 * RTS must be kept low, the device keeps CTS low as well.
 * when the device wants to send data, it raises CTS. RTS must
   be raised as well. Data can then pass, CTS and RTS are lowered.

Actually it's pretty simillar to the problem, described here:
http://groups.google.de/group/linux.kernel/browse_thread/thread/b5a059bfba931188/1d8cfeef17431180?lnk=gst&q=crtscts&rnum=5&hl=ru#1d8cfeef17431180
and I suppose, here:
http://groups.google.de/group/linux.kernel/browse_thread/thread/9479f1a2336e6aaa/b2d0cccb7cdb1f2a?lnk=gst&q=crtscts&rnum=2&hl=ru#b2d0cccb7cdb1f2a

It looked for me obvios that the solution is to switch off the flow
control (CRTSCTS) and to assert/deassert RTS via
ioctl. But I have found, that:
 * even if flow control is switched off, serial_core.c asserts RTS
during opening the serial device.
 * there is no possibility (at least I didn't find it) to preconfigure
serial interface in the user space before opening
  serial device (looks logically), but there is a time gap between
opening the serial device and configuring it, there
  control device "thinks" that arm is ready to get data (RTS is
asserted), but the configuration parameters are
  potentially wrong.

So the first question is, is there any provided by kernel way to solve
the described above task?

If not, maybe it would be more correct just to don't touch RTS, if
flow control is switched off, like here:

Index: drivers/serial/serial_core.c
===================================================================
--- a/drivers/serial/serial_core.c  (mode:100644)
+++ b/drivers/serial/serial_core.c  (mode:100644)
@@ -212,7 +212,7 @@
        * is open and ready to respond.
        */
       if (info->tty->termios->c_cflag & CBAUD)
-               info->mctrl |= TIOCM_RTS | TIOCM_DTR;
+               info->mctrl |= TIOCM_DTR | (info->flags &
ASYNC_CTS_FLOW ? 0 : TIOCM_RTS );
       info->ops->set_mctrl(info->port, info->mctrl);

       info->flags |= ASYNC_INITIALIZED;
@@ -1001,8 +1001,8 @@
       /* Handle transition away from B0 status */
       if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
               info->mctrl |= TIOCM_DTR;
-               if (!(cflag & CRTSCTS) ||
-                   !test_bit(TTY_THROTTLED, &tty->flags))
+               if (/*!(cflag & CRTSCTS) ||*/
+                   !test_bit(TTY_THROTTLED, &tty->flags))
                       info->mctrl |= TIOCM_RTS;
               info->ops->set_mctrl(info->port, info->mctrl);
       }
@@ -1301,7 +1301,7 @@
               spin_lock_irqsave(&info->lock, flags);
               if (!(info->flags & ASYNC_CALLOUT_ACTIVE) &&
                   (tty->termios->c_cflag & CBAUD)) {
-                       info->mctrl |= TIOCM_DTR | TIOCM_RTS;
+                       info->mctrl |= TIOCM_DTR | (info->flags &
ASYNC_CTS_FLOW ? 0 : TIOCM_RTS );
                       info->ops->set_mctrl(info->port, info->mctrl);
               }
               spin_unlock_irqrestore(&info->lock, flags);

---
Oleksiy
