Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYGXHkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYGXHkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYGXHk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:40:26 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:29065 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750696AbYGXHkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:40:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sz0MnLj9+7bAEFIJvUW10IoSM5McognraIYI9hB+vzPFCqixO/1eQ9qSdqLIlgKFN8hpUXXfqydddwPpSZQbuAK+NSke4dMq24kxiXUiavktMIqMtsqBlgIy+U2ppAxA7vvoJR1VnCrVYAl2yEqI1NZEcYPTP8tDVJZmjcSjigE=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption. prev->next should be next (ffff88003b8f82f8)
Date: Thu, 24 Jul 2008 00:40:20 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0807232342510.25883-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807232342510.25883-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807240040.21006.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008, Alan Stern wrote:
> On Wed, 23 Jul 2008, David Brownell wrote:
> 
> > So far, the fingers point at dummy_hcd... the merge doesn't
> > seem to have had problems, and the gadget driver had been
> > tested with four different peripheral controller drivers
> > (pre-merge).
> 
> > > list_add corruption. prev->next should be next (ffff88003b8f82f8),
> > > 			but was ffff88003b8f8e80. (prev=ffff88003b8f8e80). 
> > 
> > Now, prev->next == prev is expected here:  that list of messages
> > should be empty.
> > 
> > What's wrong is that head->prev != head, meaning something
> > trashed a dummy_hcd data structure.
> 
> The problem could easily be that dummy-hcd simply isn't 
> list-debugging-safe.  I wouldn't be at all surprised if, for example, 
> it adds a node to a list without initializing the node first.

I would be surprised if it did something that foolish.  ;)

Trying this with a serial console and some extra debug printfs suggests
to me that the culprit is the code near line 548 of dummy_hcd.c near
the end of dummy_queue.  That "emulated single-request fifo" code is
kicking in, and doing very strange stuff.  See annotated console log
below.

Note that the "ECM" rework did change how these notifications were
issued a bit ... less of a gross hack, now it's just a little bit
ugly and has a little state machine.  It's actually less demanding
on the underlying driver, but I could believe dummy_hcd hasn't had
to cope with this (valid) I/O pattern before.

- Dave


dummy_udc dummy_udc: binding gadget driver 'g_cdc'
g_cdc gadget: using random self ethernet address
g_cdc gadget: using random host ethernet address
usb0: MAC a2:85:65:50:b6:19
usb0: HOST MAC d6:ce:e9:16:bf:b3
gserial_setup: registered 1 ttyGS* device
g_cdc gadget: adding config #1 'CDC Composite (ECM + ACM)'/bf00da0c
g_cdc gadget: adding 'cdc_ethernet'/c174ea24 to config 'CDC Composite (ECM + ACM)'/bf00da0c
g_cdc gadget: CDC Ethernet: dual speed IN/ep-a OUT/ep-b NOTIFY/ep-c
g_cdc gadget: adding 'acm'/c174eb10 to config 'CDC Composite (ECM + ACM)'/bf00da0c
g_cdc gadget: acm ttyGS0: dual speed IN/ep-d OUT/ep-e NOTIFY/ep-f
g_cdc gadget: cfg 1/bf00da0c speeds: high full
g_cdc gadget:   interface 0 = cdc_ethernet/c174ea24
g_cdc gadget:   interface 1 = cdc_ethernet/c174ea24
g_cdc gadget:   interface 2 = acm/c174eb10
g_cdc gadget:   interface 3 = acm/c174eb10
g_cdc gadget: CDC Composite Gadget, version: King Kamehameha Day 2008
g_cdc gadget: g_cdc ready

dummy_hcd dummy_hcd: port status 0x00010101 has changes
hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
dummy_hcd dummy_hcd: port status 0x00010101 has changes
hub 1-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
g_cdc gadget: resume
dummy_hcd dummy_hcd: port status 0x00100503 has changes
usb 1-1: new high speed USB device using dummy_hcd and address 2

	I modified dummy_hcd to print messages whenever a request
	was queued to an endpoint, or acompletion was issued.
	If the endpoint queue was empty at that time, it's shown.

	So for example this must be a device descriptor fetch:

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

