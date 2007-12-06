Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXLFSUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXLFSUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXLFSU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:20:28 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35274 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXLFSU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:20:28 -0500
Message-ID: <47583D4F.2050707@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2007 23:49:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, rsa@us.ibm.com, apw@shadowen.org, balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com>
In-Reply-To: <20071205141202.GB13189@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The 2.6.24-rc4-mm1 kernel build fails with build failure,
> 
>   CC      drivers/char/hvcs.o
> drivers/char/hvcs.c: In function ‘hvcs_open’:
> drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
> make[2]: *** [drivers/char/hvcs.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 
> The kref_get begin void return type, check for the kobject return type
> as in the previous kobject_get()
> 
>         if (!kref_get(&hvcsd->kref)) {
>                 spin_unlock_irqrestore(&hvcsd->lock, flags); 
>                 printk(KERN_ERR "HVCS: Kobject of open"
>                         " hvcs doesn't exist.\n");
>                 return -EFAULT; /* Is this the right return value? */
>         }
> 
> I have tested for the build failure only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> --- linux-2.6.24-rc4/drivers/char/hvcs.c	2007-12-05 12:17:37.000000000 +0530
> +++ linux-2.6.24-rc4/drivers/char/~hvcs.c	2007-12-05 19:17:12.000000000 +0530
> @@ -1177,12 +1177,8 @@ fast_open:
>  	hvcsd = tty->driver_data;
> 
>  	spin_lock_irqsave(&hvcsd->lock, flags);
> -	if (!kref_get(&hvcsd->kref)) {
> -		spin_unlock_irqrestore(&hvcsd->lock, flags);
> -		printk(KERN_ERR "HVCS: Kobject of open"
> -			" hvcs doesn't exist.\n");
> -		return -EFAULT; /* Is this the right return value? */
> -	}
> +	kref_get(&hvcsd->kref);
> +	spin_unlock_irqrestore(&hvcsd->lock, flags);
> 

Why release the spinlock here? It's done after the count is incremented.
This patch does not seem correct.

>  	hvcsd->open_count++;
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
