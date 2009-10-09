Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbZJIT2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbZJIT2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761356AbZJIT2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:28:20 -0400
Received: from www.tglx.de ([62.245.132.106]:38435 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761326AbZJIT2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:28:19 -0400
Date: Fri, 9 Oct 2009 21:27:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] nvram: Drop the bkl from nvram_llseek()
In-Reply-To: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.00.0910092124260.9428@localhost.localdomain>
References: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOn Fri, 9 Oct 2009, Frederic Weisbecker wrote:

> There is nothing to protect inside nvram_llseek(), the file
> offset doesn't need to be protected and nvram_len is only
> initialized from an __init path.
> 
> It's safe to remove the big kernel lock there.
> 
> (Is this file still used? I can't even build it,
> looks like it is built under CONFIG_GENERIC_NVRAM but this
> option is referenced nowhere except in powerpc defconfigs)

Yes it is used. Look at arch/powerpc/Kconfig

config GENERIC_NVRAM
        bool
	default y if PPC32

But I have to admit that the GENERIC part is confusing :)

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Alessio Igor Bogani <abogani@texware.it>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Greg KH <gregkh@suse.de>

Added to the pile of pending BKL bashing. Thanks,

      tglx      

> ---
>  drivers/char/generic_nvram.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
> index ef31738..c49200e 100644
> --- a/drivers/char/generic_nvram.c
> +++ b/drivers/char/generic_nvram.c
> @@ -32,7 +32,6 @@ static ssize_t nvram_len;
>  
>  static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  {
> -	lock_kernel();
>  	switch (origin) {
>  	case 1:
>  		offset += file->f_pos;
> @@ -41,12 +40,11 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  		offset += nvram_len;
>  		break;
>  	}
> -	if (offset < 0) {
> -		unlock_kernel();
> +	if (offset < 0)
>  		return -EINVAL;
> -	}
> +
>  	file->f_pos = offset;
> -	unlock_kernel();
> +
>  	return file->f_pos;
>  }
>  
> -- 
> 1.6.2.3
> 
