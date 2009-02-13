Return-Path: <linux-kernel-owner+w=401wt.eu-S1761141AbZBMQhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbZBMQhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZBMQhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:37:39 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:2275 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZBMQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:37:38 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Philippe De Muyter <phdm@macqel.be>
Subject: Re: [PATCH] floppy: request and release only the ports we actually use
Date: Fri, 13 Feb 2009 09:37:31 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockrwd@gmail.com>, Adam M Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>
References: <20090205174859.18396.68512.stgit@bob.kio> <20090213085537.GA21230@frolo.macqel>
In-Reply-To: <20090213085537.GA21230@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902130937.32690.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 01:55:37 am Philippe De Muyter wrote:
> Andrew,
> 
> this is a combined patch replacing the following ones currently in
> the -mm tree :
> 	floppy-request-only-the-ports-we-actually-use.patch
> 	floppy-request-only-the-ports-we-actually-use-fix.patch
> 
> Bjorn,
> 
> Since you did the hard job of collecting the used io-ports and writing
> the changelog and part of this patch, I kept your Signed-off-by :

Great!  Thanks for putting this together.  This looks like the
right thing to me.

Bjorn


> --
> 
> The floppy driver requests an I/O port it doesn't need, and
> sometimes this causes a conflict with a motherboard device
> reported by PNPBIOS.
> 
> This patch makes the floppy driver request and release
> only the ports it actually uses.  It also factors out
> the request/release stuff and the io-ports list so
> they're all in one place now.
> 
> The current floppy driver uses only these ports:
>     0x3f2 (FD_DOR)
>     0x3f4 (FD_STATUS)
>     0x3f5 (FD_DATA)
>     0x3f7 (FD_DCR/FD_DIR)
> but it requests 0x3f2-0x3f5 and 0x3f7, which includes the
> unused port 0x3f3.
> 
> Some BIOSes report 0x3f3 as a motherboard resource.  The PNP system
> driver reserves that, which causes a conflict when the floppy driver
> requests 0x3f2-0x3f5 later.
> 
> Philippe reported that this conflict broke the floppy driver between
> 2.6.11 and 2.6.22.  His PNPBIOS reports these devices:
> 
>     $ cat 00:07/id 00:07/resources	# motherboard device
>     PNP0c02
>     state = active
>     io 0x80-0x80
>     io 0x10-0x1f
>     io 0x22-0x3f
>     io 0x44-0x5f
>     io 0x90-0x9f
>     io 0xa2-0xbf
>     io 0x3f0-0x3f1
>     io 0x3f3-0x3f3
> 
>     $ cat 00:03/id 00:03/resources	# floppy device
>     PNP0700
>     state = active
>     io 0x3f4-0x3f5
>     io 0x3f2-0x3f2
> 
> Reference:
>     http://lkml.org/lkml/2009/1/31/162
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> Reported-by: Philippe De Muyter <phdm@macqel.be>
> Tested-by: Philippe De Muyter <phdm@macqel.be>
> CC: Adam M Belay <abelay@mit.edu>
> CC: Robert Hancock <hancockrwd@gmail.com>
> ---
> diff -r 94166a3a38bd drivers/block/floppy.c
> --- a/drivers/block/floppy.c	Sat Jan 31 15:56:23 2009 -0800
> +++ b/drivers/block/floppy.c	Fri Feb 13 09:24:51 2009 +0100
> @@ -558,6 +558,8 @@ static void recalibrate_floppy(void);
>  static void recalibrate_floppy(void);
>  static void floppy_shutdown(unsigned long);
>  
> +static int floppy_request_regions(int);
> +static void floppy_release_regions(int);
>  static int floppy_grab_irq_and_dma(void);
>  static void floppy_release_irq_and_dma(void);
>  
> @@ -4274,8 +4276,7 @@ static int __init floppy_init(void)
>  		FDCS->rawcmd = 2;
>  		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
>  			/* free ioports reserved by floppy_grab_irq_and_dma() */
> -			release_region(FDCS->address + 2, 4);
> -			release_region(FDCS->address + 7, 1);
> +			floppy_release_regions(fdc);
>  			FDCS->address = -1;
>  			FDCS->version = FDC_NONE;
>  			continue;
> @@ -4284,8 +4285,7 @@ static int __init floppy_init(void)
>  		FDCS->version = get_fdc_version();
>  		if (FDCS->version == FDC_NONE) {
>  			/* free ioports reserved by floppy_grab_irq_and_dma() */
> -			release_region(FDCS->address + 2, 4);
> -			release_region(FDCS->address + 7, 1);
> +			floppy_release_regions(fdc);
>  			FDCS->address = -1;
>  			continue;
>  		}
> @@ -4358,6 +4358,47 @@ out_put_disk:
>  
>  static DEFINE_SPINLOCK(floppy_usage_lock);
>  
> +static const struct io_region {
> +	int offset;
> +	int size;
> +} io_regions[] = {
> +	{ 2, 1 },
> +	/* address + 3 is sometimes reserved by pnp bios for motherboard */
> +	{ 4, 2 },
> +	/* address + 6 is reserved, and may be taken by IDE.
> +	 * Unfortunately, Adaptec doesn't know this :-(, */
> +	{ 7, 1 },
> +};
> +
> +static void floppy_release_allocated_regions(int fdc, const struct io_region *p)
> +{
> +	while (p != io_regions) {
> +		p--;
> +		release_region(FDCS->address + p->offset, p->size);
> +	}
> +}
> +	
> +#define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
> +
> +static int floppy_request_regions(int fdc)
> +{
> +	const struct io_region *p;
> +
> +	for (p = io_regions; p < ARRAY_END(io_regions); p++) {
> +		if (!request_region(FDCS->address + p->offset, p->size, "floppy")) {
> +			DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + p->offset);
> +			floppy_release_allocated_regions(fdc, p);
> +			return -EBUSY;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void floppy_release_regions(int fdc)
> +{
> +	floppy_release_allocated_regions(fdc, ARRAY_END(io_regions));
> +}
> +
>  static int floppy_grab_irq_and_dma(void)
>  {
>  	unsigned long flags;
> @@ -4399,18 +4440,8 @@ static int floppy_grab_irq_and_dma(void)
>  
>  	for (fdc = 0; fdc < N_FDC; fdc++) {
>  		if (FDCS->address != -1) {
> -			if (!request_region(FDCS->address + 2, 4, "floppy")) {
> -				DPRINT("Floppy io-port 0x%04lx in use\n",
> -				       FDCS->address + 2);
> -				goto cleanup1;
> -			}
> -			if (!request_region(FDCS->address + 7, 1, "floppy DIR")) {
> -				DPRINT("Floppy io-port 0x%04lx in use\n",
> -				       FDCS->address + 7);
> -				goto cleanup2;
> -			}
> -			/* address + 6 is reserved, and may be taken by IDE.
> -			 * Unfortunately, Adaptec doesn't know this :-(, */
> +			if (floppy_request_regions(fdc))
> +				goto cleanup;
>  		}
>  	}
>  	for (fdc = 0; fdc < N_FDC; fdc++) {
> @@ -4432,15 +4463,11 @@ static int floppy_grab_irq_and_dma(void)
>  	fdc = 0;
>  	irqdma_allocated = 1;
>  	return 0;
> -cleanup2:
> -	release_region(FDCS->address + 2, 4);
> -cleanup1:
> +cleanup:
>  	fd_free_irq();
>  	fd_free_dma();
> -	while (--fdc >= 0) {
> -		release_region(FDCS->address + 2, 4);
> -		release_region(FDCS->address + 7, 1);
> -	}
> +	while (--fdc >= 0)
> +		floppy_release_regions(fdc);
>  	spin_lock_irqsave(&floppy_usage_lock, flags);
>  	usage_count--;
>  	spin_unlock_irqrestore(&floppy_usage_lock, flags);
> @@ -4501,10 +4528,8 @@ static void floppy_release_irq_and_dma(v
>  #endif
>  	old_fdc = fdc;
>  	for (fdc = 0; fdc < N_FDC; fdc++)
> -		if (FDCS->address != -1) {
> -			release_region(FDCS->address + 2, 4);
> -			release_region(FDCS->address + 7, 1);
> -		}
> +		if (FDCS->address != -1)
> +			floppy_release_regions(fdc);
>  	fdc = old_fdc;
>  }
>  
> 


