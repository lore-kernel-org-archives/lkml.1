Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0BAIAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:00:08 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:43383 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab0BAIAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:00:05 -0500
X-Greylist: delayed 786 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 03:00:05 EST
Date: Mon, 1 Feb 2010 08:46:44 +0100 (CET)
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw.se.axis.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 03/17] blktrans: track open and close calls.
In-Reply-To: <1264863768-27606-4-git-send-email-maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.1002010845040.13031@lnxricardw.se.axis.com>
References: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
 <1264863768-27606-4-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 30 Jan 2010, Maxim Levitsky wrote:

> This patch adds tracking for open and close calls.
> Now trans ->open and ->release are never called twise in a row
> ->release is also called once before mtd device disappers
> ...

> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -128,6 +128,9 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
> 	if (!get_mtd_device(NULL, dev->mtd->index))
> 		goto out;
>
> +	if (dev->open++)
> +		goto out;
> +
> 	if (!try_module_get(tr->owner))
> 		goto out_tr;
>
> @@ -153,6 +156,10 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
> 	struct mtd_blktrans_ops *tr = dev->tr;
> 	int ret = 0;
>
> +	dev->open--;
> +	if (dev->open)
> +		return 0;
> +

Just a very minor quibble: if you use if (dev->open++) in one function, 
why not use if (--dev->open) in the other? Or separate the 
increment/decrement from the test, depending on you style preferences.

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
