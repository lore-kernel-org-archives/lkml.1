Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZBFQVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZBFQVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBFQUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:20:55 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:23879 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZBFQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:20:54 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Philippe De Muyter <phdm@macqel.be>
Subject: Re: [PATCH] floppy: release only the ports we actually requested
Date: Fri, 6 Feb 2009 09:20:13 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hancockrwd@gmail.com, abelay@mit.edu, lenb@kernel.org,
       stable@kernel.org
References: <20090205174859.18396.68512.stgit@bob.kio> <200902051643.32591.bjorn.helgaas@hp.com> <20090206085501.GA18125@frolo.macqel>
In-Reply-To: <20090206085501.GA18125@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902060920.14194.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 01:55:01 am Philippe De Muyter wrote:
> Bjorn, Andrew,
> 
> --
> 
> With the last floppy patch, the floppy driver requests only the ports that
> it really uses, but the code contains yet places where it releases those
> unrequested ports.  I don't know if it is harmfull, but I think it is cleaner
> that the parameters of the release_region calls match the request_region ones.

Doh!  Boy, do I feel stupid.  I doubt this is in any git trees yet,
so I'll combine the two patches and send a cleaner one.

Bjorn

> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> 
> --- a/drivers/block/floppy.c	2009-02-06 08:56:33.000000000 +0100
> +++ b/drivers/block/floppy.c	2009-02-06 09:05:55.000000000 +0100
> @@ -4274,7 +4274,8 @@ static int __init floppy_init(void)
>  		FDCS->rawcmd = 2;
>  		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
>  			/* free ioports reserved by floppy_grab_irq_and_dma() */
> -			release_region(FDCS->address + 2, 4);
> +			release_region(FDCS->address + 2, 1);
> +			release_region(FDCS->address + 4, 2);
>  			release_region(FDCS->address + 7, 1);
>  			FDCS->address = -1;
>  			FDCS->version = FDC_NONE;
> @@ -4284,7 +4285,8 @@ static int __init floppy_init(void)
>  		FDCS->version = get_fdc_version();
>  		if (FDCS->version == FDC_NONE) {
>  			/* free ioports reserved by floppy_grab_irq_and_dma() */
> -			release_region(FDCS->address + 2, 4);
> +			release_region(FDCS->address + 2, 1);
> +			release_region(FDCS->address + 4, 2);
>  			release_region(FDCS->address + 7, 1);
>  			FDCS->address = -1;
>  			continue;
> @@ -4510,7 +4512,8 @@ static void floppy_release_irq_and_dma(v
>  	old_fdc = fdc;
>  	for (fdc = 0; fdc < N_FDC; fdc++)
>  		if (FDCS->address != -1) {
> -			release_region(FDCS->address + 2, 4);
> +			release_region(FDCS->address + 2, 1);
> +			release_region(FDCS->address + 4, 2);
>  			release_region(FDCS->address + 7, 1);
>  		}
>  	fdc = old_fdc;
> 


