Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbYA2T0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbYA2T0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYA2T0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:26:39 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9661 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYA2T0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:26:37 -0500
Date: Tue, 29 Jan 2008 20:26:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Oliver Neukum <oliver@neukum.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080129192633.GP15220@kernel.dk>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <20080129191504.GO15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129191504.GO15220@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008, Jens Axboe wrote:
> On Tue, Jan 29 2008, Matthew Dharm wrote:
> > On Tue, Jan 29, 2008 at 07:39:11PM +0100, Jens Axboe wrote:
> > > On Tue, Jan 29 2008, Jens Axboe wrote:
> > > > On Tue, Jan 29 2008, Oliver Neukum wrote:
> > > > > Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > > > >> Greg KH wrote:
> > > > >  
> > > > > > > > No difference, still just a lot of resets.
> > > > > > > > 
> > > > > > > Where you able to figure out which usb storage transport is used?
> > > > > > > 
> > > > > > > in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> > > > > > > functions. I'm not sure if these get stored in sysfs perhaps. This will
> > > > > > > pinpoint better where to look. Let me research a bit. 
> > > > > > 
> > > > > > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
> > > > > > transport is 'Bulk'
> > > > > 
> > > > > You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
> > > > > That should tell the reason for the resets.
> > > > 
> > > > Sure, I'll do that. Will post the results tonight.
> > > 
> > > OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> > > in the device, waited 10 seconds or so and pulled it out. These are the
> > > messages.
> > > 
> > > It all looks good until the MODE_SENSE command, where it only transfers
> > > 4 of 192 bytes.
> > 
> > No, that's not the problem.  This is the problem:
> 
> It's where the problem starts, otherwise there would not be a need to
> sense :-)
> 
> > > usb-storage: *** thread awakened.
> > > usb-storage: Command TEST_UNIT_READY (6 bytes)
> > > usb-storage:  00 00 00 00 00 00
> > > usb-storage: Bulk Command S 0x43425355 T 0xd L 0 F 0 Trg 0 LUN 1 CL 6
> > > usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > > usb-storage: Status code 0; transferred 31/31
> > > usb-storage: -- transfer complete
> > > usb-storage: Bulk command transfer result=0
> > > usb-storage: Attempting to get CSW...
> > > usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> > > usb-storage: Status code 0; transferred 13/13
> > > usb-storage: -- transfer complete
> > > usb-storage: Bulk status result = 0
> > > usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x1
> > > usb-storage: -- transport indicates command failure
> > > usb-storage: Issuing auto-REQUEST_SENSE
> > > usb-storage: Bulk Command S 0x43425355 T 0xe L 18 F 128 Trg 0 LUN 1 CL 6
> > > usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > > usb-storage: Status code 0; transferred 31/31
> > > usb-storage: -- transfer complete
> > > usb-storage: Bulk command transfer result=0
> > > usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
> > > usb-storage: usb_sg_init returned -22
> > > usb-storage: Bulk data transfer result 0x4
> > > usb-storage: -- auto-sense failure
> > > usb-storage: storage_pre_reset
> > > ehci_hcd 0000:00:1d.7: port 1 high speed
> > > ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
> > > usb 5-1: reset high speed USB device using ehci_hcd and address 2
> > > ehci_hcd 0000:00:1d.7: port 1 high speed
> > > ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
> > > usb-storage: storage_post_reset
> > > usb-storage: usb_reset_composite_device returns 0
> > > usb-storage: scsi cmd done, result=0x70000
> > > usb-storage: *** thread sleeping.
> > 
> > For some reason, usb_sg_init is boned during auto-sense.
> 
> My guess would be that sg == NULL, hence the -EINVAL.

Yep, trace below:

WARNING: at drivers/usb/storage/transport.c:426
usb_stor_bulk_transfer_sglist()
Pid: 12536, comm: usb-storage Not tainted 2.6.24 #74
 [<7810541a>] show_trace_log_lvl+0x1a/0x30
 [<78105e82>] show_trace+0x12/0x20
 [<7810689c>] dump_stack+0x6c/0x80
 [<f83e267e>] usb_stor_bulk_transfer_sglist+0x14e/0x160 [usb_storage]
 [<f83e2730>] usb_stor_bulk_srb_length+0x30/0x50 [usb_storage]
 [<f83e2762>] usb_stor_bulk_srb+0x12/0x20 [usb_storage]
 [<f83e2ce0>] usb_stor_Bulk_transport+0x190/0x3d0 [usb_storage]
 [<f83e30d6>] usb_stor_invoke_transport+0x1b6/0x320 [usb_storage]
 [<f83e1a38>] usb_stor_transparent_scsi_command+0x8/0x10 [usb_storage]
 [<f83e3813>] usb_stor_control_thread+0x143/0x2c0 [usb_storage]
 [<7813bc02>] kthread+0x42/0x70
 [<78104fab>] kernel_thread_helper+0x7/0x1c
 =======================
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries, sg
00000000
usb-storage: usb_sg_init returned -22

-- 
Jens Axboe

