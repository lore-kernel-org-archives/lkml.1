Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZJFHxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZJFHxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZJFHxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:53:02 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:61038 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZJFHxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:53:01 -0400
Date: Tue, 6 Oct 2009 07:51:41 +0000
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][UHCI-DEBUG] Don't kmalloc with BKL held
Message-ID: <20091006075141.GA6650@gambetta>
References: <1254474744.28661.2.camel@sven.thebigcorporation.com> <20091002092021.GA25083@gambetta> <1254573359.11691.0.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254573359.11691.0.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 05:35:59AM -0700, Sven-Thorsten Dietrich wrote:
> On Fri, 2009-10-02 at 09:20 +0000, Frederik Deweerdt wrote:
> > Hi Sven-Thorsten,
> > 
> > On Fri, Oct 02, 2009 at 11:12:24AM +0200, Sven-Thorsten Dietrich wrote:
> > > Subject: Don't kmalloc with BKL held.
> > > From: Sven-Thorsten Dietrich <sdietrich@suse.de>
> > > 
> > > I'm eyeballing this file for complete removal of lock_kernel but 
> > > at first glance, we definitely don't need BKL to kmalloc(). 
> > You need to move the unlock_kernel() above the out: label too.
> > 
> 
> How about this ?
Yes, looks good to me.

> 
> Subject: Don't kmalloc with BKL held.
> From: Sven-Thorsten Dietrich sdietrich@suse.de Sat Oct 3 01:27:27 2009 -0700
> Date: Sat Oct 3 01:27:27 2009 -0700:
> Git: 4f62eb81e827eb857129101e49757d84ac9ee7eb
> 
> We don't need BKL to kmalloc
> 
> diff --git a/drivers/usb/host/uhci-debug.c b/drivers/usb/host/uhci-debug.c
> index e52b954..3fd5602 100644
> --- a/drivers/usb/host/uhci-debug.c
> +++ b/drivers/usb/host/uhci-debug.c
> @@ -494,32 +494,30 @@ static int uhci_debug_open(struct inode *inode, struct file *file)
>  {
>  	struct uhci_hcd *uhci = inode->i_private;
>  	struct uhci_debug *up;
> -	int ret = -ENOMEM;
>  	unsigned long flags;
>  
> -	lock_kernel();
>  	up = kmalloc(sizeof(*up), GFP_KERNEL);
>  	if (!up)
> -		goto out;
> +		return -ENOMEM;
>  
>  	up->data = kmalloc(MAX_OUTPUT, GFP_KERNEL);
>  	if (!up->data) {
>  		kfree(up);
> -		goto out;
> +		return -ENOMEM;
>  	}
>  
>  	up->size = 0;
> +
> +	lock_kernel();
>  	spin_lock_irqsave(&uhci->lock, flags);
>  	if (uhci->is_initialized)
>  		up->size = uhci_sprint_schedule(uhci, up->data, MAX_OUTPUT);
>  	spin_unlock_irqrestore(&uhci->lock, flags);
>  
>  	file->private_data = up;
> -
> -	ret = 0;
> -out:
>  	unlock_kernel();
> -	return ret;
> +
> +	return 0;
>  }
>  
>  static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
> 
> 
