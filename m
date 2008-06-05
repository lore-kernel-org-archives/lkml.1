Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbYFETBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbYFETBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYFETBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:01:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:5799 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYFETBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t+3m1DTsXbUMd53wfLlIHmXqIbicBubBm+yIC+E1LF+EgkeYX6Kt6HG95RQPUG5Jxq
         fZOzmWXH6SjbbaxcSQw4PIY1YbkXL92KWxpZO1uCRj14CXrFL59Z0j3nOnDPlXm17r5v
         xKnfH8Ll1t+uTUzbgmWBBTvzRoU+Qh81eUjPo=
Date: Thu, 5 Jun 2008 23:00:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
Message-ID: <20080605190045.GD7030@cvg>
References: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl> <20080531101832.GA15170@elte.hu> <20080605091949.GA2307@elte.hu> <Pine.LNX.4.55.0806051541210.2875@cliff.in.clinika.pl> <20080605150327.GA22128@elte.hu> <Pine.LNX.4.55.0806051911500.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806051911500.2875@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Thu, Jun 05, 2008 at 07:33:04PM +0100]
| On Thu, 5 Jun 2008, Ingo Molnar wrote:
| 
| > NOTE: you need to copy out and use the boot parameters from the boot 
| > log:
| > 
| >  [ 0.000000] Command line: root=/dev/sda6 console=ttyS0,115200 
| >  earlyprintk=se rial,ttyS0,115200 debug initcall_debug apic=verbose 
| >  sysrq_always_enabled ignore _loglevel selinux=0 nmi_watchdog=1 
| >  profile=0 maxcpus=1 nosmp no_hz=off highres =0 noapic nolapic_timer 
| >  hpet=disable idle=mwait
| > 
| > as -tip testing occasionally randomizes boot parameters too. (to find 
| > regressions like this) Let me know if you cannot reproduce this.
| 
|  Thanks.  I figured out I cannot build an x86-64 kernel, because my i386
| compiler does not support the target.  Probably because of target library
| dependencies at the time I built my compiler.  I would have to build a
| bare-iron cross-compiler for the x86-64 which I'd rather not to just to
| fix this small problem -- it usually takes a few days to sort out all the
| pesky details when doing such a build from scratch, so it better be well
| justified.
| 
|  However, the reason is quite clear to me -- the command line specifies
| "noapic" among others (there is also "nosmp", but probably overridden by
| "maxcpus=1" -- I am afraid there is no clear precedence among these
| options), so the bug is the I/O APIC NMI watchdog is tried at all.  This
| is also clearly seen from the log where the I/O APIC is not set up at all.  
| 
|  A fix along the lines of what I implemented for "nosmp" in the
| "nosmp-watchdog" patch is needed which I will post shortly.  It's needed
| both for the i386 and the x86-64 target; hopefully the latter does not
| differ too much from the former.
| 
|   Maciej
| 

Btw, just for the record: my hang was exactly on same line as Ingo reported:

static int __init pci_acpi_init(void) {
...
	printk(KERN_INFO "PCI: Using ACPI for IRQ routing\n");
...
}

well, Ingo had a few additional messages caused by debug_initcall,
but I guess there was a real hang. I mean acpi_irq_penalty_init()
is never reached (I've added a few printk there to be sure).

		- Cyrill -
