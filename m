Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbXKAJsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbXKAJsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXKAJsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:48:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34866 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbXKAJsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:48:30 -0400
Message-ID: <4729A0DF.20800@garzik.org>
Date: Thu, 01 Nov 2007 05:48:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Drake <dsd@gentoo.org>
CC: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org> <20071030153417.59b9182c@the-village.bc.nu> <47276DCA.1000808@gentoo.org> <20071030190153.373c9347@the-village.bc.nu> <47278439.4030801@gentoo.org> <20071031114958.210bd7cc@the-village.bc.nu> <20071031115754.GK5059@kernel.dk>
In-Reply-To: <20071031115754.GK5059@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, gave this a hard look.

This is basically a behavior change with regards to how we program the 
bcount(low) and bcount(high) registers.

Issues about FIFO draining and devices returning too-much data are 
ultimately tangential.  Furthermore, this is an ATAPI PIO issue, as 
demonstrated by (a) Alan's patch did not change DMA lbam/lbah 
programming and (b) Daniel's report of the message "ata2.00: 66 bytes 
trailing data" which occurs in the PIO state machine.

To survey the behaviors for ATAPI PIO:

ide-cd:			read/write commands,	blimit = 32k
			others cmds,		blimit = xfer_len

old libata (pre-Alan):	blimit = 8k

new libata behavior:	blimit = xfer_len

thus Alan's patch was moving us CLOSER to ide-cd's behavior (if we 
ignore read/write commands for the moment, which are not at issue).

and the end result is that the change from old-libata to new-libata 
behavior broke Daniel's case, which is a device known to ignore the SCSI 
command CDB's allocation length field.

Additionally, let's add some background:

libata was originally written for first-gen SATA controllers (incl. 
first-gen SATA bridges), most notably ata_piix, the controller Daniel is 
using.

I chose blimit 8k because I felt that matches the maximum size of a SATA 
Data FIS.  I felt -- this was a wild-added guess -- that setting blimit 
thusly would properly configure all the magic internal FIFOs and data 
buffers in silicon that handled these crazy ATAPI devices with random 
transfer lengths.

I am not drawing any conclusions yet, but I'm thinking that blimit=8k 
may be a better choice for SATA ATAPI.

Other comment:

* as Tejun noted in IRC, we don't have a clear idea of what triggered 
the HSM violation.  turning on debugging printk's would help, but 
unfortunately that means turning them on for everything, including hard 
drives.

	Jeff


