Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXDUAmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXDUAmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXDUAmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:42:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbXDUAl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:41:59 -0400
Date: Fri, 20 Apr 2007 17:41:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH] fixed spinlock use in hysdn_log_close()
Message-Id: <20070420174146.42ccd6b4.akpm@linux-foundation.org>
In-Reply-To: <20070411170907.GO24898@traven>
References: <20070411170907.GO24898@traven>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007 07:09:07 +0200
Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> fixed incorrect spinlock use in hysdn_log_close(). the function
> declared a spinlock on the stack and used it to 'protect' a shared
> driver structure. the patch removes the declaration of hysdn_lock and 
> uses card->hysdn_lock instead.
> 

Interesting.

> 
> ---
> diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
> index f7e83a8..32f0b75 100644
> --- a/drivers/isdn/hysdn/hysdn_proclog.c
> +++ b/drivers/isdn/hysdn/hysdn_proclog.c
> @@ -299,7 +299,6 @@ hysdn_log_close(struct inode *ino, struct file *filep)
>  	hysdn_card *card;
>  	int retval = 0;
>  	unsigned long flags;
> -	spinlock_t hysdn_lock = SPIN_LOCK_UNLOCKED;
>  
>  	lock_kernel();
>  	if ((filep->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_WRITE) {
> @@ -309,7 +308,7 @@ hysdn_log_close(struct inode *ino, struct file *filep)
>  		/* read access -> log/debug read, mark one further file as closed */
>  
>  		pd = NULL;
> -		spin_lock_irqsave(&hysdn_lock, flags);
> +		spin_lock_irqsave(&card->hysdn_lock, flags);

I guess it won't hurt - are you actually able to test this code?

afaict most of the data in there is locked with lock_kernel(), if it's
locked at all.

If you had some runtime problem and this patch fixed it then fine.  If
however you're not able to test this code then perhaps the safest option is
to simply remove that locking altogether, which is pretty much a
runtime-equivalent change.

