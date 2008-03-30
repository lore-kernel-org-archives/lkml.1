Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYC3TWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYC3TWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYC3TWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:22:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:13225 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYC3TWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YkyS2bKADk6VE3yT0+ZuWsSMw5WVSsjwtEJlx0jI3mh9w0X8sn1dh1X9lRg+gEuyWjNDMFx3GLou5lRu50MfQ5thTXznN3GWe4DMnyrKOcqDFZbihgT0dh2Hp2TUYZ9JMnyI54tGC92Q4j7IjQE0CgGq/RCosyxmBYOw0JMGlaA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods
Date: Sun, 30 Mar 2008 21:34:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
References: <200803301714.04527.bzolnier@gmail.com> <Pine.LNX.4.64.0803302012560.16372@anakin>
In-Reply-To: <Pine.LNX.4.64.0803302012560.16372@anakin>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803302134.42569.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 30 March 2008, Geert Uytterhoeven wrote:
> 	Hi Bart,
> 
> On Sun, 30 Mar 2008, Bartlomiej Zolnierkiewicz wrote:
> > * Add ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods to
> >   falconide and q40ide host drivers (->ata_* methods are implemented on
> >   top of ->atapi_* methods so they also do byte-swapping now).
> > 
> > * Cleanup atapi_{in,out}put_bytes().
> 
> Thanks!
> 
> One remaining issue (for which the fix has never been submitted upstream so
> far) with Atari and Q40 is that due to the byteswapped interface, the driveid
> is also byteswapped, so it has to be unswapped again in ide_fix_driveid().

My patch causes unswapping for _all_ data coming from the device so I wonder
whether the ide_fix_driveid() fix is still needed?

[ I now recall some discussion that we shouldn't un-swap fs requests because
  of how the things were done in the past fs itself is stored byte-swapped on
  the disk - if this is the case I will recast the patch to pass rq to
  ->ata_*put_data in ide_pio_sector() and check rq->cmd_type == REQ_TYPE_FS
  in falconide/q40ide_*put_data() to decide whether to unswap data or not ]

Thanks,
Bart

> Here's a very old and unclean but working patch:
> 
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -284,6 +284,23 @@ void ide_fix_driveid (struct hd_driveid 
>  	int i;
>  	u16 *stringcast;
>  
> +#ifdef __mc68000__
> +	if (!MACH_IS_AMIGA && !MACH_IS_MAC && !MACH_IS_Q40 && !MACH_IS_ATARI)
> +		return;
> +
> +#ifdef M68K_IDE_SWAPW
> +	if (M68K_IDE_SWAPW) {	/* fix bus byteorder first */
> +		u_char *p = (u_char *)id;
> +		u_char t;
> +		for (i = 0; i < 512; i += 2) {
> +			t = p[i];
> +			p[i] = p[i+1];
> +			p[i+1] = t;
> +		}
> +	}
> +#endif
> +#endif /* __mc68000__ */
> +
>  	id->config         = __le16_to_cpu(id->config);
>  	id->cyls           = __le16_to_cpu(id->cyls);
>  	id->reserved2      = __le16_to_cpu(id->reserved2);
> 
> Note that include/asm-m68k/ide.h has
> 
>     #define M68K_IDE_SWAPW  (MACH_IS_Q40 || MACH_IS_ATARI)
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
