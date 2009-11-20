Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZKTRnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZKTRnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZKTRnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:43:50 -0500
Received: from kroah.org ([198.145.64.141]:40254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbZKTRnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:43:47 -0500
Date: Fri, 20 Nov 2009 09:43:28 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@novell.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Char: cyclades, fix compiler warning
Message-ID: <20091120174328.GB14888@kroah.com>
References: <20091114080505.7715b022.akpm@linux-foundation.org>
 <1258546702-29591-1-git-send-email-jslaby@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258546702-29591-1-git-send-email-jslaby@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 01:18:22PM +0100, Jiri Slaby wrote:
> With gcc 4.0.2:
> drivers/char/cyclades.c: In function 'cyy_interrupt':
> drivers/char/cyclades.c:581: warning: 'info' may be used uninitialized in this function
> 
> introduced by
> 
> : commit 3aeea5b92210083c7cffd4f08a0bb141d3f2d574
> : Author:     Jiri Slaby <jirislaby@gmail.com>
> : AuthorDate: Sat Sep 19 13:13:16 2009 -0700
> : Commit:     Live-CD User <linux@linux.site>
> : CommitDate: Sat Sep 19 13:13:16 2009 -0700
> :
> :    cyclades: introduce cyy_readb/writeb
> 
> In fact the true branch which uses uninitialized 'info' can never
> happen because chip is always less than ->nchips and channel is
> always less than 4 which we alloc.
> 
> So behave similar to rx handling and remove the test completely.
> 
> I wonder why gcc 4.4.1 doesn't spit a word.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Jiri Slaby <jslaby@novell.com>
> ---
>  drivers/char/cyclades.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
> index a188c05..e026f24 100644
> --- a/drivers/char/cyclades.c
> +++ b/drivers/char/cyclades.c
> @@ -595,14 +595,8 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
>  	channel = save_xir & CyIRChannel;
>  	save_car = readb(base_addr + (CyCAR << index));
>  	cy_writeb(base_addr + (CyCAR << index), save_xir);
> -	info = &cinfo->ports[channel + chip * 4];
>  
> -	/* validate the port# (as configured and open) */
> -	if (channel + chip * 4 >= cinfo->nports) {
> -		cy_writeb(base_addr + (CySRER << index),
> -			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
> -		goto end;
> -	}
> +	info = &cinfo->ports[channel + chip * 4];

Wierd, but this doesn't apply at all to my or Linus's tree.  Are there
some other cyclades patch floating around out there that is needed here
before this one?

thanks,

greg k-h
