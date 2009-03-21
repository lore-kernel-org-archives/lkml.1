Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZCUC31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZCUC31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 22:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZCUC3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 22:29:17 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:39989
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZCUC3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 22:29:16 -0400
Date: Sat, 21 Mar 2009 11:29:10 +0900
From: Mattia Dongili <malattia@linux.it>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] sony-laptop: Kill the BKL
Message-ID: <20090321022910.GB3834@kamineko.org>
References: <1237572165-6494-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237572165-6494-1-git-send-email-abogani@texware.it>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.26-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:02:45PM +0100, Alessio Igor Bogani wrote:
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>

Applied, thanks. Will send together with my patch set for .30 soon.

> ---
>  drivers/platform/x86/sony-laptop.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index 537959d..15f940b 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -46,7 +46,6 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/init.h>
> -#include <linux/smp_lock.h>
>  #include <linux/types.h>
>  #include <linux/backlight.h>
>  #include <linux/platform_device.h>
> @@ -1934,10 +1933,15 @@ static int sonypi_misc_release(struct inode *inode, struct file *file)
>  static int sonypi_misc_open(struct inode *inode, struct file *file)
>  {
>  	/* Flush input queue on first open */
> -	lock_kernel();
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(sonypi_compat.fifo->lock, flags);
> +
>  	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
> -		kfifo_reset(sonypi_compat.fifo);
> -	unlock_kernel();
> +		__kfifo_reset(sonypi_compat.fifo);
> +
> +	spin_unlock_irqrestore(sonypi_compat.fifo->lock, flags);
> +
>  	return 0;
>  }
>  
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
-- 
mattia
:wq!
