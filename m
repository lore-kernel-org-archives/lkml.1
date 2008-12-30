Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYL3WdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYL3WdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYL3WdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:33:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:32113 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYL3WdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tINJhnkbYeBDjmV7XaiTfbJe9/pyBG3+Ij5UNQEsYDQBeavFLHpm5JghTiHXh60E9s
         p1BfY8xwiyfbCulD/mWwKRJyvUwUdozUr/BRwohFD+4D3u/S/7nNUapUwQZuefyk+Mxj
         f189xR4FqQwgsQro6WkYqSCefeyLk3oEKRtHs=
Subject: Re: [PATCH] ACPI: Do not modify SCI_EN directly
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200812302259.14866.rjw@sisk.pl>
References: <200812291919.07663.rjw@sisk.pl>
	 <1230585366.4667.26.camel@maxim-laptop>  <200812302259.14866.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 00:33:02 +0200
Message-Id: <1230676382.4958.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-30 at 22:59 +0100, Rafael J. Wysocki wrote:
> On Monday 29 December 2008, Maxim Levitsky wrote:
> > On Mon, 2008-12-29 at 19:19 +0100, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > According to the ACPI specification the SCI_EN flag is controlled by
> > > the hardware, which sets this flag to inform the kernel that ACPI is
> > > enabled.  For this reason, we shouldn't try to modify SCI_EN
> > > directly.  Also, we don't need to do it in irqrouter_resume(), since
> > > lower-level resume code takes care of enabling ACPI in case it hasn't
> > > been enabled by the BIOS before passing control to the kernel (which
> > > by the way is against the ACPI specification).
> > 
> > 
> > Hi, 
> 
> Hi,
> 
> > I am an unfortunate owner of an acer notebook ( aspire 5720 if this
> > matters) and it doesn't come back after second suspend, subsequently  I
> > figured out that bios doesn't pass control to linux at all, after second
> > resume, and moreover, a suspend to disk , 'fixes' this and enables me to
> > do another suspend/resume cycle. This is a poor man workaround I use
> > now.
> 
> I suspect there may be a problem with interrupts handling on your system.
> 
> There is http://bugzilla.kernel.org/show_bug.cgi?id=11698 describing a very
> similar (if not the same) issue.  Please attach a boot log and the contents
> of /proc/interrupts to that bug.
> 
> > I already told about this here, and many peoples from here (including
> > you) tried to help me, but unfortunately this is very weird issue, and
> > nether me nor you can do much about, it is all about guesswork,
> > something, at least something is 'armed' on resume, so it confuses bios
> > then (it could be that yet, the critical part that confuses bios happens
> > in second suspend time)
> > 
> > Needless to say that nothing useful appears in the logs, and everything
> > seems to work fine following each successful resume (both disk and ram).
> > 
> > so I have a question, do you have a git branch to pull that includes all
> > patches like this to test, so I build it weekly, and who knows, maybe
> > something like above will fix it.
> 
> Unfortunately, I don't.  If I have any patches that can possibly fix the
> problem, I'll let you know.
>  
> > Anyway I would gladly test any patch that you suspect might be involved
> > here.
> > 
> > Also, I tried to do a I/O port and PCI config dump before and after a
> > resume, aka in 'armed' and 'unarmed' state.
> > 
> > While there were many I/O port registers changes, and I yet to process
> > it bit after bit (and unfortunately there are plenty of undocumented
> > stuff), I noticed a meaningful change between bad and good state:
> 
> Please check if the appended patch from Len changes anything.
> 
> Thanks,
> Rafael
> 
> ---
> Author: Len Brown <len.brown@intel.com>
> Date:   Sat Dec 20 12:50:23 2008 +0100
> 
>     ACPI: PCI Interrupt Links -- disable when unused
>     
>     We start the system off with disabled links.
>     Here we enable the reference counting
>     on the links so that when drivers free IRQs
>     the links can return to the disabled state.
>     
>     Drivers free their IRQ and reference on a link
>     when they unload.  They may also do so upon
>     suspend.  However, if they don't, irqrouter_resume()
>     will still resume any links that were
>     not disabled before suspend.
>     
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
> index 595b131..0f7722d 100644
> --- a/drivers/acpi/pci_link.c
> +++ b/drivers/acpi/pci_link.c
> @@ -693,18 +693,7 @@ int acpi_pci_link_free_irq(acpi_handle handle)
>  		printk(KERN_ERR PREFIX "Link isn't initialized\n");
>  		return -1;
>  	}
> -#ifdef	FUTURE_USE
> -	/*
> -	 * The Link reference count allows us to _DISable an unused link
> -	 * and suspend time, and set it again  on resume.
> -	 * However, 2.6.12 still has irq_router.resume
> -	 * which blindly restores the link state.
> -	 * So we disable the reference count method
> -	 * to prevent duplicate acpi_pci_link_set()
> -	 * which would harm some systems
> -	 */
>  	link->refcnt--;
> -#endif
>  	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  			  "Link %s is dereferenced %d\n",
>  			  acpi_device_bid(link->device), link->refcnt));
> 

As usual, same hang after resume.
Just to note, this isn't a regression, it even appears in 2.6.19.


Best regards,
	Maxim Levitsky

