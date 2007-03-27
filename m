Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXC0Jg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXC0Jg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXC0Jg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:36:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53359 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbXC0Jg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:36:56 -0400
Date: Tue, 27 Mar 2007 11:37:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] usb: call bdev_read_only() only on CONFIG_BLOCK
Message-ID: <20070327093725.GA2481@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0703270201410.10410@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703270201410.10410@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 02:03:25AM -0700, David Rientjes wrote:
> bdev_read_only() is only defined on CONFIG_BLOCK so we make sure not to
> call it unless we have it.  A new static inline function,
> is_inode_read_only(), is invoked to call bdev_read_only() on CONFIG_BLOCK
> and return zero otherwise.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/usb/gadget/file_storage.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3493,6 +3493,14 @@ static int fsg_main_thread(void *fsg_)
>  	complete_and_exit(&fsg->thread_notifier, 0);
>  }
>  
> +#ifdef CONFIG_BLOCK
> +static inline int is_inode_read_only(struct inode *inode)
> +{
> +	return bdev_read_only(inode->i_bdev);
> +}
> +#else
> +#define is_inode_read_only(inode)	(0)
> +#endif

This looks like the wrong place to fix this.
Like we do with for exampel the pci_ functions we should provide a dummy
implementation in the kernel if configured without CONFIG_BLOCK.

In this way the decision to provide dummy functions are centralized
and benefits all users.

	Sam
