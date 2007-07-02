Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbXGBXKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbXGBXKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 19:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbXGBXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 19:10:37 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19093 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbXGBXKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 19:10:36 -0400
Date: Mon, 2 Jul 2007 16:12:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Juan Antonio Martinez <jonsito@teleline.es>, linux-kernel@vger.kernel.org
Subject: Re: ppdev - libieee1284.so  conflicts with 2.6.21
Message-Id: <20070702161220.0b151a28.randy.dunlap@oracle.com>
In-Reply-To: <20070702154753.56d06f10.akpm@linux-foundation.org>
References: <1183368129.4967.1.camel@drake.micasa.es>
	<20070702154753.56d06f10.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 15:47:53 -0700 Andrew Morton wrote:

> On Mon, 02 Jul 2007 11:22:09 +0200
> Juan Antonio Martinez <jonsito@teleline.es> wrote:
> 
> > I've reported this error to Fedora Bugzilla:
> > 
> > http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246406
> > 
> > In sort: to use libieee1284 I need to disable ppdev usage with
> > kernel 2.6.21. Kernel 2.6.20 works fine
> > 
> > [root@drake char]# uname -a
> > Linux drake.micasa.es 2.6.21-1.3228.fc7 #1 SMP Tue Jun 12 15:37:31 EDT
> > 2007 i686 athlon i386 GNU/Linux
> > 
> > By doing "echo disallow method ppdev > /etc/ieee1284.conf" everything
> > works fine on both kernels
> > 
> > Seems affect several distributions, not Fedora specific:
> > http://bugs.archlinux.org/task/7438
> > http://sourceforge.net/tracker/index.php?func=detail&aid=1739643&group_id=29314&atid=395778
> > http://www.digipedia.pl/man/libieee1284.3.html
> > 
> > Not sure if a kernel bug or a library one, so my apologizes if
> > this is not the propper list
> > 
> 
> Not much has changed in ppdev.c.  Possibly this:
> 
> commit da6752964290567a6b4ea180d1becda75e810e87
> Author: David Brownell <david-b@pacbell.net>
> Date:   Tue May 8 00:27:42 2007 -0700
> 
>     layered parport code uses parport->dev
>     
>     Update some of the layered parport_driver code to use parport->dev:
>     
>         - i2c-parport (parent of i2c_adapter)
>         - spi_butterfly (parent of spi_master, allowing cruft removal)
>         - lp (creating class_device)
>         - ppdev (parent of parportN device)
>         - tipar (creating class_device)
>     
>     There are still drivers that should be updated, like some of the input
>     drivers; but they won't be any worse off than they are today.
> 
> broke something.
> 
> Can you test a kernel with this change applied?
> 
> --- a/drivers/char/ppdev.c~a
> +++ a/drivers/char/ppdev.c
> @@ -751,7 +751,7 @@ static const struct file_operations pp_f
>  
>  static void pp_attach(struct parport *port)
>  {
> -	device_create(ppdev_class, port->dev, MKDEV(PP_MAJOR, port->number),
> +	device_create(ppdev_class, NULL, MKDEV(PP_MAJOR, port->number),
>  			"parport%d", port->number);
>  }
>  
> _


and if that doesn't help, please try this:

boot with kernel boot options:
noisapnp pnpacpi=off

since we have also seen a couple of cases that look like ACPI + PNP
are mucking up parallel port printers, so maybe they also muck up
other ppdevs.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
