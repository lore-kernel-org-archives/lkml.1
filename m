Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYIQIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYIQIsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYIQIsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:48:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYIQIsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:48:19 -0400
Date: Wed, 17 Sep 2008 10:47:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Message-ID: <20080917084754.GC24035@elte.hu>
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com> <20080917073058.GA3770@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917073058.GA3770@x200.localdomain>
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

> On Wed, Sep 17, 2008 at 12:10:09AM -0700, Yinghai Lu wrote:
> >     KERN_PCI
> >     KERN_ACPI
> > v4: fix some checkpatch error and warning
> > v5: add default with DEFINE_LOGLEVE_SETUP_DEF
> >     KERN_APIC
> > 
> > usage:
> > 	in .h to have
> > 		#define KERN_PCI "<pci>"
> > 	in .c to have
> > 		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
> > 	then could use
> > 		printk(KERN_DEBUG KERN_PCI fmt, ...);
> > 	and command line
> > 		loglevel=3,pci:8
> > 
> > you can add different printk to different files of one subsys if you like
> > not just one susbsys one tag, and don't need to update kernel.h to add more tags
> 
> I think all of this is overdesigned and stupid.
> 
> People expecting that loglevels are exactly right so they can calm 
> messages are like security-savvy people who expect all security 
> relevant bugfixes carry CVE tag.
> 
> grep says there are 50757 printk calls, only 32129 of them carry KERN_ 
> tag.
>
> Oh, and new and improved logs:
> 
> 	[    0.340326] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> 	[    0.340326] pci 0000:00:01.0: PME# disabled
> 	[    0.340326] <pci>PCI: 0000:00:1a.0 reg 20 io port: [dc00, dc1f]
> 	[    0.340413] <pci>PCI: 0000:00:1a.1 reg 20 io port: [e000, e01f]
> 	[    0.340549] <pci>PCI: 0000:00:1a.7 reg 10 32bit mmio: [febffc00, febfffff]
> 		       ^^^^^^^^^
> How this can be an improvement for those who boot with ignore_loglevel,
> I don't know.

the subsystem tags should be cut out by dmesg by default, just like the 
normal <1> tags are cut out.

about your general point: it's valid observations. The idea would be to 
end this never ending unstable conflict of people adding printks for 
debug reasons versus people removing printks who'd like to have a nice 
looking bootup log.

Both point of views are correct in different usecases - and IMO the best 
solution is the consolidation hpa suggested and what Yinghai is working 
towards: to replace all the current ad-hoc debug printouts (with 
different switchlets strewn all across the kernel) with an ASCII based 
generic printk facility and a generic boot line option.

people adding printks without any KERN_ tag is fine - this facility is 
only interesting to subsystems who'd like to make use of it. (core code, 
ec. - the items that have a disproportionate weight in terms of system 
stability, and which thus have a disproportionate need to stay 
debuggable and regression-free)

[ and we also need a dynamic facility to change the filters via debugfs 
  btw - it should be possible to modify these printk filters after 
  bootup, runtime. Many subsystems have debug printks that make sense to 
  enable/disable after the system has booted up. ]

and it's bad and a showstopper if the default output of 'dmesg' 
degrades, like your noticed - those are bugs in the concept and need to 
be fixed.

	Ingo
