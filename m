Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbXEJMl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbXEJMl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXEJMls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:41:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57415 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbXEJMlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:41:47 -0400
Date: Thu, 10 May 2007 13:41:45 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: HDIO_DRIVE_CMD and hdparm
Message-ID: <20070510124145.GA19856@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 02:12:59PM +0200, Geert Uytterhoeven wrote:
> 	Hi,
> 
> `hdparm -t' uses HDIO_DRIVE_CMD(null) to flush the disk's buffer.
> When using it on my own block device (the new PS3 disk storage driver), hdparm
> gives the following error message:
> 
> | HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Inappropriate ioctl for device
> 
> When using it on an ATA or SCSI device, no such error message is printed.
> 
> According to the hdparm sources, hdparm expects the HDIO_DRIVE_CMD(null) ioctl
> to either succeed, or to fail with errno EINVAL.
> 
> Apparently handling of ioctls is different for the different device types:
>   - ATA/SATA handle HDIO_DRIVE_CMD(null) (and a few other variants)
>     => fine for hdparm
>   - SCSI doesn't handle HDIO_DRIVE_CMD(null), and returns EINVAL
>     => fine for hdparm
>   - If a block device doesn't support the ioctl, blkdev_driver_ioctl() returns
>     ENOTTY
>     => hdparm error message
> 
> Which one is correct?
>   - blkdev_ioctl()/blkdev_driver_ioctl() return -ENOTTY
>   - scsi_cmd_ioctl() returns -ENOTTY
>   - scsi_ioctl() returns -EINVAL
>   - cdrom_ioctl() returns -ENOSYS to mean not handled, continue
>   - some block layer routines return -ENOIOCTLCMD to mean not handled, continue

ENOTTY is the traditional unix errno value for this ioctl is not implemented.
ENOIOCTLCMD is a new fashioned code meaning about the same.  In the block
layer the latter should be used as generic code should handlde this.

> 
> My questions:
>   1. Does any of these have to be fixed?
>   2. Shall I add a dummy HDIO_DRIVE_CMD(null) handler to my block device to
>      return -EINVAL?
>   3. Shall I just ignore the hdparm error message?

I suspect you can just ignore this.  Even better send a patch to the hdparm
maintainer to deal with ENOTTY aswell.
