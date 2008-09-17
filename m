Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYIQJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYIQJ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQJ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:28:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41130 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYIQJ2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:28:04 -0400
Date: Wed, 17 Sep 2008 11:27:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Message-ID: <20080917092732.GB32107@elte.hu>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <20080917015543.27172da4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917015543.27172da4.akpm@linux-foundation.org>
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


(Jason Cc:-ed)

* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 17 Sep 2008 01:27:41 -0700 Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> >     KERN_PCI
> >     KERN_ACPI
> > v4: fix some checkpatch error and warning
> > v5: add default with DEFINE_LOGLEVE_SETUP_DEF
> >     KERN_APIC
> > v6: set the default only one time
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
> This all looks dreadfully similar to Jason Baron's "dynamic debug v2".

yeah, but s/dreadfully/luckily

> Similar enough that we couldn't justify merging both.

agreed.

Here's the summary as i see it: Jason's "dynamic debug" mainly relies on 
automatically creating a section of tags associated with each pr_debug() 
callsite. The unit of filtering is the .c file - which lends itself well 
to things like individual drivers but is not quite good for more generic 
entities like full subsystems.

I think a better model is what hpa suggested: add string tags at the 
call site and make it all a sub-case of printk, via ASCII space tags. 
OTOH, a pr_debug() variant could be offered that just inserts a __FILE__ 
tag into the output - this would enable most of the "dynamic debug" 
functionality that Jason's patch series implements IMO.

There's also a wider robustness argument why this is better: we want to 
keep printk simple by default, hence doing these things via the ASCII 
space is good design. "dynamic debug" does it all programmatically via 
extra sections, etc., which is eventually a source of bugs and 
unrobustness.

	Ingo