g_cdc gadget: resume
dummy_hcd dummy_hcd: port status 0x00100503 has changes
dummy_udc dummy_udc: set_address = 2

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

usb 1-1: skipped 3 descriptors after interface
usb 1-1: skipped 4 descriptors after interface

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

usb 1-1: default language 0x0409

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

usb 1-1: uevent
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
g_cdc gadget: high speed config #1: CDC Composite (ECM + ACM)

	Control interface activated:  one notification endpoint.

dummy_udc dummy_udc: enabled ep-c (ep3in-intr) maxpacket 16

	This "init ecm" message means the data interface
	has been set to altsetting 0 (no data).

g_cdc gadget: init ecm

	Last step of entering altsetting 0:  issue a connect status
	notification.  (Where "connected" means that the peripheral
	ethernet link is "up".)  Later when that is completed, reuse
	that request to issue a speed notification.

g_cdc gadget: notify connect false
ep-c: queue req c10980e0 (q empty)

	Here's where it starts to go squirrely...
	
	You would EXPECT to see a completion callback here since
	that's what dummy_queue() says to do:  write this small
	packet into a FIFO (just like Real Hardware would) and
	wait for the host to collect it.

	Note that the emulated FIFO is represented by a request
	object ... one that *never* seems to get a completion
	issued for it.  That seems very wrong...

g_cdc gadget: notify speed 425984000
ep-c: queue req c10980e0 (q empty)

	So in fact we next saw the "notify speed" diagnostic (above)
	which is only triggered through that ecm_notify_complete()
	callback.  How could that be?

	Plus, the endpoint's queue is somehow empty here; lacking
	any completion from the previously queued request, how?

ep-c: FIFO complete IN req c10980e0 (q empty)

	OK, there was a completion message, like I would have expected
	earlier (before "notify speed...") ...

ep-c: FIFO complete IN req c10980e0

	... followed immediately by a second completion message,
	reporting that the (reused) request was reported as
	complete.
	
	Note that it does not say the endpoint request queue was
	empty here ... that's fishy.  How?

dummy_udc dummy_udc: enabled ep-f (ep6in-intr) maxpacket 8
g_cdc gadget: activate acm ttyGS0
dummy_udc dummy_udc: enabled ep-d (ep4in-bulk) maxpacket 512
dummy_udc dummy_udc: enabled ep-e (ep5out-bulk) maxpacket 512

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

