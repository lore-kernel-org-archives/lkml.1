Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZDPFpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZDPFpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZDPFpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:45:06 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64304 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbZDPFpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:45:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=Im32wDL5nRu9HbXshZ4LUVwq7yWQ4BCrso+9NkRDBOMg2qtW4cVGjTGHVylY6M5pqQ
         sYlk1+C/TuxCYqhlmCjHpD5La2qfQUE+BOdfV2F8a5+XTKtNdmouuyaapLuAzi0fFYJu
         Iu13RFTUanlLXf/vnzoWNTiDj9fo84pwTBHwM=
Date: Thu, 16 Apr 2009 07:44:57 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com,
       James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
       axboe@kernel.dk, bzolnier@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Message-ID: <20090416054457.GA13226@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	bharrosh@panasas.com, James.Bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org, axboe@kernel.dk, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org
References: <49E6A0B5.2090704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49E6A0B5.2090704@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 16, 2009 at 12:06:29PM +0900, Tejun Heo wrote:
> I updated the patch a bit and folded it into the series after patch
> 10.  I hope I didn't butcher the patch too bad.  Can I add your
> Signed-off-by: on the modified patch?  Also, I just started working on
> the atapi version.  Do you already have something?

Ok here's what I got: I went and converted all ide-cd and ide-atapi to
using a common routine ide_prep_sense, see following patches for that.
Preliminary testing is promising but you never know :).

[..]

> Preallocate a sense request in the ->do_request method and reinitialize
> it only on demand, in case it's been consumed in the IRQ handler path.
> The reason for this is that we don't want to be mapping rq to bio in
> the IRQ path and introduce all kinds of unnecessary hacks to the block
> layer.
> 
> tj: * After this patch, ide_cd_do_request() might sleep.  This should
>       be okay as ide request_fn - do_ide_request() - is invoked only
>       from make_request and plug work.  Make sure this is the case by
>       adding might_sleep() to do_ide_request().
> 
>     * Adapted to apply to the tree without blk_rq_map_prealloc()
>       changes.
> 
>     * Use of blk_rq_map() and possible failure handling from it are
>       moved to later separate patch.  ide_cd_prep_sense() now handles
>       everything regarding sense rq preparation.
>
>     * Move ide_drive->rq_sense to cdrom_info->sense_rq and put the
>       request when releasing cdrom_info.

I put the request_sense buffer as defined in <linux/cdrom.h> into the
drive struct so that each device can have its own buffer. IMHO, request
sense standard data should be pretty identical across most ATAPI devices
(yeah, I'm sure there are exceptions :)). We might move the struct
request_sense to a more generic location instead of <linux/cdrom.h> if
we decide to go with that.

>     * Both user and kernel PC requests expect sense data to be stored
>       in separate storage other than info->sense_data.  Copy sense
>       data to rq->sense on completion if rq->sense is not NULL.  This
>       fixes bogus sense data on PC requests.

I took that into my version of the patch.

Anyway, please do have a closer look in case I've missed something. Of
course you can split them the way you see fit, there's more to be done
there anyways but should suffice for your block layer stuff, I hope.

Thanks.

-- 
Regards/Gruss,
    Boris.
