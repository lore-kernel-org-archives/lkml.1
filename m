Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0CIG3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:29:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:33622 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0CIG33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:29:29 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] usb console improvements series
Date: Tue,  9 Mar 2010 00:29:05 -0600
Message-Id: <1268116151-1448-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 09 Mar 2010 06:29:19.0372 (UTC) FILETIME=[D9608CC0:01CABF51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I aggregated and ported all usb patches I have previously posted which
are not mainlined into a single series aimed at providing a stable usb
console.

This is picking up where Alan Stern and I left after a discussion in
September 2009.

-- The recap about synchronous usb serial consoles --

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
required slightly more than 2ms in the worst case else there was some
sporadic data loss.

I also tested incurring the penalty 3ms for each write with the device
in a "failed" capacity.  In that case it introduced a 3ms delay for
each printk() which only showed any noticeable delay with the "SysRq t"
packet.

Part of having the console stable requires that usb sysrq handler get
executed in a tasklet.  The hcd device lock is always held while the
driver call backs are executed.  The means you cannot get the sysrq
printk's out to the usb console device after the in_flight urb queue
is filled.

Thanks,
Jason.

---

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh

Jason Wessel (6):
      tty_port,usb-console: Fix usb serial console open/close regression
      usb-serial: Use tty_port version of console instead of the usb_serial_port version
      usb-console: pass baud from console to the initial tty open
      usb-serial: optimize sysrq function calls
      usb-hcd,usb-console: poll hcd device to force usb console writes
      usb-serialy,sysrq: Run the sysrq handler in a tasklet

 drivers/char/sysrq.c            |   29 ++++++++++++++++
 drivers/char/tty_port.c         |    2 +-
 drivers/usb/core/hcd.c          |   11 ++++++
 drivers/usb/core/hcd.h          |    1 +
 drivers/usb/serial/console.c    |   71 ++++++++++++++++++++++----------------
 drivers/usb/serial/ftdi_sio.c   |    9 +++--
 drivers/usb/serial/generic.c    |   28 +---------------
 drivers/usb/serial/pl2303.c     |    8 +++--
 drivers/usb/serial/usb-serial.c |    4 +-
 drivers/usb/serial/usb_debug.c  |    2 +-
 include/linux/sysrq.h           |    4 ++
 include/linux/tty.h             |    1 +
 include/linux/usb/serial.h      |   36 ++++++++++++++++----
 13 files changed, 131 insertions(+), 75 deletions(-)

