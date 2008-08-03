Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYHCOzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYHCOzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbYHCOzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:55:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:22121 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbYHCOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=hkvCLOePC+dKgX4hnWearOPu4bJBT8AqXnRgRArPK6e4BfYXngWBK8L729PwUaCXLW
         KUfgOe5tovh+HzYoFJDAElvLaJh8Y5Yq/ntNOy3wBoKTdfeTxlpz4kvUmtmsnlpAJESb
         w39ZJOTdmLofWxaumjDU+Em/psNS+e1bJVtXE=
Date: Sun, 3 Aug 2008 16:54:57 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] ide-generic: handle probing of legacy io-ports
Message-ID: <20080803145457.GB27766@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, alan@redhat.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808022046.16990.bzolnier@gmail.com> <20080803073842.GB8762@gollum.tnic> <200808031611.11033.bzolnier@gmail.com> <20080803144539.GA27766@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080803144539.GA27766@gollum.tnic>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 04:45:39PM +0200, Borislav Petkov wrote:
> On Sun, Aug 03, 2008 at 04:11:10PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > On Sunday 03 August 2008, Borislav Petkov wrote:
> > > From: Borislav Petkov <petkovbb@gmail.com>
> > > Date: Sun, 3 Aug 2008 09:28:53 +0200
> > > Subject: [PATCH 2/2] ide-generic: handle probing of legacy io-ports
> > > 
> > > Avoid probing the io-ports in case an IDE PCI controller is present and it uses
> > > the legacy iobases. If we still want to enforce the probing, we do
> > > 
> > > ide_generic.probe_mask=0x3f
> > > 
> > > on the kernel command line.
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > 
> > Thanks for reworking the patch, looks much better now.
> > 
> > There are still some issues to address though.
> > 
> > > ---
> > >  drivers/ide/ide-generic.c |   23 ++++++++++++++++++-----
> > >  1 files changed, 18 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
> > > index 8fe8b5b..7d79616 100644
> > > --- a/drivers/ide/ide-generic.c
> > > +++ b/drivers/ide/ide-generic.c
> > > @@ -27,7 +27,7 @@
> > >  
> > >  #define DRV_NAME	"ide_generic"
> > >  
> > > -static int probe_mask = 0x03;
> > > +static int probe_mask = 0x00;
> > 
> > No need to initialize it now.
> 
> right, static.
> 
> > >  module_param(probe_mask, int, 0);
> > >  MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
> > >  
> > > @@ -105,18 +105,31 @@ static int __init ide_generic_init(void)
> > >  	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
> > >  	struct ide_host *host;
> > >  	unsigned long io_addr;
> > > -	int i, rc;
> > > +	int i, rc, dummy, primary = 0, secondary = 0;
> > >  
> > >  #ifdef CONFIG_MIPS
> > >  	if (!ide_probe_legacy())
> > >  		return -ENODEV;
> > >  #endif
> > > -	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
> > > -			 "parameter for probing all legacy ISA IDE ports\n");
> > > +	ata_legacy_check_iobases(&primary, &secondary, &dummy);
> > > +
> > > +	if (primary) {
> > 
> > Shouldn't this also check for secondary?
> 
> you don't have to since primary is set to one in all cases.

crap, forget what i said here ^ :(.

-- 
Regards/Gruss,
    Boris.
