Return-Path: <linux-kernel-owner+w=401wt.eu-S1751919AbZEWHMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbZEWHMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 03:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZEWHML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 03:12:11 -0400
Received: from [222.92.8.141] ([222.92.8.141]:39803 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZEWHMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 03:12:09 -0400
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
From: yanh <yanh@lemote.com>
Reply-To: yanh@lemote.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: wuzhangjin@gmail.com, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
In-Reply-To: <200905222032.55869.bzolnier@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <a998340033c8f89ec028b354ebe2956239144049.1242855716.git.wuzhangjin@gmail.com>
	 <200905222032.55869.bzolnier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 May 2009 15:11:42 +0800
Message-Id: <1243062702.8509.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2009-05-22五的 20:32 +0200，Bartlomiej Zolnierkiewicz写道：
> On Thursday 21 May 2009 00:12:46 wuzhangjin@gmail.com wrote:
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > This is originally from the to-mips branch from
> > http://dev.lemote.com/code/linux_loongson
> 
> Sadly, the patch description lacks all the important information.
> 
> What is the original problem that this fixup tries to address?
> 
> Is it limited to amd74xx controllers?

In loongson2f yeeloong machines, the ide controller is AMD cs5536, or
say  amd74xx, and the hard drives is Fujistu. 
While debuging the hard disk suspned and resume, the ide irq can not be
cleared. I guess this is a fake interrupt, hence the clear irq action
can not be finished. 
This patch is to fix this issue. Maybe other controller and drives also
have this issue, but I am not sure.

Thanks for your reply.  
> 
> [ We are generalizing quirk_drives handling currently... ]
> 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > ---
> >  drivers/ide/amd74xx.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/ide/amd74xx.c b/drivers/ide/amd74xx.c
> > index 77267c8..8f488b8 100644
> > --- a/drivers/ide/amd74xx.c
> > +++ b/drivers/ide/amd74xx.c
> > @@ -23,6 +23,11 @@
> >  
> >  #define DRV_NAME "amd74xx"
> >  
> > +static const char *am74xx_quirk_drives[] = {
> > +	"FUJITSU MHZ2160BH G2",
> > +	NULL
> > +};
> > +
> >  enum {
> >  	AMD_IDE_CONFIG		= 0x41,
> >  	AMD_CABLE_DETECT	= 0x42,
> > @@ -112,6 +117,19 @@ static void amd_set_pio_mode(ide_drive_t *drive, const u8 pio)
> >  	amd_set_drive(drive, XFER_PIO_0 + pio);
> >  }
> >  
> > +static void amd_quirkproc(ide_drive_t *drive)
> > +{
> > +	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
> > +
> > +	for (list = am74xx_quirk_drives; *list != NULL; list++)
> > +			if (strstr(m, *list) != NULL) {
> > +				drive->quirk_list = 2;
> > +				return;
> > +			}
> > +
> > +	drive->quirk_list = 0;
> > +}
> > +
> >  static void amd7409_cable_detect(struct pci_dev *dev)
> >  {
> >  	/* no host side cable detection */
> > @@ -194,6 +212,7 @@ static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
> >  static const struct ide_port_ops amd_port_ops = {
> >  	.set_pio_mode		= amd_set_pio_mode,
> >  	.set_dma_mode		= amd_set_drive,
> > +	.quirkproc		= amd_quirkproc,
> >  	.cable_detect		= amd_cable_detect,
> >  };
> 

