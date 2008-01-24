Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYAXMnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYAXMnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYAXMmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:42:11 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50486 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753306AbYAXMmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:42:02 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH -mm v4 0/9] atmel_serial cleanups and improvements
Date: Thu, 24 Jan 2008 13:41:42 +0100
Message-Id: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset cleans up the atmel_serial driver a bit,
moves a significant portion of the interrupt handler into a tasklet,
and adds DMA support. This is the result of a combined effort by Chip
Coldwell, Remy Bohmer and me. The patches should apply cleanly onto
Linus' latest git tree, and I've also tested it on -mm (with a couple
of avr32 fixes applied to make the rest of the tree compile.)

With DMA, I see transfer rates around 92 kbps when transferring a big
file using ZModem (both directions are roughly the same.) I've also
tested the same thing with a bunch of debug options enabled. The
transfer rate is slightly lower, but no errors are reported.

Note that break and error handling doesn't work too well with DMA
enabled. This is a common problem with all the efforts I've seen
adding DMA support to this driver (including my own). The PDC error
handling also accesses icount without locking. I'm tempted to just
ignore the problem for now and hopefully come up with a solution
later.

I think this stuff is ready for -mm now, but I'd like to see a couple
more ACKs from Andrew Victor and other people who may be familiar with
this driver and/or the serial/tty layer in general.

Changes since v3:
  * Added myself to MAINTAINERS
  * Additional cleanups suggested by Andrew Victor
  * Made PDC support configurable through Kconfig
  * Converted lots of potentially unsafe casts to use container_of()
  * Show tty name (not just "atmel_serial") in /proc/interrupts

Chip Coldwell (1):
      atmel_serial: Add DMA support

Haavard Skinnemoen (6):
      MAINTAINERS: Add myself as maintainer of the atmel_serial driver
      atmel_serial: Use cpu_relax() when busy-waiting
      atmel_serial: Use existing console options only if BRG is running
      atmel_serial: Fix bugs in probe() error path and remove()
      atmel_serial: Use container_of instead of direct cast
      atmel_serial: Show tty name in /proc/interrupts

Remy Bohmer (2):
      atmel_serial: Clean up the code
      atmel_serial: Split the interrupt handler

 MAINTAINERS                   |    6 +
 drivers/serial/Kconfig        |   15 +
 drivers/serial/atmel_serial.c |  888 +++++++++++++++++++++++++++++++++--------
 3 files changed, 740 insertions(+), 169 deletions(-)
