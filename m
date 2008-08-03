Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYHCONt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYHCONt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYHCONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:13:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:15720 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbYHCONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=AZfaviO8RdmTiEKBzuA2OUVfTHcPv/ifhro9wwuNbHYaQlbrzHglsIek1bLsrGcs+y
         U80y1aLJWmPAAUWQVWkJ94xre1E27ws7rR3leO0rkN7+kbGdNXOtpWWhN9s94m29UpqB
         1h4oj6qQdbQa1hcQLniy35SjBvjUCLqddDWi8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/2] ide-generic: handle probing of legacy io-ports
Date: Sun, 3 Aug 2008 16:11:10 +0200
User-Agent: KMail/1.9.9
Cc: alan@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808022046.16990.bzolnier@gmail.com> <20080803073842.GB8762@gollum.tnic>
In-Reply-To: <20080803073842.GB8762@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808031611.11033.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 03 August 2008, Borislav Petkov wrote:
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sun, 3 Aug 2008 09:28:53 +0200
> Subject: [PATCH 2/2] ide-generic: handle probing of legacy io-ports
> 
> Avoid probing the io-ports in case an IDE PCI controller is present and it uses
> the legacy iobases. If we still want to enforce the probing, we do
> 
> ide_generic.probe_mask=0x3f
> 
> on the kernel command line.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Thanks for reworking the patch, looks much better now.

There are still some issues to address though.

> ---
>  drivers/ide/ide-generic.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
> index 8fe8b5b..7d79616 100644
> --- a/drivers/ide/ide-generic.c
> +++ b/drivers/ide/ide-generic.c
> @@ -27,7 +27,7 @@
>  
>  #define DRV_NAME	"ide_generic"
>  
> -static int probe_mask = 0x03;
> +static int probe_mask = 0x00;

No need to initialize it now.

>  module_param(probe_mask, int, 0);
>  MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
>  
> @@ -105,18 +105,31 @@ static int __init ide_generic_init(void)
>  	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
>  	struct ide_host *host;
>  	unsigned long io_addr;
> -	int i, rc;
> +	int i, rc, dummy, primary = 0, secondary = 0;
>  
>  #ifdef CONFIG_MIPS
>  	if (!ide_probe_legacy())
>  		return -ENODEV;
>  #endif
> -	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
> -			 "parameter for probing all legacy ISA IDE ports\n");
> +	ata_legacy_check_iobases(&primary, &secondary, &dummy);
> +
> +	if (primary) {

Shouldn't this also check for secondary?

> +		if (probe_mask) {
> +			printk(KERN_WARNING "%s: enforcing probing of io ports "
> +			       "upon user request.\n", DRV_NAME);
> +			primary = 0;
> +			secondary = 0;
> +		} else
> +			printk(KERN_INFO DRV_NAME ": please use "
> +			       \"probe_mask=0x3f\" module parameter for probing"
> +			       "all legacy ISA IDE ports\n");

Help message is no longer printed for !primary
(we always want to have it unless probe_mask is set).

> +
> +	} else
> +		probe_mask = 0x3;

I think this was meant to be 'probe_mask |= 3;'?

>  	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
>  
> -	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
> +	for (i = primary + secondary; i < ARRAY_SIZE(legacy_bases); i++) {

No need for primary/secondary checking here now as everything
is controlled by probe_mask.

Thus we can check for probe_mask first in the previous chunk
and it can be rewritten/simplified to something like:

	ata_legacy_check_iobases(&primary, &secondary, &dummy);

	if (probe_mask == 0) {
		printk(KERN_INFO DRV_NAME ": please use "
		       \"probe_mask=0x3f\" module parameter for probing"
		       "all legacy ISA IDE ports\n");

		if (primary == 0)
			probe_mask |= 1;

		if (secondary == 0)
			probe_mask |= 2;
	}
