Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYDMWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYDMWjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYDMWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:39:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37651 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752390AbYDMWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:39:09 -0400
Date: Sun, 13 Apr 2008 23:35:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sander@van-ginkel.eu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptmx: adding handshake support
Message-ID: <20080413233503.22576c47@core>
In-Reply-To: <480229CB.2080108@van-ginkel.eu>
References: <20080311212830.5f4apfr4uqs884cc@62.129.139.44>
	<20080330140948.0cqmtqb9us880cw8@62.129.139.44>
	<20080330131652.7073589c@core>
	<480229CB.2080108@van-ginkel.eu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + *  Added support for MCR/MSR, used for serial over ethernet
> + *    -- Sander van Ginkel <sander@van-ginkel.eu>

We've been trying to get rid of these long lists in the code and put them
in the git tree (git whatchanged/git blame show the info rather better)

> +
> +    /* initialize the pointer in case something fails */
> +   
> +    tty->driver_data = NULL;                         
> +    tty->link->driver_data = NULL;

Not needed

  +    /* first time accessing this device, let's create it */
> +
> +    mcrmsr = kmalloc(sizeof(*mcrmsr), GFP_KERNEL);

kzalloc will clear it for you...

> +static int pty_tiocmset(struct tty_struct *tty, struct file 
> *file,unsigned int set, unsigned int clear)
> +{
> +    unsigned int *mcrmsr;
> +
> +    mcrmsr = tty->driver_data;
> +    *mcrmsr=set;
> +    tty->driver_data=mcrmsr;

Why this last assignment ?

> +
> +    case VMCRMSR: /* Set all of the handshake line, even the normally 
> read only */
> +        {
> +        if (copy_from_user(&value,(unsigned int *)arg,sizeof(unsigned 
> int)))
> +            return -EFAULT;
> +
> +        *mcrmsr=value;

Ok - possibly we shouldn't allow people to set undefined bits but I'm not
sure it matters

> +        tty->driver_data=mcrmsr;

Why ??


I am curious how this is handled by other Unix systems and if there is an
ioctl we can follow from other systems ?


Looks basically ok, coding style is wrong, some odd extra assignments but
I agree entirely with the idea of adding this functionality to keep
remote serial drivers in user space.

I'll try and find out if other Unixes have similar features we can use to
keep API consistency tidy it up and fold it at some point in the next
couple of weeks.

Alan
