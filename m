Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXCYWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXCYWgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXCYWgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:36:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33107 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbXCYWgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:36:14 -0400
Date: Sun, 25 Mar 2007 14:36:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [PATCH] aoe, tb0219: fix late spin_lock_init() and friends
Message-Id: <20070325143609.75165bf6.akpm@linux-foundation.org>
In-Reply-To: <20070325190221.GA5308@martell.zuzino.mipt.ru>
References: <20070325190221.GA5308@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 23:02:21 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Some drivers do register_chrdev() before lock or semaphore used in
> corresponding file_operations is initialized.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  drivers/block/aoe/aoechr.c |    4 ++--
>  drivers/char/tb0219.c      |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/drivers/block/aoe/aoechr.c
> +++ b/drivers/block/aoe/aoechr.c
> @@ -246,13 +246,13 @@ aoechr_init(void)
>  {
>  	int n, i;
>  
> +	sema_init(&emsgs_sema, 0);
> +	spin_lock_init(&emsgs_lock);
>  	n = register_chrdev(AOE_MAJOR, "aoechr", &aoe_fops);
>  	if (n < 0) { 
>  		printk(KERN_ERR "aoe: can't register char device\n");
>  		return n;
>  	}
> -	sema_init(&emsgs_sema, 0);
> -	spin_lock_init(&emsgs_lock);
>  	aoe_class = class_create(THIS_MODULE, "aoe");
>  	if (IS_ERR(aoe_class)) {
>  		unregister_chrdev(AOE_MAJOR, "aoechr");
> --- a/drivers/char/tb0219.c
> +++ b/drivers/char/tb0219.c
> @@ -287,6 +287,8 @@ static int __devinit tb0219_probe(struct
>  {
>  	int retval;
>  
> +	spin_lock_init(&tb0219_lock);
> +
>  	if (request_mem_region(TB0219_START, TB0219_SIZE, "TB0219") == NULL)
>  		return -EBUSY;
>  
> @@ -304,8 +306,6 @@ static int __devinit tb0219_probe(struct
>  		return retval;
>  	}
>  
> -	spin_lock_init(&tb0219_lock);
> -
>  	old_machine_restart = _machine_restart;
>  	_machine_restart = tb0219_restart;
>  

These locks can and should be initialised at compile-time.
