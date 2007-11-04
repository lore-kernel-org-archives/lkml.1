Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbXKDKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbXKDKvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 05:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbXKDKvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 05:51:24 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:23159 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbXKDKvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 05:51:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NushnOxD3xj8KCYCDgMngLhTEzDXLdXHxofkpOjQJbYYM16ksvRZ4KGRiDJulUZcJfQ1VHAbDFsVNhnM18ZnmygJQEU45UEVJaPyIeaGBSx2pm41xm3bEvnoKYl0j9R0ayAznV6QjG5g74emRa0irad1K5M/j4tcn7+tFEGGDXQ=
Message-ID: <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
Date: Sun, 4 Nov 2007 11:51:21 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to boot: kernel BUG at include/linux/scatterlist.h:49!
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <20071104084456.GJ28340@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
	 <472BA567.8040301@s5r6.in-berlin.de>
	 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
	 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk>
	 <20071104084456.GJ28340@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Sat, Nov 03 2007, Jens Axboe wrote:
> > It's probably enough. Only if you use chaining do you need to convert to
> > using for_each_sg() and so on.
>
> Did a grep over ieee1394/, this seems to be all you need.

What *I* need. For eth1394.

Stefan Richter wrote:
> (The other place where the 1394 stack deals with s/g lists is sbp2 where
> we have to deal with what comes from the SCSI stack or the block layer.
> But sbp2's s/g list handling is entirely unrelated to ieee1394's own
> code for isochronous I/O and async streams, which eth1394 needs and
> caused the bug.)

I see nothing preventing chained sg lists to be feed into
sbp2scsi_queuecommand() which then gives these lists to
sbp2_prep_command_orb_sg().

And there I find this:
static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
                                     struct sbp2_fwhost_info *hi,
                                     struct sbp2_command_info *cmd,
                                     unsigned int scsi_use_sg,
                                     struct scatterlist *sgpnt,
                                     u32 orb_direction,
                                     enum dma_data_direction dma_dir)
{
[snip]
for (i = 0, sg_count = 0 ; i < count; i++, sgpnt++) {


As yesterday my md1_raid5-thread oopsed with the same bug from the
thread "kernel NULL pointer dereference in blk_rq_map_sg with
v2.6.23-6815-g0895e91" I'm rather suspicious of anything sg related
right now. (At least I think its the same bug, as 2.6.23-mm1 does not
contain the fix from that thread)

> diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
> index f5f4983..7c4eb39 100644
> --- a/drivers/ieee1394/dma.c
> +++ b/drivers/ieee1394/dma.c
> @@ -103,8 +103,7 @@ int dma_region_alloc(struct dma_region *dma, unsigned long n_bytes,
>                 goto err;
>         }
>
> -       /* just to be safe - this will become unnecessary once sglist->address goes away */
> -       memset(dma->sglist, 0, dma->n_pages * sizeof(*dma->sglist));
> +       sg_init_table(dma->sglist, dma->n_pages);
>
>         /* fill scatter/gather list with pages */
>         for (i = 0; i < dma->n_pages; i++) {
>

With that patch, 2.6.24-rc1-b4f555081fdd27d13e6ff39d455d5aefae9d2c0c
boots, eth1394 works.

Torsten
