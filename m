Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYDKGaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYDKGaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYDKGaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:30:04 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:18901 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752051AbYDKGaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:30:01 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-29.messagelabs.com!1207895397!10601790!13
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 11 Apr 2008 08:21:06 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080411062106.GA18096@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410224804.GI3193@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Apr 2008 06:21:07.0046 (UTC) FILETIME=[3A01D060:01C89B9C]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--27.737100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

Hans J. Koch wrote:
> > +/* XXX: I thought there already exists something like STRINGIFY, but I could not
> > + * find it ...
> > + */
> 
> Why do you want that macro? You only use it once. The macro definition and the
> comment above are more than you can ever expect to save with it.
See below.
BTW, I found it, it's in linux/stringify.h.  And there are several
possible users:

	ukleinek@zentaur:~/gsrc/linux-2.6$ git ls-files -z | xargs -0 perl -n -e 'print "$ARGV\n" if (/define\s+\w+\((\w+)\)\s*#\s*$1/)'
	arch/arm/vfp/vfpinstr.h
	arch/cris/arch-v10/boot/tools/build.c
	arch/m68k/lib/checksum.c
	arch/mips/kernel/unaligned.c
	arch/powerpc/boot/reg.h
	arch/um/drivers/mconsole_user.c
	arch/um/include/sysdep-i386/kernel-offsets.h
	arch/um/include/sysdep-x86_64/kernel-offsets.h
	arch/x86/kernel/machine_kexec_32.c
	drivers/atm/ambassador.c
	drivers/media/video/cpia2/cpia2_v4l.c
	drivers/mtd/maps/amd76xrom.c
	drivers/mtd/maps/ichxrom.c
	drivers/s390/cio/qdio.h
	drivers/scsi/aacraid/aacraid.h
	drivers/scsi/aacraid/linit.c
	drivers/scsi/arm/acornscsi.c
	drivers/scsi/g_NCR5380.h
	drivers/uio/uio_pdrv.c
	drivers/usb/serial/garmin_gps.c
	include/asm-cris/arch-v10/irq.h
	include/asm-cris/arch-v32/hwregs/supp_reg.h
	include/asm-cris/arch-v32/irq.h
	include/asm-m32r/assembler.h
	include/asm-m68k/entry.h
	include/asm-mips/mipsregs.h
	include/asm-mips/sim.h
	include/asm-sh/cpu-sh5/registers.h
	include/asm-v850/macrology.h
	include/linux/stringify.h
	include/sound/core.h
	sound/core/memalloc.c
	usr/gen_init_cpio.c

> > +static int uio_pdrv_open(struct uio_info *info, struct inode *inode)
> > +{
> > +	struct uio_platdata *pdata = info->priv;
> > +	int ret;
> > +
> > +	BUG_ON(pdata->uioinfo != info);
> 
> How can this BUG ever be triggered?
I hope it cannot, that's why it is a bug if it happens. :-)  And one
should expect that no BUG_ON should ever be triggered.  I usually use
BUG_ON for "declaring" preconditions.
 
> > +	for (i = 0; i < pdev->num_resources; ++i) {
> > +		struct resource *r = &pdev->resource[i];
> 
> Please don't define new variables in the middle of a function.
This is a matter of taste.  In my eyes it's better to declare it here
because then it's easier to see where it's used.
 
> > +
> > +		if (r->flags != IORESOURCE_MEM)
> > +			continue;
> > +
> > +		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
> 
> I'd prefer this:
> 		if (i >= MAX_UIO_MAPS) {
> 		...
OK.

BTW would you be open to redefine uio_info as:

	struct uio_info {
		struct uio_device       *uio_dev;
		...
		size_t			num_memmaps;
		struct uio_mem		mem[];
	}

This allows to allocate exactly the number of members in the mem array
that are needed (for the cost of a size_t).  (You just do:

	uio_info uioinfo = kzalloc(sizeof(*uioinfo) + num_memmaps * sizeof(uioinfo->mem[0]), GFP_KERNEL);

it's still one chunk of memory and usage is similar---just with
MAX_UIO_MAPS substituted by uioinfo->num_memmaps.)
	
> > +			dev_warn(&pdev->dev, "device has more than "
> > +					STRINGIFY(MAX_UIO_MAPS)
> > +					" I/O memory resources.\n");
> 
> What about this:
> 
> 			dev_warn(&pdev->dev, "device has more than %d"
> 				" I/O memory resources.\n", MAX_UIO_MAPS);
> 
> would save the macro.
The macro is for free, using "%d" is not:

	ukleinek@zentaur:~/kbuild-ns921x$ size drivers/uio/uio_pdrv_with*
	   text    data     bss     dec     hex filename
	    808      72       0     880     370 drivers/uio/uio_pdrv_withoutstringify.o
	    800      72       0     872     368 drivers/uio/uio_pdrv_withstringify.o

You might consider that a bit over-engineered :-)

> > +	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
> > +
> > +	if (ret) {
> > +		clk_put(pdata->clk);
> > +err_clk_get:
> > +
> > +		kfree(pdata);
> > +err_alloc_pdata:
> > +err_uioinfo:
> > +		return ret;
> > +	}
> 
> How I hate labels within blocks... OK, I admit, it looks good here...
> Well...
That's a matter of taste, too, I like it that way.  Probably it doesn't
matter for the compiler (I havn't tried), but this way it's one goto
less.  And if it doesn't matter for the compiler it's at least nice for
the reader.  Though obviously YMMV.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
