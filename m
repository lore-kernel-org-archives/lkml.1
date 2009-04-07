Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbZDGGjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbZDGGjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbZDGGic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:38:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:10829 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbZDGGia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=BOTTlRSN5FN3kOk9vm8b4GlClQ7++CHYDFHVnOmDJ3YFwc811MgmINlVLDsVRABopq
         mA2961zgb6CAropRmTcDoUaYC1+BqFZ5Mt7H/WK84JnxfEpzbL+w9Snqnb6t2tU8Fh7S
         XZI4eNg/p/JrDpc4YcEakIRik7EhYM4ll4WFU=
Date: Tue, 7 Apr 2009 08:38:21 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] ide-cd: cdrom_decode_status: use return codes
	instead of naked numbers
Message-ID: <20090407063821.GB4532@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238922962-19727-2-git-send-email-petkovbb@gmail.com> <200904062300.16108.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200904062300.16108.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 06, 2009 at 11:00:15PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 05 April 2009, Borislav Petkov wrote:
> > Remove unused SECTOR_SIZE while at it.
> > 
> > There should be no functional change resulting from this patch.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> [...]
> 
> > @@ -431,7 +425,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
> >  	/* if we got a CHECK_CONDITION status, queue a request sense command */
> >  	if (stat & ATA_ERR)
> >  		cdrom_queue_request_sense(drive, NULL, NULL);
> > -	return 1;
> > +	return REQ_RECOVER;
> >  
> >  end_request:
> >  	if (stat & ATA_ERR) {
> > @@ -445,9 +439,9 @@ end_request:
> >  		hwif->rq = NULL;
> >  
> >  		cdrom_queue_request_sense(drive, rq->sense, rq);
> > -		return 1;
> > -	} else
> > -		return 2;
> > +		return REQ_RECOVER;
> > +	}
> > +	return REQ_FAIL;
> >  }
> 
> Could it be that cdrom_newpc_intr() chunk got lost somewhere along the way,
> IIRC it was there?

That I dropped :), my bad.

> > +/* internal decode_status codes */
> > +#define REQ_CONT               0
> > +#define REQ_RECOVER            1
> > +#define REQ_FAIL               2
> 
> Did you notice my comments about REQ_* in previous mail?

Yep, about those - is there a valid reason for calling them IDE_RQ_*?
I know REQ_* is too generic but since they're private to the driver it
really is the only proper naming you _can_ have without adding too much
information to the name. FWIW, SCSI has even more generic names for them
- SUCCESS, FAILED, etc. And the IDE_* prefix is only then called for
when they're going to be visible/used by some other IDE parts. So IMHO
REQ_* or RQ_* is actually better in this case.

-- 
Regards/Gruss,
    Boris.
