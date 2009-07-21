Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZGUPxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZGUPxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZGUPxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:53:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38773 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753469AbZGUPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:53:36 -0400
Date: Tue, 21 Jul 2009 11:53:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Daniel Mack <daniel@caiaq.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
In-Reply-To: <20090721004531.1036d9af@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0907211141180.2652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Alan Cox wrote:

> > Depends on how you define the time of removal. The user space connection
> > stays open after the device was removed. 
> 
> If that is occuring then the bug is elsewhere. The hang up sequence
> reconnects the user space to the hung up tty ops and no longer references
> the hardware.

I got something similar with a pl2303 device, though not a crash.  I 
plugged in the device, opened /dev/ttyUSB0, unplugged the device, then 
tried to read from the open file descriptor.  The read provoked this:

[  961.902428] WARNING: at kernel/lockdep.c:2621 __lock_acquire+0x395/0xaf5()
[  961.902523] Hardware name:         
[  961.902608] Modules linked in: pl2303 usbserial sd_mod sg usb_storage scsi_mod evdev pcspkr e100 mii ohci_hcd uhci_hcd ehci_hcd floppy processor button thermal_sys usbcore [last unloaded: sd_mod]
[  961.903538] Pid: 2536, comm: cat Not tainted 2.6.31-rc3 #1
[  961.903630] Call Trace:
[  961.903720]  [<c1021718>] warn_slowpath_common+0x60/0x90
[  961.903814]  [<c1021755>] warn_slowpath_null+0xd/0x10
[  961.903907]  [<c103ed98>] __lock_acquire+0x395/0xaf5
[  961.903999]  [<c103ddb9>] ? mark_lock+0x1e/0x1e4
[  961.904020]  [<c103f540>] lock_acquire+0x48/0x64
[  961.904020]  [<c1126810>] ? tty_port_close_start+0x1a/0x118
[  961.904020]  [<c11c21ef>] _spin_lock_irqsave+0x2e/0x3e
[  961.904020]  [<c1126810>] ? tty_port_close_start+0x1a/0x118
[  961.904020]  [<c1126810>] tty_port_close_start+0x1a/0x118
[  961.904020]  [<f09649b5>] serial_close+0x4f/0x7b [usbserial]
[  961.904020]  [<c11215e3>] tty_release_dev+0x17c/0x400
[  961.904020]  [<c103d28e>] ? register_lock_class+0x17/0x272
[  961.904020]  [<c1121879>] tty_release+0x12/0x1c
[  961.904020]  [<c107201f>] __fput+0xe9/0x172
[  961.904020]  [<c10720c1>] fput+0x19/0x1c
[  961.904020]  [<c106f93c>] filp_close+0x51/0x5b
[  961.904020]  [<c106f9b0>] sys_close+0x6a/0xa4
[  961.904020]  [<c1002a08>] sysenter_do_call+0x12/0x36
[  961.904020] ---[ end trace ed6ce19124f40616 ]---

This is only a lockdep warning, and I don't understand its
significance.  Even worse, when I plugged in a USB flash drive
afterward this appeared:

[ 1093.156767] =============================================================================
[ 1093.156913] BUG kmalloc-1024: Poison overwritten
[ 1093.157003] -----------------------------------------------------------------------------
[ 1093.157006] 
[ 1093.157223] INFO: 0xeea78c9c-0xeea78cab. First byte 0x6c instead of 0x6b
[ 1093.157335] INFO: Allocated in kzalloc+0xb/0xd [usbserial] age=41170 cpu=0 pid=483
[ 1093.157480] INFO: Freed in port_free+0x75/0x78 [usbserial] age=34856 cpu=0 pid=6
[ 1093.157619] INFO: Slab 0xc21c9060 objects=15 used=11 fp=0xeea78c90 flags=0x400040c3
[ 1093.157757] INFO: Object 0xeea78c90 @offset=3216 fp=0xeea7baa0

So it looks like something really is wrong, some sort of 
use-after-free.  Maybe a refcounting imbalance.

Alan Stern

