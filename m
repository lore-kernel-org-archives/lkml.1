Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbXFEQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbXFEQNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763311AbXFEQNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:13:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760512AbXFEQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:13:05 -0400
Date: Tue, 5 Jun 2007 09:12:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Subject: Re: [KJ] Re: [PATCH] bugfix GFP_KERNEL -> GFP_ATOMIC in spin_locked
 region
Message-Id: <20070605091258.d38d33de.akpm@linux-foundation.org>
In-Reply-To: <87k5uimzkh.fsf@wanadoo.fr>
References: <87odjvu1on.fsf@wanadoo.fr>
	<20070604210018.0eaa20a0.akpm@linux-foundation.org>
	<87k5uimzkh.fsf@wanadoo.fr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 13:05:18 +0200 Yoann Padioleau <padator@wanadoo.fr> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> >> 
> >>  net/wan/lmc/lmc_main.c        |    2 +-
> >>  scsi/megaraid/megaraid_mm.c   |    2 +-
> >>  usb/serial/io_ti.c            |    2 +-
> >>  usb/serial/ti_usb_3410_5052.c |    2 +-
> >>  usb/serial/whiteheat.c        |    6 +++---
> >>  5 files changed, 7 insertions(+), 7 deletions(-)
> >
> > This patch covers three areas of maintainer responsibility, so poor old me
> > has to split it up and redo the changelogs.  Oh well.
> 
> Sorry. 
> 
> For modifications that crosscut the kernel it is not very practical to
> look each time for the maintainer.

That's OK - I can take care of that

> We plan to send a patch that
> replaces some calls to kmalloc/memset with kzalloc; do we have to split
> it for each maintainer ?

Per subsystem: yes, please.  That maps pretty well onto per-subdirectory so
I'd suggest that each patch only affect the files in a single directory.

> >> diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
> >> index ae132c1..750b3ef 100644
> >> --- a/drivers/net/wan/lmc/lmc_main.c
> >> +++ b/drivers/net/wan/lmc/lmc_main.c
> >> @@ -483,7 +483,7 @@ #endif /* end ifdef _DBG_EVENTLOG */
> >>                              break;
> >>                      }
> >>  
> >> -                    data = kmalloc(xc.len, GFP_KERNEL);
> >> +                    data = kmalloc(xc.len, GFP_ATOMIC);
> >>                      if(data == 0x0){
> >>                              printk(KERN_WARNING "%s: Failed to allocate memory for copy\n", dev->name);
> >>                              ret = -ENOMEM;
> >
> > A few lines later we do:
> >
> > 	if(copy_from_user(data, xc.data, xc.len))
> >
> > which also is illegal under spinlock.
> 
> I have launched my tool to detect such situations and I get this 
> (in a diff-like format).
> 
> --- /home/pad/kernels/git/linux-2.6/arch/cris/arch-v10/drivers/gpio.c	2007-03-27 15:12:38.000000000 +0200
> +++ /tmp/output.c	2007-06-05 11:38:47.000000000 +0200
> @@ -776,7 +776,7 @@
>  		/* bits set in *arg is set to input,
>  		 * *arg updated with current input pins.
>  		 */
> -		if (copy_from_user(&val, (unsigned long*)arg, sizeof(val)))
>  		{
>  			ret = -EFAULT;
>  			break;
> @@ -789,7 +789,7 @@
>  		/* bits set in *arg is set to output,
>  		 * *arg updated with current output pins.
>  		 */
> -		if (copy_from_user(&val, (unsigned long*)arg, sizeof(val)))
>  		{
>  			ret = -EFAULT;
>  			break;
> 
> 
> --- /home/pad/kernels/git/linux-2.6/arch/mips/au1000/common/power.c	2007-03-27 15:12:41.000000000 +0200
> +++ /tmp/output.c	2007-06-05 11:38:57.000000000 +0200
> @@ -330,7 +330,7 @@
>  			spin_unlock_irqrestore(&pm_lock, flags);
>  			return -EFAULT;
>  		}
> -		if (copy_from_user(buf, buffer, *len)) {
>  			spin_unlock_irqrestore(&pm_lock, flags);
>  			return -EFAULT;
>  		}
> 
> and some cases in lmc_main.c

OK.

> 
> >
> >
> > Frankly, I think that a better use of this tool would be to just report on
> > the errors, let humans fix them up.
> 
> Ok. Do you have a preference on the format ?  a <file>:<line> format  ?

file-n-line is good.  If it can quote the relevant test then that's better
- line numbers change often.

Please always work against the very latest Linus git tree,

> Is there a place that gathered all those implicit programming rules 
> (that copy_from_user must not be called inside a spinlock, etc) so that
> I can translate them in a script for our tool.

Not that I can think of, sorry.