usb 1-1: adding 1-1:1.0 (config #1, interface 0)
usb 1-1:1.0: uevent

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

usb 1-1: adding 1-1:1.1 (config #1, interface 1)
usb 1-1:1.1: uevent
usb 1-1: adding 1-1:1.2 (config #1, interface 2)
usb 1-1:1.2: uevent

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

usb 1-1: adding 1-1:1.3 (config #1, interface 3)
usb 1-1:1.3: uevent

ep0: queue req c10989bc (q empty)
ep0: complete c10989bc (q empty)

	... all those ep0 requests worked just fine ...

drivers/usb/core/inode.c: creating file '002'
usb 1-1: New USB device found, idVendor=0525, idProduct=a4aa
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: CDC Composite Gadget
usb 1-1: Manufacturer: Linux 2.6.26 with dummy_udc
hub 1-0:1.0: state 7 ports 1 chg 0000 evt 0002
cdc_ether 1-1:1.0: usb_probe_interface
cdc_ether 1-1:1.0: usb_probe_interface - got id
g_cdc gadget: activate ecm
dummy_udc dummy_udc: enabled ep-a (ep1in-bulk) maxpacket 512
dummy_udc dummy_udc: enabled ep-b (ep2out-bulk) maxpacket 512
usb0: qlen 10

	And right here it goes really bad...
	
	This is the third time this request object was used to
	send a short notification packet through this endpoint.
	Completions were issued for both previous packets.

	Notice that the queue should have been empty here (but
	isn't), but that the "fifo_req" never had a completion
	issued.

g_cdc gadget: notify connect false
ep-c: queue req c10980e0

list_add corruption. prev->next should be next (c1c0b220), but was c1c0b7f0. (prev=c1c0b7f0).
kernel BUG at lib/list_debug.c:33!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c17f8000
[00000000] *pgd=2178b031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
Modules linked in: cdc_ether(+) g_cdc dummy_hcd [last unloaded: ohci_hcd]
CPU: 0    Not tainted  (2.6.26 #98)
PC is at __bug+0x20/0x2c
LR is at vprintk+0x32c/0x374
pc : [<c00224d0>]    lr : [<c00343cc>]    psr: 60000093
sp : c17b7598  ip : c17b74c0  fp : c17b75a4
r10: c10980d8  r9 : c1c0b7f0  r8 : c1c0b220
r7 : c1c0b614  r6 : c1c0b234  r5 : c1c0b174  r4 : c10980e0
r3 : 00000000  r2 : 60000093  r1 : c01c4690  r0 : 00000026
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000317f  Table: 217f8000  DAC: 00000017
Process klogd (pid: 711, stack limit = 0xc17b6260)
Stack: (0xc17b7598 to 0xc17b8000)
7580:                                                       c17b75b4 c17b75a8 
75a0: c00fcdfc c00224c0 c17b75e4 c17b75b8 bf002394 c00fcdb0 60000093 c174ea24 
75c0: c170c94c 00000001 c1066690 c174ea24 c170c94c c10980e0 c17b7610 c17b75e8 
75e0: bf007150 bf0021f8 c174ea24 c170c94c 00000001 00000001 c109960c 0000d000 
7600: c170c94c c17b7620 c17b7614 bf0071b8 bf006fec c17b763c c17b7624 bf007570 
7620: bf0071b0 00000001 00000001 c17b76b4 c17b7688 c17b7640 bf0097e8 bf0073e8 
7640: 00000002 c1c0b174 bf001420 c1c0b614 bf0013b4 c10989bc 00000000 c1c0b174 
7660: 00000001 c1c0b190 c1c0b174 bf0013b4 c109960c 0000d000 c1c0b190 c17b76e4 
7680: c17b768c bf001c68 bf009120 c17bc2c0 c1066e88 c1c0b8a8 60000013 c17b76a8 
76a0: c005510c c0054ed4 c0281ec0 c1c0b868 c0281ec0 00010b01 00000001 00000101 
76c0: c1c0b868 c0281ec0 bf0013b4 c17b6000 00000000 00000040 c17b7718 c17b76e8 
76e0: c003cdbc bf0013c4 c1c0b884 00000000 c17b76f0 c17b76f0 c0281ca4 00000087 
7700: 0000000a c171f5f8 00000001 c17b7734 c17b771c c0038898 c003cc5c 60000093 
7720: c015eda4 c1c4ba80 c17b7748 c17b7738 c0038968 c003883c c17b6000 c17b7760 
7740: c17b774c c003908c c003892c c171f5c0 00000000 c17b778c c17b7764 c015eda4 
7760: c0038fe8 00000001 c015ea74 c1c4ba80 c170c604 0000000e 00000000 c1735360 
7780: c17b77ac c17b7790 c01785c4 c015e980 c1c4ba80 c1c4ba80 c172c000 00000040 
77a0: c17b77bc c17b77b0 c0178910 c01783c8 c17b77d0 c17b77c0 c0176e90 c01788cc 
77c0: c1075c4c c17b77fc c17b77d4 c01771b4 c0176e74 c17b7a14 c1c4ba80 c1735360 
77e0: c172c000 c1075c60 c172c000 7800000a c17b782c c17b7800 c01932a4 c0176ea4 
7800: c172c0e4 00000000 c1735360 00000000 00000000 c172c000 c17b79f8 7800000a 
7820: c17b78d8 c17b7830 c0194438 c0192ffc 00000000 c17b78a0 c1735360 00004040 
7840: 00000070 00000000 00000011 0000c103 00000000 7800000a 00000000 00000108 
7860: 00000000 00000000 00000000 00000000 7800000a 5f00000a 00000000 00000000 
7880: 00000000 00000000 00000000 00000000 00000000 00000011 0108c103 00000000 
78a0: 7800000a 00000000 00000000 c1735360 c172c000 00000070 c17b78fc c17b79f8 
78c0: 00000010 c1807200 c17b79f8 c17b78f8 c17b78dc c019ab04 c0193fc4 c17bc2c0 
78e0: c17b79f8 c17b78fc c1c528e8 c17b79d8 c17b78fc c014f7dc c019aab8 c1c520c0 
7900: c1c4b1c0 00000000 00000001 ffffffff 00000000 00000000 00000000 00000000 
7920: 00000000 c17bc2c0 00000000 00000000 c0174964 c17bc2c0 c0048654 c17b793c 
7940: c17b793c c00569dc c00555ec c17b7980 00000000 c1c4b1c0 c17b6000 00000000 
7960: c17bc2c0 c0055190 00000040 c17b7994 c17b797c c005510c c0054ed4 c17b6000 
7980: 00000000 00000001 00000001 00000070 c1807200 00000000 00000000 c17b79f8 
79a0: c02b7d50 c17bc2c0 c1c0a7a8 c17b7a20 c17b79bc c0055b40 c00549b8 c1759080 
79c0: c17b6000 bf000000 c1c0a7ac c17b79f0 c17b79dc c0150a54 c014f738 00004040 
79e0: 00000000 c17b7a44 c17b79f4 c01ae4c8 c0150a1c 00000070 c1c528e8 00000010 
7a00: c17b7a14 00000001 00000000 00000000 00004040 c1759084 00000070 00000070 
7a20: 00000000 00000000 00000010 c1c0a7ac c1736c00 c1c0a7a8 c17b7a84 c17b7a48 
7a40: c01ae57c c01ae43c 00000000 00000000 c1807200 c1c0a81c c17b7a74 c1c0a834 
7a60: c1c0a7a8 c1c528dc c1736c00 c1c528dc c1736c00 c1c0a7a8 c17b7aa8 c17b7a88 
7a80: c01b05b4 c01ae4e8 00000000 c1c0a834 c1c52c80 c1c0a81c c1736c00 c17b7ad4 
7aa0: c17b7aac c01ad070 c01b058c c1c0a7a8 c1c0a7a8 00000000 c1736c00 c04cdaec 
7ac0: c17b7df4 c04cdaec c17b7af8 c17b7ad8 c01ab8ec c01acfa0 c1816628 c1736c00 
7ae0: c1736c00 00000000 c1736c48 c17b7b18 c17b7afc c01b1ccc c01ab6dc c1736c00 
7b00: c17b7b48 00000000 c17b7b48 c17b7b2c c17b7b1c c01b1f30 c01b1c54 c1736c00 
7b20: c17b7b44 c17b7b30 c01aabc8 c01b1f08 c1740684 c17b7b84 c17b7b80 c17b7b48 
7b40: c01aaca8 c01aab70 00000000 c1740684 c17b7b84 c01cfc00 00000000 00000000 
7b60: 00000000 c1816628 c17b7bbc c1740000 c17b7b84 c17b7bb4 c17b7b84 c00d2fd8 
7b80: c01aac5c c0256ccc c1816628 c17b7bbc 00000000 c1816734 c1740000 c1814114 
7ba0: c17b7bbc c1816620 c17b7c70 c17b7bb8 c00cc6d4 c00d2f70 c17b7c2c c17b0000 
7bc0: c0055b40 c00549b8 c17bc5c8 0000001f 00000000 00000000 00000000 00000000 
7be0: 00000000 c1813ad0 00000000 00000001 c02ba924 c046347c c17bc5c8 00000046 
7c00: 00000000 60000013 c17b6000 00000000 c17b7ee8 c17b7ee8 c17b7df4 c17b7e08 
7c20: c17b7c54 c17b7c30 c00569dc c00555ec 00000002 c17b7c58 c17b7c44 c00cc850 
7c40: c00cb984 c1814114 000005ec c1813ab8 c1816734 c1814114 c17b7ee8 c1813310 
7c60: c17b7e08 c17b7da8 c17b7c74 c00ca2e0 c00cc5f4 c0254088 00000000 00000001 
7c80: 00000000 00000000 c17bc5c8 00000029 00000000 60000013 c17b6000 00000000 
7ca0: c024adac 00000001 00000002 c17bc5f0 c02ba924 c17bc2c0 0002bbb4 c17b7d30 
7cc0: c17b7ccc c0055b40 c00549b8 c02b9208 c17bc2c0 00014800 00000000 00000000 
7ce0: 00000000 00000000 c1813ad0 00000001 00000000 c02ba924 c046ac7c c17bc5f0 
7d00: 00014846 00000000 60000013 c17b6000 00000000 c17b7df4 00000002 c11e4105 
7d20: 0002bbb4 c17b7d58 c17b7d34 c00569dc c00555ec 00000002 c1813ac0 c1813ae0 
7d40: c1813ac0 c1813ab8 c1813310 c17b7df4 c1813ac0 c1813ab8 c1813ab8 c1813310 
7d60: c17b7df4 00000002 c17b7da8 c17b7d78 c00996b0 c00566ac 00000001 c0099550 
7d80: 000041ed c17b7ee8 c1813ab8 c17b7ee8 00000000 c1814114 c17b7ee8 c17b7dd8 
7da0: c17b7dac c008f8ac c00ca15c c1c03780 000041ed c17b7ee8 00000000 c1814114 
7dc0: c11e4100 c17b6000 400ac1fc c17b7e38 c17b7ddc c0090ef4 c008f774 c11e4107 
7de0: 00000000 00000101 c17bc5c8 00000044 c17b6000 0002bbb4 00000002 c11e4105 
7e00: 00000001 c11e4100 c1c03780 c1813310 c1c3a584 c17b7ee8 c11e4100 c17b7e3c 
7e20: c11e4100 c17b6000 400ac1fc c17b7e60 c17b7e3c c0091494 c009056c c1c03780 
7e40: c180ab7c c1c3a584 c1c3a580 c17b7ee8 00000001 c17b7e88 c17b7e64 c00917b4 
7e60: c0091450 c17b7e70 c17b7ee8 ffffff9c c11e4100 00000001 ffffff9c c17b7ea8 
7e80: c17b7e8c c009238c c0091654 00000000 00000004 c11e4100 00000001 c17b7ec0 
7ea0: c17b7eac c009245c c0092348 00000001 00000000 c17b7f70 c17b7ec4 c0092750 
7ec0: c0092448 00000001 c02c23dc 0000ffff 00000000 00000004 00000000 00000000 
7ee0: c17b6000 00000000 c1c03780 c1813310 c17b6000 00000000 c17b7f2c 00000101 
7f00: 00000001 00000000 00000002 c1092e24 400b1a80 c1092e24 00000004 c17b6000 
7f20: c1092e08 c1092e24 c17b7f48 00000001 00000000 c11eaa80 00000004 c17b7f70 
7f40: c17b7f4c c00858d0 00000000 00000004 c11e4100 0000ffff ffffff9c c17b6000 
7f60: 400ac1fc c17b7f94 c17b7f74 c0085930 c00926e4 00000000 400b1a80 400ad270 
7f80: 00000005 c001ec24 c17b7fa4 c17b7f98 c00859ac c00858ec 00000000 c17b7fa8 
7fa0: c001ea80 c0085998 00000000 400b1a80 400a1b88 00000000 0000ffff 00000000 
7fc0: 00000000 400b1a80 400ad270 00000007 000affd4 00000002 400ac1fc 00000ad0 
7fe0: 400ac9a4 beee27d0 40085908 40099930 60000010 400a1b88 00000000 00000000 
Backtrace: 
[<c00224b0>] (__bug+0x0/0x2c) from [<c00fcdfc>] (__list_add+0x5c/0x7c)
[<c00fcda0>] (__list_add+0x0/0x7c) from [<bf002394>] (dummy_queue+0x1ac/0x1e8 [dummy_hcd])

[<bf0021e8>] (dummy_queue+0x0/0x1e8 [dummy_hcd]) from [<bf007150>] (ecm_do_notify+0x174/0x1c4 [g_cdc])
[<bf006fdc>] (ecm_do_notify+0x0/0x1c4 [g_cdc]) from [<bf0071b8>] (ecm_notify+0x18/0x1c [g_cdc])
[<bf0071a0>] (ecm_notify+0x0/0x1c [g_cdc]) from [<bf007570>] (ecm_set_alt+0x198/0x1b4 [g_cdc])
[<bf0073d8>] (ecm_set_alt+0x0/0x1b4 [g_cdc]) from [<bf0097e8>] (composite_setup+0x6d8/0x8cc [g_cdc])
 r6:c17b76b4 r5:00000001 r4:00000001
[<bf009110>] (composite_setup+0x0/0x8cc [g_cdc]) from [<bf001c68>] (dummy_timer+0x8b4/0x910 [dummy_hcd])

[<bf0013b4>] (dummy_timer+0x0/0x910 [dummy_hcd]) from [<c003cdbc>] (run_timer_softirq+0x170/0x200)
[<c003cc4c>] (run_timer_softirq+0x0/0x200) from [<c0038898>] (__do_softirq+0x6c/0xf0)
 r8:00000001 r7:c171f5f8 r6:0000000a r5:00000087 r4:c0281ca4
[<c003882c>] (__do_softirq+0x0/0xf0) from [<c0038968>] (do_softirq+0x4c/0x70)
 r6:c1c4ba80 r5:c015eda4 r4:60000093
[<c003891c>] (do_softirq+0x0/0x70) from [<c003908c>] (local_bh_enable+0xb4/0xe8)
 r4:c17b6000
[<c0038fd8>] (local_bh_enable+0x0/0xe8) from [<c015eda4>] (dev_queue_xmit+0x434/0x494)
 r5:00000000 r4:c171f5c0

	The NFS traffic below seems like it should be irrelevant.

[<c015e970>] (dev_queue_xmit+0x0/0x494) from [<c01785c4>] (ip_finish_output+0x20c/0x25c)
 r8:c1735360 r7:00000000 r6:0000000e r5:c170c604 r4:c1c4ba80
[<c01783b8>] (ip_finish_output+0x0/0x25c) from [<c0178910>] (ip_output+0x54/0x5c)
 r7:00000040 r6:c172c000 r5:c1c4ba80 r4:c1c4ba80
[<c01788bc>] (ip_output+0x0/0x5c) from [<c0176e90>] (ip_local_out+0x2c/0x30)
[<c0176e64>] (ip_local_out+0x0/0x30) from [<c01771b4>] (ip_push_pending_frames+0x320/0x39c)
 r4:c1075c4c
[<c0176e94>] (ip_push_pending_frames+0x0/0x39c) from [<c01932a4>] (udp_push_pending_frames+0x2b8/0x310)
[<c0192fec>] (udp_push_pending_frames+0x0/0x310) from [<c0194438>] (udp_sendmsg+0x484/0x590)
[<c0193fb4>] (udp_sendmsg+0x0/0x590) from [<c019ab04>] (inet_sendmsg+0x5c/0x64)
[<c019aaa8>] (inet_sendmsg+0x0/0x64) from [<c014f7dc>] (sock_sendmsg+0xb4/0xd0)
 r7:c1c528e8 r6:c17b78fc r5:c17b79f8 r4:c17bc2c0
[<c014f728>] (sock_sendmsg+0x0/0xd0) from [<c0150a54>] (kernel_sendmsg+0x48/0x7c)
 r6:c1c0a7ac r5:bf000000 r4:c17b6000
[<c0150a0c>] (kernel_sendmsg+0x0/0x7c) from [<c01ae4c8>] (xs_send_kvec+0x9c/0xac)
 r5:00000000 r4:00004040
[<c01ae42c>] (xs_send_kvec+0x0/0xac) from [<c01ae57c>] (xs_sendpages+0xa4/0x210)
[<c01ae4d8>] (xs_sendpages+0x0/0x210) from [<c01b05b4>] (xs_udp_send_request+0x38/0x134)
[<c01b057c>] (xs_udp_send_request+0x0/0x134) from [<c01ad070>] (xprt_transmit+0xe0/0x1dc)
 r7:c1736c00 r6:c1c0a81c r5:c1c52c80 r4:c1c0a834
[<c01acf90>] (xprt_transmit+0x0/0x1dc) from [<c01ab8ec>] (call_transmit+0x220/0x28c)
[<c01ab6cc>] (call_transmit+0x0/0x28c) from [<c01b1ccc>] (__rpc_execute+0x88/0x29c)
 r7:c1736c48 r6:00000000 r5:c1736c00 r4:c1736c00
[<c01b1c44>] (__rpc_execute+0x0/0x29c) from [<c01b1f30>] (rpc_execute+0x38/0x3c)
 r7:c17b7b48 r6:00000000 r5:c17b7b48 r4:c1736c00
[<c01b1ef8>] (rpc_execute+0x0/0x3c) from [<c01aabc8>] (rpc_run_task+0x68/0x70)
 r4:c1736c00
[<c01aab60>] (rpc_run_task+0x0/0x70) from [<c01aaca8>] (rpc_call_sync+0x5c/0x80)
 r5:c17b7b84 r4:c1740684
[<c01aac4c>] (rpc_call_sync+0x0/0x80) from [<c00d2fd8>] (nfs_proc_getattr+0x78/0xb0)
 r7:c17b7b84 r6:c1740000 r5:c17b7bbc r4:c1816628
[<c00d2f60>] (nfs_proc_getattr+0x0/0xb0) from [<c00cc6d4>] (__nfs_revalidate_inode+0xf0/0x244)
 r8:c1816620 r7:c17b7bbc r6:c1814114 r5:c1740000 r4:c1816734
[<c00cc5e4>] (__nfs_revalidate_inode+0x0/0x244) from [<c00ca2e0>] (nfs_lookup_revalidate+0x194/0x390)
[<c00ca14c>] (nfs_lookup_revalidate+0x0/0x390) from [<c008f8ac>] (do_lookup+0x148/0x18c)
 r8:c17b7ee8 r7:c1814114 r6:00000000 r5:c17b7ee8 r4:c1813ab8
[<c008f764>] (do_lookup+0x0/0x18c) from [<c0090ef4>] (__link_path_walk+0x998/0xee4)
[<c009055c>] (__link_path_walk+0x0/0xee4) from [<c0091494>] (path_walk+0x54/0xa4)
[<c0091440>] (path_walk+0x0/0xa4) from [<c00917b4>] (do_path_lookup+0x170/0x190)
 r7:00000001 r6:c17b7ee8 r5:c1c3a580 r4:c1c3a584
[<c0091644>] (do_path_lookup+0x0/0x190) from [<c009238c>] (__path_lookup_intent_open+0x54/0x90)
 r8:ffffff9c r7:00000001 r6:c11e4100 r5:ffffff9c r4:c17b7ee8
[<c0092338>] (__path_lookup_intent_open+0x0/0x90) from [<c009245c>] (path_lookup_open+0x24/0x2c)
 r7:00000001 r6:c11e4100 r5:00000004 r4:00000000
[<c0092438>] (path_lookup_open+0x0/0x2c) from [<c0092750>] (do_filp_open+0x7c/0x744)
[<c00926d4>] (do_filp_open+0x0/0x744) from [<c0085930>] (do_sys_open+0x54/0x98)
[<c00858dc>] (do_sys_open+0x0/0x98) from [<c00859ac>] (sys_open+0x24/0x28)
 r8:c001ec24 r7:00000005 r6:400ad270 r5:400b1a80 r4:00000000
[<c0085988>] (sys_open+0x0/0x28) from [<c001ea80>] (ret_fast_syscall+0x0/0x2c)
Code: e1a01000 e59f000c eb0047d1 e3a03000 (e5833000) 
Kernel panic - not syncing: Fatal exception in interrupt

