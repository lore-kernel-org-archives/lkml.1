Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYH0Vc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYH0Vc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYH0VcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:32:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42952 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751003AbYH0VcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:32:17 -0400
Date: Wed, 27 Aug 2008 17:32:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <antonio.lin@alcormicro.com>, <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <20080626174157.GE20851@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0808271731440.2137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Jens Axboe wrote:

> On Thu, Jun 26 2008, Alan Stern wrote:
> > On Thu, 26 Jun 2008, Jens Axboe wrote:
> > 
> > > Alan, in what specific cases have you observed IO requests that violate
> > > the rules you gave? The example of:
> > > 
> > > "For example, suppose an I/O request starts out with two S-G elements of
> > > 1536 bytes and 2048 bytes respectively, and the DMA requirement is"
> > > 
> > > really sounds concocted, have you ever seen something like that?
> > 
> > It really was observed, though not by me.  Here's the email message in
> > which it was reported (for some reason this doesn't seem to have made 
> > it into the list archives):
> > 
> > > From antonio.lin@alcormicro.com Thu Jun 26 11:05:30 2008
> > > Date: Wed, 11 Jun 2008 20:51:52 +0800
> > > From: AntonioLin <antonio.lin@alcormicro.com>
> > > To: Alan Stern <stern@rowland.harvard.edu>
> > > Cc: David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org
> > > Subject: Re: [S] Re: [linux-uwb] packet size problem
> > > 
> > > Hi All,
> > > 
> > > I checked srb->device->request_queue->dma_alignment in usb_stor_bulk_Bulk_transport() routine. , the value is 1023.
> > > 
> > > But in usb_stor_bulk_transfer_sglist, the length of first element in sg array is 3584 which is not divisible by 1024.
> > > 
> > > 
> > > Can you post your /proc/bus/usb/devices ?
> > > 
> > > I don't know how to do this, could you descript moe about it ?
> > > (Sorry,I have few experience about Linux.)
> > > 
> > > Thanks.
> > > 
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320234] usb-storage: *** thread sleeping.
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320271] usb-storage: queuecommand called
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320288] usb-storage: *** thread awakened.
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320294] usb-storage: Command READ_10 (10 bytes)
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320297] usb-storage:  28 00 00 00 a8 91 00 00 1f 00
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320316] usb_stor_Bulk_transport:dma_alignment:1023
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320322] usb-storage: Bulk Command S 0x43425355 T 0x2f L 15872 F 128 Trg 0 LUN 0 CL 10
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320327] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320333] hwahc_op_urb_enqueue
> > > Jun 11 16:43:14 localhost kernel: [ 1959.320340] xfer d3202dc0 urb d30e6780 pipe 0xc0008200 [31 bytes] dma outbound inline
> > > Jun 11 16:43:14 localhost kernel: [ 1956.597834] giveback d3202dc0 0
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323583] usb-storage: Status code 0; transferred 31/31
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323588] usb-storage: -- transfer complete
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323593] usb-storage: Bulk command transfer result=0
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323598] usb-storage: usb_stor_bulk_transfer_sglist: xfer 15872 bytes, 4 entries
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323611] hwahc_op_urb_enqueue
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323618] xfer d3202000 urb d30e6c00 pipe 0xc0008280 [3584 bytes] dma inbound deferred
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323633] hwahc_op_urb_enqueue
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323640] xfer d32020c0 urb d30e6180 pipe 0xc0008280 [4096 bytes] dma inbound deferred
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323647] hwahc_op_urb_enqueue
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323652] xfer d3202780 urb d30e6900 pipe 0xc0008280 [4096 bytes] dma inbound deferred
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323659] hwahc_op_urb_enqueue
> > > Jun 11 16:43:14 localhost kernel: [ 1959.323665] xfer d3202800 urb d30e6100 pipe 0xc0008280 [4096 bytes] dma inbound deferred
> > > Jun 11 16:43:14 localhost kernel: [ 1956.607877] hwa-hc 1-4:1.1: DTI: xfer d3202000#0 failed (0x87)
> > > Jun 11 16:43:14 localhost kernel: [ 1956.607877] giveback d3202000 -84
> > 
> > As you can see, the S-G element lengths for this I/O request were 3584, 
> > 4096, 4096, 4096, totalling 15872 bytes.  I don't know what workload 
> > caused this request to be generated; maybe Antonio can tell us.
> 
> OK, I can see that happening for fs IO if the block alignment odd. The
> 1kb block size would definitely fix that, but cause SCSI to treat you as
> such and cause problems as well. Alright, I'll write something up for
> you to bounce such a request.

Any progress?

Alan Stern

