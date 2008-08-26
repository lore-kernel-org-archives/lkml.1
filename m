Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYHZVOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYHZVOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHZVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:14:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46941 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751726AbYHZVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:14:08 -0400
Date: Tue, 26 Aug 2008 17:14:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Karsten Wiese <fzu@wemgehoertderstaat.de>,
       David Brownell <david-b@pacbell.net>, amruth <amruth_pv@yahoo.com>
cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB Serial device disconnect causes IRQ disable after using ehci
 controller halted
In-Reply-To: <214918.92613.qm@web45204.mail.sp1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808261707090.2139-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten and Dave:

It looks like the logic in ehci-hcd's handshake_on_error_set_halt() 
needs to be revisited.

On Tue, 26 Aug 2008, amruth wrote:

> Hi
> Alan
> I am posting below detail log after adding debug messages

...
> [  308.850665] ehci_hcd 0000:00:1d.7: devpath 1 ep2in 3strikes
> [  308.850670] drivers/usb/serial/magtek.c: magtek_read_int_callback - port 0
> [  308.850683] usb 5-1: unlink qh0-00ff/ded67080 start 0 [1/0 us]
> [  308.850846] usb 5-1: link qh0-00ff/ded67080 start 0 [1/0 us]
> [  308.851537] usb 5-1: unlink qh0-00ff/ded67080 start 0 [1/0 us]
> [  308.853487] ehci_hcd 0000:00:1d.7: handshake failed: controller halted

The line above was a debugging message added specially for this test.  
The controller wasn't really halted, but hcd->state was set to 
HC_STATE_HALTED.

> [  308.853487] Pid: 0, comm: swapper Not tainted 2.6.26EHCIDBG #3
> [  308.853487]  [<e08405aa>] handshake_on_error_set_halt+0x45/0x51 [ehci_hcd]
> [  308.853487]  [<e08405d6>] disable_periodic+0x20/0x40 [ehci_hcd]
> [  308.853487]  [<e0841fb4>] ehci_work+0x5e6/0x6ad [ehci_hcd]
> [  308.853487]  [<c0424230>] ? printk+0x15/0x17
> [  308.853487]  [<e0845c7e>] ehci_irq+0x28a/0x2fd [ehci_hcd]
> [  308.853487]  [<e090005d>] ? cdrom_newpc_intr+0x52e/0x544 [ide_cd_mod]
> [  308.853487]  [<c042addd>] ? lock_timer_base+0x1f/0x3e
> [  308.853487]  [<c05764c4>] usb_hcd_irq+0x27/0x58
> [  308.853487]  [<c044b852>] handle_IRQ_event+0x21/0x48
> [  308.853487]  [<c044c9fb>] handle_fasteoi_irq+0x77/0xac
> [  308.853487]  [<c044c984>] ? handle_fasteoi_irq+0x0/0xac
> [  308.853487]  [<c040598c>] do_IRQ+0xa9/0xd1
> [  308.853487]  [<c04025f2>] ? default_idle+0x0/0x42
> [  308.853487]  [<c040429b>] common_interrupt+0x23/0x28
> [  308.853487]  [<c04025f2>] ? default_idle+0x0/0x42
> [  308.853487]  [<c041007b>] ? acpi_save_state_mem+0xa/0x12b
> [  308.853487]  [<c040261f>] ? default_idle+0x2d/0x42
> [  308.853487]  [<c040256d>] cpu_idle+0x8b/0x9f
> [  308.853487]  [<c061f329>] start_secondary+0x156/0x15b
> [  308.853487]  =======================
> [  308.853487] ehci_hcd 0000:00:1d.7: hcd state 0
> [  308.853487] ehci_hcd 0000:00:1d.7: hcd state 0
> [  308.853487] ehci_hcd 0000:00:1d.7: HC died; cleaning up
> [  308.854983] hub 5-0:1.0: state 0 ports 8 chg 0000 evt 0000
> [  308.854983] usb 5-1: USB disconnect, address 6
> [  308.854983] usb 5-1: unregistering device
> [  308.854983] usb 5-1: usb_disable_device nuking all URBs
> [  308.854983] usb 5-1: unregistering interface 5-1:1.0
> [  308.854983] drivers/usb/serial/magtek.c: magtek_shutdown
> [  308.854983] magtek ttyUSB0: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB0
> [  308.854983] magtek 5-1:1.0: device disconnected
> [  308.854983] usb 5-1:1.0: uevent
> [  308.854983] usb 5-1: uevent
> [  309.153998] irq 23: nobody cared (try booting with the "irqpoll" option)

Simply setting hcd->state to HC_STATE_HALTED isn't a good idea,
especially in cases like this where the controller really _isn't_
halted.  Here it was still generating IRQs, leading to the "nobody
cared" problem on the last line of the log.

While it certainly would be a good idea to prevent the handshake 
failures from occurring in the first place -- Dave, aren't you working 
on a patch for that? -- we should also make sure that when they do 
occur, the controller gets reset properly.  And an error message should 
be printed in the log.

Alan Stern

