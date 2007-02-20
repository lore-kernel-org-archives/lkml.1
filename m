Return-Path: <linux-kernel-owner+w=401wt.eu-S932677AbXBTF2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbXBTF2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 00:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXBTF2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 00:28:55 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:22470 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677AbXBTF2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 00:28:54 -0500
Date: Mon, 19 Feb 2007 23:28:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
In-reply-to: <fa.qFxa41A3LU3cQ19L+5DTEFMtCEY@ifi.uio.no>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb-users@lists.sourceforge.net
Message-id: <45DA8716.7090009@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.bxsB54F+7+006rE+o/VWUj5keQk@ifi.uio.no>
 <fa.zK5W70l1vhk1YNxuwxFwZ8t1uIs@ifi.uio.no>
 <fa.qFxa41A3LU3cQ19L+5DTEFMtCEY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> [  497.499249] usb-storage   D 00000000     0   671      5           
> 773   670 (L-TLB)
> [  497.506930] Call Trace:
> [  497.509372] [C3F35A60] [C00083AC] __switch_to+0x28/0x40
> [  497.514608] [C3F35A80] [C01F4B78] schedule+0x324/0x6bc
> [  497.519756] [C3F35AC0] [C01F5D6C] schedule_timeout+0x6c/0xd0
> [  497.525426] [C3F35B00] [C01F5C9C] io_schedule_timeout+0x30/0x54
> [  497.531356] [C3F35B20] [C0050DE4] congestion_wait+0x64/0x8c
> [  497.536941] [C3F35B70] [C004A9F0] throttle_vm_writeout+0x1c/0x84
> [  497.542958] [C3F35B90] [C004F33C] shrink_zone+0xbb0/0xfe4
> [  497.548367] [C3F35D40] [C004F8F4] try_to_free_pages+0x184/0x2cc
> [  497.554298] [C3F35DB0] [C0049AA8] __alloc_pages+0x110/0x2c0
> [  497.559878] [C3F35E00] [C0060F84] cache_alloc_refill+0x394/0x694
> [  497.565900] [C3F35E30] [C00614A0] __kmalloc+0xc4/0xcc
> [  497.570961] [C3F35E40] [C01544D0] usb_alloc_urb+0x1c/0x5c
> [  497.576371] [C3F35E50] [C015520C] usb_sg_init+0x1a0/0x2f8
> [  497.581779] [C3F35EA0] [C0167318] usb_stor_bulk_transfer_sg+0x8c/0x138
> [  497.588317] [C3F35ED0] [C0167960] usb_stor_Bulk_transport+0x140/0x310
> [  497.594767] [C3F35F00] [C0167DCC] usb_stor_invoke_transport+0x2c/0x344
> [  497.601303] [C3F35F50] [C0166B2C] 
> usb_stor_transparent_scsi_command+0x10/0x20
> [  497.608449] [C3F35F60] [C0168498] usb_stor_control_thread+0x1f8/0x290
> [  497.614900] [C3F35FC0] [C0033E48] kthread+0xf4/0x130
> [  497.619876] [C3F35FF0] [C001093C] kernel_thread+0x44/0x60

This seems like a problem, the usb-storage thread is trying to allocate 
some memory which is ending up waiting for VM writeout, which obviously 
won't proceed since this thread is the one that needs to do this.. It 
looks like the allocation in usb_stor_bulk_transfer_sglist is done with 
GFP_NOIO, so I wonder why we're getting into this state?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

