Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbYETXBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbYETXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934657AbYETXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:01:27 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:42087 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934477AbYETXBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e6ndzKFAeU8oDURfrxovIWz8VqLaTYVvxZObG5ddPahq/R1y3ICUKhxURWNzBHSUM9tFlAl53f61yJw/0QVfEwqeqjAmcaS1AzcZigKDJ8JdLYWxARysDRlrpHVApSZFybegBreGnsg1K6y0eD3SGLQzyCO4NZAsg7PR6IPY63o=
Message-ID: <8bd0f97a0805201601h1b08df6fw3fbf6c58759b07b4@mail.gmail.com>
Date: Tue, 20 May 2008 19:01:24 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>, "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH 1/3, RFC] misc char dev BKL pushdown
Cc: "Jonathan Corbet" <corbet@lwn.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Alexander Viro" <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <200805200126.29738.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <13762.1211142411@vena.lwn.net> <200805200107.51659.arnd@arndb.de>
	 <200805200126.29738.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 7:26 PM, Arnd Bergmann wrote:
> The Big Kernel Lock has been pushed down from chardev_open
> to misc_open, this change moves it to the individual misc
> driver open functions.
>
> As before, the change was purely mechanical, most drivers
> should actually not need the BKL. In particular, we still
> hold the misc_mtx() while calling the open() function
> The patch should probably be split into one changeset
> per driver.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> ---
> Index: linux-2.6/arch/blackfin/mach-bf561/coreb.c
> ===================================================================
> --- linux-2.6.orig/arch/blackfin/mach-bf561/coreb.c
> +++ linux-2.6/arch/blackfin/mach-bf561/coreb.c
> @@ -32,6 +32,7 @@
>  #include <linux/device.h>
>  #include <linux/ioport.h>
>  #include <linux/module.h>
> +#include <linux/smp_lock.h>
>  #include <linux/uaccess.h>
>  #include <linux/fs.h>
>  #include <asm/dma.h>
> @@ -196,6 +197,7 @@ static loff_t coreb_lseek(struct file *f
>
>  static int coreb_open(struct inode *inode, struct file *file)
>  {
> +       lock_kernel();
>        spin_lock_irq(&coreb_lock);
>
>        if (coreb_status & COREB_IS_OPEN)
> @@ -204,10 +206,12 @@ static int coreb_open(struct inode *inod
>        coreb_status |= COREB_IS_OPEN;
>
>        spin_unlock_irq(&coreb_lock);
> +       unlock_kernel();
>        return 0;
>
>  out_busy:
>        spin_unlock_irq(&coreb_lock);
> +       unlock_kernel();
>        return -EBUSY;
>  }

please drop the coreb.c changes from your patch
-mike
