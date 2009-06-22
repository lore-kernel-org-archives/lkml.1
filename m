Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZFVH11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZFVH11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZFVH1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:27:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50930
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbZFVH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:27:18 -0400
Date: Mon, 22 Jun 2009 00:27:22 -0700 (PDT)
Message-Id: <20090622.002722.53993293.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: sparclinux@vger.kernel.org
Subject: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If some expert in this area can help I'd appreciate it.
And I'll note immediately that the issue I'm looking into
I've only investigated thoroughly with 2.6.29 vanilla.

In 2.6.29 we added an NMI watchdog timer to sparc64, it
operates identically to how the x86 one works except that
it's on by default :-)

When the qla2xxx driver is built into the kernel statically,
the firmware load causes an NMI watchdog timeout.

The qla2xxx driver is fine, it only actually disables interrupts for
very short periods to program the chip registers, telling it to load a
few blocks of the firmware via DMA or similar.

Then it waits for the interrupt to signal the firmware partial-load is
done using wait_for_completion_timeout() (see qla2x00_mailbox_command
in drivers/scsi/qla2xx/qla_mbx.c)

Assuming NOHZ is enabled, what if qla2xxx driver init is the only
running task on a cpu, no timers (at least for 5 seconds, the NMI
timeout) are due to fire, and the qla2xxx code loops in this manner
for more than 5 seconds loading the firmware?

As far as I can see it, the NOHZ code has no reason to start the timer
firing again in this situation.

So we'll just loop continuously into the scheduler (to wait for
the qla2xxx driver completion).  I believe the events trigger quick
enough that need_resched() is not true if the scheduler even makes
it to the idle thread.

So the sequence seems to be scheduling in and out of a pure kernel
thread, with no pending non-scheduler timers for a long time, and all
this happening for longer than the NMI watchdog timeout, with NOHZ
enabled.

I'll note that adding printk's (this is a serial console) to the
qla2xxx mailbox command code makes the NMI watchdog problem go away :)
But if I only put printk's around the entire firmware loading
sequence, the NMI watchdog does trigger.

Is there something fundamental that should be preventing this?
