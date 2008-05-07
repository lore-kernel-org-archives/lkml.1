Return-Path: <linux-kernel-owner+w=401wt.eu-S1764006AbYEGHGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764006AbYEGHGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbYEGHGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:06:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:52395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbYEGHGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:06:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,446,1204531200"; 
   d="scan'208";a="325331403"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080507062834.GA30306@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>
	 <1210131712.3453.43.camel@ymzhang> <20080507062639.GA26031@elte.hu>
	 <20080507062834.GA30306@elte.hu>
Content-Type: text/plain
Date: Wed, 07 May 2008 15:05:00 +0800
Message-Id: <1210143900.3453.72.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 08:28 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > 3) Caller of lock_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.
> > 
> > that's one often-forgotten BKL site: about 1000 ioctls are still 
> > running under the BKL. The TTY one is hurting the most. [...]
> 
> although it's an unlocked_ioctl() now in 2.6.26, so all the BKL locking 
> has been nicely pushed down to deep inside the tty code.
> 
> > [...] To make sure it's only that BKL acquire/release that hurts, 
> > could you try the hack patch below, does it make any difference to 
> > performance?
> 
> if you use a serial console you will need the updated patch below.
I tested it on my 8-core stoakley. The result is 4% worse than the one of pure
2.6.26-rc1. Still not good.

> 
> 	Ingo
> 
> ---------------------->
> Subject: no: tty bkl
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed May 07 08:21:22 CEST 2008
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/char/tty_io.c        |    5 +++--
>  drivers/serial/serial_core.c |    2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux/drivers/char/tty_io.c
> ===================================================================
> --- linux.orig/drivers/char/tty_io.c
> +++ linux/drivers/char/tty_io.c
> @@ -2844,9 +2844,10 @@ out:
>  
>  static int tty_release(struct inode *inode, struct file *filp)
>  {
> -	lock_kernel();
> +	/* DANGEROUS - can crash your kernel! */
> +//	lock_kernel();
>  	release_dev(filp);
> -	unlock_kernel();
> +//	unlock_kernel();
>  	return 0;
>  }
>  
> Index: linux/drivers/serial/serial_core.c
> ===================================================================
> --- linux.orig/drivers/serial/serial_core.c
> +++ linux/drivers/serial/serial_core.c
> @@ -1241,7 +1241,7 @@ static void uart_close(struct tty_struct
>  	struct uart_state *state = tty->driver_data;
>  	struct uart_port *port;
>  
> -	BUG_ON(!kernel_locked());
> +//	BUG_ON(!kernel_locked());
>  
>  	if (!state || !state->port)
>  		return;
> 

