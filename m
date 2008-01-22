Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbYAVOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbYAVOxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYAVOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:53:32 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61376 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276AbYAVOxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:53:31 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v3 0/6] atmel_serial: Cleanups, irq handler splitup & DMA
Date: Tue, 22 Jan 2008 15:50:38 +0100
Message-Id: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset cleans up the atmel_serial driver a bit,
moves a significant portion of the interrupt handler into a tasklet,
and adds DMA support. This is the result of a combined effort by Chip
Coldwell, Remy Bohmer and me. The patches should apply cleanly onto
Linus' latest git tree.

With DMA, I see transfer rates around 92 kbps when transferring a big
file using ZModem (both directions are roughly the same.)

Note that break and error handling doesn't work too well with DMA
enabled. This is a common problem with all the efforts I've seen
adding DMA support to this driver (including my own). The PDC error
handling also accesses icount without locking. I'm tempted to just
ignore the problem for now and hopefully come up with a solution
later.

The following changes have been made since v2 of this patchset:
  * Drop the lock before calling tty_flip_buffer_push()
  * Revert the UART_{PUT,GET} macro cleanups since Andrew didn't seem
    to like them.

Everyone, please give it a try and/or review the code.

Chip Coldwell (1):
      atmel_serial: Add DMA support

Haavard Skinnemoen (3):
      atmel_serial: Use cpu_relax() when busy-waiting
      atmel_serial: Use existing console options only if BRG is running
      atmel_serial: Fix bugs in probe() error path and remove()

Remy Bohmer (2):
      atmel_serial: Clean up the code
      atmel_serial: Split the interrupt handler

 drivers/serial/atmel_serial.c |  897 +++++++++++++++++++++++++++++++++--------
 1 files changed, 722 insertions(+), 175 deletions(-)
