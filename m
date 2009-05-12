Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbZELWda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbZELWda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZELWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:32:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:57579 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZELWcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:32:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, oliver@neukum.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] usb hcd console polling and sysrq tasklet
Date: Tue, 12 May 2009 17:32:18 -0500
Message-Id: <1242167540-23585-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.9.g6345d
X-OriginalArrivalTime: 12 May 2009 22:32:23.0502 (UTC) FILETIME=[85104EE0:01C9D351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a version 2 of the patch set to the original usb_debug patches
which contained a polling loop to forcibly poll the usb hcd device.

The original patch made use of the polling regardless whether it was
the tty driver path or the console path, which was not desired.

The serial uart code implements the console writes synchronously such
that you get the data right away and "pay the toll" in terms of system
performance loss if you do lots of printk's to the console.  The usb
serial console code just eats the data if there is no room left in the
queue, and you do not see the data until the interrupts are restored.

If we assume the main reason you would use a usb console device is to
get printk's then every effort should be made to be able to see the
printk's on the usb console device.  In this patch series, two
conditions must be met before the hcd device would get polled.

1) The data write is a usb serial console write
2) The usb serial driver has set the variable max_in_flight_urbs

Based on Alan's comments about the 1ms minimum response time for the
hcd device I ended up using a maximum 3ms delay loop.  The 3ms was
selected based on testing the usb_debug device and the ftdi usb rs232
port.  I found the usb_debug device needed the 1ms and the ftdi device
required slightly more than 2ms else there was some sporadic data
loss.  Perhaps we can decide if this approach is any more or less
reasonable...

I also tested incurring the penalty 3ms for each write with the device
in a "failed" capacity.  In that case it introduced a 3ms delay for
each printk() which only showed any noticible delay with the "SysRq t"
packet.

The second patch in the series changes the sysrq handler to execute in
a tasklet.  I found that the hcd device lock was always held while the
driver call backs were executed, and that poses a problem that you
cannot get the sysrq printk's out to the usb console device after the
in_flight urb queue is filled.

Using these patches on top of the 4 that Greg K-H already accepted I
found that the usb serial console worked for a number of debug
circumstances where it does not work at all today, including reporting
an oops after conole init and prior to the execution of the init
process.

Thanks,
Jason.


The short log and git info is below, which is against the 2.6.30
development tree + the 4 accepted patches


git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh_2


Jason Wessel (2):
      usb hcd: poll hcd device to force writes
      usb_serial: Run the sysrq handler in a tasklet

 drivers/usb/core/hcd.c         |   15 +++++++++++++
 drivers/usb/core/hcd.h         |    1 +
 drivers/usb/serial/console.c   |   44 ++++++++++++++++++++++++++-------------
 drivers/usb/serial/ftdi_sio.c  |    7 +++--
 drivers/usb/serial/generic.c   |   33 +++++++++++++++++++++++++++++-
 drivers/usb/serial/usb_debug.c |    2 +-
 6 files changed, 82 insertions(+), 20 deletions(-)

