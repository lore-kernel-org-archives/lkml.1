Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZJBJUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZJBJUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZJBJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:20:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:44337 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZJBJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:20:19 -0400
Date: Fri, 2 Oct 2009 09:20:21 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][UHCI-DEBUG] Don't kmalloc with BKL held
Message-ID: <20091002092021.GA25083@gambetta>
References: <1254474744.28661.2.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254474744.28661.2.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sven-Thorsten,

On Fri, Oct 02, 2009 at 11:12:24AM +0200, Sven-Thorsten Dietrich wrote:
> Subject: Don't kmalloc with BKL held.
> From: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> I'm eyeballing this file for complete removal of lock_kernel but 
> at first glance, we definitely don't need BKL to kmalloc(). 
You need to move the unlock_kernel() above the out: label too.

Regards,
Frederik

> 
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> 
> 
> diff --git a/drivers/usb/host/uhci-debug.c b/drivers/usb/host/uhci-debug.c
> index e52b954..325d508 100644
> --- a/drivers/usb/host/uhci-debug.c
> +++ b/drivers/usb/host/uhci-debug.c
> @@ -497,7 +497,6 @@ static int uhci_debug_open(struct inode *inode, struct file *file)
>  	int ret = -ENOMEM;
>  	unsigned long flags;
>  
> -	lock_kernel();
>  	up = kmalloc(sizeof(*up), GFP_KERNEL);
>  	if (!up)
>  		goto out;
> @@ -509,6 +508,8 @@ static int uhci_debug_open(struct inode *inode, struct file *file)
>  	}
>  
>  	up->size = 0;
> +
> +	lock_kernel();
>  	spin_lock_irqsave(&uhci->lock, flags);
>  	if (uhci->is_initialized)
>  		up->size = uhci_sprint_schedule(uhci, up->data, MAX_OUTPUT);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
