Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbXBSQG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbXBSQG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbXBSQG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:06:26 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:18801 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932379AbXBSQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:06:26 -0500
Date: Mon, 19 Feb 2007 11:06:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: dougg@torque.net, <linux-kernel@vger.kernel.org>, <jens.axboe@oracle.com>,
       <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <45d89a8b.QpxTpRwQB4A12sQN%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.44L0.0702191051210.13197-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007, Joerg Schilling wrote:

> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > Alternatively the SG_GET_RESERVED_SIZE ioctl could be
> > > modified to yield no more than max_sectors*512 .
> >
> > There should be one single ioctl which can be applied uniformly to all
> > CD-type devices (in fact, to all devices using a request_queue) to learn
> > max_sectors.  This rules out using SG_GET_RESERVED_SIZE.
> 
> This has nothing to do with CD-type devices!
> It is related to SCSI tansport.

Actually, it isn't even related to SCSI transport; it is related to the
request_queue interface.  Even for devices which don't use a SCSI
transport, the request_queue code limits transfer lengths to max_sectors.

> > Furthermore, if you changed SG_GET_RESERVED_SIZE in this way you would 
> > only increase the confusion.  The reserved size isn't directly related to 
> > the maximum allowed DMA length, and there's no point pretending it is.  
> > What if it turns out that the reserved size is smaller than max_sectors?  
> > Then you'd force user programs to do I/O in chunks that were smaller than 
> > necessary.

I take back that last sentence.  If the reserved size was smaller than 
max_sectors then nothing would be changed.

> It would not increase confusion but reduce confusion because all
> programs would later behave correctly without the need to change them.

Well, if Doug wants to reduce the value returned by SG_GET_RESERVED_SIZE, 
it's okay with me.  An advantage of doing this is that older versions of 
cdrecord would then work correctly.

However you don't seem to realize that people can use programs like
cdrecord with devices whose drivers don't support SG_GET_RESERVED_SIZE --
because that ioctl works only with sg.  Programs would have to try
SG_GET_RESERVED_SIZE and if it faied, then try BLKSECTGET.

Remember also, the "reserved size" is _not_ the maximum allowed size of a
DMA transfer.  Rather, it is the size of an internal buffer maintained by
sg.  It's legal to do an I/O transfer larger than the "reserved size", but 
it is not legal to do an I/O transfer larger than max_sectors.

Alan Stern

