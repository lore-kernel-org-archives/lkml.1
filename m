Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYIQJlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYIQJlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYIQJlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:41:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYIQJlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:41:16 -0400
Date: Wed, 17 Sep 2008 11:40:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Message-ID: <20080917094053.GC32107@elte.hu>
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com> <20080917073058.GA3770@x200.localdomain> <20080917084754.GC24035@elte.hu> <20080917092526.GC3770@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917092526.GC3770@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Sep 17, 2008 at 10:47:54AM +0200, Ingo Molnar wrote:
> > 
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > On Wed, Sep 17, 2008 at 12:10:09AM -0700, Yinghai Lu wrote:
> > > >     KERN_PCI
> > > >     KERN_ACPI
> > > > v4: fix some checkpatch error and warning
> > > > v5: add default with DEFINE_LOGLEVE_SETUP_DEF
> > > >     KERN_APIC
> > > > 
> > > > usage:
> > > > 	in .h to have
> > > > 		#define KERN_PCI "<pci>"
> > > > 	in .c to have
> > > > 		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
> > > > 	then could use
> > > > 		printk(KERN_DEBUG KERN_PCI fmt, ...);
> > > > 	and command line
> > > > 		loglevel=3,pci:8
> > > > 
> > > > you can add different printk to different files of one subsys if you like
> > > > not just one susbsys one tag, and don't need to update kernel.h to add more tags
> > > 
> > > I think all of this is overdesigned and stupid.
> > > 
> > > People expecting that loglevels are exactly right so they can calm 
> > > messages are like security-savvy people who expect all security 
> > > relevant bugfixes carry CVE tag.
> > > 
> > > grep says there are 50757 printk calls, only 32129 of them carry KERN_ 
> > > tag.
> > >
> > > Oh, and new and improved logs:
> > > 
> > > 	[    0.340326] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> > > 	[    0.340326] pci 0000:00:01.0: PME# disabled
> > > 	[    0.340326] <pci>PCI: 0000:00:1a.0 reg 20 io port: [dc00, dc1f]
> > > 	[    0.340413] <pci>PCI: 0000:00:1a.1 reg 20 io port: [e000, e01f]
> > > 	[    0.340549] <pci>PCI: 0000:00:1a.7 reg 10 32bit mmio: [febffc00, febfffff]
> > > 		       ^^^^^^^^^
> > > How this can be an improvement for those who boot with ignore_loglevel,
> > > I don't know.
> > 
> > the subsystem tags should be cut out by dmesg by default, just like the 
> > normal <1> tags are cut out.
> 
> Or just leave ACPI:, PCI:. Tags are already in place in some sense.
> 
> > about your general point: it's valid observations. The idea would be 
> > to end this never ending unstable conflict of people adding printks 
> > for debug reasons versus people removing printks who'd like to have 
> > a nice looking bootup log.
> 
> Simply nice looking log is irrational. I can understand if by default 
> messages do not fit into printk buffer before userspace can save them. 
> This is indeed harmful and loses information.
> 
> OTOH, all these loglevel games ultimately lead to missed messages (by 
> design). I remember myself wasting time debugging wrong path simply 
> because box wasn't booted with ignore_loglevel and critical debugging 
> printk wasn't on serial console, but only in dmesg.
> 
> So, in some cases useless information will not be shown, but in some 
> absolutely critical information will not be shown.

yes, i had that happen too, and i am quite sure that the most sensible 
way out is to provide a _single_ point for users to enable 'all things 
debug'. I.e. a "loglevel=debug" (or loglevel=all) boot parameter.

Instead of the current list of zillions of ad-hoc switchlets that are 
scattered all around the kernel. Tell me, within 10 seconds, which one 
of these are the correct options and which ones are typos:

 lapic
 lapic=verbose 
 apic=debug
 ignore-loglevel 
 initcalldebug
 early_printk=vga
 ignoreloglevel
 debug
 verbose
 ignore_loglevel
 initcall_debug
 apic=verbose
 initcall=debug
 earlyprintk=vga

(i'm willing to bet a good beer that you probably have not found the 
right solution in time :-)

People dont really want to individually enable pci or apic or smp 
debugging or whatnot - when it's about boot debugging they (and we) just 
want something really verbose. (_Sometimes_ we want more accurate 
filters for runtime debugging, especially if something can produce a log 
of continuing printks during userspace bootup - but that is an 
afterthought IMO.)

with such a facility in place we could just hide all non-essential 
messages by default, and have the perpetual possibility to get a verbose 
bootup without users having to rebuild their (often distro-built) 
kernel.

The only ongoing work would be to occasionally convert a stray 
informational printk that seemed to be useful during early development 
to a subsystem printk that hides it by default. The printk is not 
actually _lost_ and is utmost trivial to activate it again, should the 
need arise - which loss is why the "get rid of printks" patches are 
opposed most of the time.

So i think we'll hit multiple birds with the same stone.

	Ingo
