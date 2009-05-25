Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZEYGoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZEYGoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZEYGoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:44:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:55856 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZEYGoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:44:20 -0400
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0905191031240.4611-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0905191031240.4611-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Mon, 25 May 2009 16:43:12 +1000
Message-Id: <1243233792.24376.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found it. Patch below.

usb-serial: Fix crash when sub-driver attach() returns positive value

This fixes a crash in usb-serial that typically happens with keyspan USB
devices, though it would happen potentially with anything that returns
a positive value from the subdriver's attach() method to indicate that
a FW was loaded and the device will disconnect and reconnect.

What happens is that we haven't yet initialized the struct device embedded
inside the struct usb_serial_port when we call "exit:" and return
from probe().

Later, when we get the disconnect() call, usb_serial_disconnect() tries
to do a device_del() and put_device() on all the ports, despite the fact
that in this case, the struct device wasn't initialized. This causes the
device core to crash (right, it should be more robust).

This works around it by using the device->bus pointer as an indication
as to whether those structures are initialized.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/drivers/usb/serial/usb-serial.c
===================================================================
--- linux-work.orig/drivers/usb/serial/usb-serial.c	2009-05-25 16:25:10.000000000 +1000
+++ linux-work/drivers/usb/serial/usb-serial.c	2009-05-25 16:26:22.000000000 +1000
@@ -1075,14 +1075,19 @@ void usb_serial_disconnect(struct usb_in
 			}
 			kill_traffic(port);
 			cancel_work_sync(&port->work);
-			device_del(&port->dev);
+			/* port->dev may not be initialized yet. We check that
+			 * by testing if the "bus" pointer is NULL
+			 */
+			if (port->dev.bus)
+				device_del(&port->dev);
 		}
 	}
 	serial->type->shutdown(serial);
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		if (port) {
-			put_device(&port->dev);
+			if (port->dev.bus)
+				put_device(&port->dev);
 			serial->port[i] = NULL;
 		}
 	}


On Tue, 2009-05-19 at 10:39 -0400, Alan Stern wrote:
> On Tue, 19 May 2009, Benjamin Herrenschmidt wrote:
> 
> > So I can still reproduce it with today checkout
> > (363383277081ce831642b72df40932ee05ce40a2).
> > 
> > Unable to handle kernel paging request for data at address 0x00000010
> > Faulting instruction address: 0xc000000000301e0c
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > SMP NR_CPUS=4 PowerMac
> > Modules linked in: keyspan usbserial
> > NIP: c000000000301e0c LR: c0000000002fb410 CTR: c0000000002fb29c
> > REGS: c00000015a4e34c0 TRAP: 0300   Not tainted  (2.6.30-rc6-00065-g3633832)
> > MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000024  XER: 20000000
> > DAR: 0000000000000010, DSISR: 0000000040000000
> > TASK = c00000015a494950[170] 'khubd' THREAD: c00000015a4e0000 CPU: 1
> > GPR00: c0000000008475e8 c00000015a4e3740 c000000000875430 0000000000000001 
> > GPR04: 0000000000000000 c0000001581e2290 0000000000000001 0000000000000000 
> > GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000002fb29c 
> > GPR12: 0000000024000082 c0000000008a9480 0000000000000002 c0000001581dd230 
> > GPR16: 00000000000003e8 0000000000000001 c0000001580b0800 c0000001581dd230 
> > GPR20: 0000000000000000 0000000000000001 c0000001580b1800 0000000000000002 
> > GPR24: c000000158226c00 c00000015811a780 c0000001581e2198 0000000000000000 
> > GPR28: 0000000000000000 c00000015a4e37b0 c0000000007fede8 0000000000000000 
> > NIP [c000000000301e0c] .release_nodes+0x54/0x254
> > LR [c0000000002fb410] .device_del+0x174/0x1e8
> > Call Trace:
> > [c00000015a4e3740] [c00000015a4e3880] 0xc00000015a4e3880 (unreliable)
> > [c00000015a4e37f0] [c0000000002fb410] .device_del+0x174/0x1e8
> > [c00000015a4e3880] [d0000000005454dc] .usb_serial_disconnect+0xf8/0x1d0 [usbserial]
> > [c00000015a4e3930] [c0000000003d1ed0] .usb_unbind_interface+0x7c/0x138
> > [c00000015a4e39d0] [c0000000002fe77c] .__device_release_driver+0xb8/0x100
> > [c00000015a4e3a60] [c0000000002fe930] .device_release_driver+0x30/0x54
> > [c00000015a4e3af0] [c0000000002fd9c8] .bus_remove_device+0xe4/0x124
> > [c00000015a4e3b80] [c0000000002fb404] .device_del+0x168/0x1e8
> > [c00000015a4e3c10] [c0000000003cf08c] .usb_disable_device+0xa4/0x15c
> > [c00000015a4e3cb0] [c0000000003c96ac] .usb_disconnect+0xc4/0x180
> > [c00000015a4e3d60] [c0000000003ca794] .hub_thread+0x594/0x101c
> > [c00000015a4e3f00] [c0000000000672b0] .kthread+0x80/0xcc
> > [c00000015a4e3f90] [c00000000001fef0] .kernel_thread+0x54/0x70
> > Instruction dump:
> > ebc2a398 7c7a1b78 7c872378 39000000 3b800000 3be00000 38010070 f8010070 
> > f8010078 7c1d0378 48000070 e81e8000 <e96a0010> e8840000 7fab0000 419e0014 
> > ---[ end trace f9d8f1b68a9ea04d ]---
> > 
> > Pretty clearly a NULL dereference inside release_nodes() called by
> > device_del(). After a bit of disassembly, it looks like the offending
> > dereference is node->release (ie, node_to_group) called with a NULL node,
> > so basically we got to a situation where cur == NULL in the first loop
> > inside of remove_nodes() and it thus blows on
> > 
> > 	grp = node_to_group(node);
> > 
> > It also looks like first is NULL but it's unclear whether it is such
> > as the result of first = first->next or the function was called that
> > way, though I could try to figure it out with added debugging. It -does-
> > seem that "cnt" might be 1 at the time of the crash.
> 
> It looks like dev->devres has been corrupted somehow.  As far as I can
> tell, the keyspan driver doesn't touch it at all.  In fact, nothing in
> drivers/usb/serial does.
> 
> > Do you need more data ?
> 
> The inner device_del() call comes from usb_serial_disconnect().  You 
> could try adding some debugging there, to find out if dev->devres has 
> been tampered with.
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

