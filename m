Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYCGFs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYCGFs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYCGFsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:48:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:25709 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbYCGFsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=HL6zVzv/FCCeb05UtV2Tde+gcyJ4qldse1NRxO2qkMeeaXOXXjzrfjdp+Te9a/eowbGaICRphfT0v2ppIDN0hj7FchCmH7BENfEl8iM0jkBH/Y9inzuWh/XShW+y8WbPzP41k3QHzx618b10jDj9AFqFj9r8nTD/JHnDio6D3W0=
Date: Fri, 7 Mar 2008 06:48:25 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: walt <w41ter@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Commit 9f10d9ee breaks CD mounting/burning
Message-ID: <20080307054825.GA19778@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	walt <w41ter@gmail.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200803062235.00396.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803062235.00396.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 10:35:00PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> On Thursday 06 March 2008, walt wrote:
> > Hi Bartolmiej,
> > 
> > For me, this commit causes the problem it's intended to fix:
> > 
> > commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
> > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date:   Tue Feb 26 21:50:35 2008 +0100
> > 
> >      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
> > 
> >      This fixes some hangs caused by not finishing the transfer before ending
> >      the request and also makes use of 'ireason == 1' quirk for spurious IRQs.
> > 
> > When I mount a CD there is a long delay, and I see this error message:
> > 
> > hdc: ide_cd_check_ireason: wrong transfer direction!
> > cdrom: failed setting lba address space
> > hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > ide: failed opcode was: unknown
> > hdc: drive not ready for command
> > <repeated many times>
> > 
> > When I revert this commit everything works properly again, including
> > CD burning.
> > 
> > Here is the drive info:
> > 
> > hdc: TSSTcorpCD/DVDW SH-S182M, ATAPI CD/DVD-ROM drive
> > hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> > hdc: UDMA/33 mode selected
> > hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> > Uniform CD-ROM driver Revision: 3.20
> > hdc: UDMA/33 mode selected
> > 
> > I'm happy to try patches or supply more info, just let me know
> > what you need.
> 
> Does the following patch help?
> 
> [ Borislav, please take a look and double check that it is OK. ]
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: mark REQ_TYPE_ATA_PC write requests with REQ_RW flag
> 
> On Thursday 06 March 2008, walt wrote:
> 
> > For me, this commit causes the problem it's intended to fix:
> > 
> > commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
> > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Date:   Tue Feb 26 21:50:35 2008 +0100
> > 
> >      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
> > 
> >      This fixes some hangs caused by not finishing the transfer before ending
> >      the request and also makes use of 'ireason == 1' quirk for spurious IRQs.
> > 
> > When I mount a CD there is a long delay, and I see this error message:
> > 
> > hdc: ide_cd_check_ireason: wrong transfer direction!
> > cdrom: failed setting lba address space
> > hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > ide: failed opcode was: unknown
> > hdc: drive not ready for command
> > <repeated many times>
> > 
> > When I revert this commit everything works properly again, including
> > CD burning.
> 
> It turned out that REQ_TYPE_ATA_PC write requests were not marked as such
> (the previous commit assumed them to be).
> 
> Reported-by: walt <w41ter@gmail.com>
> Cc: Borislav Petkov <petkovbb@googlemail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-cd_ioctl.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: b/drivers/ide/ide-cd_ioctl.c
> ===================================================================
> --- a/drivers/ide/ide-cd_ioctl.c
> +++ b/drivers/ide/ide-cd_ioctl.c
> @@ -457,6 +457,10 @@ int ide_cdrom_packet(struct cdrom_device
>  	   layer. the packet must be complete, as we do not
>  	   touch it at all. */
>  	ide_cd_init_rq(drive, &req);
> +
> +	if (cgc->data_direction == CGC_DATA_WRITE)
> +		req.cmd_flags |= REQ_RW;
> +
>  	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
>  	if (cgc->sense)
>  		memset(cgc->sense, 0, sizeof(struct request_sense));

Here's how i understand it (and correct me if i'm wrong):

req.cmd_flags & 0x1 (i.e. the least sig. bit) was remaining unset for write requests
and that's why the ireason check in the interrupt handler was failing loudly.
This sets it correctly so that rq_data_dir(rq) evaluates to the correct data
direction of the request, no?

-- 
Regards/Gruﬂ,
    Boris.
