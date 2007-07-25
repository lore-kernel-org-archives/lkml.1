Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbXGYXe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbXGYXe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXGYXev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:34:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbXGYXeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:34:50 -0400
Date: Wed, 25 Jul 2007 16:34:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] more USB patches for 2.6.22
In-Reply-To: <20070720034456.GA5826@kroah.com>
Message-ID: <alpine.LFD.0.999.0707251628200.3607@woody.linux-foundation.org>
References: <20070720034456.GA5826@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Greg KH wrote:
>
> Here are some more USB patches and fixes against your 2.6.22 git tree.
> 
> They add a new usb gadget driver, more urb->status cleanups, a new sysfs
> attribute to get the raw config of the usb device, and some bugfixes and
> documentation updates.

I have a flaky(?) USB multi-card reader, and I just got an oops with it on 
x86-64. It was preceded by some of the IO errors:

	end_request: I/O error, dev sdc, sector 0
	sd 11:0:0:1: [sdc] Result: hostbyte=0x07 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	usb 2-5: reset high speed USB device using ehci_hcd and address 10
	usb 2-5: reset high speed USB device using ehci_hcd and address 10
	usb 2-5: reset high speed USB device using ehci_hcd and address 10
	usb 2-5: reset high speed USB device using ehci_hcd and address 10
	usb 2-5: reset high speed USB device using ehci_hcd and address 10
	usb 2-5: reset high speed USB device using ehci_hcd and address 10
	usb 2-5: device descriptor read/all, error 0

but the oops itself happened when I then removed the USB device due to 
the errors, causing this:

	usb 2-5: USB disconnect, address 10
	sd 11:0:0:1: [sdc] Result: hostbyte=0x07 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	sd 11:0:0:1: [sdc] Result: hostbyte=0x07 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	sd 11:0:0:1: [sdc] Result: hostbyte=0x01 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	sd 11:0:0:1: [sdc] Result: hostbyte=0x01 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	sd 11:0:0:1: [sdc] Result: hostbyte=0x01 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	Dev sdc: unable to read RDB block 0
	sd 11:0:0:1: [sdc] Result: hostbyte=0x01 driverbyte=0x00
	end_request: I/O error, dev sdc, sector 0
	Buffer I/O error on device sdc, logical block 0
	 unable to read partition table
	sd 11:0:0:1: [sdc] Attached SCSI removable disk
	sd 11:0:0:1: Attached scsi generic sg3 type 0
	usb-storage: device scan complete

and finally the oops itself:


	general protection fault: 0000 [1] SMP
	CPU 0
	Modules linked in:
	Pid: 214, comm: khubd Not tainted 2.6.22-g20082208 #56
	RIP: 0010:[<ffffffff80274670>]  [<ffffffff80274670>] kfree+0x27/0x81
	RSP: 0018:ffff81012bd0dd90  EFLAGS: 00010212
	RAX: 037d001b2d7d01b8 RBX: ffff810001000000 RCX: ffffffff80314f0f
	RDX: ffff81012337b738 RSI: 037c811b2e7d01b8 RDI: ff241b0cff251c0b
	RBP: ff241b0cff251c0b R08: ffffffff8062eed0 R09: ffff81012bc0f430
	R10: 0000000000000287 R11: ffffffff803ed953 R12: ffff81008642f140
	R13: 0000000000000000 R14: 0000000000001540 R15: 0000000000000008
	FS:  0000000000000000(0000) GS:ffffffff806a0000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
	CR2: 00002b02340410a0 CR3: 000000010bd4b000 CR4: 00000000000006e0
	Process khubd (pid: 214, threadinfo ffff81012bd0c000, task ffff81012bed36b0)
	Stack:  ffff81012337b738 ffff81011e9fa800 ffff81008642f140 ffffffff803f50c4
	 ffff81012337b738 ffff81011e9fa800 ffffffff8064ae70 ffff81011e9fa888
	 ffff81012ad60978 ffff81012ad60800 ffff81012ad60800 ffffffff803ed96c
	Call Trace:
	 [<ffffffff803f50c4>] usb_destroy_configuration+0x85/0xee
	 [<ffffffff803ed96c>] usb_release_dev+0x19/0x55
	 [<ffffffff803140c9>] kobject_cleanup+0x52/0x70
	 [<ffffffff803140e7>] kobject_release+0x0/0x9
	 [<ffffffff80314f0f>] kref_put+0x5d/0x68
	 [<ffffffff803ef78f>] hub_thread+0x390/0xb27
	 [<ffffffff8023dcb1>] autoremove_wake_function+0x0/0x2e
	 [<ffffffff803ef3ff>] hub_thread+0x0/0xb27
	 [<ffffffff8023db95>] kthread+0x47/0x76
	 [<ffffffff8020c0f8>] child_rip+0xa/0x12
	 [<ffffffff8023db4e>] kthread+0x0/0x76
	 [<ffffffff8020c0ee>] child_rip+0x0/0x12

	Code: 48 8b 06 25 00 40 02 00 48 3d 00 40 02 00 75 04 48 8b 76 10
	RIP  [<ffffffff80274670>] kfree+0x27/0x81
	 RSP <ffff81012bd0dd90>

Looks like another reference counting bug...

		Linus
