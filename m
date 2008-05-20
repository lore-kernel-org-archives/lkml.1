Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbYETKv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbYETKv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbYETKvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:51:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:14151 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762739AbYETKvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Wn4nYfbx5Xc3vaKYVo0SDhYsWkDKxEyOI15M3umW5ZUgHw9WcIJEi8VwR7EiMriekGc/tiI+xSHzRFIII5GXzMAlsh/F2PMdGaZe0mbR9uKfXkcXc8fZb4gjZAoSdIPfqRD0hoOKNnf+HzjyrrqmEK1cgIsdng/+dL/+y7cDeFs=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       hjk@linutronix.de, gregkh@suse.de, linux-sh@vger.kernel.org
Date: Tue, 20 May 2008 19:51:32 +0900
Message-Id: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se>
Subject: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches implement a reusable UIO platform driver. This driver
can be used to export hardware to user space, as long as the device
is a) memory mapped and b) equipped with an unique IRQ.

The uio_platform driver gets all information through platform data,
including address window information and IRQ number. The driver also
supports assigning a contiguous piece of memory to each instance.
This may be useful when the exported hardware blocks can bus master
but requires physically contiguous memory.

There are not many surprises in the code if you are familiar with UIO,
except for the interrupt handling. All UIO kernel drivers that I've
seen so far have hardware specific interrupt acknowledge code in the
interrupt handler. The uio_platform driver is different.

The interrupt handling code in uio_platform assumes the device is the
only user of the assigned interrupt. This may be rare in the PC world
but for SuperH almost all interrupt sources are unique. Having an
unique interrupt for the device allows the code to use disable_irq()
and enable_irq() in kernel space and leave actual interrupt acknowledge
to user space. That way we have no hardware specific code in the kernel.

Interrupts are of course serviced in kernel space by the uio_platform
driver, but the uio_platform interrupt handler will simply disable the
IRQ until next read() or poll() syscall. The uio_platform kernel driver
assumes that the user space driver has taken care of acknowledging
the interrupt before doing read() and waiting for events again. If no
acknowledge has happened then an interrupt will occur again (since it's
still pending) and the kernel interrupt handler will disable the IRQ
again and unblock the user space process.

The last patch contains SuperH specific code that exports various
multimedia acceleration blocks to userspace. The following processors
and hardware blocks are exported for now:

sh7343: VPU
sh7722: VPU, VEU
sh7723: VPU, VEU, VEU

If anyone is interested then I have a proof of concept vidix driver
for mplayer that is interfacing using UIO to the VEU on a sh7722 to
provide accelerated color space conversion and stretching.

[PATCH 01/03] uio: Add enable_irq() callback
[PATCH 02/03] uio: Add uio_platform driver
[PATCH 03/03] sh: Export sh7343/sh7722/sh7723 VPU/VEU blocks

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |   32 ++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |   63 ++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |   94 ++++++++++++++++++
 drivers/uio/Kconfig                    |   10 +
 drivers/uio/Makefile                   |    1 
 drivers/uio/uio.c                      |    6 +
 drivers/uio/uio_platform.c             |  161 ++++++++++++++++++++++++++++++++
 include/linux/uio_driver.h             |    1 
 include/linux/uio_platform.h           |   10 +
 9 files changed, 378 insertions(+)
