Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZFXKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZFXKES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZFXKEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:04:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46314 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZFXKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=RvfDwyqRCoXzHiGcwmUHkStmaU7VCN4cH0WbPsw7EHJjwgmRrwDr40UFKiNDR95lWC
         QGp6ILqYeN7/+mHvnM7K530IO9CKHgGH5jDrd60gne5p6XKh2+1R5qMlqKkkKYu21LTN
         aKyCiGn08y6X8REHg1GJ4Afv2tsyAxW9DftCo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
Date: Wed, 24 Jun 2009 12:09:53 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
References: <200906232326.06830.bzolnier@gmail.com> <20090623.234929.32348223.davem@davemloft.net>
In-Reply-To: <20090623.234929.32348223.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906241209.53891.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009 08:49:29 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 23 Jun 2009 23:26:06 +0200
> 
> > @@ -152,7 +152,7 @@ void ide_kill_rq(ide_drive_t *drive, str
> >  
> >  	if ((media == ide_floppy || media == ide_tape) && drv_req) {
> >  		rq->errors = 0;
> > -		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
> > +		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
> >  	} else {
> >  		if (media == ide_tape)
> >  			rq->errors = IDE_DRV_ERROR_GENERAL;
> 
> I've done some research and this logic of returning "0" appears to be
> intentional.
> 
> It keeps the block layer from printing the "I/O error" kernel log
> message during completion of the request.

It would be pretty illogical behavior for driver to intentionally not
let user know about the failed requests..

> IDE tape as one example, seems to have it's own system of passing
> errors back up to the special command completion, via rq->errors
> and IDE_DRV_ERROR_GENERAL.

Please look at the patch/code:

 		rq->errors = 0;
-		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
+		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));

and notice rq->errors line.

> See idetape_queue_rw_tail() and ide_tape_callback() for example.
> 
> IDE floppy has similar pieces of logic, and possibly similar desires
> wrt. emission of the block layer I/O error log message during
> special requests.
> 
> When something sticks out like an eyesore (as this -EIO thing does)
> and seems to make no sense at all, there often is some obscure
> reason.

The obscure reasons is just the fact that both ide-floppy and ide-tape
had a they own duplicated/buggy request completion routines.

While they were being unified the whole bunch of similar class of bugs
were fixed so I agree that there may still be more issues to deal with
there.
