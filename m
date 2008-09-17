Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYIQJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYIQJXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYIQJX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:23:26 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:44822 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYIQJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A41AB+CTXtdUBSeva3zmEGM333vvlm/SCrTKuwOsoFm6WOaZs9Ud0NUS86/wc3hEj4
         dFGmXqY0R5QV8N49gqBAWteoxzntcoJeRSeV4BadPczfUzQLbzTOe9bieQvm/JN3tlFz
         HffWnt8nDILy6dKNAcI+scObBvP/k4vWwsIDU=
Date: Wed, 17 Sep 2008 13:25:26 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Message-ID: <20080917092526.GC3770@x200.localdomain>
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com> <20080917073058.GA3770@x200.localdomain> <20080917084754.GC24035@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917084754.GC24035@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 10:47:54AM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Wed, Sep 17, 2008 at 12:10:09AM -0700, Yinghai Lu wrote:
> > >     KERN_PCI
> > >     KERN_ACPI
> > > v4: fix some checkpatch error and warning
> > > v5: add default with DEFINE_LOGLEVE_SETUP_DEF
> > >     KERN_APIC
> > > 
> > > usage:
> > > 	in .h to have
> > > 		#define KERN_PCI "<pci>"
> > > 	in .c to have
> > > 		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
> > > 	then could use
> > > 		printk(KERN_DEBUG KERN_PCI fmt, ...);
> > > 	and command line
> > > 		loglevel=3,pci:8
> > > 
> > > you can add different printk to different files of one subsys if you like
> > > not just one susbsys one tag, and don't need to update kernel.h to add more tags
> > 
> > I think all of this is overdesigned and stupid.
> > 
> > People expecting that loglevels are exactly right so they can calm 
> > messages are like security-savvy people who expect all security 
> > relevant bugfixes carry CVE tag.
> > 
> > grep says there are 50757 printk calls, only 32129 of them carry KERN_ 
> > tag.
> >
> > Oh, and new and improved logs:
> > 
> > 	[    0.340326] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> > 	[    0.340326] pci 0000:00:01.0: PME# disabled
> > 	[    0.340326] <pci>PCI: 0000:00:1a.0 reg 20 io port: [dc00, dc1f]
> > 	[    0.340413] <pci>PCI: 0000:00:1a.1 reg 20 io port: [e000, e01f]
> > 	[    0.340549] <pci>PCI: 0000:00:1a.7 reg 10 32bit mmio: [febffc00, febfffff]
> > 		       ^^^^^^^^^
> > How this can be an improvement for those who boot with ignore_loglevel,
> > I don't know.
> 
> the subsystem tags should be cut out by dmesg by default, just like the 
> normal <1> tags are cut out.

Or just leave ACPI:, PCI:. Tags are already in place in some sense.

> about your general point: it's valid observations. The idea would be to 
> end this never ending unstable conflict of people adding printks for 
> debug reasons versus people removing printks who'd like to have a nice 
> looking bootup log.

Simply nice looking log is irrational. I can understand if by default
messages do not fit into printk buffer before userspace can save them.
This is indeed harmful and loses information.

OTOH, all these loglevel games ultimately lead to missed messages (by design).
I remember myself wasting time debugging wrong path simply because box
wasn't booted with ignore_loglevel and critical debugging printk wasn't on
serial console, but only in dmesg.

So, in some cases useless information will not be shown, but in some
absolutely critical information will not be shown.

> Both point of views are correct in different usecases - and IMO the best 
> solution is the consolidation hpa suggested and what Yinghai is working 
> towards: to replace all the current ad-hoc debug printouts (with 
> different switchlets strewn all across the kernel) with an ASCII based 
> generic printk facility and a generic boot line option.

> people adding printks without any KERN_ tag is fine -

According to checkpatch.pl, it isn't.

> this facility is  only interesting to subsystems who'd like to make use
> of it. (core code,  ec. - the items that have a disproportionate weight
> in terms of system  stability, and which thus have a disproportionate
> need to stay  debuggable and regression-free)
> 
> [ and we also need a dynamic facility to change the filters via debugfs 
>   btw - it should be possible to modify these printk filters after 
>   bootup, runtime. Many subsystems have debug printks that make sense to 
>   enable/disable after the system has booted up. ]
> 
> and it's bad and a showstopper if the default output of 'dmesg' 
> degrades, like your noticed - those are bugs in the concept and need to 
> be fixed.
