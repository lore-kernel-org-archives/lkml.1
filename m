Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZFZIUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZFZIUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZFZIUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:20:03 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:43882 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZFZIUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xIg9Do/W2rxEYKmvY2E2wAS0GEnU8gjYTGZe8P90bk0zxb16rJ1yDlA5s7h/cE88yE
         u5i4j41+uXGsneoEdo6b6cUURc3+C98eD455UuFAfHIZgIZjh5mt8X8KYzSOu3JUp8uR
         /zBMJys0mvuB6fF9d/aWAU+Dz4dYxLYIcuzy4=
Date: Fri, 26 Jun 2009 10:19:58 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: handle fragmented packet commands gracefully
Message-ID: <20090626081958.GA15449@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	David Miller <davem@davemloft.net>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1245574527-2104-1-git-send-email-petkovbb@gmail.com> <200906221150.22992.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200906221150.22992.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Jun 22, 2009 at 11:50:22AM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 21 June 2009 10:55:27 Borislav Petkov wrote:
> > There are some devices in the wild that clear the DRQ bit during the
> > last word of a packet command and therefore could use a "second chance"
> > for that last word of data to be xferred instead of simply failing the
> > request. Do that by attempting to suck in those last bytes in PIO mode.
> > 
> > In addition, the ATA_ERR bit has to be cleared for we cannot be sure the
> > data is valid otherwise.
> > 
> > See http://bugzilla.kernel.org/show_bug.cgi?id=13399 for details.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

can you pick that one too, please. I can't seem to find it on patchwork.

Thanks.

> 
> > ---
> >  drivers/ide/ide-cd.c |   14 ++++++++++++--
> >  1 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 4a19686..8d3f7d0 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -592,9 +592,19 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
> >  			}
> >  		} else if (!blk_pc_request(rq)) {
> >  			ide_cd_request_sense_fixup(drive, cmd);
> > -			/* complain if we still have data left to transfer */
> > +
> >  			uptodate = cmd->nleft ? 0 : 1;
> > -			if (uptodate == 0)
> > +
> > +			/*
> > +			 * suck out the remaining bytes from the drive in an
> > +			 * attempt to complete the data xfer. (see BZ#13399)
> > +			 */
> > +			if (!(stat & ATA_ERR) && !uptodate && thislen) {
> > +				ide_pio_bytes(drive, cmd, write, thislen);
> > +				uptodate = cmd->nleft ? 0 : 1;
> > +			}
> > +
> > +			if (!uptodate)
> >  				rq->cmd_flags |= REQ_FAILED;
> >  		}
> >  		goto out_end;

-- 
Regards/Gruss,
    Boris.
