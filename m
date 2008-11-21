Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYKUK6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYKUK6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYKUK6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:58:35 -0500
Received: from ext-nj2ut-12.online-age.net ([64.14.54.245]:46301 "EHLO
	ext-nj2ut-12.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbYKUK6e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:58:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ISP1760 driver crashes
Date: Fri, 21 Nov 2008 11:58:28 +0100
Message-ID: <62DDBB9E5E23CC4A929EE46F9427CEAF015BFB56@BUDMLVEM04.e2k.ad.ge.com>
In-Reply-To: <Pine.LNX.4.44L0.0811201026280.2447-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ISP1760 driver crashes
Thread-Index: AclLJLThKZiDYBO/TRS0fmIA+NctiQAoxu4g
References: <20081120144125P.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.44L0.0811201026280.2447-100000@iolanthe.rowland.org>
From: "Hommel, Thomas (GE EntSol, Intelligent Platforms)" 
	<Thomas.Hommel@gefanuc.com>
To: "Alan Stern" <stern@rowland.harvard.edu>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <jens.axboe@oracle.com>, <bigeasy@linutronix.de>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <James.Bottomley@HansenPartnership.com>
X-OriginalArrivalTime: 21 Nov 2008 10:58:31.0660 (UTC) FILETIME=[17805AC0:01C94BC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan Stern wrote:
> 
> On Thu, 20 Nov 2008, FUJITA Tomonori wrote:
> 
> > We have been used 4GB for long time if dma_mask is zero (I guess we 
> > use 4GB as kinda the default dma address limit at several 
> places). The 
> > majority of drivers (such as pci) sets properly 
> dev->dma_mask so the 
> > patch might not change anything but suddenly changing the 
> > long-standing rule in an odd way (use BLK_BOUNCE_HIGH if dma_mask is
> > zero) doesn't sound a good idea to me.
> > 
> > Why not calling blk_queue_bounce_limit() in the 
> slave_configure hook?
> > I think that it's the common way for SCSI LLDs with odd 
> bounce limit.
> 
> Thomas, here's a patch to do what Tomonori suggests.  Try 
> replacing the old patch with this one.
> 
Thanks, I've tried the new patch and everything works ok.
Thomas

> Alan Stern
> 
> 
> Index: usb-2.6/drivers/usb/storage/scsiglue.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/scsiglue.c
> +++ usb-2.6/drivers/usb/storage/scsiglue.c
> @@ -129,6 +129,14 @@ static int slave_configure(struct scsi_d
>  					      max_sectors);
>  	}
>  
> +	/* Some USB host controllers can't do DMA; they have to use PIO.
> +	 * They indicate this by setting their dma_mask to NULL.  For
> +	 * such controllers we need to make sure the block layer sets
> +	 * up bounce buffers in addressable memory.
> +	 */
> +	if (!us->pusb_dev->bus->controller->dma_mask)
> +		blk_queue_bounce_limit(sdev->request_queue, 
> BLK_BOUNCE_HIGH);
> +
>  	/* We can't put these settings in slave_alloc() because 
> that gets
>  	 * called before the device type is known.  Consequently these
>  	 * settings can't be overridden via the scsi devinfo 
> mechanism. */
> 
> 
