Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZIAQ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZIAQ1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZIAQ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:27:54 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:37626 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZIAQ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:27:53 -0400
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
X-Mailer: MH [version 6.8]
Organization: Home, Grenoble, France
Date: Tue, 01 Sep 2009 18:27:46 +0200
Message-ID: <6661.1251822466@nice.ram.loc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I have switched to 2.6.x two years ago, I've been experiencing weird
IDE lockups that I did not have when I was running 2.4.x, on the exact same
hardware.

What happens is that when I launch a SMART long test on /dev/hda, I get the
following messages on the netconsole:

hda: lost interrupt
hda: ide_dma_sff_timer_expiry: DMA status (0x61)
hda: DMA timeout error

followed by a hard lockup.

I've added traces to understand what is happening, but I find them weird,
and my lack of IDE expertise shows.  Here's the netconsole ooutput from
the initial "lost interrupt" incident to the lockup:

-- entering ide_timer_expiry() --
hda: in ide_timer_expiry, expiry = 0x00000000
hda: drive->waiting_for_dma = 0
hda: hwif->ack_intr = 0x00000000
hda: hwif->handler = 0xc022fb08 <task_no_data_intr>
hda: request queue is not empty
--- entering drive_is_ready() ---
hda: reading alt status
hda: drive_is_ready: stat = -/ATA_DRDY/-/-/-
--- leaving drive_is_ready() ---
hda: lost interrupt
--- entering task_no_data_intr() ---
hda: entering task_no_data_intr
hda: task_no_data_intr: stat = -/ATA_DRDY/-/-/-
--- leaving task_no_data_intr() ---
hda: startstop = "stopped"
hda: exiting from ide_timer_expiry, plug_device=1
-- leaving ide_timer_expiry() --

<a few secs later>

-- entering ide_timer_expiry() --
hda: in ide_timer_expiry, expiry = 0xc0233a94 <ide_dma_sff_timer_expiry>
hda: drive->waiting_for_dma = 1
hda: hwif->ack_intr = 0x00000000
hda: hwif->handler = 0xc023392c <ide_dma_intr>
hda: request queue is not empty
--- entering ide_timer_expiry() --
hda: ide_dma_sff_timer_expiry: DMA status (0x61)
--- leaving ide_timer_expiry() --
hda: will be waiting (3000)
-- leaving ide_timer_expiry() --

<3 secs later>

-- entering ide_timer_expiry() --
hda: in ide_timer_expiry, expiry = 0x00000000
hda: drive->waiting_for_dma = 1
hda: hwif->ack_intr = 0x00000000
hda: hwif->handler = 0xc023392c <ide_dma_intr>
hda: request queue is not empty
--- entering drive_is_ready() ---
hda: drive waiting for DMA
--- leaving drive_is_ready() ---
--- entering ide_dma_timeout_retry() ---
hda: entering ide_dma_timeout_retry
hda: hwif->handler = 0x00000000
hda: hwif->expiry = 0x00000000
hda: DMA timeout error
hda: ended DMA
hda: unmapped command
hda: reading status with "hwif->tp_ops->read_status(hwif)"

[hard lockup, ALT-SysRq is not responding]

Here is what I find weird: initially, when ide_timer_expiry() is called,
the drive is not waiting for a DMA, and indeed task_no_data_intr() is
called.  Processing there leads to the call of ide_plug_device(), which
enqueues a request.  But this time, this is a DMA request?  So that's not
the request  that caused the initial "lost interrupt" condition?

The whole "rescue" chain highlighted above leads to a hang when the
kernel tries to read the status register from the IDE interface.

I'm looking for some hints as to what is happening here, how to further
diagnose the problem, and find a possible workaround.  Currently, I cannot
schedule weekly SMART long tests on my drives since this locks the machine
up, but I've recently lost a RAID array because of corruption of some
sectors that had been silently developping for too long...

Can someone please suggest some course of action?

Thanks,
Raphael
