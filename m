Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0BAPkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:40:32 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:55921 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0BAPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LuXWSNMnGKcTyqrpPhu7ct5O1snsG49nGINnsw4tXS4YKDD8NOOxMs08EbJv7GgNLl
         p+AJ7hBjdDkhYAFdnQ5CQWuwFbLBQCHEgwgDKA19uZvhHQb/4eeD4rwmrsdSHh2n758Z
         CTeTfTLi8LlIyRuqxHdXHlvxWGULAk/R+p0y0=
Subject: Re: [PATCH 03/17] blktrans: track open and close calls.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ricard Wanderlof <ricard.wanderlof@axis.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
In-Reply-To: <Pine.LNX.4.64.1002010845040.13031@lnxricardw.se.axis.com>
References: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
	 <1264863768-27606-4-git-send-email-maximlevitsky@gmail.com>
	 <Pine.LNX.4.64.1002010845040.13031@lnxricardw.se.axis.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 17:40:24 +0200
Message-ID: <1265038824.3785.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 08:46 +0100, Ricard Wanderlof wrote: 
> On Sat, 30 Jan 2010, Maxim Levitsky wrote:
> 
> > This patch adds tracking for open and close calls.
> > Now trans ->open and ->release are never called twise in a row
> > ->release is also called once before mtd device disappers
> > ...
> 
> > --- a/drivers/mtd/mtd_blkdevs.c
> > +++ b/drivers/mtd/mtd_blkdevs.c
> > @@ -128,6 +128,9 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
> > 	if (!get_mtd_device(NULL, dev->mtd->index))
> > 		goto out;
> >
> > +	if (dev->open++)
> > +		goto out;
> > +
> > 	if (!try_module_get(tr->owner))
> > 		goto out_tr;
> >
> > @@ -153,6 +156,10 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
> > 	struct mtd_blktrans_ops *tr = dev->tr;
> > 	int ret = 0;
> >
> > +	dev->open--;
> > +	if (dev->open)
> > +		return 0;
> > +
> 
> Just a very minor quibble: if you use if (dev->open++) in one function, 
> why not use if (--dev->open) in the other? Or separate the 
> increment/decrement from the test, depending on you style preferences.
No problem, this just got lost in all the noise.
I tried all kinds of approaches to make hotplug reliable, before finally
making it be so. (It is really stable here, I didn't have any hotplug
related issues for very long time)

In fact I feel that my xd card is more stable that sd one...
(I recently found a bug in sdhci driver....)

I would be very happy to receive a full review of the patches, and get
it in the kernel.

Best regards,
Maxim Levitsky



