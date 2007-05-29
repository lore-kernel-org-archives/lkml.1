Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbXE2Qdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbXE2Qdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXE2Qdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:33:44 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbXE2Qdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:33:44 -0400
Date: Tue, 29 May 2007 09:33:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <Stuart_Hayes@Dell.com>
Cc: <gregkh@suse.de>, <malattia@linux.it>, <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic:
 rmmod/0x00000001/4568
Message-Id: <20070529093324.92e571a0.akpm@linux-foundation.org>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9524D51@ausx3mpc125.aus.amer.dell.com>
References: <20070521024437.GA4751@inferi.kami.home>
	<20070525214005.GA6925@suse.de>
	<20070525150015.b5eaafc3.akpm@linux-foundation.org>
	<DFEF91B22ED07447AB6AA4B237F913F9524D51@ausx3mpc125.aus.amer.dell.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 10:14:35 -0500 <Stuart_Hayes@Dell.com> wrote:

> 
> Sorry about that.  Would it be helpful if I verified that and sent it in
> signed off?
> 

Yes please.  The question in my mind was "did it add a race": say, the
notifier chain gets called by some external source after we've gone and
reset the device?


> 
> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Friday, May 25, 2007 5:00 PM
> To: Greg KH
> Cc: Mattia Dongili; Linux Kernel Mailing List; Hayes, Stuart; David
> Brownell; linux-usb-devel@lists.sourceforge.net
> Subject: Re: [2.6.22-rc1-mm1] ehci-hcd - BUG: scheduling while atomic:
> rmmod/0x00000001/4568
> 
> On Fri, 25 May 2007 14:40:05 -0700 Greg KH <gregkh@suse.de> wrote:
> 
> > On Mon, May 21, 2007 at 11:44:37AM +0900, Mattia Dongili wrote:
> > > Hello,
> > > 
> > > with gregkh-usb-usb-ehci-cpufreq-fix.patch removing ehci-hcd causes 
> > > the following BUG:
> > 
> > Thanks for letting me know.
> > 
> > Stuart, any help here?
> 
> pretty obvious.  cpufreq_unregister_notifier() sleeps, and that patch
> causes it to be called under spinlock.
> 
> Something like this...
> 
> --- a/drivers/usb/host/ehci-hcd.c~fix-gregkh-usb-usb-ehci-cpufreq-fix
> +++ a/drivers/usb/host/ehci-hcd.c
> @@ -452,14 +452,14 @@ static void ehci_stop (struct usb_hcd *h
>  	if (HC_IS_RUNNING (hcd->state))
>  		ehci_quiesce (ehci);
>  
> -#ifdef CONFIG_CPU_FREQ
> -	cpufreq_unregister_notifier(&ehci->cpufreq_transition,
> -				    CPUFREQ_TRANSITION_NOTIFIER);
> -#endif
>  	ehci_reset (ehci);
>  	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
>  	spin_unlock_irq(&ehci->lock);
>  
> +#ifdef CONFIG_CPU_FREQ
> +	cpufreq_unregister_notifier(&ehci->cpufreq_transition,
> +				    CPUFREQ_TRANSITION_NOTIFIER);
> +#endif
>  	/* let companion controllers work when we aren't */
>  	ehci_writel(ehci, 0, &ehci->regs->configured_flag);
>  
> _
