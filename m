Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945Ab0A2OeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0A2OeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909Ab0A2OeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:34:22 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48928 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab0A2OeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:34:21 -0500
Subject: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 29 Jan 2010 14:34:15 +0000
Message-Id: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2010 14:34:15.0996 (UTC) FILETIME=[2234C7C0:01CAA0F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

I've been trying for some time to use a rootfs (ext2) on a USB memory
stick on ARM platforms but without any success. The USB HCD driver is
ISP1760 which doesn't use DMA.

ARM has a Harvard cache architecture and what I get is incoherency
between the I and D caches. The CPU I'm using (ARM11MPCore) has PIPT
caches with D-cache lines allocation on write.

Basically, when user space tries to execute from a new page, it faults
and the data is requested via the VFS layer, SCSI block device and USB
mass storage from the ISP1760 driver. The page is then mapped into user
space and update_mmu_cache() called.

However, since the driver is PIO, the data copied from the USB device
into RAM gets stuck in the D-cache. On the above page requesting path
there is no call to flush_dcache_page() to handle D-cache maintenance
(for DMA drivers, that's handled by the DMA API).

Since the USB mass storage code has the information about the USB driver
capabilities (DMA or PIO), it looks like the best place to call
flush_dcache_page(). But I got lost in the SCSI emulation and all my
attempts failed to get a working rootfs.

Adding flush_dcache_page() higher up in mpage_end_io_read() solves the
problem but that's not the correct fix as it has wider implications and
it's not needed for DMA-capable devices.

Thanks.

-- 
Catalin

