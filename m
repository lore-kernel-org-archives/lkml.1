Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZDJVBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZDJVBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZDJVBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:01:15 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36113 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZDJVBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:01:14 -0400
Date: Fri, 10 Apr 2009 23:01:11 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: "Bryan Wu" <cooloney@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: align data size for host which only supports
 power-of-2 block
Message-ID: <20090410230111.75619035@mjolnir.ossman.eu>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA03D4261F@chinexm1.ad.analog.com>
References: <20090405210900.644a81bb@mjolnir.ossman.eu>
	<0F1B54C89D5F954D8535DB252AF412FA03D4261F@chinexm1.ad.analog.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 16:34:37 +0800
"Cai, Cliff" <Cliff.Cai@analog.com> wrote:

>  
> 
> >-----Original Message-----
> >From: Pierre Ossman [mailto:drzeus-mmc@drzeus.cx] 
> >Sent: Monday, April 06, 2009 3:09 AM
> >To: Cai, Cliff
> >Cc: Bryan Wu; linux-kernel@vger.kernel.org
> >Subject: Re: [PATCH] mmc: align data size for host which only 
> >supports power-of-2 block
> >
> >On Thu, 26 Mar 2009 10:22:54 +0800
> >"Cai, Cliff" <Cliff.Cai@analog.com> wrote:
> >
> >> >
> >> >mmc_align_data_size() shouldn't be adjusting the size to 
> >something it 
> >> >can easily determine that it's invalid.
> >> 
> >> Should I create a new function to do the power-of-2 adjustment?
> >> Or any ideal way to do it?
> >
> >That function is the correct place. My point was that we need 
> >to check after the adjustment that we didn't violate any of 
> >the other restrictions the driver has set. If we do, we should 
> >just return the original value.
> 
> What are other restrictions?I don't see any other restrictions on data
> size in current host driver
> Except 4 byte alignment.
> 

The ones that are in the mmc_host structure:

        /* host specific block data */
        unsigned int            max_seg_size;   /* see blk_queue_max_segment_size */
        unsigned short          max_hw_segs;    /* see blk_queue_max_hw_segments */
        unsigned short          max_phys_segs;  /* see blk_queue_max_phys_segments */
        unsigned short          unused;
        unsigned int            max_req_size;   /* maximum number of bytes in one req */
        unsigned int            max_blk_size;   /* maximum size of one mmc block */
        unsigned int            max_blk_count;  /* maximum number of blocks in one req */

If you adjust a transfer from 1100 bytes to 2048, that could exceed the
limit of 2047 bytes some controllers have.

> 
> >> Otherwise,the SDH almost can't be used as sdio host.
> >
> >Unfortunately I think this controller will be very unsuitable 
> >as an SDIO controller anyway with that restriction.
> 
> Yes,But since we need to support some SDIO devices according to our
> customers'
> Requests ,I think we have no other choice of this.
> 

They should be prepared for the fact that many SDIO devices cannot be
made to work with a controller with these bugs though. The function
you're modifying is only to optimise the transfer and is not mandatory
for SDIO drivers to call in any way.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
